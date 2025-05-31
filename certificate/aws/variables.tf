variable "project_name" {
  type        = string
  description = "Nome do seu projeto"
  default     = "my-project"
}
locals {
  env = ["dev", "desenvolvimento", "development", "prd", "prod", "production", "producao", "hml", "homol", "homologacao", "sbx"]
}
variable "project_env" {
  type        = string
  default     = "dev"
  description = "Abreviação do ambiente. Valores suportados: `sbx` para sandbox, `dev` para desenvolvimento, `hml` para homologação e `prd` para produção."
  validation {
    condition     = can(regex("^(dev|desenvolvimento|development|prd|prod|production|producao|hml|homol|homologacao|sbx)$", var.project_env))
    error_message = "O project_env deve ser um dos seguintes valores: 'sbx', 'dev', 'hml' ou 'prd'."
  }
}

variable "project_region" {
  type        = string
  description = "Região do seu projeto"
  default     = "us-east-1"
  validation {
    condition     = can(regex("^(us-east-[1-2]|us-west-[1-2]|eu-west-[1-2]|ap-southeast-[1-2])$", var.project_region))
    error_message = "Região inválida. Regioes aceitas: 'us-east-[1-2]', 'us-west-[1-2], 'eu-west-[1-2]','ap-southeast-[1-2]'"
  }
}

#Certificate
variable "dns_name" {
  type        = string
  description = "DNS Name para o a criação do certificado"
}

variable "validation_method" {
  type        = string
  default     = "DNS"
  description = "Tipo de validação para o dns do certificado"
  validation {
    condition     = contains(["DNS", "EMAIL"], var.validation_method)
    error_message = "O tipo de validação precisa ser 'DNS' ou 'EMAIL'"
  }
}
