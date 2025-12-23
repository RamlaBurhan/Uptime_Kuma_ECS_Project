variable "project_name" {
  description = "Name of the project"
  type        = string
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
