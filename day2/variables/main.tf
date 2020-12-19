provider "aws" {
  region = "us-east-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*18.04*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "myserver" {
  count = 5
  ami = data.aws_ami.ubuntu.image_id
  instance_type = var.size
  tags = {
    Name = "terraform-servers"
  }
}

variable "size" {
  type = string
  default = "t2.micro"
}

output "all-servers" {
  value = aws_instance.myserver[*].public_ip
}
