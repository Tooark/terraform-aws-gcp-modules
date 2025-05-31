# Módulo Storage GCP

[IAC](../../README.md) / [Storage](../README.md) / **[GCP](./README.md)**

Módulo de infraestrutura como código (IAC) para provisionamento de Cloud Storage buckets na GCP.

## Provider

- [**GCP**](../../gcp/README.md)

## Requisitos

- [Terraform](https://www.terraform.io/downloads.html)

- [GCP SDK](https://cloud.google.com/sdk/docs/install)

## Utilização

```hcl
module "storage_gcp" {
  source = "github.com/Grupo-Jacto/iac/storage/gcp?ref=v1.0.0"

  project_id = "<PROJECT_ID>"
  name       = "<BUCKET_NAME>"
  location   = "<LOCATION>" # ex: "para região especifica utilizar parâmetro 'region'"
}
```

## Inputs

| Name                             | Description                                    | Type                          | Default                           | Required |
| -------------------------------- | ---------------------------------------------- | ----------------------------- | --------------------------------- | :------: |
| project_id                       | ID do projeto no GCP                           | `string`                      | n/a                               |   yes    |
| name                             | Nome do bucket Cloud Storage                   | `string`                      | n/a                               |   yes    |
| labels                           | Labels adicionais para o recurso               | `object({owner, technician})` | n/a                               |   yes    |
| project_env                      | Ambiente do projeto                            | `string`                      | `dev`                             |    no    |
| location                         | Localização para multi região                  | `string`                      | `US` caso `region` seja `null`    |    no    |
| region                           | Região específica do serviço                   | `string`                      | `null`                            |    no    |
| class                            | Classe de armazenamento do bucket              | `string`                      | `"STANDARD"`                      |    no    |
| autoclass                        | Ativação da classe de armazenamento automática | `bool`                        | `false`                           |    no    |
| autoclass_terminal               | Classe de armazenamento final para autoclass   | `string`                      | `"NEARLINE"`                      |    no    |
| public_prevention                | Prevenção de acesso público                    | `bool`                        | `true`                            |    no    |
| uniform_access                   | Acesso uniforme ao bucket                      | `bool`                        | `true`                            |    no    |
| force_destroy                    | Força a exclusão do bucket                     | `bool`                        | `true`                            |    no    |
| cors_age                         | Tempo de cache do CORS no navegador            | `number`                      | `3600`                            |    no    |
| cors_origin                      | Origens permitidas pelo CORS                   | `list(string)`                | `["*"]`                           |    no    |
| cors_method                      | Métodos permitidos pelo CORS                   | `list(string)`                | `["GET"]`                         |    no    |
| cors_header                      | Cabeçalhos permitidos pelo CORS                | `list(string)`                | `["Access-Control-Allow-Origin"]` |    no    |
| website                          | Ativação do website do bucket                  | `bool`                        | `false`                           |    no    |
| website_main                     | Página principal do website do bucket          | `string`                      | `"index.html"`                    |    no    |
| website_error                    | Página de erro do website do bucket            | `string`                      | `"404.html"`                      |    no    |
| iam_public                       | Permissão pública de visualização dos objetos  | `bool`                        | `false`                           |    no    |
| iam_member_viewer                | Membros com permissão de visualização          | `list(string)`                | `[]`                              |    no    |
| iam_member_creator               | Membros com permissão de criação de objetos    | `list(string)`                | `[]`                              |    no    |
| iam_member_admin                 | Membros com permissão de administração         | `list(string)`                | `[]`                              |    no    |
| storage_account_create           | Criação de conta de serviço para o bucket      | `bool`                        | `true`                            |    no    |
| storage_account_condition        | Condição de acesso ao bucket                   | `bool`                        | `false`                           |    no    |
| storage_account_member           | Membro com acesso ao bucket                    | `string`                      | `null`                            |    no    |
| storage_account_iam_role         | Papel IAM para o bucket                        | `string`                      | `"roles/storage.objectAdmin"`     |    no    |
| storage_account_key_private_type | Tipo de chave privada                          | `string`                      | `"TYPE_GOOGLE_CREDENTIALS_FILE"`  |    no    |
| storage_account_key_public_type  | Tipo de chave pública                          | `string`                      | `"TYPE_X509_PEM_FILE"`            |    no    |

## Outputs

| Name                         | Description                                                                      | Type     |
| ---------------------------- | -------------------------------------------------------------------------------- | -------- |
| resource_bucket_storage      | Dados do recurso do Bucket Storage.                                              | `object` |
| resource_bucket_storage_iam  | Dados do recurso de Permissão do AllUsers do Bucket Storage.                     | `object` |
| resource_storage_account     | Dados do recurso para criação de um Service Account para o Storage.              | `object` |
| resource_storage_account_iam | Dados do recurso de Permissão para a Service Account Storage.                    | `object` |
| resource_storage_account_key | Dados do recurso para criar Private e Public Key para a Service Account Storage. | `object` |
| storage_id                   | ID do Storage Bucket.                                                            | `string` |
| storage_name                 | Nome do Storage Bucket.                                                          | `string` |
| storage_url                  | URL do Storage Bucket.                                                           | `string` |
| storage_link                 | Link do Storage Bucket.                                                          | `string` |
| storage_role                 | Role do Storage Bucket.                                                          | `string` |
| storage_account_id           | ID da Service Account.                                                           | `string` |
| storage_account_name         | Nome da Service Account.                                                         | `string` |
| storage_account_email        | Email da Service Account.                                                        | `string` |
| storage_account_member       | Membro da Service Account.                                                       | `string` |
| storage_account_role         | Role da Service Account.                                                         | `string` |
