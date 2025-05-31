resource "aws_db_instance" "db" {
  count = var.db_resource_type == "db" ? 1 : 0

  allocated_storage       = var.db_allocated_storage
  db_name                 = var.db_database_name
  identifier              = "db-${var.db_engine}${var.project_name}"
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  availability_zone       = var.db_availability_zone
  instance_class          = var.db_instance_class
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = aws_db_parameter_group.parameter_group.name
  backup_retention_period = var.db_backup_retention_period
  multi_az                = var.db_multi_az
  storage_encrypted       = var.db_storage_encrypted
  skip_final_snapshot     = var.db_skip_final_snapshot

  dynamic "timeouts" {
    for_each = var.db_resource_type == "db" ? [1] : []
    content {
      create = var.db_timeout_create
      delete = var.db_timeout_delete
      update = var.db_timeout_update
    }
  }
}

resource "aws_db_parameter_group" "parameter_group" {
  name   = var.pg_name
  family = var.pg_family
}

resource "aws_rds_cluster" "db_cluster" {
  count = var.db_resource_type == "db_cluster" ? 1 : 0

  cluster_identifier              = "db-cluster-${var.db_engine}${var.project_name}"
  engine                          = var.db_engine
  engine_version                  = var.db_engine_version
  availability_zones              = var.db_cluster_availability_zones
  db_cluster_parameter_group_name = aws_db_parameter_group.parameter_group.name
  database_name                   = var.db_database_name
  allocated_storage               = var.db_allocated_storage
  master_username                 = var.db_username
  master_password                 = var.db_password
  backup_retention_period         = var.db_backup_retention_period
  preferred_backup_window         = var.db_cluster_preferred_backup_window
}

resource "aws_rds_cluster_instance" "db_cluster_instance" {
  count = var.db_resource_type == "db_cluster" ? var.db_cluster_count_instances : 0

  identifier         = "aurora-cluster-${count.index}"
  cluster_identifier = aws_rds_cluster.db_cluster[count.index].id
  instance_class     = var.db_instance_class
  engine             = aws_rds_cluster.db_cluster[count.index].engine
  engine_version     = aws_rds_cluster.db_cluster[count.index].engine_version

  depends_on = [aws_rds_cluster.db_cluster]
}