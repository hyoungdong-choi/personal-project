data "aws_iam_policy_document" "s3_webpage_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${var.web_bucket_arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = ["arn:aws:cloudfront::${var.aws_account_id}:distribution/${var.cloudfront_distribution_id}"]
    }
  }
}

resource "aws_s3_bucket_policy" "project_s3_policy" {
  bucket = var.web_bucket_name
  policy = data.aws_iam_policy_document.s3_webpage_policy.json
}

data "aws_iam_policy_document" "flightlist_lambda_policy_doc" {
  statement {
    actions   = ["dynamodb:GetItem", "dynamodb:Scan", "dynamodb:Query", "dynamodb:UpdateItem", "dynamodb:PutItem" ]
    resources = [var.dynamodb_table_arn]
  }

  statement {
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents", "logs:CreateLogGroup"]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = [var.s3_bucket_arn]
  }
}

resource "aws_iam_policy" "flightlist_lambda_policy" {
  name   = "project_flightlist_lambda_access_policy"
  policy = data.aws_iam_policy_document.flightlist_lambda_policy_doc.json
}
