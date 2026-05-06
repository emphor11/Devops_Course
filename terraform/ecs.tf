# ecs.tf

# 1. Get default VPC and Subnets (needed for Fargate)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# 2. Use the existing LabRole for AWS Academy
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

# 3. Create ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "simple-api-cluster"
}

# 4. Create Security Group for ECS Task
resource "aws_security_group" "ecs_tasks" {
  name        = "simple-api-ecs-sg"
  description = "Allow inbound access to Simple API on port 3000"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 3000
    to_port     = 3000
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

# 5. Create ECS Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = "simple-api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.aws_iam_role.lab_role.arn
  task_role_arn            = data.aws_iam_role.lab_role.arn

  container_definitions = jsonencode([
    {
      name = "simple-api-container"
      # Note: This is the URL of the ECR image we pushed in Step 7
      image     = "711402355499.dkr.ecr.us-east-1.amazonaws.com/simple-api:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

# 6. Create ECS Service
resource "aws_ecs_service" "main" {
  name            = "simple-api-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }
}
