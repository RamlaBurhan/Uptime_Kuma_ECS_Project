module "vpc" {
  source                = "./modules/vpc"
  project_name          = var.project_name
  vpc_cidr              = var.vpc_cidr
  subnet_count          = var.subnet_count
  enable_nat_gateway_ha = var.enable_nat_gateway_ha
  region                = var.region
}

module "sg" {
  source       = "./modules/sg"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  alb_ports    = var.alb_ports
  ecs_port     = var.ecs_port
  db_port      = var.db_port
}

module "rds" {
  source                    = "./modules/rds"
  project_name              = var.project_name
  db_subnet_ids             = module.vpc.db_subnet_ids
  db_sg_id                  = module.sg.db_sg_id
  engine                    = var.engine
  engine_version            = var.engine_version
  instance_class            = var.instance_class
  db_name                   = var.db_name
  db_username               = var.db_username
  allocated_storage         = var.allocated_storage
  storage_type              = var.storage_type
  multi_az                  = var.multi_az
  backup_retention_period   = var.backup_retention_period
  backup_window             = var.backup_window
  maintenance_window        = var.maintenance_window
  final_snapshot_identifier = var.final_snapshot_identifier
  skip_final_snapshot       = var.skip_final_snapshot
  retention_in_days         = var.retention_in_days
  deletion_protection       = var.deletion_protection
  deletion_window_in_days   = var.deletion_window_in_days
}

module "iam" {
  source                 = "./modules/iam"
  project_name           = var.project_name
  db_password_secret_arn = module.rds.db_password_secret_arn
  kms_key_arn            = module.rds.kms_key_arn
}

module "alb" {
  source          = "./modules/alb"
  project_name    = var.project_name
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids
  alb_sg_id       = module.sg.alb_sg_id
  container_port  = var.container_port
  ssl_policy      = var.ssl_policy
  certificate_arn = module.acm.certificate_arn
}

module "acm" {
  source         = "./modules/acm"
  domain_name    = var.domain_name
  project_name   = var.project_name
  hosted_zone_id = module.route53.hosted_zone_id
  subdomain      = var.subdomain
}

module "route53" {
  source       = "./modules/route53"
  domain_name  = var.domain_name
  record_name  = var.record_name
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

module "ecs" {
  source                  = "./modules/ecs"
  project_name            = var.project_name
  region                  = var.region
  container_name          = var.container_name
  container_port          = var.container_port
  image_tag               = var.image_tag
  task_cpu                = var.task_cpu
  task_memory             = var.task_memory
  desired_count           = var.desired_count
  private_subnet_ids      = module.vpc.app_subnet_ids
  ecs_sg_id               = module.sg.ecs_sg_id
  target_group_arn        = module.alb.target_group_arn
  alb_listener_arn        = module.alb.https_listener_arn
  ecr_repository_url      = module.ecr.repository_url
  task_execution_role_arn = module.iam.task_execution_role_arn
  environment_variables   = local.environment_variables
  log_retention_days      = var.log_retention_days
  secrets                 = local.secrets
}

module "ecs-autoscaling" {
  source               = "./modules/ecs-autoscaling"
  project_name         = var.project_name
  ecs_cluster_name     = module.ecs.cluster_name
  ecs_service_name     = module.ecs.service_name
  ecs_min_capacity     = var.ecs_min_capacity
  ecs_max_capacity     = var.ecs_max_capacity
  cpu_scale_out_tv     = var.cpu_scale_out_tv
  memory_scale_out_t_v = var.memory_scale_out_t_v
  scale_in_cooldown    = var.scale_in_cooldown
  scale_out_cooldown   = var.scale_out_cooldown
}

