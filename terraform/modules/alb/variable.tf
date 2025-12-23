variable "project_name" {
  description = "Project name"
  type        = string
}

variable "alb_sg_id" {
  description = "Security Group ID that controls ALB inbound/outbound traffic"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC containing the infrastructure"
  type        = string
}

variable "ssl_policy" {
  description = "ALB SSL policy defining protocol"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of ACM certificate for HTTPS"
  type        = string
}

variable "container_port" {
  description = "Application container port"
  type        = string
}
