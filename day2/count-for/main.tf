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


resource "aws_s3_bucket" "s3" {
  bucket = "onmobile-s3-bucket-tut-123"
  lifecycle {
    prevent_destroy = true
  }
  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "dynamodb" {
  name = "terraform-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket= "onmobile-s3-bucket-tut-123"
    key = "global/s3/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "terraform-lock-table"
    encrypt = true
  }
}
