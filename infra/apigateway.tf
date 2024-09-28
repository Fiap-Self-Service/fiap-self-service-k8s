resource "aws_api_gateway_rest_api" "fiap_api" {
  name        = "Fiap Self Service API"
  description = "Fiap API"
}

resource "aws_api_gateway_resource" "default" {
  rest_api_id = aws_api_gateway_rest_api.fiap_api.id
  parent_id   = aws_api_gateway_rest_api.fiap_api.root_resource_id
  path_part   = "$default"
}

resource "aws_api_gateway_method" "default_method" {
  rest_api_id   = aws_api_gateway_rest_api.fiap_api.id
  resource_id   = aws_api_gateway_resource.default.id
  http_method   = "ANY"  # Aceita todos os métodos HTTP
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "http_proxy_integration" {
  rest_api_id = aws_api_gateway_rest_api.fiap_api.id
  resource_id = aws_api_gateway_resource.default.id
  http_method = aws_api_gateway_method.default_method.http_method

  type                     = "HTTP_PROXY"
  uri                      = "http://a55fb585ed9f94fc399f66f3f60f5e96-913860324.us-east-1.elb.amazonaws.com:3000"
  connection_type          = "INTERNET"
  request_parameters       = {}
  request_templates        = {}
}

resource "aws_api_gateway_deployment" "fiap_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.fiap_api.id
  stage_name  = "v1"
}

output "invoke_url" {
  value = "${aws_api_gateway_deployment.fiap_api_deployment.invoke_url}"
}
