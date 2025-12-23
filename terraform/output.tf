output "application_url" {
  description = "URL to access Uptime Kuma"
  value       = "https://${module.acm.domain_name}"
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.alb_dns_name
}


output "repository_url" {
  description = "ECR repository URL for pushing Docker images"
  value       = module.ecr.repository_url
}

output "cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_name
}

output "service_name" {
  description = "ECS service name"
  value       = module.ecs.service_name
}

output "db_endpoint" {
  description = "RDS database endpoint"
  value       = module.rds.db_endpoint
  sensitive   = true
}

output "db_name" {
  description = "Database name"
  value       = module.rds.db_name
}

output "certificate_arn" {
  description = "ACM certificate ARN"
  value       = module.acm.certificate_arn
}

output "domain_name" {
  description = "Domain name"
  value       = module.acm.domain_name
}