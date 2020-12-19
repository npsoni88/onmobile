provider "aws" {
  region = "us-east-2"
}

#resource "aws_instance" "myserver" {
#  ami = "ami-0dd9f0e7df0f0a138"
#  instance_type = "t2.micro"
#  key_name = "onmobile-key"
#  vpc_security_group_ids = [aws_security_group.mysg.id]
#  user_data = <<-EOF
#              #!/bin/bash
#              sudo apt-get update
#              sudo apt-get install -y apache2
#              echo "Kubernetes is great!" > /var/www/html/index.html
#              EOF
#  tags = {
#    Name = "terraform-server"
#  }
#}

resource "aws_security_group" "mysg" {
  name = "terraform-security-group"

  ingress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_launch_configuration" "mylc" {
  image_id = "ami-0dd9f0e7df0f0a138"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.mysg.id]
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y apache2
              echo "Kubernetes is great!" > /var/www/html/index.html
              EOF

}

resource "aws_autoscaling_group" "myasg" {
  name = "onmobile-asg"
  launch_configuration = aws_launch_configuration.mylc.name
  vpc_zone_identifier = data.aws_subnet_ids.default.ids
  load_balancers = [aws_elb.mylb.name]
  desired_capacity = 2
  min_size = 2
  max_size = 10
  tag {
    key = "Name"
    value = "onmobile-autoscaling-group"
    propagate_at_launch = true
  }
}

resource "aws_elb" "mylb" {
  name = "onmobile-lb"
  security_groups = [aws_security_group.mysg.id]
  availability_zones = data.aws_availability_zones.all.names
  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 80
    lb_protocol        = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
}

data "aws_availability_zones" "all" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

