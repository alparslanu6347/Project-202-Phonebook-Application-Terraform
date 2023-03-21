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
  user_data   = base64encode(data.template_file.phonebook.rendered)
  depends_on  = [github_repository_file.webserver-db_endpoint]
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = var.instance_name
    }
  }
}

