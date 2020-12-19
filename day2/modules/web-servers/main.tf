resource "aws_instance" "servers" {
  count = var.instance-count
  ami = var.ami-id
  instance_type = var.instance-type
  key_name = var.key-name
  vpc_security_group_ids = var.security-group-id
}

