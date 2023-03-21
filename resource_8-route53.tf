resource "aws_route53_record" "phonebook" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "phonebook.${var.hosted-zone}"
  type    = "A"

  alias {
    name                   = aws_alb.webserver-alb.dns_name
    zone_id                = aws_alb.webserver-alb.zone_id
    evaluate_target_health = true
  }
}








