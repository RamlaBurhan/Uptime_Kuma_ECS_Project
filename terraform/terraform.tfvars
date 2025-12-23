project_name = "rb-monitoring"
environment  = "Development"
subdomain    = ["www.rb-monitoring.com"]

#vpc
vpc_cidr              = "18.0.0.0/16"
subnet_count          = "2"
enable_nat_gateway_ha = "true"
region                = "us-east-1"

#sg
alb_ports = {
  80  = ["0.0.0.0/0"]
  443 = ["0.0.0.0/0"]
}
ecs_port = "3001"
db_port  = "3306"
efs_port = "2049"

#route-53
domain_name = "rb-monitoring.com"
record_name = "www"

#RDS
engine                    = "mariadb"
engine_version            = "10.11"
instance_class            = "db.t3.micro"
db_name                   = "UptimeKumaDB"
db_username               = "uptime_admin"
db_type                   = "mariadb"
db_host                   = "rb-monitoring-rds.cofgm8um4m05.us-east-1.rds.amazonaws.com"
allocated_storage         = "20"
storage_type              = "gp3"
multi_az                  = "true"
backup_retention_period   = "7"
backup_window             = "03:00-04:00"
maintenance_window        = "mon:04:00-mon:05:00"
skip_final_snapshot       = "false"
final_snapshot_identifier = "rb-monitoring-final-snapshot"
retention_in_days         = "7"
deletion_window_in_days   = "10"
deletion_protection       = "false"


#ecs-autoscling
ecs_min_capacity     = "2"
ecs_max_capacity     = "4"
cpu_scale_out_tv     = "70"
cpu_scale_in_t_v     = "30"
memory_scale_out_t_v = "70"
memory_scale_in_t_v  = "30"
scale_in_cooldown    = "300"
scale_out_cooldown   = "60"

#ecs
container_name     = "uptime-kuma"
container_port     = "3001"
image_tag          = "latest"
task_cpu           = "256"
task_memory        = "512"
desired_count      = "2"
log_retention_days = "30"

#alb
ssl_policy = "ELBSecurityPolicy-2016-08"

