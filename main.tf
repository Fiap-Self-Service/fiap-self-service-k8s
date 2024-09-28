module "k8s" {
  source = "./infra"

  cluster_name = "fiap-self-service-k8s"
  region       = "us-east-1"
  zone_az1     = "us-east-1a"
  zone_az2     = "us-east-1b"
  iam_role_arn = "arn:aws:iam::125427248349:role/LabRole"
  url_load_balance = "http://a55fb585ed9f94fc399f66f3f60f5e96-913860324.us-east-1.elb.amazonaws.com:3000"
}