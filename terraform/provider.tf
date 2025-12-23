terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.26.0"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      project_name = "rb-monitoring"
      Environment  = "development"
      managed_by   = "terraform"
    }
  }
}

