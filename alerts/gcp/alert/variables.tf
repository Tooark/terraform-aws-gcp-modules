variable "project_id" {
  type = string
  description = "ID do projeto no Google Cloud"
}

#Alerts
variable "alert_name" {
  type = string
  description = "Nome do alerta"
}
variable "combiner" {
  type = string
  description = "Como combinar os resultados de várias condições para determinar se um incidente deve ser aberto. Os valores possíveis são: AND, OR, AND_WITH_MATCHING_RESOURCE"

  validation {
    condition = contains(["AND", "OR", "AND_WITH_MATCHING_RESOURCE"], var.combiner)
    error_message = "Forneça um combinador valido. (AND, OR ou AND_WITH_MATCHING_RESOURCE)."
  }
}
variable "enabled" {
  type = bool
  description = "Ativa ou desativa o alerta"
  default = true
}
variable "notification_channel" {
  type = list(string)
  description = "Lista de IDs dos canais de notificação associados à política de alerta"
  default = []  
}

# Ativar modos de condição
variable "enable_builder" {
  type        = bool
  description = "Ativa o modo Builder para condições de alerta"
  default     = false
}
variable "enable_mql" {
  type        = bool
  description = "Ativa o modo MQL para condições de alerta"
  default     = false
}
variable "enable_promql" {
  type        = bool
  description = "Ativa o modo PromQL para condições de alerta"
  default     = false
}

#Builder
variable "conditiion_filter" {
  type        = string
  description = "Filtro para a condição do alerta usando padrões do Metrics Splorer na console da GCP"
  default     = null
}
variable "condition_duration" {
  type        = string
  description = "Duracao em minutos(multiplos de 60) que é considerado uma falha pela metrica"
  default     = null
}
variable "condition_comparison" {
  type        = string
  description = "The comparison to apply between the time series (indicated by filter and aggregation) and the threshold (indicated by threshold_value)."
  default     = null
}
variable "condition_threshold" {
  type        = number
  description = "Valor limite a ser usado para o alarme, exemplo '0.7' para milisegundos de uma requisição"
  default     = null
}
variable "aggregation_period" {
  type        = string
  description = "O período de alinhamento para alinhamento por série temporal. Se presente, alignmentPeriod deve ter pelo menos 60 segundos. Após o alinhamento por série temporal, cada série temporal conterá pontos de dados apenas nos limites do período."
  default     = "60s"
}
variable "aggregation_series_aligner" {
  type        = string
  description = "A abordagem a ser usada para alinhar séries temporais individuais. Nem todas as funções de alinhamento podem ser aplicadas a todas as séries temporais, dependendo do tipo de métrica e do tipo de valor da série temporal original."
  default = null
}
variable "documentation" {
  type = string
  description = "Texto do alerta que chegará no canal de notificação para os usuarios"
}
variable "documentation_mime_type" {
  type = string
  description = "Tipo do texto da Documentation"
  default = "text/markdown"
}
variable "link_name" {
  type = string
  description = "Nome do link para o acionamento do alerta"
  default = "Console Google Cloud - Cloud Logging"
}
variable "alert_auto_close" {
  type = string
  description = "Tempo para o alerta se auto fechar, por padrao sera de 3 dias"
  default = "259200s"
}
variable "alert_notification_prompt" {
  type = list(string)
  description = "Quando eu quero receber as notificacoes do alarme"
  default = ["OPENED"]
}
#MQL
variable "mql_query" {
  type        = string
  description = "Consulta MQL para o alerta"
  default     = null
}
variable "mql_duration" {
  type        = string
  description = "Duração da consulta MQL"
  default     = null
}
variable "mql_evaluation_interval" {
  type        = string
  description = "Intervalo de avaliação da consulta MQL"
  default     = null
}

#Promql
variable "promql_query" {
  type        = string
  description = "Consulta PromQL para o alerta"
  default     = null
}
variable "promql_duration" {
  type        = string
  description = "Duração da consulta PromQL"  
  default     = null
}
variable "promql_evaluation_interval" {
  type        = string
  description = "Intervalo de avaliação da consulta PromQL"
  default     = null
}
variable "promql_alert_rule" {
  type        = string
  description = "Regra de alerta para a consulta PromQL"
  default     = null
}
