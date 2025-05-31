variable "project_id" {
  type = string
  description = "ID do projeto no Google Cloud"
}

#Notification Channel
variable "notification_channel_type" {
  type = string
  description = "Tipo de notificação do canal. https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.notificationChannelDescriptors/list"

  validation {
    condition = contains([
    "email",
    "google_chat",
    "pagerduty",
    "pubsub",
    "slack",
    "sms",
    "webhook_basicauth",
    "webhook_tokenauth"
  ], var.notification_channel_type)
    error_message = "O tipo de canal esta invalido, verifique a documentação oficial:\n- https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel"
  }
}
variable "notification_channel_emails" {
  type        = list(string)
  description = "Lista de emails para notificação (usado apenas se notification_channel_type == 'email')"
  default     = []

  validation {
    condition = alltrue([
    for email in var.notification_channel_emails : can(regex("^\\S+@\\S+\\.\\S+$", email))
  ])
    error_message = "Email invalido. Forneça um email valido."
  }
}
variable "notification_channel_labels" {
  type        = map(string)
  description = "Mapa de labels para outros tipos de canal (ex: slack, google_chat, etc)"
  default     = {}
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
    error_message = "Forneça um combinador valido. (AND, OR ou AND_WITH_MATCHING_RESOURCE)"
  }
}
variable "enabled" {
  type = bool
  description = "Ativa ou desativa o alerta"
  default = true
}
variable "condition_name" {
  description = "Nome da condição do alerta"
}
variable "conditiion_filter" {
  type = string
  description = "Filtro para a condição do alerta usando padrões do Metrics Splorer na console da GCP"
}
variable "condition_duration" {
  type = string
  description = "Duracao em minutos(multiplos de 60) que é considerado uma falha pela metrica"
}
variable "condition_comparison" {
  type = string
  description = "The comparison to apply between the time series (indicated by filter and aggregation) and the threshold (indicated by threshold_value)."

  validation {
    condition = startswith(var.condition_comparison, "COMPARISON_")
    error_message = "O campo precisa começar com 'COMPARISON_'"
  }
}
variable "condition_threshold" {
  type = number
  description = "Valor limite a ser usado para o alarme, exemplo '0.7' para milisegundos de uma requisição"
}
variable "aggregation_period" {
  type = string
  description = "O período de alinhamento para alinhamento por série temporal. Se presente, alignmentPeriod deve ter pelo menos 60 segundos. Após o alinhamento por série temporal, cada série temporal conterá pontos de dados apenas nos limites do período."
  default = "60s"
}
variable "aggregation_series_aligner" {
  type = string
  description = "A abordagem a ser usada para alinhar séries temporais individuais. Nem todas as funções de alinhamento podem ser aplicadas a todas as séries temporais, dependendo do tipo de métrica e do tipo de valor da série temporal original."

  validation {
    condition = startswith(var.aggregation_series_aligner, "ALIGN_")
    error_message = "O campo precisa começar com 'ALIGN_'"
  }
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