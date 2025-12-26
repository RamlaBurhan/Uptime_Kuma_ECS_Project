
output "db_password_secret_arn" {
  description = "RDS password secret ARN"
  value       = aws_secretsmanager_secret.rds_psswrd.arn
  sensitive   = true
}

output "kms_key_arn" {
  description = "KMS key for RDS encryption ARN"
  value       = aws_kms_key.rds.arn
}

output "db_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.rds.endpoint
}

output "db_address" {
  description = "RDS database address"
  value       = aws_db_instance.rds.address
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.rds.db_name
}





