module "k8s" {
  source = "./infra"

  cluster_name = "fiap-self-service-k8s"
  region       = "us-east-1"
  zone_az1     = "us-east-1a"
  zone_az2     = "us-east-1b"
  iam_role_arn = "arn:aws:iam::657290934315:role/LabRole"
  url_load_balance_clientes = "http://afeddc5b1eb6748ae9dea98e36d024fc-2107783033.us-east-1.elb.amazonaws.com:3000/{proxy}"
  url_load_balance_produtos = "http://a66bebda4839040d985d6b1f69d8489b-2057161215.us-east-1.elb.amazonaws.com:3001/{proxy}"
  url_load_balance_pagamentos = "http://a54b7fa13836f4239bda3ceb3a01624f-240287251.us-east-1.elb.amazonaws.com:3003/{proxy}"
  url_load_balance_pedidos = "http://ae0c35b56d686420cbbf9427d9685c0a-274499234.us-east-1.elb.amazonaws.com:3002/{proxy}"
}
