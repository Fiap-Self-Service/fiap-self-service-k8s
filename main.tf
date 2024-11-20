module "k8s" {
  source = "./infra"

  cluster_name = "fiap-self-service-k8s"
  region       = "us-east-1"
  zone_az1     = "us-east-1a"
  zone_az2     = "us-east-1b"
  iam_role_arn = "arn:aws:iam::629468475927:role/LabRole"
  url_load_balance = "http://aadfa33dba232459c953a70b3381a909-617e9a439eaa8419.elb.us-east-1.amazonaws.com:3000"
}