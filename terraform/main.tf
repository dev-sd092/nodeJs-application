provider "aws" {
  region = var.aws_region
}

# -----------------------
# ECR Repository
# -----------------------
resource "aws_ecr_repository" "app_repo" {
  name = var.ecr_repo_name
}

# -----------------------
# ECS Cluster
# -----------------------
resource "aws_ecs_cluster" "app_cluster" {
  name = var.ecs_cluster_name
}

# -----------------------
# IAM Role for ECS Task
# -----------------------
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# -----------------------
# ECS Task Definition
# -----------------------
resource "aws_ecs_task_definition" "app_task" {
  family                   = "my-devops-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "my-devops-app"
    image     = "${aws_ecr_repository.app_repo.repository_url}:latest"
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
  }])
}

# -----------------------
# ECS Service
# -----------------------
resource "aws_ecs_service" "app_service" {
  name            = "my-devops-app-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.security_group_id]
    assign_public_ip = true
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_task_execution_policy]
}
