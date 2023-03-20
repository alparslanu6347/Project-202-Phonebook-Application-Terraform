# data "aws_vpc" "default" {
#   default = true
# } 

# data "aws_subnets" "phonebook" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.default.id]
#   }
# }

resource "aws_alb_target_group" "webserver-tg" {
  name        = "phonebook-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}

# resource "aws_alb" "webserver-alb" {
#     name               = "phonebook-alb"
#     ip_address_type    = "ipv4"
#     internal           = false
#     load_balancer_type = "application"
#     security_groups    = [aws_security_group.alb_sec-grp.id]
#     subnets            = data.aws_subnets.phonebook.ids
# }

# resource "aws_alb_listener" "webserver-listener" {
#     load_balancer_arn = aws_alb.webserver-alb.arn
#     port              = 80
#     protocol          = "HTTP"
#     default_action {
#         type             = "forward"
#         target_group_arn = aws_alb_target_group.webserver-tg.arn
#   }
# }

# resource "aws_autoscaling_group" "webserver-asg" {
#   name                      = "webserver_autoscaling-group"
#   max_size                  = 3
#   min_size                  = 1
#   desired_capacity          = 2
#   health_check_grace_period = 300
#   health_check_type         = "ELB"
#   target_group_arns = [aws_alb_target_group.webserver-tg.arn]
#   vpc_zone_identifier       =  aws_alb.webserver-alb.subnets
#   launch_template {
#     id                      = aws_launch_template.ec2_lt.id
#     version                 = "$Latest" # aws_launch_template.ec2_lt.latest_version
#   }
# }


