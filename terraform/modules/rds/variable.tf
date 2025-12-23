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

variable "project_name" {
  description = "project name"
  type        = string
}

variable "db_subnet_ids" {
  description = "list of databse subnet IDs"
  type        = list(string)
} #

variable "allocated_storage" {
  description = "Allocated storage for database"
  type        = number
}

variable "storage_type" {
  description = "Database storage type"
  type        = string
}

variable "db_sg_id" {
  description = "Database security group ID"
  type        = string

}

variable "final_snapshot_identifier" {
  description = "Unique identifier for the final DB snapshot"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Whether to skip creating a final snapshot"
  type        = bool
  default     = false
}


variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = string
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


variable "retention_in_days" {
  description = "amount of days it eil be held"
  type        = string
}

variable "deletion_window_in_days" {
  description = "deletion window in days"
  type        = string
}