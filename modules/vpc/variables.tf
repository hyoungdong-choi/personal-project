variable "vpc_cidr" {
  description = "CIDR block for the VPC"
}

variable "private_subnets_cidr" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones in which to place subnets"
  type        = list(string)
}
