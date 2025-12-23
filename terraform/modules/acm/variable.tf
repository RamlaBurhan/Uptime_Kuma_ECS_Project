
variable "domain_name" {
  description = "The primary domain name for the application"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}
variable "hosted_zone_id" {
  description = "The ID of the existing Route53 hosted zone"
  type        = string
}
variable "subdomain" {
  description = "Additional subdomains for application"
  type        = list(string)
  default     = []
}
