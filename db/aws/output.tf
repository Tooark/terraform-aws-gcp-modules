output "db" {
  value = [for db in aws_db_instance.db : {
    db_name                    = db.db_name
    db_storage                 = db.allocated_storage
    db_engine                  = db.engine
    db_engine_version          = db.engine_version
    db_availability_zone       = db.availability_zone
    db_instance_class          = db.instance_class
    db_username                = db.username
    db_parameter_group         = db.parameter_group_name
    db_backup_retention_period = db.backup_retention_period
    db_subnet_group_name       = db.db_subnet_group_name
    db_multi_az                = db.multi_az
    db_storage_encrypted       = db.storage_encrypted
    db_timeout_create_action   = db.timeouts.create
    db_timeout_delete_action   = db.timeouts.delete
    db_timeout_update_action   = db.timeouts.update
  }]
  description = "Dados - Banco de dados(RDS)"
}

output "db_cluster" {
  value = [for cluster in aws_rds_cluster.db_cluster : {
    db_cluster_name                    = cluster.cluster_identifier
    db_cluster_engine                  = cluster.engine
    db_cluster_engine_version          = cluster.engine_version
    db_cluster_availability_zones      = cluster.availability_zones
    db_cluster_database_name           = cluster.database_name
    db_cluster_username                = cluster.master_username
    db_cluster_backup_retention_period = cluster.db_cluster.backup_retention_period
    db_cluster_preferred_backup_window = cluster.db_cluster.preferred_backup_window
  }]
  description = "Dados - Cluster banco de dados(RDS Cluster)"
}

output "db_cluster_instance" {
  value = [for instance in aws_rds_cluster_instance.db_cluster_instance : {
    nome               = instance.identifier
    cluster_associated = instance.cluster_identifier
    instance_type      = instance.instance_class
    engine             = instance.engine
    engine_version     = instance.engine_version
  }]
}

output "db_parameter_group" {
  value = var.db_resource_type == "db" ? [for db in aws_db_parameter_group.parameter_group : {
    pg_name   = aws_db_parameter_group.parameter_group.name
    pg_family = aws_db_parameter_group.parameter_group.family
    }] : [for db_cluster in aws_db_parameter_group.parameter_group : {
      pg_name   = db_cluster.db_cluster_parameter_group_name
      pg_family = db_cluster.parameter_group
  }]
  description = "Dados - Grupo de parametros do banco de dados"
}

output "db_name" {
  value = var.db_resource_type == "db" ? [for db in aws_db_instance.db : { db_name = db.db_name }] : [for db_cluster in aws_rds_cluster.db_cluster : {
    cluster_name = db_cluster.cluster_identifier
  }]
  description = "Nome da instancia do banco de dados"
}

output "db_engine" {
  value = var.db_resource_type == "db" ? [for db in aws_db_instance.db : {
    engine         = db.engine
    engine_version = db.engine_version
    }] : [for db_cluster in aws_rds_cluster.db_cluster : {
    engine         = db_cluster.parameter_group.engine
    engine_version = db_cluster.engine_version
  }]
  description = "Engine do banco de dados"
}

output "db_availability_zone" {
  value = var.db_resource_type == "db" ? [for db in aws_db_instance.db : {
    availability_zones = db.availability_zone
    }] : [for db_cluster in aws_rds_cluster.db_cluster : {
    availability_zones = db_cluster.availability_zones
  }]
  description = "Zonas de disponibilidade do banco de dados"
}

output "db_allocated_storage" {
  value = var.db_resource_type == "db" ? [for db in aws_db_instance.db : {
    allocated_storage = db.allocated_storage
    }] : [for db_cluster in aws_rds_cluster.db_cluster : {
    allocated_storage = db_cluster.allocated_storage
  }]
  description = "Espaço em disco alocado para o banco de dados"
}
# Ver como fazer com replicas no meu cluster (nao sei como ainda)
output "db_instance_class" {
  value = var.db_resource_type == "db" ? [for db in aws_db_instance.db : {
    instance_class = db.instance_class
    }] : [for db_cluster_instance in aws_rds_cluster_instance.db_cluster_instance : {
    instance_class = db_cluster_instance.instance_class
  }]
  description = "Tipo da instancia do banco de dados"
}

output "db_username" {
  value = var.db_resource_type == "db" ? [for db in aws_db_instance.db : { username = db.username }] : [for db_cluster in aws_rds_cluster.db_cluster : {
  username = db_cluster.username }]
  description = "Nome do usuario root do banco de dados"
}

output "db_backup_retention_period" {
  value = var.db_resource_type == "db" ? [for db in aws_db_instance.db : {
    backup_retention_period = db.backup_retention_period
    }] : [for db_cluster in aws_rds_cluster.db_cluster : {
    backup_retention_period = db_cluster.backup_retention_period
  }]
  description = "Tempo de retenção de backup do banco de dados"
}

output "db_subnet_group" {
  value = var.db_resource_type == "db" ? [for db in aws_db_instance.db : {
    db_subnet_group_name = db.db_subnet_group_name
    }] : [for db_cluster in aws_rds_cluster.db_cluster : {
    db_subnet_group_name = db_cluster.db_subnet_group_name
  }]
  description = "Grupo de subnets do banco de dados"
}

output "db_skip_final_snapshot" {
  value = var.db_resource_type == "db" ? [for db in aws_db_instance.db : {
    skip_final_snapshot = db.skip_final_snapshot
    }] : [for db_cluster in aws_rds_cluster.db_cluster : {
    skip_final_snapshot = db_cluster.skip_final_snapshot
  }]
  description = "Pular imagem final do banco de dados"
}