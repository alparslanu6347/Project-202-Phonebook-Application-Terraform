resource "aws_launch_template" "ec2_lt" {
  name          = var.launch-template_name
  description   = "Phonebook-Launch-Template"
  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = var.instance_type

  key_name               = var.instance_keypair
  vpc_security_group_ids = [aws_security_group.ec2_sec-grp.id]
  network_interfaces {
    associate_public_ip_address = true
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.instance_name
    }
  }
  user_data = file("${path.module}/phonebook-userdata.sh")
}


# data "aws_ami" "amazon-linux-2" {
#   owners      = ["amazon"]
#   most_recent = true

#   filter {                                  
#     name   = "root-device-type"
#     values = ["ebs"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   filter {
#     name   = "architecture"
#     values = ["x86_64"]
#   }

#   filter {
#     name   = "owner-alias"      
#     values = ["amazon"]
#   }

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-kernel-5.10-hvm*"]
#   }
# }


