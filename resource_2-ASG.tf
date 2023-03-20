resource "aws_autoscaling_group" "webserver-asg" {
  name                      = "webserver_autoscaling-group"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [aws_alb_target_group.webserver-tg.arn]
  vpc_zone_identifier       = aws_alb.webserver-alb.subnets
  launch_template {
    id      = aws_launch_template.ec2_lt.id
    version = "$Latest" # aws_launch_template.ec2_lt.latest_version
  }
}







