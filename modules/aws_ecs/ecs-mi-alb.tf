# Crear el ALB (Application Load Balancer)
resource "aws_lb" "ejemplo_alb" {
  name                        = "ecs-alb-${var.environment}"
  internal                    = false
  load_balancer_type          = "application"
  security_groups             = [aws_security_group.alb_sg.id] 
  subnets                     = var.subnets # Añadir una segunda subred
  enable_deletion_protection  = false
  //enable_cross_zone_load_balancing = true

  tags = {
    Environment = var.environment
    Team        = "Devops-bootcamp"
  }
}

# Crear el Target Group para ECS con tipo de destino 'ip'
resource "aws_lb_target_group" "ecs_targets" {
  name     = "ecs-target-group-${var.environment}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Environment = var.environment
    Team        = "Devops-bootcamp"
  }
}
