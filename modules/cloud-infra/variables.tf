variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "alternative_names" {
  type        = list(string)
  description = "List of alternative domain names."
}

variable "provider_region" {
  type        = string
  description = "Provider region for ACM and CloudFront."
}

variable "s3_bucket_domain_name" {
  type        = string
  description = "The domain name of the S3 bucket used as the origin for CloudFront."
}

variable "cloudfront_cache_policy_name" {
  type        = string
  description = "The name of the CloudFront cache policy."
}

variable "default_root_object" {
  type        = string
  default     = "index.html"
  description = "The default root object for CloudFront distribution."
}
