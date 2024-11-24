# API Gateway para acesso a aplicação
resource "aws_apigatewayv2_api" "fiap_api" {
  name          = "Fiap Self Service API"
  protocol_type = "HTTP"
}

# VPC Link para integração do load balancer interno com api gateway
resource "aws_apigatewayv2_vpc_link" "fiap_vpc_link" {
  name        = "FiapVpcLink"
  security_group_ids = [aws_security_group.eks_security_group.id]
  subnet_ids  = concat(module.vpc.private_subnets, module.vpc.public_subnets)
}

# Integracao com load balance do EKS
resource "aws_apigatewayv2_integration" "fiap_api_clientes" {
  api_id           = aws_apigatewayv2_api.fiap_api.id
  integration_type = "HTTP_PROXY"

  integration_method = "ANY"
  integration_uri    = var.url_load_balance_clientes
}

# Rota default que serve como proxy, redirecionando a chamada do API Gateway para os endpoints expostos pelo load balance
resource "aws_apigatewayv2_route" "fiap_api_clientes" {
  api_id    = aws_apigatewayv2_api.fiap_api.id
  route_key = "ANY /fiap-clientes-api/{proxy+}"

#   # Vinculando o Authorizer à Rota
#   authorization_type = "JWT"
#   authorizer_id      = aws_apigatewayv2_authorizer.cognito_authorizer.id

  target = "integrations/${aws_apigatewayv2_integration.fiap_api_clientes.id}"
}

# Stage (prefixo, anterior ao path/endpoint que será acionado pelo load balance )
resource "aws_apigatewayv2_stage" "fiap_api" {
  api_id      = aws_apigatewayv2_api.fiap_api.id
  name        = "v1"
  auto_deploy = true
}

# Criação do Authorizer
# resource "aws_apigatewayv2_authorizer" "cognito_authorizer" {
#   api_id       = aws_apigatewayv2_api.fiap_api.id
#   name         = "CognitoAuthorizer"
#   authorizer_type = "JWT"
  
#   identity_sources = ["$request.header.Authorization"]

#   jwt_configuration {
#     audience = [aws_cognito_user_pool_client.user_pool_client.id]
#     issuer   = "https://cognito-idp.us-east-1.amazonaws.com/${aws_cognito_user_pool.user_pool.id}"
#   }
# }


# resource "aws_cognito_user_pool" "user_pool" {
#   name = "auth_user_pool"

#   # Definindo atributos do usuário
#   alias_attributes        = ["email"]
#   auto_verified_attributes = ["email"]

#   # Configuração de verificação de email
#   email_verification_message = "Seu código de verificação é {####}."
#   email_verification_subject  = "Confirmação de email"

#   # Configurações de segurança
#     password_policy {
#       minimum_length                = 6
#       require_uppercase             = false
#       require_lowercase             = false
#       require_numbers               = false
#       require_symbols               = false
#       temporary_password_validity_days = 7
#     }

#   # Configuração de atributos
#   schema {
#     name     = "email"
#     attribute_data_type = "String"
#     required = true
#     mutable  = true
#   }

#   # Limitar as configurações de recursos
#   admin_create_user_config {
#     allow_admin_create_user_only = true
#   }
# }

# resource "aws_cognito_user_pool_client" "user_pool_client" {
#   name         = "auth_user_pool_client"
#   user_pool_id = aws_cognito_user_pool.user_pool.id

#   generate_secret = true
#   explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_CUSTOM_AUTH"]
# }

# output "user_pool_id" {
#   value = aws_cognito_user_pool.user_pool.id
# }

# output "client_id" {
#   value = aws_cognito_user_pool_client.user_pool_client.id
# }

# output "invoke_url" {
#   value = "${aws_apigatewayv2_stage.fiap_api.invoke_url}"
# }
