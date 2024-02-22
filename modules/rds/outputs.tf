output "rds_instance_address" {
  description = "RDS 인스턴스의 주소"
  value       = aws_db_instance.default.address
}

output "rds_instance_endpoint" {
  description = "RDS 인스턴스의 접속 엔드포인트"
  value       = aws_db_instance.default.endpoint
}
