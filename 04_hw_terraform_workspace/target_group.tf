# Create a Load Balancer Target Group for ECS
resource "aws_lb_target_group" "app_tg" {
  name        = "app-tg"
  port        = var.default_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.devops_main.id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "app_tg"
  }
}