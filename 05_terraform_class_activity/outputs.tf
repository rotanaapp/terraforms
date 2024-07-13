# outputs.tf
output "load_balancer_dns_name" {
  description = "HTTP URL of the application load balancer"
  value       = "http://${aws_lb.app_lb.dns_name}"
}
