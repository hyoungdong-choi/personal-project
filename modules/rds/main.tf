resource "aws_db_instance" "default" {
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  identifier              = var.instance_identifier
  username                = var.username
  password                = var.password
  db_subnet_group_name    = var.db_subnet_group_name
  vpc_security_group_ids  = var.vpc_security_group_ids
  multi_az                = var.multi_az
  skip_final_snapshot     = true
  publicly_accessible     = false

  # 추가 설정이 필요하다면 여기에 포함시킵니다.
}


