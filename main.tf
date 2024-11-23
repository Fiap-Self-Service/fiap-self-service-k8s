module "k8s" {
  source = "./infra"

  cluster_name = "fiap-self-service-k8s"
  region       = "us-east-1"
  zone_az1     = "us-east-1a"
  zone_az2     = "us-east-1b"
  iam_role_arn = "arn:aws:iam::629468475927:role/LabRole"
  url_load_balance_clientes = "http://ab2d76323dda749e2a825b9d7eb44e5e-95224636.us-east-1.elb.amazonaws.com:3000/clientes/"
}
