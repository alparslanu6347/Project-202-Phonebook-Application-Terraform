resource "aws_security_group" "ec2_sec-grp" {
  name        = "phonebook_ec2_sec-grp"
  vpc_id      = data.aws_vpc.default.id
  description = "phonebook_ec2_sec-grp enables HTTP for Flask Web Server and SSH for getting into EC2"

  ingress {
    description     = "Allow Port 80 from application load balancer security group"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sec-grp.id]
  }

  ingress {
    description = "Allow SSH access from any IP address"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "phonebook-application_ec2_secgrp"
  }
}
