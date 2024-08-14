# Create ECS Cluster
resource "aws_ecs_cluster" "demo_cluster" {
  name = "demo_cluster"
}

# Create ECS Task Definition
resource "aws_ecs_task_definition" "htmldemo" {
  family                   = var.proj_name
  network_mode             = "awsvpc"
  requires_compatibilities = [var.ecs_type]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = var.proj_name
      image     = var.image_name
      essential = true
      portMappings = [
        {
          containerPort = var.default_port
          hostPort      = var.default_port
        }
      ]
    }
  ])
}

# Create ECS Service
resource "aws_ecs_service" "htmldemo_service" {
  name            = "htmldemo_service"
  cluster         = aws_ecs_cluster.demo_cluster.id
  task_definition = aws_ecs_task_definition.htmldemo.arn
  desired_count   = 1
  launch_type     = var.ecs_type

  network_configuration {
    subnets          = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
    security_groups  = [aws_security_group.fargate_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = var.proj_name
    container_port   = var.default_port
  }

  depends_on = [aws_lb_listener.app_lb_listener]
}
