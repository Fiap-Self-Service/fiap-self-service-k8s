# Criar o VPC Endpoint para o API Gateway se integrar com Load balancer
resource "aws_vpc_endpoint" "apigateway" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.us-east-1.execute-api"
  vpc_endpoint_type = "Interface"
  subnet_ids = concat(module.vpc.private_subnets, module.vpc.public_subnets)
  security_group_ids = [aws_security_group.eks_security_group.id]

  depends_on = [
    module.vpc
  ]
}

# API Gateway para acesso a aplicação
resource "aws_apigatewayv2_api" "fiap_api" {
  name          = "Fiap Self Service API"
  protocol_type = "HTTP"
}

# Integracao com load balance do EKS
resource "aws_apigatewayv2_integration" "fiap_api" {
  api_id           = aws_apigatewayv2_api.fiap_api.id
  integration_type = "HTTP_PROXY"

  integration_method = "ANY"
  integration_uri    = var.url_load_balance
}

# Rota default que serve como proxy, redirecionando a chamada do API Gateway para os endpoints expostos pelo load balance
resource "aws_apigatewayv2_route" "fiap_api" {
  api_id    = aws_apigatewayv2_api.fiap_api.id
  route_key = "$default"

  target = "integrations/${aws_apigatewayv2_integration.fiap_api.id}"
}

# Stage (prefixo, anterior ao path/endpoint que será acionado pelo load balance )
resource "aws_apigatewayv2_stage" "fiap_api" {
  api_id      = aws_apigatewayv2_api.fiap_api.id
  name        = "v1"
  auto_deploy = true
}

output "invoke_url" {
  value = "${aws_apigatewayv2_stage.fiap_api.invoke_url}"
}
