variable "ecs_min_capacity" {
  description = "Minimum number of ECS tasks"
  type        = number
}

variable "ecs_max_capacity" {
  description = "Maximum number of ECS tasks"
  type        = number
}


variable "cpu_scale_out_tv" {
  description = "cpuscale out target value"
  type        = number
}


variable "cpu_scale_in_t_v" {
  description = "cpuscale in target value"
  type        = number
}

variable "memory_scale_out_t_v" {
  description = "memory scale out target value"
  type        = number
}

variable "memory_scale_in_t_v" {
  type = number
}

variable "scale_in_cooldown" {
  description = "Cooldown period for scaling in (seconds)"
  type        = number
}

variable "scale_out_cooldown" {
  description = "Cooldown period for scaling out (seconds)"
  type        = number
}

variable "project_name" {
  description = "project name"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ecs cluster name"
  type        = string

}

variable "ecs_service_name" {
  description = "ecs service name"
  type        = string
}
