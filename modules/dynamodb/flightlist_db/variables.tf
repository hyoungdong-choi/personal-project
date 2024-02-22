variable "table_name" {
  description = "The name of the DynamoDB table"
  type        = string
}

variable "hash_key_name" {
  description = "The hash key name of the DynamoDB table"
  type        = string
}

variable "hash_key_type" {
  description = "The type of the hash key (S, N, or B for String, Number, or Binary)"
  type        = string
  default     = "S"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
