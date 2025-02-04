provider "aws" {
  region = "eu-west-3" # Cambia por la región que usas
}

resource "aws_ecs_cluster" "agd_ecs" {
  name = "${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = var.container_insight_status.disable ? "disabled" : "enabled" # Conversión del booleano a cadena
  }

  tags = {
    Environment = var.environment
    Team        = "Devops-bootcamp"
  }
}

# Referenciar la VPC predeterminada existente
data "aws_vpc" "default" {
  default = true
}

resource "aws_subnet" "default" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.231.0/24"
  availability_zone       = "eu-west-3a"  # Ajusta según tu zona de disponibilidad
  map_public_ip_on_launch = true
}

resource "aws_security_group" "default" {
  name        = "default-security-group"
  description = "Grupo de seguridad para nginx service"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
