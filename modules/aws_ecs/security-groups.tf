resource "aws_security_group" "alb_sg" {
  name        = "ecs-agd-alb-sg"
  description = "Security group for ALB"
  vpc_id      = data.aws_vpc.default.id
 
  # Reglas de entrada para el ALB
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic"
  }
 
  # Reglas de salida (permitir todo el tráfico de salida)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
 
  tags = {
    Name = "${var.environment}ecs-alb-sg"
  }
}


resource "aws_security_group" "ecs_service_sg" {
  name        = "vecs-agd-task-sg"
  description = "Security group for ECS task"
  vpc_id      = data.aws_vpc.default.id
 
  # Permitir tráfico de las instancias del ALB en el puerto 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]  # Permite tráfico desde el ALB
    description = "Allow HTTP traffic from ALB"
  }
 
  # Regla de salida (permitir todo el tráfico de salida)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
 
  tags = {
    Name = "${var.environment}ecs-task-sg"
  }
}