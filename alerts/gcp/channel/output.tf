output "notification_channel_email_id" {
  description = "IDs dos canais de notificação de email criados"
  value       = [for c in google_monitoring_notification_channel.email : c.id]
}

output "notification_channel_email_name" {
  description = "Nome dos canais de notificação de email criados"
  value       = [for c in google_monitoring_notification_channel.email : c.display_name]
}

output "notification_channel_other_id" {
  description = "ID do canal de notificação criado para outros tipos"
  value       = google_monitoring_notification_channel.other[*].id
}

output "notification_channel_other_type" {
  description = "Tipo do canal de notificação criado para outros tipos"
  value       = google_monitoring_notification_channel.other[*].type
}

output "notification_channel_other_name" {
  description = "Nome do canal de notificação criado para outros tipos"
  value       = google_monitoring_notification_channel.other[*].display_name
}