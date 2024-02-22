resource "aws_lambda_function" "flightlist_lambda" {
  function_name = var.function_name
  runtime       = var.runtime
  handler       = var.handler
  role          = var.role_arn

  source_code_hash = filebase64sha256("${var.source_dir}/project_flightlist.zip")
  filename         = "${var.source_dir}/project_flightlist.zip"
}