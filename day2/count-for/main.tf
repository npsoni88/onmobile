provider "aws" {
  region = "us-east-2"
}

variable "users" {
  type = list(string)
  default = ["nishant","john","manjunath"]
}

resource "aws_iam_user" "user" {
  for_each = toset(var.users)
  name = each.key
}

resource "aws_instance" "myserver" {
  ami = "ami-0dd9f0e7df0f0a138"
  instance_type = "t2.micro"
  key_name = "onmobile-key"
  tags = {
    Name = "terraform-server"
  }
}

