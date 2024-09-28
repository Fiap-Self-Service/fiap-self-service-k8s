resource "aws_api_gateway_rest_api" "example" {
  name        = "FiapSelfServiceAPI"
  description = "API Gateway FiapSelfService"
}

resource "aws_api_gateway_resource" "default" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "$default"
}

resource "aws_api_gateway_method" "default_method" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.default.id
  http_method   = "ANY"  # Aceita todos os métodos HTTP
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "redirect_integration" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.default.id
  http_method = aws_api_gateway_method.default_method.http_method

  type                     = "HTTP"
  uri                      = "http://a55fb585ed9f94fc399f66f3f60f5e96-913860324.us-east-1.elb.amazonaws.com:3000"
}

resource "aws_api_gateway_deployment" "example_deployment" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  stage_name  = "v1"
}

output "invoke_url" {
  value = "${aws_api_gateway_deployment.example_deployment.invoke_url}"
}
