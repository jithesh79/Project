resource "aws_ecs_cluster" "main" {
  name = "cloudzenia-ecs-cluster"
}

resource "aws_ecs_task_definition" "wordpress_task" {
  family                   = "wordpress"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "wordpress"
    image     = "wordpress:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
    secrets = [
      { name = "DB_USERNAME", valueFrom = aws_secretsmanager_secret.db_secret.arn },
      { name = "DB_PASSWORD", valueFrom = aws_secretsmanager_secret.db_secret.arn }
    ]
  }])
}

resource "aws_ecs_task_definition" "node_task" {
  family                   = "node-microservice"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "microservice"
    image     = var.node_docker_image
    essential = true
    portMappings = [{ containerPort = 3000, hostPort = 3000 }]
  }])
}
