resource "aws_s3_bucket" "project-webpage-bucket" {
  bucket = var.bucket_name
  tags = {
    Name = "My Project Webpage Bucket"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.project-webpage-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.project-webpage-bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "access_block" {
  bucket = aws_s3_bucket.project-webpage-bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_cors_configuration" "cors" {
  bucket = aws_s3_bucket.project-webpage-bucket.id
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = [var.allowed_origin]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

locals {
  html_files = fileset(var.html_file_path, "*.html")
  css_files  = fileset(var.css_file_path, "*.css")
}

resource "aws_s3_object" "html_objects" {
  for_each = { for filename in local.html_files : filename => filename }

  bucket = aws_s3_bucket.project-webpage-bucket.bucket
  key    = each.value
  source = "${var.html_file_path}/${each.value}"
  content_type = "text/html"
}

resource "aws_s3_object" "css_objects" {
  for_each = { for filename in local.css_files : filename => filename }

  bucket = aws_s3_bucket.project-webpage-bucket.bucket
  key    = "CSS/${each.value}"
  source = "${var.css_file_path}/${each.value}"
  content_type = "text/css"

}
