# Módulo Virtual Machine GCP

[IAC](../../README.md) / [vm](../README.md) / **[GCP](./README.md)**

Módulo de infraestrutura como código (IAC) para provisionamento de Compute Engine na GCP.

## Provider

- [**GCP**](../../gcp/README.md)

## Requisitos

- [Terraform](https://www.terraform.io/downloads.html)

- [GCP SDK](https://cloud.google.com/sdk/docs/install)

## Utilização

```hcl
module "vm_gcp" {
  source = "github.com/Grupo-Jacto/iac/vm/gcp?ref=v1.0.0"

  project_id = "<PROJECT_ID>"
  project_env = "<PROJECT_ENV>"
}
```

## Resources

| Name                                                                                                                                        | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [google_compute_firewall.vm_firewall](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall)      | resource |
| [google_compute_instance.vm](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance)               | resource |
| [google_service_account.service_account_vm](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |

## Inputs

| Name                        | Description                                                                                                                                                                                                              | Type           | Default                             | Required |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------- | ----------------------------------- | :------: |
| project_env                 | Abreviação do ambiente. Valores suportados: `sbx` para sandbox, `dev` para desenvolvimento, `hml` para homologação e `prd` para produção.                                                                                | `string`       | n/a                                 |   yes    |
| project_id                  | ID do projeto                                                                                                                                                                                                            | `string`       | n/a                                 |   yes    |
| service_user_name           | Nome do usuario de serviço                                                                                                                                                                                               | `string`       | `"my-su-compute-engine"`            |    no    |
| source_ranges               | Ranges liberados para ingress na regra de firewall                                                                                                                                                                       | `list(string)` | `[ "0.0.0.0/0" ]`                   |    no    |
| use_service_user            | Ativa ou não a criação do usuario de serviço                                                                                                                                                                             | `bool`         | `true`                              |    no    |
| vm_count                    | Numero de instancias que deseja subir                                                                                                                                                                                    | `number`       | `1`                                 |    no    |
| vm_disk_interface           | Tipo do disco ssd utilizado, por padrao o NVME é o mais rapido e barato                                                                                                                                                  | `string`       | `"NVME"`                            |    no    |
| vm_firewall_allow_ports     | Portas para liberação na regra de firewall, usar nos seguintes formatos: [22], [80, 443], and ['12345-12349']                                                                                                            | `list(number)` | `[ 80, 8080 ]`                      |    no    |
| vm_firewall_allow_protocols | Protocolos para liberação na regra de firewall, algumas opções de exemplo: ssh, tcp, udp, icmp, esp, ah, sctp, ipip, all                                                                                                 | `string`       | `"all"`                             |    no    |
| vm_firewall_name            | Nome do firewall para a vm                                                                                                                                                                                               | `string`       | `"my-firewall-for-vm"`              |    no    |
| vm_image                    | Imagem a ser utilizada na vm com o formato aceito em 'https://cloud.google.com/compute/docs/images#gcloud'                                                                                                               | `string`       | `"ubuntu-os-cloud/ubuntu-2004-lts"` |    no    |
| vm_machine_type             | Tipo da instancia da vm, verifique todas as disponiveis em: https://cloud.google.com/compute/docs/machine-resource                                                                                                       | `string`       | `"e2-micro"`                        |    no    |
| vm_name                     | Nome da vm: - letras minúsculas - número - hifén.                                                                                                                                                                        | `string`       | `"my-vm"`                           |    no    |
| vm_network_interface        | Configurações da interface de rede da vm                                                                                                                                                                                 | `string`       | `"default"`                         |    no    |
| vm_service_account_scopes   | Permissao do usuario de serviço a apis da Google cloud. 'cloud-platform' por padrão com acesso a ALL Api's. Veja as opções em: https://cloud.google.com/sdk/gcloud/reference/alpha/compute/instances/set-scopes#--scopes | `list(string)` | `[ "cloud-platform" ]`              |    no    |
| vm_zone                     | Zona de disponibilidade da vm, consulte todas as zonas disponiveis em: https://cloud.google.com/compute/docs/regions-zones                                                                                               | `string`       | `"us-central1"`                     |    no    |

## Outputs

| Name                         | Description                                     |
| ---------------------------- | ----------------------------------------------- |
| service_user                 | Dados do usuario de serviço                     |
| service_user_vm_id           | ID do usuario de serviço pra vm                 |
| service_user_vm_name         | Nome do usuario de serviço para a vm            |
| vm                           | Dados da vm                                     |
| vm_firewall_allow_ports      | Portas liberadas na regra de firewall para a vm |
| vm_firewall_allowed_protocol | Protocolos liberados para a regra da vm         |
| vm_firewall_id               | ID da regra de firewall para a vm               |
| vm_firewall_name             | Nome da regra de firewall para a vm             |
| vm_id                        | ID da vm                                        |
| vm_image                     | Imagem sendo usada na vm                        |
| vm_machine_type              | Tipo da instancia sendo usada na vm             |
| vm_name                      | Nome da vm                                      |
| vm_private_ip                | Ip privado da vm                                |
| vm_zone                      | Zona da vm                                      |

<!-- END_TF_DOCS -->
