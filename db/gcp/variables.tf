variable "project_id" {
  type        = string
  description = "ID do projeto"
  validation {
    condition     = length(var.project_id) > 1
    error_message = "O project_id deve conter apenas:\n- letras minúsculas\n- número\n- hifén."
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

variable "choose_db" {
  type    = string
  default = "db"
  validation {
    condition = (
      lower(contains(["db", "db_cluster"], var.choose_db))
    )
    error_message = "Valor inválido para 'choose_db'. Use 'db_cluster' para AlloyDB e 'db' para SQL."
  }
  description = "Seleção do tipo de banco de dados que deseja criar"
}

# Db
variable "db_name" {
  type    = string
  default = "my-db"
  validation {
    condition     = length(var.db_name) > 0 && length(var.db_name) <= 16 || can(lower(regex("[a-z]")))
    error_message = "O nome é invalido"
  }
  description = "Nome do banco de dados"
}
variable "db_instance_name" {
  type    = string
  default = "my-instance"
  validation {
    condition     = length(var.db_instance_name) > 0 && length(var.db_instance_name) <= 16 || can(lower(regex("[a-z]")))
    error_message = "O nome não pode ser menor que 1"
  }
  description = "Nome da instancia do banco de dados"
}
variable "db_disk_size" {
  type        = number
  default     = 10
  description = "Tamanho do disco para o banco de dados"
  validation {
    condition     = var.db_disk_size >= 10
    error_message = "Tamanho do disco pro banco de dados(tamanho minimo 10gb)"
  }
}
variable "db_region" {
  type        = string
  default     = "us-central1"
  description = "Regiao para a instancia do banco de dados"
  validation {
    condition     = var.db_region == null || !startswith("us|asia|africa|australia|europe|me|northamerica|southamerica|", var.db_region) || can(lower(regex("^[a-z0-9]{4,30}")))
    error_message = "Zone invalida"
  }
}
variable "db_version_engine" {
  type    = string
  default = "POSTGRES_16"
  validation {
    condition     = length(var.db_version_engine) > 6 || !startswith("(POSTGRES|MYSQL|SQLSERVER)", var.db_version_engine)
    error_message = "Engine invalida, consultar as engines validas em: https://cloud.google.com/sql/docs/db-versions?hl=pt-br"
  }
  description = "Versao da engine do rds usada, veja as opções em 'https://cloud.google.com/sql/docs/db-versions?hl=pt-br'"
}
variable "db_instance_type" {
  type        = string
  default     = "db-f1-micro"
  description = "Tipo de instancia do db"
  validation {
    condition     = var.db_instance_type == null || length(var.db_instance_type) > 5 || can(lower(regex(!startswith("^(?i)(db)$", var.db_instance_type))))
    error_message = "Classe de instancia invalida, consulte as disponiveis em: https://cloud.google.com/sql/docs/mysql/instance-settings?hl=pt-br"
  }
}
variable "db_deletion_protection" {
  type        = bool
  default     = true
  description = "Ativa a proteção contra deleção do db"
  validation {
    condition     = contains([true, false], var.db_deletion_protection)
    error_message = "O valor precisa ser 'true' ou 'false'"
  }
}

# Db user and password
variable "random_password_length" {
  type        = number
  default     = 16
  description = "Quantidade de caracteres para o valor randomico"
  validation {
    condition     = var.random_password_length > 0 && var.random_password_length <= 16
    error_message = "O valor gerado precisa conter até 16 caracteres"
  }
}
variable "random_password_special" {
  type        = bool
  default     = true
  description = "Inclui caracteres especiais na senha"
  validation {
    condition     = contains([true, false], var.random_password_special) || var.random_password_special == null
    error_message = "O valor precisa ser 'true' ou 'false'"
  }
}
variable "random_password_override_special" {
  type        = string
  default     = "!#$%&*()-+"
  description = "Define quais caracteres especiais usar na geração do valor aleatorio"
  validation {
    condition     = can(regex("[!#$%&*()-+]+$", var.random_password_override_special))
    error_message = "Caracteres especiais restringidas a: !#$%&*()-+"
  }
}
variable "db_user_name" {
  type        = string
  default     = "root"
  description = "Nome do usuario do banco de dados"
  validation {
    condition     = var.db_user_name != null || length(var.db_user_name) > 0 && length(var.db_user_name) <= 15 || can(lower(regex("[a-z]")))
    error_message = "O nome de usuario precisa conter:\n- Apenas caracteres minusculas"
  }
}

# Db certificate
variable "db_certificate" {
  type        = bool
  default     = true
  description = "Cria um certificado ssl para o db"
  validation {
    condition     = contains([true, false], var.db_certificate) || var.db_certificate == null
    error_message = "O valor pra criar um certificado precisa ser 'true' ou 'false'"
  }
}
variable "db_certificate_name" {
  type        = string
  default     = "my-cert"
  description = "Nome do certificado SSL pro banco de dados"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.db_certificate_name)) || var.db_certificate_name == null
    error_message = "O nome do certificado pode conter:\n- Caracteres minusculas\n- Numeros"
  }
}

# DB cluster
variable "db_cluster_user_type" {
  type        = string
  default     = "ALLOYDB_BUILT_IN"
  description = "Tipo de usuario para o db cluster:\nUse ALLOYDB_BUILT_IN para criar usuários que serão gerenciados exclusivamente dentro do AlloyDB.\nUse ALLOYDB_IAM_USER para criar usuários que serão gerenciados pelo IAM e podem precisar acessar outros serviços do Google Cloud."
  validation {
    condition     = contains(["ALLOYDB_BUILT_IN", "ALLOYDB_IAM_USER"], var.db_cluster_user_type)
    error_message = "Tipo de usuario invalido, o valor precisa ser: ALLOYDB_IAM_USER ou ALLOYDB_BUILT_IN"
  }
}
variable "db_cluster_user_role" {
  type        = list(string)
  default     = ["alloydbsuperuser"]
  description = "Role para liberar acesso do usuario ao cluster de banco de dados"
  validation {
    condition = alltrue([
      contains(["alloydbiamuser", "alloydbsuperuser"], var.db_cluster_user_role[0]),
      anytrue([
        var.db_cluster_user_role[0] == "alloydbiamuser",
        var.db_cluster_user_role[0] == "alloydbsuperuser",
      ])
    ])
    error_message = "O valor precisa ser 'alloydbiamuser' ou 'alloydbsuperuser' para a role do usuario"
  }
}
#DB Cluster Instance
variable "db_cluster_instance_name" {
  type        = string
  default     = "my_db_instance"
  description = "Nome da instancia do cluster de banco dados"
}
variable "db_cluster_instance_type" {
  type        = string
  default     = "PRIMARY"
  description = "Tipo de instancia usada no cluster, consulte em:https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_instance"
  validation {
    condition     = contains(["PRIMARY", "READ_POOL", "SECONDARY"], var.db_cluster_instance_type)
    error_message = "O tipo de instancia precisa ser: 'PRIMARY', 'READ_POOL', 'SECONDARY'\nConsulte em:https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_instance "
  }
}