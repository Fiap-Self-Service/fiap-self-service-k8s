# Virtual Private Cloud - Rede virtual AWS
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
  
module "vpc" {

  source = "terraform-aws-modules/vpc/aws" 

  name = "vpc-k8s" 
  cidr = "10.0.0.0/16" 

  # zonas de disponibilidade
  azs             = [var.zone_az1, var.zone_az2]

  # Configuracao das 6 subnets, 3 privadas e 3 publicas
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

   public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}