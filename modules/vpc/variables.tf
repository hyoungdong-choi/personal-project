variable "cidr_block" {
  description = "The CIDR block for the VPC."
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC."
  default     = true
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC."
  default     = true
}

variable "vpc_name" {
  description = "The name of the VPC."
}

variable "public_subnets_cidr" {
  description = "A list of CIDR blocks for the public subnets."
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "A list of CIDR blocks for the private subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "A list of availability zones in the region."
  type        = list(string)
}

variable "igw_name" {
  description = "The name of the Internet Gateway."
  default     = "my-internet-gateway"
}

variable "enable_nat_gateway" {
  description = "A boolean flag to enable/disable NAT Gateway creation."
  default     = true
}

variable "region" {
  description = "AWS region for the VPC."
  default     = "us-east-1"
}
