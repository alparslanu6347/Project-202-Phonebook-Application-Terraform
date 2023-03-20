resource "aws_alb_listener" "webserver-listener" {
  load_balancer_arn = aws_alb.webserver-alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.webserver-tg.arn
  }
}