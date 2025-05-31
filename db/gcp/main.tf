# Cloud SQL
resource "google_sql_database" "db" {
  name     = var.db_name
  instance = google_sql_database_instance.db[0].name
  project  = var.project_id
}

resource "random_password" "password" {
  length           = var.random_password_length
  special          = var.random_password_special
  override_special = var.random_password_override_special
}

resource "google_sql_database_instance" "db" {
  count            = var.choose_db == "db" ? 1 : 0
  project          = var.project_id
  name             = var.db_instance_name
  region           = var.db_region
  database_version = var.db_version_engine

  settings {
    tier      = var.db_instance_type
    disk_size = var.db_disk_size
  }

  deletion_protection = var.db_deletion_protection
}

locals {
  generated_password = random_password.password.result
}

resource "google_sql_user" "db_user" {
  name     = var.db_user_name
  password = random_password.password.result
  instance = var.choose_db == "db" ? google_sql_database_instance.db[0].name : google_alloydb_cluster.db_cluster[0].name
}

resource "google_sql_ssl_cert" "db_certificate" {
  count = var.db_certificate == true ? 1 : 0

  common_name = var.db_certificate_name
  instance    = var.choose_db == "db" ? google_sql_database_instance.db[0].name : google_alloydb_cluster.db_cluster[0].name
}

#AlloyDB
resource "google_compute_network" "db_cluster" {
  count = var.choose_db == "db_cluster" ? 1 : 0
  name  = "alloydb-network-${var.db_name}" # Nome definido explicitamente
}

resource "google_alloydb_cluster" "db_cluster" {
  count = var.choose_db == "db_cluster" ? 1 : 0

  cluster_id = var.db_name
  location   = var.db_region
  network_config {
    network = google_compute_network.db_cluster[0].id
  }
}

resource "google_alloydb_instance" "db_cluster_instance" {
  count = var.choose_db == "db_cluster" ? 1 : 0

  cluster       = google_alloydb_cluster.db_cluster[0].cluster_id
  instance_id   = var.db_cluster_instance_name
  instance_type = var.db_cluster_instance_type
}

resource "google_alloydb_user" "db_cluster_user" {
  count = var.choose_db == "db_cluster" ? 1 : 0

  cluster   = google_alloydb_cluster.db_cluster[0].name
  user_id   = var.db_user_name
  user_type = var.db_cluster_user_type

  password       = random_password.password.result
  database_roles = var.db_cluster_user_role
  depends_on     = [google_alloydb_instance.db_cluster_instance]
}