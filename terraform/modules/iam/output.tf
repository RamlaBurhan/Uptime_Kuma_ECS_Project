
output "task_execution_role_arn" {
  description = "ECS task execution role ARN"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "task_execution_role_name" {
  description = "ECS task execution role name"
  value       = aws_iam_role.ecs_execution_role.name
}

output "task_execution_role_id" {
  description = "ECS task execution role ID"
  value       = aws_iam_role.ecs_execution_role.id
}
