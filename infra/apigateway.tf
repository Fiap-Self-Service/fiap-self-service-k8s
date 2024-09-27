resource "aws_apigatewayv2_api" "apifiap" {
  name          = "apifiap"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id = aws_apigatewayv2_api.apifiap.id

  name        = "prod"
  auto_deploy = true
}

resource "aws_apigatewayv2_vpc_link" "eks" {
  name               = "eks"
  security_group_ids = [aws_security_group.eks_security_group.id]
  subnet_ids = module.vpc.private_subnets
}

resource "aws_apigatewayv2_integration" "eks" {
  api_id = aws_apigatewayv2_api.apifiap.id

  integration_uri    = "arn:aws:elasticloadbalancing:us-east-1:125427248349:listener/net/a7c7c084d283b4e76ab8ef40afc61122/ffa958cf9616c2e2/fc3bccc07cf4ed63"
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.eks.id
}

resource "aws_apigatewayv2_route" "geral" {
  api_id = aws_apigatewayv2_api.apifiap.id

  route_key = "ANY /totem/{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.eks.id}/{proxy+}"
}

resource "aws_apigatewayv2_route" "teste" {
  api_id = aws_apigatewayv2_api.apifiap.id

  route_key = "ANY /api"
  target    = "integrations/${aws_apigatewayv2_integration.eks.id}/api"
}

resource "aws_apigatewayv2_route" "teste2" {
  api_id = aws_apigatewayv2_api.apifiap.id

  route_key = "ANY /api2"
  target    = "integrations/${aws_apigatewayv2_integration.eks.id}:3000/api"
}

output "hello_base_url" {
  value = "${aws_apigatewayv2_stage.prod.invoke_url}"
}
