resource "aws_alb" "webserver-alb" {
  name               = "phonebook-alb"
  ip_address_type    = "ipv4"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sec-grp.id]
  subnets            = data.aws_subnets.phonebook.ids
}
