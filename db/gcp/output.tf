output "db" {
  value = [for db in google_sql_database_instance.db : {
    db_id                  = db.id
    db_name                = db.name
    db_region              = db.region
    db_database_engine     = db.database_version
    db_deletion_protection = db.deletion_protection
  }]
  description = "Dados - Banco de dados(Cloud SQL)"
}

output "db_cluster" {
  value = [for db_cluster in google_alloydb_cluster.db_cluster : {
    db_id     = db_cluster.id
    db_name   = db_cluster.cluster_id
    db_region = db_cluster.location
  }]
  description = "Dados - Cluster(AlloyDB)"
}

output "db_cluster_instance" {
  value = [for db_cluster_instance in google_alloydb_instance.db_cluster_instance : {
    associated_cluster = db_cluster_instance.cluster
    name               = db_cluster_instance.instance_id
    instance_type      = db_cluster_instance.var.db_instance_type
  }]
  description = "Dados - Instancia do Cluster(AlloyDB)"
}

output "db_id" {
  value = [for db in google_sql_database_instance.db : {
    db_id = db.id
  }]
  description = "ID do banco de dados"
}
output "db_name" {
  value = var.choose_db == "db" ? [for db in google_sql_database_instance.db : {
    db_name = db.name
    }] : [for db_cluster in google_alloydb_cluster.db_cluster : {
    db_name = db_cluster.cluster_id
  }]
  description = "Nome do banco de dados"
}

output "db_region" {
  value       = var.choose_db == "db" ? google_sql_database_instance.db[0].region : google_alloydb_cluster.db_cluster[0].location
  description = "Regiao do banco de dados"
}

output "db_database_engine" {
  value       = var.choose_db == "db" ? google_sql_database_instance.db[0].database_version : null # Null para AlloyDB
  description = "Engine do banco de dados"
}

output "db_deletion_protection" {
  value       = var.choose_db == "db" ? google_sql_database_instance.db[0].deletion_protection : null # Null para AlloyDB
  description = "Proteção contra destruição pro banco de dados"
}

output "db_user_name" {
  value = var.choose_db == "db" ? [for db in google_sql_database_instance.db : {
    db_name = db.name
  }] : google_alloydb_user.db_cluster_user[0].user_id
  description = "Nome do usuario do banco de dados"
}

output "db_user_id" {
  value       = var.choose_db == "db" ? var.db_user_name : var.db_user_name
  sensitive   = true
  description = "ID do usuario do banco de dados"
}

output "db_user_password" {
  value       = var.choose_db == "db" ? random_password.password.result : random_password.password.result
  sensitive   = true
  description = "Senha do usuario do banco de dados"
}

output "db_certificate_id" {
  value       = var.choose_db == "db" ? google_sql_ssl_cert.db_certificate[0].id : null # Null para AlloyDB
  description = "ID do certificado do banco de dados"
}

output "db_certificate_name" {
  value       = var.choose_db == "db" ? google_sql_ssl_cert.db_certificate[0].common_name : null # Null para AlloyDB
  description = "Nome do certificado do banco de dados"
}