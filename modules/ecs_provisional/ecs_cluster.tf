provider "aws" {
  region = local.aws_region  # Usamos una variable para la región, que podemos definir en variables.tf

}
locals {
  tag_value="agd"
  instance_type="t2.small" 
  aws_region = "eu-west-3" 
  vpc_id="vpc-002427d5be38383d7"
  subnets=["subnet-0717aac9526c9ff4b", "subnet-00f809b073695b201"]
}

terraform {
  backend "s3" {
    bucket = "proyect-1-agd-devops-bucket"          # Nombre de tu bucket S3
    key    = "terraform/ecs/terraform.tfstate"           # Ruta y nombre del archivo de estado dentro del bucket
    region = "eu-west-3"                           # Región donde está tu bucket S3
    encrypt = true                                   # Habilita el cifrado en el bucket
    #dynamodb_table = "mi-tabla-dynamodb"             # (Opcional) Usa DynamoDB para el bloqueo del estado (si lo deseas)
  }
}

resource "aws_ecs_cluster" "mi_ecs" {
    name = "${local.tag_value}-cluster"
        setting {
            name = "containerInsights"
            value = "disabled"
        }
    tags = {
        Team = "Devops-bootcamp"
    }
}

output "ecs_cluster_id" {
  description = "El ID del clúster ECS creado"
  value       = aws_ecs_cluster.mi_ecs.id
}

output "ecs_cluster_name" {
  description = "El nombre del clúster ECS creado"
  value       = aws_ecs_cluster.mi_ecs.name
}

