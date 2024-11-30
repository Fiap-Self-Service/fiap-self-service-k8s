module "k8s" {
  source = "./infra"

  cluster_name = "fiap-self-service-k8s"
  region       = "us-east-1"
  zone_az1     = "us-east-1a"
  zone_az2     = "us-east-1b"
  iam_role_arn = "arn:aws:iam::657290934315:role/LabRole"
  url_load_balance_clientes = "http://a2d78a18e02f34026bc8eae7884eebf9-1640504450.us-east-1.elb.amazonaws.com:3000/clientes/$${proxy}"
}
