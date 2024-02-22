resource "aws_vpc" "project_vpc" {
  cidr_block       = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "project-vpc"
  }
}

resource "aws_subnet" "project_private_subnet" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.project_vpc.id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "private-${count.index}"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS instances"
  vpc_id      = aws_vpc.project_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

resource "aws_db_subnet_group" "rds-subnet-group" {
  name = "rds-subnet-group"
  subnet_ids =  aws_subnet.project_private_subnet[*].id

  tags = {
    Name = "My DB Subnet Group"
  }
}
