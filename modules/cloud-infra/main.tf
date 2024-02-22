resource "aws_acm_certificate" "website_cert" {
  provider          = aws.us-east-1
  domain_name       = var.domain_name
  validation_method = "DNS"
  subject_alternative_names = var.alternative_names
  tags = {
    Name = "project-website-cert"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "project_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.website_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.project_zone.zone_id
}

resource "aws_acm_certificate_validation" "website_cert_validation" {
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.website_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

data "aws_cloudfront_cache_policy" "optimized_caching" {
  provider = aws.us-east-1
  name     = var.cloudfront_cache_policy_name
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name = "project-s3-oac"
  signing_behavior = "always"
  signing_protocol = "sigv4"
  origin_access_control_origin_type = "s3"
}

resource "aws_cloudfront_distribution" "project_website" {
  provider = aws.us-east-1
  origin {
    domain_name = var.s3_bucket_domain_name
    origin_id   = "S3-it-is-what-it-is.site"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }
  enabled             = true
  default_root_object = "main.html"
  aliases             = ["www.it-is-what-it-is.site"]
  default_cache_behavior {
    allowed_methods     = ["GET", "HEAD"]
    cached_methods      = ["GET", "HEAD"]
    target_origin_id    = "S3-it-is-what-it-is.site"
    cache_policy_id     = data.aws_cloudfront_cache_policy.optimized_caching.id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }
  price_class = "PriceClass_All"
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.website_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

resource "aws_route53_record" "website_dns" {
  zone_id = aws_route53_zone.project_zone.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.project_website.domain_name
    zone_id                = aws_cloudfront_distribution.project_website.hosted_zone_id
    evaluate_target_health = true
  }
}

