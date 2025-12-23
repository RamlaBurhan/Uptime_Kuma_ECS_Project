output "min_capacity" {
  description = "Minimum task capacity"
  value       = aws_appautoscaling_target.ecs.min_capacity
}

output "max_capacity" {
  description = "Maximum task capacity"
  value       = aws_appautoscaling_target.ecs.max_capacity
}
