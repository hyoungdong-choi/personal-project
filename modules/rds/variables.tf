variable "instance_class" {
  description = "RDS 인스턴스 타입"
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "할당된 스토리지의 크기 (GB)"
  default     = 20
}

variable "engine" {
  description = "데이터베이스 엔진"
  default     = "mysql"
}

variable "engine_version" {
  description = "데이터베이스 엔진 버전"
  default     = "8.0.36"
}

variable "instance_identifier" {
  description = "RDS 인스턴스 식별자"
  default     = "my-rds-instance"
}

variable "username" {
  description = "데이터베이스 마스터 사용자 이름"
  default     = "admin"
}

variable "password" {
  description = "데이터베이스 마스터 사용자 비밀번호"
  default     = "change-me"
}

variable "vpc_security_group_ids" {
  description = "RDS 인스턴스에 연결할 VPC 보안 그룹 ID들"
  type        = list(string)
  default     = ["sg-xxxxxxxx"]
}

variable "db_subnet_group_name" {
  description = "RDS 데이터베이스 서브넷 그룹 이름"
  default     = "my-db-subnet-group"
  type = string
}

variable "multi_az" {
  description = "멀티 AZ 설정 여부"
  default     = false
}

variable "storage_type" {
  description = "스토리지 타입"
  default     = "gp2"
}


