############ Tipo de banco de dados escolhido:
variable "db_resource_type" {
  type        = string
  description = "Tipo de recurso a ser criado ('db' -> para bancos Mysql, Postgresql, Oracle ou Sql Server | 'db_cluster' para bancos Aurora MySql e Aurora Postgresql)"
  default     = "db"
  validation {
    condition = can(regex("^(db|db_cluster)$", var.db_resource_type))
    error_message = "Tipo de recurso a ser criado ('db' -> para bancos Mysql, Postgresql, Oracle ou Sql Server | 'db_cluster' -> para bancos Aurora MySql e Aurora Postgresql)"
  }
}
############################################################################################################################
#Project
variable "project_name" {
  type        = string
  description = "Nome do seu projeto"
}
variable "aws_account_id" {
  type        = number
  description = "ID da sua conta AWS"
  validation {
    condition     = var.aws_account_id > 12
    error_message = "ID da conta inválido"
  }
}

variable "project_env" {
  type        = string
  description = "Abreviação do ambiente. Valores suportados: `sbx` para sandbox, `dev` para desenvolvimento, `hml` para homologação e `prd` para produção."
  validation {
    condition     = var.project_env == null || can(lower(regex("^(sbx|dev|prd|prod|hml|homol)$", var.project_env)))
    error_message = "O project_env deve ser nulo ou um dos seguintes valores: 'sbx', 'dev', 'hml' ou 'prd'."
  }
}
variable "project_region" {
  type        = string
  description = "Região do seu projeto"
  default     = "us-east-1"
  validation {
    condition     = var.project_region == null || length(var.project_region) > 5 || can(regex(!startswith("^(?i)(us|eu|ap)$", var.project_region)))
    error_message = "Região inválida. Regioes aceitas: 'us-east-[1-2]', 'us-west-[1-2], 'eu-west-[1-2]','ap-southeast-[1-2]'"
  }

  validation {
    condition = var.project_region == "us" ? "us-east-1" : null || var.project_region == "eu" ? "eu-west-1" : null || var.project_region == "ap" ? "ap-southeast-1" : null
    error_message = "Região inválida. Regioes aceitas: 'us-east-[1-2]', 'us-west-[1-2], 'eu-west-[1-2]','ap-southeast-[1-2]'"
  }
}

#RDS
variable "db_allocated_storage" {
  type        = number
  description = "Quantidade de storage a ser utilizado"
  default     = 25
  validation {
    condition     = var.db_allocated_storage == null || var.db_allocated_storage > 0 || var.db_allocated_storage <= 536 || can(regex("^[A-Z]+$", var.db_allocated_storage))
    error_message = "O tamanho do disco precisa ser maior que 0gb até 536gb (25gb por padrão)"
  }
}
variable "db_database_name" {
  type        = string
  description = "Nome do database dentro do banco de dados"
  default     = "my-db"
  validation {
    condition     = var.db_database_name == null || can(regex("^[a-z-_]-[a-z-_]+$", var.db_database_name)) && can(regex("[a-z]", var.db_database_name)) || length(var.db_database_name) > 0
    error_message = "O nome do database esta incorreto"
  }
}

variable "db_engine" {
  type        = string
  description = "Engine do banco de dados selecionado (Mysql, Postgresql, Oracle ou Sql Server)"
  default     = "postgres"
  validation {
    condition     = can(regex("(postgresql|mysql|mariadb|oracle-ee|oracle-se2|oracle-se1|oracle-se|sqlserver-ee|sqlserver-se|sqlserver-ex|sqlserver-web)", var.db_engine)) || var.db_engine == null || length(var.db_engine) > 0
    error_message = "O tipo de egine pro banco de dados precisa ser entre mysql ou postgresql"
  }
}
variable "db_engine_version" {
  type        = string
  default     = "16.3"
  description = "Versão da engine (Ex: mysql -> 8.x - 5.x | postgresql -> 16.x e etc)"
  validation {
    condition     = var.db_engine_version == null || can(regex("^[0-9]$", var.db_engine_version)) || length(var.db_engine_version) > 0
    error_message = "A versão da engine precisa ser valida, consulte em: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance"
  }
}
variable "db_availability_zone" {
  type        = string
  description = "Zonas de disponibilidade para o banco de dados (Ex: 'us-east-1a','us-east-1b','us-east-1c','us-east-1d' ou 'us-west-1a','us-west-1b','us-west-1c','us-west-1d')"
  default     = "us-east-1a"
  validation {
    condition     = var.db_availability_zone == null || length(var.db_availability_zone) > 5 || can(regex(!startswith("^(?i)(us|eu|ap)$", var.db_availability_zone)))
    error_message = "Região inválida. Regioes aceitas: 'us-east-1[a-z]', 'us-west-1[a-z], 'eu-west-1[a-z]','ap-southeast-1[a-z]'"
  }
}
variable "db_instance_class" {
  type        = string
  description = "Instancia do banco de dados"
  default     = "db.t4g.medium"
  validation {
    condition     = var.db_instance_class == null || length(var.db_instance_class) > 5 || can(regex(!startswith("^(?i)(db)$", var.db_instance_class)))
    error_message = "Classe de instancia invalida, consulte as disponiveis em: https://aws.amazon.com/rds/instance-types/"
  }
}
variable "db_username" {
  type        = string
  description = "Nome do usuario root do banco de dados"
  default     = "root"
  validation {
    condition     = var.db_username == null || length(var.db_username) > 0 && length(var.db_username) < 15 || can(regex("^[a-z]$"))
    error_message = "O nome de usuario precisa ser:\n- minusculo\n- menor que 15 caracteres"
  }
}
variable "db_password" {
  type        = string
  description = "Senha do usuario root do banco de dados"
  default     = "}8ky9#V-mS]F~jb]t7'&"
  validation {
    condition     = length(var.db_password) > 0 || var.db_password == null || can(regex("^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#\\$%\\^&\\*])[A-Za-z0-9!@#\\$%\\^&\\*]+$", var.db_password))
    error_message = "A senha deve conter pelo menos:\n- Uma letra\n- Um número\n- Um caractere especial (!, @, #, $, %, ^, &, *)."
  }
}
variable "db_skip_final_snapshot" {
  type        = bool
  description = "Pular a criação do backup final ao destruir o banco de dados"
  default     = true
  validation {
    condition     = contains([true, false], var.db_skip_final_snapshot) || var.db_skip_final_snapshot == null
    error_message = "O valor precisar ser 'true' ou 'false'"
  }
}
variable "db_backup_retention_period" {
  type        = number
  description = "Tempo de retenção de backup do banco de dados em dias"
  default     = 7
  validation {
    condition     = var.db_backup_retention_period >= 0 && var.db_backup_retention_period <= 34 || var.db_backup_retention_period == null
    error_message = "Os dias precisam ser entre 0 e 35 dias"
  }
}

