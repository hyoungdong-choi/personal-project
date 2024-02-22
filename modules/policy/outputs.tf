output "s3_policy_json" {
  value = data.aws_iam_policy_document.s3_webpage_policy.json
}

output "flightlist_policy_arn" {
  description = "The ARN of the IAM policy for Flightlist Lambda"
  value = aws_iam_policy.flightlist_lambda_policy.arn
}