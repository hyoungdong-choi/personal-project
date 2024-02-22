output "vpc_id" {
  value = aws_vpc.project_vpc.id
  description = "The ID of the VPC"
}

output "private_subnet_ids" {
  value = aws_subnet.project_private_subnet[*].id
  description = "The IDs of the private subnets"
}

output "rds_security_group_id" {
  value = aws_security_group.rds_sg.id
  description = "The ID of the security group for RDS instances"
}

output "rds_subnet_group_name" {
  value = aws_db_subnet_group.rds-subnet-group.name
}
