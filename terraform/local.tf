locals {
  environment_variables = [



    { name = "UPTIME_KUMA_DB_HOSTNAME", value = var.db_host },
    { name = "UPTIME_KUMA_DB_PORT", value = var.db_port },
    { name = "UPTIME_KUMA_DB_NAME", value = var.db_name },
    { name = "UPTIME_KUMA_DB_USERNAME", value = var.db_username },
    { name = "UPTIME_KUMA_DB_TYPE", value = var.db_type },
    { name = "UPTIME_KUMA_ENABLE_EMBEDDED_MARIADB", value = "false" },
  ]

  secrets = [
    {
      name      = "UPTIME_KUMA_DB_PASSWORD"
      valueFrom = module.rds.db_password_secret_arn
    }
  ]
}


