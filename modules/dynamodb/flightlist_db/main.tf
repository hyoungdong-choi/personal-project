resource "aws_dynamodb_table" "flightlist_info" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST" # On-demand 용량 모드를 사용합니다.
  hash_key     = var.hash_key_name

  attribute {
    name = var.hash_key_name
    type = var.hash_key_type
  }

  # DynamoDB가 관리하는 암호화 사용
  server_side_encryption {
    enabled     = true
  }

  tags = var.tags
}

resource "aws_dynamodb_table_item" "flightlist_item" {
  table_name = aws_dynamodb_table.flightlist_info.name
  hash_key = var.hash_key_name

  item = <<ITEM
  {
  "${var.hash_key_name}": {"S": "EFS000"},
  "airline": {"S": "KoreanAir"},
  "bookedSeats": {"N": "0"},
  "departure": {"S": "ICN"},
  "departureDate": {"S": "2024-01-29"},
  "destination": {"S": "NRT"},
  "passengers": {"N": "1"},
  "price": {"N": "100"},
  "returnDate": {"S": "2024-01-31"},
  "totalSeats": {"N": "180"}
}
ITEM
}


