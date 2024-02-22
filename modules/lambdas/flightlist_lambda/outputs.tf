output "flightlist_lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.flightlist_lambda.arn
}
