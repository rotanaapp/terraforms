# Create Target Group
resource "aws_lb_target_group" "app_tg" {
  name        = "app-tg"
  port        = var.default_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
}