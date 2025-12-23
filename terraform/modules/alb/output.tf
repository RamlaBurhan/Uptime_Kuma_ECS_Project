output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "ALB Zone ID"
  value       = aws_lb.this.zone_id
}

output "target_group_arn" {
  description = "target group ARN"
  value       = aws_lb_target_group.app_alb_tg.arn
}

output "https_listener_arn" {
  description = "HTTPS listener ARN"
  value       = aws_lb_listener.https.arn
}

output "alb_url" {
  description = "ALB HTTPS URL"
  value       = "https://${aws_lb.this.dns_name}"
}
