module "k8s" {
  source = "./infra"

  cluster_name = "fiap-self-service-k8s"
  region       = "us-east-1"
  zone_az1     = "us-east-1a"
  zone_az2     = "us-east-1b"
  iam_role_arn = "arn:aws:iam::125427248349:role/LabRole"
  url_load_balance = "arn:aws:elasticloadbalancing:us-east-1:125427248349:listener/net/a498c0a3c49e84633abab4f7a8edfe00/4bd21da3955ffe78/ef2abff5cb715205"
}