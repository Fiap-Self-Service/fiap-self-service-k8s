
resource "aws_cognito_user_pool" "user_pool" {
  name = "auth_user_pool"

  # Definindo atributos do usuário
  alias_attributes        = ["email"]
  auto_verified_attributes = ["email"]

  # Configuração de verificação de email
  email_verification_message = "Seu código de verificação é {####}."
  email_verification_subject  = "Confirmação de email"

  # Configurações de segurança
    password_policy {
      minimum_length                = 6
      require_uppercase             = false
      require_lowercase             = false
      require_numbers               = false
      require_symbols               = false
      temporary_password_validity_days = 7
    }

  # Configuração de atributos
  schema {
    name     = "email"
    attribute_data_type = "String"
    required = true
    mutable  = true
  }

  # Limitar as configurações de recursos
  admin_create_user_config {
    allow_admin_create_user_only = true
  }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "auth_user_pool_client"
  user_pool_id = aws_cognito_user_pool.user_pool.id

  generate_secret = true
  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_CUSTOM_AUTH"]
}

output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}
