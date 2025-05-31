# Módulo Storage AWS

[IAC](../../README.md) / [Storage](../README.md) / **[AWS](./README.md)**

Módulo de infraestrutura como código (IAC) para provisionamento de S3 buckets na AWS.

## Provider

- [**AWS**](../../aws/README.md)

## Requisitos

- [Terraform](https://www.terraform.io/downloads.html)

- [AWS CLI](https://aws.amazon.com/pt/cli/)

## Utilização

```hcl
module "storage_aws" {
  source = "github.com/Grupo-Jacto/iac/storage/aws?ref=v1.0.0"

  aws_account_id = "<ACCOUNT_ID>"
  project_name = "<PROJECT_NAME>"
  project_env = "<PROJECT_ENV>"
}
```

## Resources

| Name                                                                                                                                                                       | Type     |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_iam_access_key.service-user-key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key)                                          | resource |
| [aws_iam_policy.grant-storage-access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                              | resource |
| [aws_iam_user.service-user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user)                                                          | resource |
| [aws_iam_user_policy_attachment.grant-users-access-storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment)        | resource |
| [aws_s3_bucket.storage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)                                                             | resource |
| [aws_secretsmanager_secret.service_user_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret)                         | resource |
| [aws_secretsmanager_secret_version.service_user_secret_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Inputs

| Name                            | Description                                                                                                                               | Type           | Default          | Required |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ---------------- | :------: |
| aws_account_id                  | ID da sua conta AWS                                                                                                                       | `string`       | `"767397849711"` |    no    |
| iam_policy_action               | Ação na política                                                                                                                          | `string`       | `"s3:*"`         |    no    |
| iam_policy_effect               | Efeito na política                                                                                                                        | `list(string)` | `[ "Allow" ]`    |    no    |
| iam_user_name                   | Nome do usuário                                                                                                                           | `string`       | `"my-user"`      |    no    |
| iam_users                       | Usuários para conceder acesso ao bucket storage                                                                                           | `list(string)` | `[ null ]`       |    no    |
| project_env                     | Abreviação do ambiente. Valores suportados: `sbx` para sandbox, `dev` para desenvolvimento, `hml` para homologação e `prd` para produção. | `string`       | `"dev"`          |    no    |
| project_name                    | Nome do seu projeto                                                                                                                       | `string`       | `"projeto-test"` |    no    |
| project_region                  | Região do seu projeto                                                                                                                     | `string`       | `"us-east-1"`    |    no    |
| storage_error_index             | Índice de erro do seu site                                                                                                                | `string`       | `"error.html"`   |    no    |
| storage_index                   | Índice do seu site                                                                                                                        | `string`       | `"index.html"`   |    no    |
| storage_lifecycle_rule          | Regra de ciclo de vida para modificações no seu bucket                                                                                    | `bool`         | `false`          |    no    |
| storage_objects_expiration_days | Dias para expiração da transição                                                                                                          | `number`       | `0`              |    no    |
| storage_objects_transition_days | Dias para transição de objetos                                                                                                            | `number`       | `60`             |    no    |
| storage_website                 | Habilitar bucket como site                                                                                                                | `bool`         | `false`          |    no    |
| transition_storage_class        | Classe de armazenamento para transição -> STANDARD GLACIER, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, DEEP_ARCHIVE, GLACIER_IR        | `string`       | `"STANDARD_IA"`  |    no    |
| user_count                      | Ativar criação de usuário, por padrão é criado 1 usuario                                                                                  | `number`       | `1`              |    no    |

## Outputs

| Name                                  | Description                                             |
| ------------------------------------- | ------------------------------------------------------- |
| count_users_atached_on_storage_policy | Quantidade de usuarios com acesso ao Storage Bucket     |
| iam_storage_service_user_arn          | Arn do usuario de servico com acesso ao Storage Bucket  |
| iam_storage_service_user_key          | Chave de usuario do usuario de servico                  |
| resource_bucket_storage               | Dados do Storage Bucket                                 |
| resource_bucket_storage_iam           | Politicas de acesso ao storage bucket                   |
| storage_arn                           | Arn do Storage bucket                                   |
| storage_id                            | Id do Storage Bucket                                    |
| storage_name                          | Nome do Storage Bucket                                  |
| storage_policy                        | Nome da politica de acesso ao Storage Bucket            |
| storage_region                        | Regiao do Storage Bucket                                |
| storage_service_user_name             | Nome do usuario de servico com acesso ao Sotrage Bucket |
| users_attached_on_s3                  | n/a                                                     |
| users_with_permission_on_this_storage | Nome dos usuarios com acesso ao Storage Bucket          |

<!-- END_TF_DOCS -->
