provider "aws" {
  region = "us-east-2"
  profile = "ADGS"
}

resource "aws_instance" "name" {
  # ami="ami-0b29b5390767b72b2"
  ami="ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"

  user_data = <<-EOF
    #!/bin/bash
    echo "Hello,World" > index.html
    nohup busybox httpd -f -p ${var.port} &
    EOF

  user_data_replace_on_change = true

  vpc_security_group_ids = [aws_security_group.instance.id]
  tags = {
    "Name" = "terraform-example"
  }

}

resource "aws_security_group" "instance" {
  name = "terraform-example-sg"

  ingress  {
    from_port=var.port
    to_port=var.port
    protocol="tcp"
    cidr_blocks=["0.0.0.0/0"]
  }

}