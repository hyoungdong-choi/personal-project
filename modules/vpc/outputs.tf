output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.my_vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private_subnet[*].id
}

output "nat_gateway_public_ips" {
  description = "The public IP addresses of the NAT gateways"
  value       = aws_eip.nat_eip[*].public_ip
}

output "security_group_id" {
  description = "The ID of the security group created for EKS"
  value       = aws_security_group.eks_sg.id
}
