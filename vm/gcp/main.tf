resource "google_service_account" "service_account_vm" {
  account_id   = var.project_id
  display_name = var.service_user_name
  project      = var.project_id
}

#Exists
data "google_compute_network" "exists_vpc" {
  count = var.create_vpc == false ? 1 : 0

  name = var.exists_vpc
}

data "google_compute_subnetwork" "exists_subnet" {
  count = var.create_subnet == false ? 1 : 0

  name = var.exists_subnet
}

#New
resource "google_compute_network" "new_vpc" {
  count = var.create_vpc == true ? 1 : 0

  name                    = "my-vpc-${var.project_id}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "new_subnet" {
  count = var.create_subnet == true ? 1 : 0

  name          = "subnet-${var.project_id}-${var.project_env}"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = var.create_vpc == true ? google_compute_network.new_vpc[0].id : data.google_compute_network.exists_vpc[0].id
}

resource "google_compute_instance" "vm" {
  count        = var.vm_count
  name         = var.vm_name
  machine_type = var.vm_machine_type
  zone         = var.vm_zone

  boot_disk {
    initialize_params {
      image = var.vm_image
    }
  }

  network_interface {
    subnetwork = var.create_subnet == true ? google_compute_subnetwork.new_subnet[0].name : data.google_compute_subnetwork.exists_subnet[0].name
  }

  service_account {
    email  = google_service_account.service_account_vm.email
    scopes = var.vm_service_account_scopes
  }
  tags = ["name", var.vm_name]
}

resource "google_compute_firewall" "vm_firewall" {
  name          = "firewall-rule-${google_compute_instance.vm[0].name}"
  network       = var.create_vpc == true ? google_compute_network.new_vpc[0].id : data.google_compute_network.exists_vpc[0].id
  source_ranges = var.source_ranges
  allow {
    protocol = var.vm_firewall_allow_protocols
  }
}
