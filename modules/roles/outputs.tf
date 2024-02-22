output "project_flightlist_role_arn" {
  description = "The ARN of the IAM role created for Flightlist Lambda execution."
  value       = aws_iam_role.flightlist_lambda_execution_role.arn
}
