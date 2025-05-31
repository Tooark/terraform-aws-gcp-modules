terraform {
  required_version = ">= 0.13"

  required_providers {

    google = {
      source  = "hashicorp/google"
      version = ">= 5.22, < 6"
    }
  }
}

provider "google" {
  project = var.project_id
  default_labels = {
    Project     = "${var.project_id}"
    Environment = "${var.project_env}"
    iac         = "terraform"
    service     = var.choose_db == "db" ? "Cloud SQL" : "AlloyDB"
  }
}