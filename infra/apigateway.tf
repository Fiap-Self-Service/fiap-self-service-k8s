resource "aws_apigatewayv2_api" "example" {
  name          = "example-http-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "example" {
  api_id           = aws_apigatewayv2_api.example.id
  integration_type = "HTTP_PROXY"

  integration_method = "ANY"
  integration_uri    = "https://example.com/{proxy}"
}

resource "aws_apigatewayv2_route" "example" {
  api_id    = aws_apigatewayv2_api.example.id
  route_key = "ANY /example/{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.example.id}"
}
resource "aws_api_gateway_deployment" "fiap_api_deployment" {
  api_id      = aws_apigatewayv2_api.example.id
  name        = "v1"
  auto_deploy = true
}


output "invoke_url" {
  value = "${aws_api_gateway_deployment.fiap_api_deployment.invoke_url}"
}
