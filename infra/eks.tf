# Cluster EKS, rodando na VPC criada no arquivo vpc.tf
resource "aws_eks_cluster" "k8s_cluster" {
  name     = var.cluster_name
  role_arn = var.iam_role_arn

  depends_on = [
    module.vpc
  ]

  vpc_config {
    subnet_ids = concat(module.vpc.private_subnets, module.vpc.public_subnets)
    security_group_ids = [aws_security_group.eks_security_group.id]
  }

  tags = {
    Name = var.cluster_name
  }
}

data "aws_eks_cluster_auth" "k8s_cluster_auth" {
  name = aws_eks_cluster.k8s_cluster.name
}

# Nós disponibilizados para o cluster kubernates
resource "aws_eks_node_group" "k8s_node_group" {
  cluster_name    = var.cluster_name
  node_group_name = "k8s_node_group"
  node_role_arn   = var.iam_role_arn
  subnet_ids      = module.vpc.private_subnets

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  instance_types = ["t3.small"]
  ami_type = "AL2_x86_64"
  depends_on = [aws_eks_cluster.k8s_cluster]

  tags = {
    Name = "k8s_node_group"
  }
}

# Grupo de segurança para acesso a protocolos e portas dos serviços
resource "aws_security_group" "eks_security_group" {
  vpc_id = module.vpc.vpc_id
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-sg"
  }
}