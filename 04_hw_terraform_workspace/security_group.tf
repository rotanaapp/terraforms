# Define a Security Group for the Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Security group for the load balancer"
  vpc_id      = aws_vpc.devops_main.id

  ingress {
    from_port   = var.default_port
    to_port     = var.default_port
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }
}

# efine a Security Group for ECS Tasks
resource "aws_security_group" "fargate_sg" {
  name        = "fargate_sg"
  description = "Security group for ECS tasks"
  vpc_id      = aws_vpc.devops_main.id

  ingress {
    from_port       = var.default_port
    to_port         = var.default_port
    protocol        = "tcp"
    security_groups = [
        aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }

  tags = {
    Name = "fargate_sg"
  }
}