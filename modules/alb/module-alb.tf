
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

##############################
# ALB
##############################
resource "aws_lb" "alb" {
  name               = "${var.PROJECT_NAME}-${var.ENV}-alb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids

  security_groups = [var.alb_sg_id]
}

##############################
# ALB Listener
##############################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.ALB_PORT
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

##############################
# ALB Listener Rule
##############################
resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

##############################
# ALB Target Group
##############################
resource "aws_lb_target_group" "asg" {

  name      = "${var.PROJECT_NAME}-${var.ENV}-tg"
  port      = var.ALB_PORT
  protocol  = "HTTP"
  vpc_id    = data.aws_vpc.default.id

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

