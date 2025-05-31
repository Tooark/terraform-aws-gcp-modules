terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.73.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "6.14.0"
    }
  }

  backend "gcs" {
    bucket = "ditie-terraform-state-aws"
  }
}
provider "aws" {
  region                   = var.project_region
  profile                  = "lab"
  shared_config_files      = ["C:\\Users\\signacio\\.aws\\config"]
  shared_credentials_files = ["C:\\Users\\signacio\\.aws\\credentials"]
  default_tags {
    tags = {
      Project     = "${var.project_name}"
      Environment = "${var.project_env}"
      iac         = "terraform"
      service     = "certificate"
    }
  }
}
