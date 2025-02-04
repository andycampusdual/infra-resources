provider "aws" {
  region = local.aws_region
}

locals {
  tag_value = "agd"
  instance_type = "t2.small"
  aws_region = "eu-west-2"
  vpc_id = "vpc-0c9f03551cb17af5d"
  subnets = ["subnet-0399f98a4db137765", "subnet-0b0842bc836a4b6cb", "subnet-0eb5d5076276d2346"]
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "mi-cluster-${local.tag_value}"
  cluster_version = "1.32"  # Asegúrate de usar una versión compatible

  vpc_id     = local.vpc_id
  subnet_ids = local.subnets

  cluster_endpoint_public_access = true
  cluster_endpoint_private_access = true

  eks_managed_node_groups = {
    grupo-nodos = {
      desired_size = 2
      max_size     = 3
      min_size     = 1

      instance_types = [local.instance_type]

      # Añadir etiquetas y configuraciones adicionales si es necesario
      labels = {
        Name = "grupo-nodos"
      }
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

terraform {
  backend "s3" {
    bucket = "project-2-agd-devops-bucket"
    key    = "terraform/eks/terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
  }
}

output "node_security_group_id" {
  description = "ID of the node shared security group"
  value       = try(module.eks.node_security_group_id, null)
}