data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "phonebook" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  /* filter {
    name = "tag:Name"
    values = ["default*"]
  } */  
}

data "aws_ami" "amazon-linux-2" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm*"]
  }
}

data "template_file" "phonebook" {
  template = file("phonebook-userdata.sh")
  vars = {
    user-data-git-token = var.git-token
    user-data-git-name  = var.git-name
  }
}

data "aws_route53_zone" "selected" {
  name = var.hosted-zone
}