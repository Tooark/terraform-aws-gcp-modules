# Módulo Alerts GCP

[IAC](../../README.md) / [Alerts](../README.md) / **[GCP](./README.md)**

Módulo de infraestrutura como código (IAC) para provisionamento de Canais de Alertas no Cloud Monitoring da GCP.

## Provider

- [**GCP**](../../gcp/README.md)

## Requisitos

- [Terraform](https://www.terraform.io/downloads.html)

- [GCP SDK](https://cloud.google.com/sdk/docs/install)

## Utilização com Email

```hcl
module "alerts_builder" {
  source = "github.com/Grupo-Jacto/iac/alerts/gcp/channel?ref=v1.0.0"

  project_id = "<PROJECT_ID>"

  notification_channel_type = "email"
  notification_channel_emails = ["xpto@gmail.com", "xpto2@gmail.com"]

}
```

## Resources

| Name | Type |
|------|------|
| [google_monitoring_notification_channel.email](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel) | resource |
| [google_monitoring_notification_channel.other](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| notification\_channel\_emails | Lista de emails para notificação (usado apenas se notification\_channel\_type == 'email') | `list(string)` | `[]` | no |
| notification\_channel\_labels | Mapa de labels para outros tipos de canal (ex: slack, google\_chat, etc) | `map(string)` | `{}` | no |
| notification\_channel\_type | Tipo de notificação do canal. https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.notificationChannelDescriptors/list | `string` | n/a | yes |
| project\_id | ID do projeto no Google Cloud | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| notification\_channel\_email\_ids | IDs dos canais de notificação de email criados |
| notification\_channel\_email\_names | Nome dos canais de notificação de email criados |
| notification\_channel\_other\_id | ID do canal de notificação criado para outros tipos |
| notification\_channel\_other\_name | Nome do canal de notificação criado para outros tipos |
| notification\_channel\_other\_type | Tipo do canal de notificação criado para outros tipos |