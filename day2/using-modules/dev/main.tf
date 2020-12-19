provider "aws" {
  region = "us-east-2"
}

module "web-servers" {
  source = "../../modules/web-servers/"

  instance-type = "t2.micro"
  key-name = "onmobile-key"
  security-group-id = ["sg-0e978140162d94189"]
  instance-count = 2
}