variable "db_multi_az" {
  type        = bool
  description = "Ativar mais zonas de disponibilidade para o banco de dados"
  default     = false
  validation {
    condition     = var.db_multi_az == null || contains([true, false], var.db_multi_az)
    error_message = "O valor precisar ser 'true' ou 'false' para ativar o recurso (Desativado por padrão)"
  }
}
variable "db_storage_encrypted" {
  type        = bool
  description = "Ativar a criptografia de storage"
  default     = true
  validation {
    condition     = var.db_storage_encrypted == null || contains([true, false], var.db_storage_encrypted)
    error_message = "O valor precisar ser 'true' ou 'false' para ativar o recurso (Ativado por padrão)"
  }
}
variable "db_timeout_create" {
  type        = string
  description = "Tempo para executar um create em algum recurso do banco de dados (Ex: 10s para segundos, 10m para minutos e 10h para horas)"
  default     = "0s"
  validation {
    condition     = var.db_timeout_create == null || length(var.db_timeout_create) > 0 || can(regex("^[a-z][0-9]", contains("(s|m|h)"), var.db_timeout_create))
    error_message = "O tempo precisa ser passado como:\n 10s ou 10m ou 10h"
  }
}
variable "db_timeout_delete" {
  type        = string
  description = "Tempo para executar um delete em algum recurso do banco de dados (Ex: 10s para segundos, 10m para minutos e 10h para horas)"
  default     = "0s"
  validation {
    condition     = var.db_timeout_delete == null || length(var.db_timeout_delete) > 0 || can(regex("^[a-z][0-9]", contains("(s|m|h)"), var.db_timeout_delete))
    error_message = "O tempo precisa ser passado como:\n 10s ou 10m ou 10h"
  }
}
variable "db_timeout_update" {
  type        = string
  description = "Tempo para executar um update em algum recurso do banco de dados (Ex: 10s para segundos, 10m para minutos e 10h para horas)"
  default     = "0s"
  validation {
    condition     = var.db_timeout_update == null || length(var.db_timeout_update) > 0 || can(regex("^[a-z][0-9]", contains("(s|m|h)"), var.db_timeout_update))
    error_message = "O tempo precisa ser passado como:\n 10s ou 10m ou 10h"
  }
}

# Cluster RDS
variable "db_cluster_availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "Zonas de disponibilidade para o banco de dados (Ex: 'us-east-1a','us-east-1b','us-east-1c','us-east-1d' ou 'us-west-1a','us-west-1b','us-west-1c','us-west-1d')"
  validation {
    condition     = length(var.db_cluster_availability_zones) > 2 || can(regex(!startswith(["^(?i)(us|eu|ap)$"], var.db_cluster_availability_zones)))
    error_message = "Região inválida. Regioes aceitas: 'us-east-1[a-z]', 'us-west-1[a-z], 'eu-west-1[a-z]','ap-southeast-1[a-z]'"
  }
}
variable "db_cluster_preferred_backup_window" {
  type        = string
  description = "Intervalo de tempo para executar o backup caso esteja ativo (ex: '07:00-09:00'AM)"
  default     = "07:00-09:00"
  validation {
    condition     = can(regex("^(0[0-9]|1[0-9]|2[0-3]):([0-5][0-9])-(0[0-9]|1[0-9]|2[0-3]):([0-5][0-9])$", var.db_cluster_preferred_backup_window))
    error_message = "O valor precisa seguir o seguinte formato: '07:00-09:00'"
  }
}

# Cluster db Instance
variable "db_cluster_count_instances" {
  type        = number
  description = "Quantidade de instancias para o cluster"
  default     = 1
  validation {
    condition     = var.db_cluster_count_instances >= 0 || var.db_cluster_count_instances == null
    error_message = "A quantidade de instancias por padrão é 1"
  }
}

#Parameter group
variable "pg_name" {
  type        = string
  description = "Nome do grupo de parametros"
  default     = "my-parameter-group"
  validation {
    condition     = length(var.pg_name) > 0 || var.pg_name == null || can(regex("^[a-z]$"))
    error_message = "O nome do grupo de parametros precisa ter os requisitos:\n- Letras minusculas apenas\n- Referenciar o nome do banco de dados que irá pertencer"
  }
}
variable "pg_family" {
  type        = string
  description = "Familia de parametros da engine escolhida no banco de dados"
  default     = "postgres16"
  validation {
    condition     = var.pg_family == null || length(var.pg_family) > 0 || contains(["postgres", "mysql", ""], var.pg_family)
    error_message = "A familia do grupo de parametros precisa ser valida, verifique em: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group"
  }
}