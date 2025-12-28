
project_name = "" \
environment  = "" \
subdomain    = ""

#VPC \
vpc_cidr              = "" \
subnet_count          = "" \
enable_nat_gateway_ha = "" \
region                = ""

#Security group \
alb_ports = { \
  80  = [""] \
  443 = [""] \
} \
ecs_port = "" \
db_port  = "" \
efs_port = ""

#Route53 \
domain_name = "" \
record_name = ""

#RDS \
engine                    = "" \
engine_version            = "" \
instance_class            = "" \
db_name                   = "" \
db_username               = "" \
db_type                   = "" \
db_host                   = "" \
allocated_storage         = "" \
storage_type              = "" \
multi_az                  = "" \
backup_retention_period   = "" \
backup_window             = "" \
maintenance_window        = "" \
skip_final_snapshot       = "" \
final_snapshot_identifier = "" \
retention_in_days         = "" \
deletion_window_in_days   = ""


#ECS autoscaling \
ecs_min_capacity     = "" \
ecs_max_capacity     = "" \
cpu_scale_out_tv     = "" \
cpu_scale_in_t_v     = "" \
memory_scale_out_t_v = "" \
memory_scale_in_t_v  = "" \
scale_in_cooldown    = "" \
scale_out_cooldown   = ""

#ECS \
container_name     = "" \
container_port     = "" \
image_tag          = "" \
task_cpu           = "" \
task_memory        = "" \ 
desired_count      = "" \
log_retention_days = ""

#ALB \
ssl_policy = ""
