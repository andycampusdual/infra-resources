/*resource "aws_ecs_service" "nginx_service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.agd_ecs.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.default.id]
    security_groups  = [aws_security_group.default.id]
    assign_public_ip = true
  }
}*/

# Asociar el Target Group con el ECS Service (balanceo de carga)
resource "aws_ecs_service" "nginx_service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.agd_ecs.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets        = var.subnets  # Añadir ambas subredes
    security_groups= [aws_security_group.ecs_service_sg.id] 
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_targets.arn
    container_name   = "nginx-container"
    container_port   = 80
  }

  tags = {
    Environment = var.environment
    Team        = "Devops-bootcamp"
  }
}