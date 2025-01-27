resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "nginx-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"     # CPU para la tarea (unidades vCPU)
  memory                   = "512"     # Memoria total de la tarea (en MiB)

  container_definitions = jsonencode([
    {
      name      = "nginx-container"
      image     = "nginx:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}
