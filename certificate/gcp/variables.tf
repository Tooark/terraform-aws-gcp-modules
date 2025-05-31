variable "project_id" {
  type        = string
  default     = "ditie-cloud-laboratorio"
  description = "ID do projeto"
  validation {
    condition     = length(var.project_id) > 1
    error_message = "O project_id deve conter apenas:\n- letras minúsculas\n- número\n- hifén."
  }
}

variable "project_env" {
  type        = string
  default     = "dev"
  description = "Abreviação do ambiente. Valores suportados: `sbx` para sandbox, `dev` para desenvolvimento, `hml` para homologação e `prd` para produção."

  validation {
    condition     = var.project_env == null || can(regex("^(sbx|dev|hml|prd)$", var.project_env))
    error_message = "O project_env deve ser nulo ou um dos seguintes valores: 'sbx', 'dev', 'hml' ou 'prd'."
  }
}

#Certificate
variable "dns_name" {
  type        = list(string)
  default     = ["test.com"]
  description = "Nome do DNS valido para o certificado"
}
