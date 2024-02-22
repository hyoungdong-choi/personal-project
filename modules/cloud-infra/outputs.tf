output "website_cert_arn" {
  value = aws_acm_certificate.website_cert.arn
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.project_website.id
}

output "ns_records" {
  value       = aws_route53_zone.project_zone.name_servers
  description = "The name servers for Route 53."
}