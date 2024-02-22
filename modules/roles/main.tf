resource "aws_iam_role" "flightlist_lambda_execution_role" {
  name = "project_flightlist_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
        Sid = "",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "flightlist_lambda_policy_attachment" {
  role       = aws_iam_role.flightlist_lambda_execution_role.name
  policy_arn = var.flightlist_policy_arn
}
