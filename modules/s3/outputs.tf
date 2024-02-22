output "bucket_name" {
  value = aws_s3_bucket.project-webpage-bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.project-webpage-bucket.arn
}

output "bucket_domain_name" {
  value = aws_s3_bucket.project-webpage-bucket.bucket_domain_name
}