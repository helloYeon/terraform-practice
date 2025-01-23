
##############################
# Security Group Module
##############################
resource "aws_security_group" "instance" {
  name = "${var.PROJECT_NAME}-${var.ENV}-instance-sg"

  ingress  {
    from_port   = var.INSTANCE_PORT
    to_port     = var.INSTANCE_PORT
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name = "${var.PROJECT_NAME}-${var.ENV}-instance-sg"
      ENV = var.ENV
  }
}
resource "aws_security_group" "alb" {
  name = "${var.PROJECT_NAME}-${var.ENV}-instance-alb"

  ingress  {
    from_port   = var.ALB_PORT
    to_port     = var.ALB_PORT
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name = "${var.PROJECT_NAME}-${var.ENV}-alb-sg"
      ENV = var.ENV
  }
}
