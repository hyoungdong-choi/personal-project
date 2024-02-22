output "dynamodb_table_name" {
  value = aws_dynamodb_table.flightlist_info.name
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.flightlist_info.arn
}
