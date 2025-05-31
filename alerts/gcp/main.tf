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

#Cria o alerta
resource "google_monitoring_alert_policy" "custom_alerts" {
  project      = var.project_id
  display_name = var.alert_name
  combiner     = var.combiner
  enabled = var.enabled
  notification_channels = concat(
    [for c in google_monitoring_notification_channel.email : c.id],
    google_monitoring_notification_channel.other[*].id
  )
  conditions {
    display_name = var.condition_name
    
    condition_threshold {
      filter = var.conditiion_filter
      duration      = var.condition_duration
      comparison    = var.condition_comparison
      threshold_value = var.condition_threshold

      aggregations {
        alignment_period = var.aggregation_period
        per_series_aligner = var.aggregation_series_aligner
      }
    }
  }
    
  documentation {
    content = var.documentation
    mime_type = var.documentation_mime_type

    links {
      display_name = var.link_name
      url = "https://console.cloud.google.com/logs/query;cursorTimestamp=2025-05-30T15:55:35.758553Z;duration=PT30M?referrer=search&inv=1&invt=Abyzbw&project=${var.project_id}"
    }
  }

  alert_strategy {
    auto_close = var.alert_auto_close
    notification_prompts = var.alert_notification_prompt
  }

  depends_on = [
    google_monitoring_notification_channel.email,
    google_monitoring_notification_channel.other
  ]
}