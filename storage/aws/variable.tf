variable "project_name" {
  type        = string
  default     = "projeto-test"
  description = "Nome do seu projeto"
}
variable "project_env" {
  type        = string
  default     = "dev"
  description = "Abreviação do ambiente. Valores suportados: `sbx` para sandbox, `dev` para desenvolvimento, `hml` para homologação e `prd` para produção."
  validation {
    condition     = var.project_env == null || contains(["dev", "prd", "hml", "prod", "test"], var.project_env)
    error_message = "O project_env deve ser nulo ou um dos seguintes valores: 'sbx', 'dev', 'hml' ou 'prd'."
  }
}
variable "project_region" {
  type        = string
  description = "Região do seu projeto"
  default     = "us-east-1"

  validation {
    condition = (
      can(regex("^(?i)(us-east-[1-2]|us-west-[1-2]|eu-west-[1-2]|ap-southeast-[1-2])$", var.project_region))
    )
    error_message = "Região inválida. Regioes aceitas: 'us-east-[1-2]', 'us-west-[1-2], 'eu-west-[1-2]','ap-southeast-[1-2]'"
  }
}

variable "aws_account_id" {
  type        = string
  default     = "767397849711"
  description = "ID da sua conta AWS"
  validation {
    condition     = var.aws_account_id > 12
    error_message = "ID da conta inválido"
  }
}

variable "storage_lifecycle_rule" {
  type        = bool
  description = "Regra de ciclo de vida para modificações no seu bucket"
  default     = false
  validation {
    condition     = var.storage_lifecycle_rule == null || contains([true, false], var.storage_lifecycle_rule)
    error_message = "O valor do parametro necessita ser true ou false"
  }
}

variable "transition_storage_class" {
  type        = string
  description = "Classe de armazenamento para transição -> STANDARD GLACIER, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, DEEP_ARCHIVE, GLACIER_IR"
  default     = "STANDARD_IA"
  validation {
    condition     = var.transition_storage_class == null || contains(["STANDARD", "GLACIER", "STANDARD_IA", "ONEZONE_IA", "INTELLIGENT_TIERING", "DEEP_ARCHIVE", "GLACIER_IR"], var.transition_storage_class)
    error_message = "A classe de storage precisa ser: 'STANDARD', 'GLACIER', 'STANDARD_IA', 'ONEZONE_IA', 'INTELLIGENT_TIERING','DEEP_ARCHIVE','GLACIER_IR'"
  }
}

variable "storage_objects_transition_days" {
  type        = number
  description = "Dias para transição de objetos"
  default     = 60
  validation {
    condition     = var.storage_objects_transition_days == null || var.storage_objects_transition_days > 0
    error_message = "A quantidade de dias precisa maior que 0"
  }
}

variable "storage_objects_expiration_days" {
  type        = number
  description = "Dias para expiração da transição"
  default     = 0
  validation {
    condition     = var.storage_objects_expiration_days == null || var.storage_objects_expiration_days >= 0
    error_message = "A quantidade de dia para expirar precisa ser maior que 0"
  }
}

variable "storage_website" {
  type        = bool
  description = "Habilitar bucket como site"
  default     = false
  validation {
    condition     = var.storage_website == null || contains([true, false], var.storage_website)
    error_message = "O valor do parametro precisa ser true ou false."
  }
}

variable "storage_index" {
  type        = string
  description = "Índice do seu site"
  default     = "index.html"
  validation {
    condition     = var.storage_index == null || length(var.storage_index) >= 4
    error_message = "O arquivo nao segue o padrão desejado: <nome>.html"
  }
}

variable "storage_error_index" {
  type        = string
  description = "Índice de erro do seu site"
  default     = "error.html"
  validation {
    condition     = var.storage_error_index == null || length(var.storage_error_index) >= 4
    error_message = "O arquivo nao segue o padrão desejado: <nome_error>.html"
  }
}

variable "user_count" {
  type        = number
  description = "Ativar criação de usuário, por padrão é criado 1 usuario"
  default     = 1
  validation {
    condition     = var.user_count >= 1 || can(regexall("^[0-9]+$", var.user_count))
    error_message = "O valor do parametro para criacao do usuario precisa ser 1 ou maior."
  }
}

variable "iam_user_name" {
  type        = string
  description = "Nome do usuário"
  default     = "my-user"
  validation {
    condition     = var.iam_user_name == null || length(var.iam_user_name) > 0
    error_message = "O nome do usuario iam precisa ser maior que 0"
  }
}

variable "iam_users" {
  type        = list(string)
  description = "Usuários para conceder acesso ao bucket storage"
  default     = [null]
  validation {
    condition     = var.iam_users == null || length(var.iam_users) > 0
    error_message = "O nome de usuario é invalido"
  }
}

variable "iam_policy_action" {
  type        = string
  description = "Ação na política"
  default     = "s3:*"
  validation {
    condition     = var.iam_policy_action == null || can(regex("^s3:([a-zA-Z]+|\\*)$", var.iam_policy_action))
    error_message = "A ação na politica precisa seguir o seguinte padrão: 's3:<action>' ou '<action>' Ex: 's3:GetObject'"
  }
}

variable "iam_policy_effect" {
  type        = list(string)
  description = "Efeito na política"
  default     = ["Allow"]
  validation {
    condition     = var.iam_policy_effect == null || alltrue([for effect in var.iam_policy_effect : effect == "Allow" || effect == "Deny"])
    error_message = "O valor do parametro precisa ser Allow ou Deny."
  }
}
