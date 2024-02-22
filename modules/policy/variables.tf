variable "web_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket to attach the policy."
}

variable "aws_account_id" {
  type        = string
  description = "AWS account ID."
}

variable "cloudfront_distribution_id" {
  type        = string
  description = "CloudFront distribution ID for the S3 bucket policy."
}

variable "web_bucket_name" {
  type = string
  description = "Web Bucket Name to attach the policy"
}

variable "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table Lambda will access."
  type        = string
}

variable "s3_bucket_arn" {
  description = "The ARN of the S3 bucket Lambda will access."
  type        = string
}
