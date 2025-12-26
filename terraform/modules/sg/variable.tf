variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_id" {
  description = "vpc ID"
  type        = string
}

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

}
variable "db_port" {
  description = "db port"
  type        = string
}

