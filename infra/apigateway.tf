resource "aws_api_gateway_rest_api" "my_api" {
  name        = "MyAPI"
  description = "My API Gateway"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy_method.http_method
  integration_http_method = "ANY"
  type                    = "HTTP"

  uri = "http://a55fb585ed9f94fc399f66f3f60f5e96-913860324.us-east-1.elb.amazonaws.com:3000/{proxy}"
}

# Modelo de resposta vazio
resource "aws_api_gateway_model" "empty_model" {
  rest_api_id  = aws_api_gateway_rest_api.my_api.id
  name         = "EmptyModel"
  content_type = "application/json"
  schema = jsonencode({
    type       = "object"
    properties = {}
  })
}

# 200 Response
resource "aws_api_gateway_method_response" "proxy_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = aws_api_gateway_model.empty_model.name
  }
}

# 201 Response
resource "aws_api_gateway_method_response" "proxy_method_response_201" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_method.http_method
  status_code = "201"

  response_models = {
    "application/json" = aws_api_gateway_model.empty_model.name
  }
}

# 400 Response
resource "aws_api_gateway_method_response" "proxy_method_response_400" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_method.http_method
  status_code = "400"

  response_models = {
    "application/json" = aws_api_gateway_model.empty_model.name
  }
}

resource "aws_api_gateway_deployment" "my_api_deployment" {
  depends_on = [
    aws_api_gateway_method_response.proxy_method_response_200,
    aws_api_gateway_method_response.proxy_method_response_201,
    aws_api_gateway_method_response.proxy_method_response_400
  ]
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name  = "v1"
}
