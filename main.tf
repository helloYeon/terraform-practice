provider "aws" {
  region  = "us-east-2"
  profile = "ADGS"
}

#########################
# ec2
#########################
resource "aws_launch_template" "example" {
  image_id        = "ami-0fb653ca2d3203ac1"
  instance_type   = "t2.micro"

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "Hello,World" > index.html
    nohup busybox httpd -f -p ${var.port} &
    EOF
  )


  network_interfaces {
    security_groups = [aws_security_group.instance.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "terraform4-asg-example"
    }
  }

  lifecycle {
    create_before_destroy = true
  }

}

#########################
# security group
#########################
resource "aws_security_group" "instance" {
  name = "terraform-example-sg"

  ingress  {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "alb" {
  name = "terraform-example-alb"

  ingress  {
    from_port   = 80
    to_port     = 80
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


#########################
# network
#########################

data "aws_vpc" "default"{
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

}

#########################
# alb
#########################
resource "aws_lb" "example" {
  name               = "terraform4-asg-example"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids

  security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404;apple banana"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}
resource "aws_lb_target_group" "asg" {
  name="terraform4-asg-example"
  port = var.port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path     = "/"
    protocol = "HTTP"
    matcher  = "200"
    interval = 15
    timeout  = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

#########################
# Auto scaling group
#########################
resource "aws_autoscaling_group" "example" {
  # launch_configuration = aws_launch_template.example.name
  vpc_zone_identifier  = data.aws_subnets.default.ids

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "terraform4-asg-example"
    propagate_at_launch = true
  }
}

