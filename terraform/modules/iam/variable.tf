
variable "db_password_secret_arn" {
  description = "RDS password secret ARN"
  type        = string
}

variable "project_name" {
  description = "project name"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of the RDS AWS KMS key"
  type        = string
}