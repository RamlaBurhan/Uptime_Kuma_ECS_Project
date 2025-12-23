#vpc
variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "environemt of the project"
}

variable "region" {
  description = "This is the region that will be used"
  type        = string
}

variable "vpc_cidr" {
  description = "vpc cidr"
  type        = string
}

variable "subnet_count" {
  description = "subnet count"
  type        = string
  default     = 2
}

variable "enable_nat_gateway_ha" {
  description = "Enable nat gateway HA"
  type        = bool
  default     = true
}

#sg

variable "alb_ports" {
  type = map(any)
  default = {
    80  = ["0.0.0.0/0"]
    443 = ["0.0.0.0/0"]
  }
}

variable "ecs_port" {
  description = "ecs port"
  type        = string
  default     = 3001

}
variable "db_port" {
  description = "db port"
  type        = string
  default     = 3306
}

variable "efs_port" {
  description = "db port"
  type        = string
  default     = 2049

}

#route53
variable "record_name" {
  description = "record name"
  type        = string
}

#rds
variable "engine" {
  description = "Engine type"
  type        = string
}
variable "engine_version" {
  description = "Enginine version of RDS"
  type        = string
}

variable "instance_class" {
  description = "Instance class for rds"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "db_type" {
  description = "Database type"
  type        = string

}

variable "db_host" {
  description = "db host"
  type        = string

}
variable "allocated_storage" {
  description = "Allocated storage for database"
  type        = number
}

variable "storage_type" {
  description = "Database storage type"
  type        = string
}


variable "final_snapshot_identifier" {
  description = "Unique identifier for the final DB snapshot"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Whether to skip creating a final snapshot"
  type        = bool
}

variable "deletion_window_in_days" {
  description = "deletion window in days"
  default     = 10
}
variable "retention_in_days" {
  description = "amount of days it eil be held"
  default     = 7
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  default     = 7
}

variable "multi_az" {
  description = "Enable Multi-AZ for HA"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Prevent accidental database deletion"
  type        = bool
  default     = false
}

variable "backup_window" {
  description = "backup window (UTC)"
  type        = string

}

variable "maintenance_window" {
  description = "maintenance window (UTC)"
  type        = string
}


#ecs-autoscaling
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
  description = "cpu scale in target value"
  type        = number
  default     = 70
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
  default     = 300
}

variable "scale_out_cooldown" {
  description = "Cooldown period for scaling out (seconds)"
  type        = number
  default     = 60
}


#ecs
variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "container_name" {
  description = "Name of the container"
  type        = string
  default     = "uptime-kuma"
}

variable "container_port" {
  description = "Port on which the container listens"
  type        = number
}

variable "task_cpu" {
  description = "CPU units for the task"
  type        = string
}

variable "task_memory" {
  description = "Memory for the task in MB"
  type        = string
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
}

variable "environment_variables" {
  description = "List of environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "secrets" {
  description = "Secrets from AWS Secrets Manager"
  type = list(object({
    name      = string
    valueFrom = string
  }))
  default = []
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = string
}

#alb
variable "ssl_policy" {
  description = "ALB SSL policy defining protocol"
  type        = string
}


#acm
variable "domain_name" {
  description = "The primary domain name for the application"
  type        = string
}

variable "subdomain" {
  description = "Additional subdomains for application"
  type        = list(string)
  default     = []
}





