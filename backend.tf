terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-unico-fiap-k8s"
    key            = "terraform/state"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks-fiap-k8s"
  }
}