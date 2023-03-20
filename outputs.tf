
output "application-load-balancer_dns" {
  description = "Phonebook Application Load Balancer Dns Name"
  value       = "http://${aws_alb.webserver-alb.dns_name}"
}