resource "aws_api_gateway_rest_api" "api_gateway_1" {
  name = var.api_name
}

resource "aws_api_gateway_resource" "api_gateway_1_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway_1.id
  parent_id   = aws_api_gateway_rest_api.api_gateway_1.root_resource_id
  path_part   = "flightlist"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_1.id
  resource_id   = aws_api_gateway_resource.api_gateway_1_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway_1.id
  resource_id = aws_api_gateway_resource.api_gateway_1_resource.id
  http_method = aws_api_gateway_method.method.http_method
  
  type                    = "AWS"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.flightlist_lambda_arn}/invocations"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.flightlist_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api_gateway_1.execution_arn}/*/*/*"
}


resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway_1.id
  resource_id = aws_api_gateway_resource.api_gateway_1_resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "integration_response_200" {
  depends_on = [ aws_api_gateway_integration.integration ]
  
  rest_api_id = aws_api_gateway_rest_api.api_gateway_1.id
  resource_id = aws_api_gateway_resource.api_gateway_1_resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'" # or the specific domain you want to allow
  }
}

# OPTIONS method for CORS
resource "aws_api_gateway_method" "options" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_1.id
  resource_id   = aws_api_gateway_resource.api_gateway_1_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# Mock Integration for OPTIONS method
resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway_1.id
  resource_id   = aws_api_gateway_resource.api_gateway_1_resource.id
  http_method   = aws_api_gateway_method.options.http_method
  
  type                    = "MOCK"
  request_templates       = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# Method response for OPTIONS
resource "aws_api_gateway_method_response" "options_response_200" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway_1.id
  resource_id = aws_api_gateway_resource.api_gateway_1_resource.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true,
  }
}

# Integration response for OPTIONS
resource "aws_api_gateway_integration_response" "options_integration_response" {
  depends_on = [ aws_api_gateway_integration.options_integration ]

  rest_api_id = aws_api_gateway_rest_api.api_gateway_1.id
  resource_id = aws_api_gateway_resource.api_gateway_1_resource.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = aws_api_gateway_method_response.options_response_200.status_code
  
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'https://www.it-is-what-it-is.site'"

  }
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration_response.integration_response_200,
    aws_api_gateway_integration_response.options_integration_response,
    aws_api_gateway_method.method,
    aws_api_gateway_integration.integration
  ]

  rest_api_id = aws_api_gateway_rest_api.api_gateway_1.id
  stage_name  = var.stage_name
}
