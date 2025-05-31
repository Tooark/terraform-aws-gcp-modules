# Módulo Alerts GCP

[IAC](../../README.md) / [Alerts](../README.md) / **[GCP](./README.md)**

Módulo de infraestrutura como código (IAC) para provisionamento de Alertas no Cloud Monitoring da GCP.

## Provider

- [**GCP**](../../gcp/README.md)

## Requisitos

- [Terraform](https://www.terraform.io/downloads.html)

- [GCP SDK](https://cloud.google.com/sdk/docs/install)

## Utilização

```hcl
module "alerts_gcp" {
  source = "github.com/Grupo-Jacto/iac/alerts/gcp?ref=v1.0.0"

  project_id = "<PROJECT_ID>"
  
  enabled = true

  notification_channel_type = "email"
  notification_channel_emails = ["xpto@gmail.com", "xpto2@gmail.com"]

  alert_name = "My Custom Alert"
  combiner = "OR"
  condition_name = "Compute Engine cpu utilization alert > 80%"
  conditiion_filter = "resource.type=\"gce_instance\" AND metric.type=\"compute.googleapis.com/instance/cpu/utilization\""
  condition_duration = "300s"
  condition_comparison  = "COMPARISON_GT"
  condition_threshold = 0.8

  aggregation_period = "60s"
  aggregation_series_aligner = "ALIGN_MEAN"

  documentation = "The Compute Engine needs more cpu SysAdmin!"
}
```

## Resources

| Name                                                                                                                                                           | Type     |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [google_monitoring_alert_policy.custom_alerts](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy)         | resource |
| [google_monitoring_notification_channel.email](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel) | resource |
| [google_monitoring_notification_channel.other](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel) | resource |

## Inputs

| Name                        | Description                                                                                                                                                                                                                                   | Type           | Default                                  | Required |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ---------------------------------------- | :------: |
| aggregation_period          | O período de alinhamento para alinhamento por série temporal. Se presente, alignmentPeriod deve ter pelo menos 60 segundos. Após o alinhamento por série temporal, cada série temporal conterá pontos de dados apenas nos limites do período. | `string`       | `"60s"`                                  |    no    |
| aggregation_series_aligner  | A abordagem a ser usada para alinhar séries temporais individuais. Nem todas as funções de alinhamento podem ser aplicadas a todas as séries temporais, dependendo do tipo de métrica e do tipo de valor da série temporal original.          | `string`       | n/a                                      |   yes    |
| alert_auto_close            | Tempo para o alerta se auto fechar, por padrao sera de 3 dias                                                                                                                                                                                 | `string`       | `"259200s"`                              |    no    |
| alert_name                  | Nome do alerta                                                                                                                                                                                                                                | `string`       | n/a                                      |   yes    |
| alert_notification_prompt   | Quando eu quero receber as notificacoes do alarme                                                                                                                                                                                             | `list(string)` | `[ "OPENED" ]`                           |    no    |
| combiner                    | Como combinar os resultados de várias condições para determinar se um incidente deve ser aberto. Os valores possíveis são: AND, OR, AND_WITH_MATCHING_RESOURCE                                                                                | `string`       | n/a                                      |   yes    |
| conditiion_filter           | Filtro para a condição do alerta usando padrões do Metrics Splorer na console da GCP                                                                                                                                                          | `string`       | n/a                                      |   yes    |
| condition_comparison        | The comparison to apply between the time series (indicated by filter and aggregation) and the threshold (indicated by threshold_value).                                                                                                       | `string`       | n/a                                      |   yes    |
| condition_duration          | Duracao em minutos(multiplos de 60) que é considerado uma falha pela metrica                                                                                                                                                                  | `string`       | n/a                                      |   yes    |
| condition_name              | Nome da condição do alerta                                                                                                                                                                                                                    | `any`          | n/a                                      |   yes    |
| condition_threshold         | Valor limite a ser usado para o alarme, exemplo '0.7' para milisegundos de uma requisição                                                                                                                                                     | `number`       | n/a                                      |   yes    |
| documentation               | Texto do alerta que chegará no canal de notificação para os usuarios                                                                                                                                                                          | `string`       | n/a                                      |   yes    |
| documentation_mime_type     | Tipo do texto da Documentation                                                                                                                                                                                                                | `string`       | `"text/markdown"`                        |    no    |
| enabled                     | Ativa ou desativa o alerta                                                                                                                                                                                                                    | `bool`         | `true`                                   |    no    |
| link_name                   | Nome do link para o acionamento do alerta                                                                                                                                                                                                     | `string`       | `"Console Google Cloud - Cloud Logging"` |    no    |
| notification_channel_emails | Lista de emails para notificação (usado apenas se notification_channel_type == 'email')                                                                                                                                                       | `list(string)` | `[]`                                     |    no    |
| notification_channel_labels | Mapa de labels para outros tipos de canal (ex: slack, google_chat, etc)                                                                                                                                                                       | `map(string)`  | `{}`                                     |    no    |
| notification_channel_type   | Tipo de notificação do canal. https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.notificationChannelDescriptors/list                                                                                                             | `string`       | n/a                                      |   yes    |
| project_id                  | ID do projeto no Google Cloud                                                                                                                                                                                                                 | `string`       | n/a                                      |   yes    |

## Outputs

| Name                               | Description                                           |
| ---------------------------------- | ----------------------------------------------------- |
| alert_policy_enabled               | Se a política de alerta está habilitada               |
| alert_policy_id                    | ID da política de alerta criada                       |
| alert_policy_name                  | Nome da política de alerta criada                     |
| alert_policy_notification_channels | Canais de notificação associados à política de alerta |
| alert_policy_reason                | Razões do alerta de notificação                       |
| notification_channel_email_ids     | IDs dos canais de notificação de email criados        |
| notification_channel_email_names   | Nome dos canais de notificação de email criados       |
| notification_channel_other_id      | ID do canal de notificação criado para outros tipos   |
| notification_channel_other_name    | Nome do canal de notificação criado para outros tipos |
| notification_channel_other_type    | Tipo do canal de notificação criado para outros tipos |

<!-- END_TF_DOCS -->
