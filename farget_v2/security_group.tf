# Security Group for the Load Balancer
resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.main.id

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

# Security Group for the Fargate Service
resource "aws_security_group" "fargate_sg" {
  name        = "fargate_sg"
  description = "Allow traffic from the load balancer"
  vpc_id      = aws_vpc.main.id

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
}