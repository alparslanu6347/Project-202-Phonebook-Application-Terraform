output "application-load-balancer_dns" {
  description = "Phonebook Application Load Balancer Dns Name"
  value       = "http://${aws_alb.webserver-alb.dns_name}"
}

output "db_instance_address" {
  value = aws_db_instance.webserver-db.address
}