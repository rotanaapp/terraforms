# Create an ECS Cluster
resource "aws_ecs_cluster" "devops_cluster" {
  name = "devops_cluster"

  tags = {
    Name = "devops_cluster"
  }
}

#Create the ECR Repository
resource "aws_ecr_repository" "devops_repository" {
  name                 = "${var.project_name}-repository"
  image_tag_mutability = "MUTABLE"

  tags = {
    Name = "${var.project_name}-repository"
  }
}

# Create a Fargate Task Definition
resource "aws_ecs_task_definition" "devops_final" {
  family                   = var.project_name
  network_mode             = "awsvpc"
  requires_compatibilities = [var.ecs_type]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = var.project_name
      image     = "${aws_ecr_repository.devops_repository.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.default_port
          hostPort      = var.default_port
        }
      ]
    }
  ])

  tags = {
    Name = "devops_final"
  }
}

# Create an ECS Service
resource "aws_ecs_service" "devops_final_service" {
  name            = "devops_final_service"
  cluster         = aws_ecs_cluster.devops_cluster.id
  task_definition = aws_ecs_task_definition.devops_final.arn
  desired_count   = 2
  launch_type     = var.ecs_type

  network_configuration {
    subnets          = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
    security_groups  = [aws_security_group.fargate_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = var.project_name
    container_port   = var.default_port
  }

  depends_on = [aws_lb_listener.app_lb_listener]

  tags = {
    name = "devops_final_service"
  }
}
