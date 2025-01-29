provider "aws" {
  region = "eu-west-3" # Reemplaza con tu región de AWS
}

resource "aws_ecr_repository" "agd_ecr_repo" {
  name                 = "agd-ecr-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "repository_url" {
  value = aws_ecr_repository.agd_ecr_repo.repository_url
}

resource "aws_ecr_repository_policy" "repo_policy" {
  repository = aws_ecr_repository.agd_ecr_repo.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowPushPull",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:sts::248189943700:assumed-role/AWSReservedSSO_EKS-alumnos_a4561514b13725b0/andy.garcia@campusdual.com"
      },
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ]
    }
  ]
}
POLICY
}

resource "null_resource" "upload_image" {
  provisioner "local-exec" {
    command = <<EOT
    # Authenticate Docker to ECR (use your actual account ID)
    aws ecr get-login-password --region eu-west-3 | docker login --username AWS --password-stdin 248189943700.dkr.ecr.eu-west-3.amazonaws.com
 
    # Build Docker image
    docker build -t 248189943700.dkr.ecr.eu-west-3.amazonaws.com/agd-ecr-repo:latest .
 
    # Push Docker image to ECR
    docker push 248189943700.dkr.ecr.eu-west-3.amazonaws.com/agd-ecr-repo:latest
    EOT
  }
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  repository = aws_ecr_repository.agd_ecr_repo.name

  policy = <<EOT
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Eliminar imágenes no etiquetadas después de 30 días",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOT
}


