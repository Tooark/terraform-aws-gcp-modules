# Módulo Alerts GCP

[IAC](../../README.md) / [Alerts](../README.md) / **[GCP](./README.md)**

Módulo de infraestrutura como código (IAC) para provisionamento de Alertas no Cloud Monitoring da GCP.

## Provider

- [**GCP**](../../gcp/README.md)

## Requisitos

- [Terraform](https://www.terraform.io/downloads.html)

- [GCP SDK](https://cloud.google.com/sdk/docs/install)

## Utilização Builder

```hcl
module "alerts_builder" {
  source = "github.com/Grupo-Jacto/iac/alerts/gcp/alert?ref=v1.0.0"

  project_id = "<PROJECT_ID>"
  
  enabled = true

  enable_builder = true
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

## Utilização Mql

```hcl
module "alerts_mql" {
  source = "github.com/Grupo-Jacto/iac/alerts/gcp/alert?ref=v1.0.0"

  project_id = "<PROJECT_ID>"
  
  enabled = true

  enable_mql = true
  mql_query = <<EOT
    fetch gce_instance
      | metric 'compute.googleapis.com/instance/cpu/utilization'
      | group_by 5m, [value_utilization_mean: mean(value.utilization)]
      | every 5m"
    EOT
  mql_duration = "60s"

  aggregation_period = "60s"
  aggregation_series_aligner = "ALIGN_MEAN"

  documentation = "The Compute Engine needs more cpu SysAdmin!"
}
```

## Utilização Promql

```hcl
module "alerts_promql" {
  source = "github.com/Grupo-Jacto/iac/alerts/gcp/alert?ref=v1.0.0"

  project_id = "<PROJECT_ID>"
  
  enabled = true

  enable_promql = true
  promql_query = <<EOT
    avg_over_time(
        compute_googleapis_com:instance_cpu_utilization{
        instance_name=~"^sonarqube-.*"
        }[5m]
      )
    EOT
  promql_duration = "60s"
  promql_evaluation_interval = "60s"
  promql_alert_rule = "AlwaysOn" 

  aggregation_period = "60s"
  aggregation_series_aligner = "ALIGN_MEAN"

  documentation = "The Compute Engine needs more cpu SysAdmin!"
}
```

## Resources

| Name | Type |
|------|------|
| [google_monitoring_alert_policy.custom_alerts](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aggregation\_period | O período de alinhamento para alinhamento por série temporal. Se presente, alignmentPeriod deve ter pelo menos 60 segundos. Após o alinhamento por série temporal, cada série temporal conterá pontos de dados apenas nos limites do período. | `string` | `"60s"` | no |
| aggregation\_series\_aligner | A abordagem a ser usada para alinhar séries temporais individuais. Nem todas as funções de alinhamento podem ser aplicadas a todas as séries temporais, dependendo do tipo de métrica e do tipo de valor da série temporal original. | `string` | `null` | no |
| alert\_auto\_close | Tempo para o alerta se auto fechar, por padrao sera de 3 dias | `string` | `"259200s"` | no |
| alert\_name | Nome do alerta | `string` | n/a | yes |
| alert\_notification\_prompt | Quando eu quero receber as notificacoes do alarme | `list(string)` | ```[ "OPENED" ]``` | no |
| combiner | Como combinar os resultados de várias condições para determinar se um incidente deve ser aberto. Os valores possíveis são: AND, OR, AND\_WITH\_MATCHING\_RESOURCE | `string` | n/a | yes |
| conditiion\_filter | Filtro para a condição do alerta usando padrões do Metrics Splorer na console da GCP | `string` | `null` | no |
| condition\_comparison | The comparison to apply between the time series (indicated by filter and aggregation) and the threshold (indicated by threshold\_value). | `string` | `null` | no |
| condition\_duration | Duracao em minutos(multiplos de 60) que é considerado uma falha pela metrica | `string` | `null` | no |
| condition\_threshold | Valor limite a ser usado para o alarme, exemplo '0.7' para milisegundos de uma requisição | `number` | `null` | no |
| documentation | Texto do alerta que chegará no canal de notificação para os usuarios | `string` | n/a | yes |
| documentation\_mime\_type | Tipo do texto da Documentation | `string` | `"text/markdown"` | no |
| enable\_builder | Ativa o modo Builder para condições de alerta | `bool` | `false` | no |
| enable\_mql | Ativa o modo MQL para condições de alerta | `bool` | `false` | no |
| enable\_promql | Ativa o modo PromQL para condições de alerta | `bool` | `false` | no |
| enabled | Ativa ou desativa o alerta | `bool` | `true` | no |
| link\_name | Nome do link para o acionamento do alerta | `string` | `"Console Google Cloud - Cloud Logging"` | no |
| mql\_duration | Duração da consulta MQL | `string` | `null` | no |
| mql\_evaluation\_interval | Intervalo de avaliação da consulta MQL | `string` | `null` | no |
| mql\_query | Consulta MQL para o alerta | `string` | `null` | no |
| notification\_channel | Lista de IDs dos canais de notificação associados à política de alerta | `list(string)` | `[]` | no |
| project\_id | ID do projeto no Google Cloud | `string` | n/a | yes |
| promql\_alert\_rule | Regra de alerta para a consulta PromQL | `string` | `null` | no |
| promql\_duration | Duração da consulta PromQL | `string` | `null` | no |
| promql\_evaluation\_interval | Intervalo de avaliação da consulta PromQL | `string` | `null` | no |
| promql\_query | Consulta PromQL para o alerta | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| alert\_policy\_enabled | Se a política de alerta está habilitada |
| alert\_policy\_id | ID da política de alerta criada |
| alert\_policy\_name | Nome da política de alerta criada |
| alert\_policy\_notification\_channels | Canais de notificação associados à política de alerta |
| alert\_policy\_reason | Razões do alerta de notificação |