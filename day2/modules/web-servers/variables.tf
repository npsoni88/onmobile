variable "ami-id"{
  type = string
  description = "AMI Image ID to be used for the servers"
  default = "ami-0dd9f0e7df0f0a138"
}

variable "instance-type" {
  type = string
  description = "Size of the AWS instance to be used"
}

variable "key-name" {
  type = string
  description = "ssh key to use for these servers"
}

variable "security-group-id" {
  type = list(string)
  description = "id of the security group to be attached to instances"
}

variable "instance-count" {
  type = number
  description = "Number of instances to spawn"
}

