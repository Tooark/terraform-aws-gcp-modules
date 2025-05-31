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
    project     = "${var.project_id}"
    environment = "${var.project_env}"
    iac         = "terraform"
    service     = "ec2"
  }
}
