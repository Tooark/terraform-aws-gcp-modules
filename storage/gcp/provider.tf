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
  project = "ditie-devops"
  region  = "us-central1"
}
