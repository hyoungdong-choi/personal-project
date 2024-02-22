resource "aws_s3_bucket" "project-webpage-bucket" {
  bucket = "jaewonflight-webpage-bucket-0000"

  # 태그 추가
  tags = {
    Name = "My Project Webpage Bucket"
  }
}

resource "aws_s3_bucket_versioning" "project-s3-versioning-enabled" {
  bucket = aws_s3_bucket.project-webpage-bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "project-s3-SSE-s3" {
  bucket = aws_s3_bucket.project-webpage-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "project-s3-public-access-block" {
  bucket = aws_s3_bucket.project-webpage-bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "project-s3-policy" {
  bucket = aws_s3_bucket.project-webpage-bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.project-webpage-bucket.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = ["arn:aws:cloudfront::${var.aws_account_id}:distribution/${aws_cloudfront_distribution.project_website.id}"]
    }
  }
}

locals {
  html_files = fileset("/home/ubuntu/terraform/project-2/webpage", "*.html")
  css_files  = fileset("/home/ubuntu/terraform/project-2/webpage", "*.css")
}

# HTML 파일들을 S3 버킷의 루트에 업로드
resource "aws_s3_object" "html_objects" {
  for_each = { for filename in local.html_files : filename => filename }

  bucket = aws_s3_bucket.project-webpage-bucket.bucket
  key    = each.value
  source = "/home/ubuntu/terraform/project-2/webpage/${each.value}"
}

# CSS 파일들을 S3 버킷의 'css/' 디렉토리에 업로드
resource "aws_s3_object" "css_objects" {
  for_each = { for filename in local.css_files : filename => filename }

  bucket = aws_s3_bucket.project-webpage-bucket.bucket
  key    = "CSS/${each.value}"
  source = "/home/ubuntu/terraform/project-2/webpage/${each.value}"
}

resource "aws_s3_bucket_cors_configuration" "project-webpage-cors" {
  bucket = aws_s3_bucket.project-webpage-bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["https://www.it-is-what-it-is.site"] # 웹 사이트의 URL로 교체하세요
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
