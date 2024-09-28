module "k8s" {
  source = "./infra"

  cluster_name = "fiap-self-service-k8s"
  region       = "us-east-1"
  zone_az1     = "us-east-1a"
  zone_az2     = "us-east-1b"
  iam_role_arn = "arn:aws:iam::125427248349:role/LabRole"
  url_load_balance = "arn:aws:elasticloadbalancing:us-east-1:125427248349:listener/net/aadfa33dba232459c953a70b3381a909/617e9a439eaa8419/d4914d423e4ea231"
}