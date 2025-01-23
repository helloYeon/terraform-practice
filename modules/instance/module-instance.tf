##############################
# EC2 - For Application
##############################
resource "aws_launch_template" "app" {
  image_id        = "ami-0fb653ca2d3203ac1"
  instance_type   = var.APP_INSTANCE_TYPE

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo "Hello,World" > index.html
    nohup busybox httpd -f -p ${var.INSTANCE_PORT} &
    EOF
  )

  network_interfaces {
    security_groups = [var.instance_sg_id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.PROJECT_NAME}-${var.ENV}-app"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}