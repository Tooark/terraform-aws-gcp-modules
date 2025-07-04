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
    error_message = "O tipo de canal esta invalido, verifique a documentação oficial:\n- https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel."
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