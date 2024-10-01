# VPC Link para integração do load balancer interno com api gateway
resource "aws_apigatewayv2_vpc_link" "fiap_vpc_link" {
  name        = "FiapVpcLink"
  security_group_ids = [aws_security_group.eks_security_group.id]
  subnet_ids  = concat(module.vpc.private_subnets, module.vpc.public_subnets)
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

  # Vinculando o Authorizer à Rota
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_authorizer.id

  target = "integrations/${aws_apigatewayv2_integration.fiap_api.id}"
}

# Stage (prefixo, anterior ao path/endpoint que será acionado pelo load balance )
resource "aws_apigatewayv2_stage" "fiap_api" {
  api_id      = aws_apigatewayv2_api.fiap_api.id
  name        = "v1"
  auto_deploy = true
}

# Criação do Authorizer
resource "aws_apigatewayv2_authorizer" "cognito_authorizer" {
  api_id       = aws_apigatewayv2_api.fiap_api.id
  name         = "CognitoAuthorizer"
  authorizer_type = "JWT"
  
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    issuer   = "https://cognito-idp.us-east-1.amazonaws.com/${aws_cognito_user_pool.user_pool.id}"
  }
}

output "invoke_url" {
  value = "${aws_apigatewayv2_stage.fiap_api.invoke_url}"
}
