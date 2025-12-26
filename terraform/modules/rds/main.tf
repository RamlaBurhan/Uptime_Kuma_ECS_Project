resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret" "rds_psswrd" {
  name                    = "${var.project_name}-rds-psswrd"
  description             = "RDS database password"
  kms_key_id              = aws_kms_key.rds.arn
  recovery_window_in_days = 7

  tags = {
    Name = "${var.project_name}-rds_psswrd"
  }
}

resource "aws_secretsmanager_secret_version" "rds_password" {
  secret_id     = aws_secretsmanager_secret.rds_psswrd.id
  secret_string = random_password.db_password.result

  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_db_subnet_group" "rds" {
  subnet_ids = var.db_subnet_ids
  tags = {
    Name = "${var.project_name}-rds_db_subnet_group"

  }
}

resource "aws_db_instance" "rds" {
  identifier                      = "${var.project_name}-rds-instance"
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_class
  db_name                         = var.db_name
  username                        = var.db_username
  password                        = random_password.db_password.result
  allocated_storage               = var.allocated_storage
  storage_type                    = var.storage_type
  storage_encrypted               = true
  kms_key_id                      = aws_kms_key.rds.arn
  multi_az                        = var.multi_az
  db_subnet_group_name            = aws_db_subnet_group.rds.name
  vpc_security_group_ids          = [var.db_sg_id]
  publicly_accessible             = false
  enabled_cloudwatch_logs_exports = ["error", "slowquery"]
  backup_retention_period         = var.backup_retention_period
  backup_window                   = var.backup_window
  maintenance_window              = var.maintenance_window
  final_snapshot_identifier       = var.final_snapshot_identifier
  skip_final_snapshot             = var.skip_final_snapshot

  deletion_protection = var.deletion_protection

  lifecycle {
    ignore_changes = [password]
  }

  tags = {
    Name = "${var.project_name}-db_instance "
  }
}

resource "aws_cloudwatch_log_group" "rds_error" {
  name              = "/aws/rds/instance/${var.project_name}-rds/error"
  retention_in_days = var.retention_in_days
  tags = {
    Name = "${var.project_name}-rds_error_logs"
  }
}

resource "aws_cloudwatch_log_group" "rds_slowquery" {
  name              = "/aws/rds/instance/${var.project_name}-rds/slowquery"
  retention_in_days = var.retention_in_days
  tags = {
    Name = "${var.project_name}-rds_slowquery_logs"
  }
}

resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = true
  tags = {
    Name = "${var.project_name}-rds_kms_key"
  }
}

resource "aws_kms_alias" "rds" {
  name          = "alias/${var.project_name}-rds"
  target_key_id = aws_kms_key.rds.key_id
}
