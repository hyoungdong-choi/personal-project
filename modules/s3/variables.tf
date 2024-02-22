variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}

variable "html_file_path" {
  description = "Local path to the html files."
  type        = string
}

variable "css_file_path" {
  description = "Local path to the css files"
  type = string
}

variable "allowed_origin" {
  description = "The origin allowed for CORS."
  type        = string
}
