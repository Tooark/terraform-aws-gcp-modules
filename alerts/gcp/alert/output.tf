output "alert_policy_id" {
  description = "ID da política de alerta criada"
  value       = google_monitoring_alert_policy.custom_alerts.id
}

output "alert_policy_name" {
  description = "Nome da política de alerta criada"
  value       = google_monitoring_alert_policy.custom_alerts.display_name
}

output "alert_policy_enabled" {
  description = "Se a política de alerta está habilitada"
  value       = google_monitoring_alert_policy.custom_alerts.enabled
}

output "alert_policy_notification_channels" {
  description = "Canais de notificação associados à política de alerta"
  value       = google_monitoring_alert_policy.custom_alerts.notification_channels
}

output "alert_policy_reason" {
  description = "Razões do alerta de notificação"
  value       = google_monitoring_alert_policy.custom_alerts.documentation
}