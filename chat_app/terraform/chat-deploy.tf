provider "aws" {
  region = local.aws_region  # Usamos una variable para la región, que podemos definir en variables.tf

}
locals {
  tag_value="agd"
  aws_region = "eu-west-2" 
  ecr_url = "248189943700.dkr.ecr.eu-west-2.amazonaws.com/agd-my-ecr-repo"

}

terraform {
  backend "s3" {
    bucket = "project-2-agd-devops-bucket"          # Nombre de tu bucket S3
    key    = "terraform/31-01-chatbot/terraform.tfstate"           # Ruta y nombre del archivo de estado dentro del bucket
    region = "eu-west-2"                           # Región donde está tu bucket S3
    encrypt = true                                   # Habilita el cifrado en el bucket
    #dynamodb_table = "mi-tabla-dynamodb"             # (Opcional) Usa DynamoDB para el bloqueo del estado (si lo deseas)
  }
}

data "template_file" "nginx_deployment_yaml" {
  template = file("${path.module}/chat-deploy.tpl")

  vars = {
    ecr_url = "${local.ecr_url}:chat-bot"
  }
}


resource "kubernetes_manifest" "nginx_deployment" {
  manifest = yamldecode(data.template_file.nginx_deployment_yaml.rendered)
}


provider "kubernetes" {
  config_path = "~/.kube/config"
}