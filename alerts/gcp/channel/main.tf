# Canal de Notificacao para emails
resource "google_monitoring_notification_channel" "email" {
  for_each = var.notification_channel_type == "email" ? toset(var.notification_channel_emails) : []
  display_name = format("notification-channel-%s-%s", var.project_id, each.value)
  type         = "email"
  project      = var.project_id

  labels = {
    email_address = each.value
  }
  force_delete = false
}

# Canal de Notificacao para outros tipos
resource "google_monitoring_notification_channel" "other" {
  count        = var.notification_channel_type != "email" ? 1 : 0
  display_name = format("notification-channel-%s", var.project_id)
  type         = var.notification_channel_type
  project      = var.project_id

  labels = var.notification_channel_labels
  force_delete = false
}
