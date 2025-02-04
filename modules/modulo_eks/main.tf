provider "aws" {
  region = "eu-west-3"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "mi-cluster-agd"
  cluster_version = "1.31"
  vpc_id          = "vpc-002427d5be38383d7"
  subnet_ids      = ["subnet-0717aac9526c9ff4b", "subnet-00f809b073695b201"]
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.my_cluster.token
}

data "aws_eks_cluster_auth" "my_cluster" {
  name = module.eks.cluster_name
}
