output "alb_sg_id" {
  description = "ID of the application load alancer security group"
  value       = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
  description = "ID of the ECS tasks security group"
  value       = aws_security_group.ecs_sg.id
}

output "db_sg_id" {
  description = "ID of the RDS database security group"
  value       = aws_security_group.db_sg.id
}

output "efs_sg_id" {
  description = "ID of the EFS filesystem security group"
  value       = aws_security_group.efs_sg.id
}
