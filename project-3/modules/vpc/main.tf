resource "aws_vpc" "my_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnets_cidr)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.public_subnets_cidr[count.index]
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "Private-${count.index}"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = var.igw_name
  }
}

resource "aws_eip" "nat_eip" {
  count = var.enable_nat_gateway ? length(var.public_subnets_cidr) : 0
}

resource "aws_nat_gateway" "my_nat_gw" {
  count         = var.enable_nat_gateway ? length(var.public_subnets_cidr) : 0
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  tags = {
    Name = "NAT-${count.index}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "public_rta" {
  count          = length(aws_subnet.public_subnet[*].id)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block    = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gw[0].id
  }

  tags = {
    Name = "PrivateRouteTable"
  }
}

resource "aws_route_table_association" "private_rta" {
  count          = length(aws_subnet.private_subnet[*].id)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "eks_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    description = "Kubernetes API Server"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 더 엄격한 CIDR 범위를 지정하는 것이 좋습니다
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "eks-cluster-security-group"
  }
}

resource "aws_security_group" "ecr_sg" {
  name        = "ecr-vpc-endpoint-sg"
  description = "Security group for ECR VPC endpoint"
  vpc_id      = aws_vpc.my_vpc.id

  # ECR 엔드포인트로의 아웃바운드 HTTPS 트래픽을 허용
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ECR 엔드포인트로부터의 인바운드 HTTPS 트래픽을 허용
  # VPC 엔드포인트 서비스는 소스 IP 주소를 기반으로 인바운드 규칙을 필요로 하지 않으므로 이 규칙은 생략 가능
  # 하지만 명시적인 인바운드 규칙 설정이 필요한 다른 사용 사례가 있을 수 있으므로 예시로 포함

  tags = {
    Name = "ecr-vpc-endpoint-sg"
  }
}

# VPC 엔드포인트 예시 (Amazon S3를 위한 VPC 엔드포인트 생성)
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.my_vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_vpc.my_vpc.main_route_table_id]
}

# ECR API를 위한 VPC 엔드포인트
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id             = aws_vpc.my_vpc.id
  service_name       = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = aws_subnet.private_subnet[*].id
  security_group_ids = [aws_security_group.ecr_sg.id]

  private_dns_enabled = true
}

# ECR Docker 레지스트리 (이미지 저장소)를 위한 VPC 엔드포인트
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id             = aws_vpc.my_vpc.id
  service_name       = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = aws_subnet.private_subnet[*].id
  security_group_ids = [aws_security_group.ecr_sg.id]

  private_dns_enabled = true
}

