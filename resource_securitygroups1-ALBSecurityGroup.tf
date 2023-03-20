resource "aws_security_group" "alb_sec-grp" {
  name        = "phonebook_alb_sec-grp"
  vpc_id      = data.aws_vpc.default.id
  description = "phonebook_alb_sec-grp enables HTTP for Application Load Balancer"

  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
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
    Name = "phonebook-application_alb_secgrp"
  }
}