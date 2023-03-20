resource "aws_security_group" "db_sec-grp" {
  name        = "phonebook_db_sec-grp"
  vpc_id      = data.aws_vpc.default.id
  description = "phonebook_db_sec-grp for Back-end Database"

  ingress {
    description     = "Allow Port 3306 comes from ec2 security group"
    from_port       = 3306
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sec-grp.id]

  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "phonebook-application_db_secgrp"
  }
}