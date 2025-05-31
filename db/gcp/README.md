# Módulo Database GCP

[IAC](../../README.md) / [DB](../README.md) / **[GCP](./README.md)**

Módulo de infraestrutura como código (IAC) para provisionamento de Cloud Storage buckets na GCP.

## Provider

- [**GCP**](../../gcp/README.md)

## Requisitos

- [Terraform](https://www.terraform.io/downloads.html)

- [GCP SDK](https://cloud.google.com/sdk/docs/install)

## Utilização

```hcl
module "db_gcp" {
  source = "github.com/Grupo-Jacto/iac/db/gcp?ref=v1.0.0"

  project_id = "<PROJECT_ID>"
  project_env = "<PROJECT_ENV>"
}
```

## Resources

| Name                                                                                                                                           | Type     |
| ---------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [google_alloydb_cluster.db_cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_cluster)            | resource |
| [google_alloydb_instance.db_cluster_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_instance) | resource |
| [google_alloydb_user.db_cluster_user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_user)             | resource |
| [google_compute_network.db_cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network)            | resource |
| [google_sql_database.db](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database)                          | resource |
| [google_sql_database_instance.db](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance)        | resource |
| [google_sql_ssl_cert.db_certificate](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_ssl_cert)              | resource |
| [google_sql_user.db_user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user)                             | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password)                            | resource |

## Inputs

| Name                             | Description                                                                                                                                                                                                                                                           | Type           | Default                  | Required |
| -------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ------------------------ | :------: |
| choose_db                        | Seleção do tipo de banco de dados que deseja criar                                                                                                                                                                                                                    | `string`       | `"db"`                   |    no    |
| db_certificate                   | Cria um certificado ssl para o db                                                                                                                                                                                                                                     | `bool`         | `true`                   |    no    |
| db_certificate_name              | Nome do certificado SSL pro banco de dados                                                                                                                                                                                                                            | `string`       | `"my-cert"`              |    no    |
| db_cluster_instance_name         | Nome da instancia do cluster de banco dados                                                                                                                                                                                                                           | `string`       | `"my_db_instance"`       |    no    |
| db_cluster_instance_type         | Tipo de instancia usada no cluster, consulte em:https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/alloydb_instance                                                                                                                       | `string`       | `"PRIMARY"`              |    no    |
| db_cluster_user_role             | Role para liberar acesso do usuario ao cluster de banco de dados                                                                                                                                                                                                      | `list(string)` | `[ "alloydbsuperuser" ]` |    no    |
| db_cluster_user_type             | Tipo de usuario para o db cluster: Use ALLOYDB_BUILT_IN para criar usuários que serão gerenciados exclusivamente dentro do AlloyDB. Use ALLOYDB_IAM_USER para criar usuários que serão gerenciados pelo IAM e podem precisar acessar outros serviços do Google Cloud. | `string`       | `"ALLOYDB_BUILT_IN"`     |    no    |
| db_deletion_protection           | Ativa a proteção contra deleção do db                                                                                                                                                                                                                                 | `bool`         | `true`                   |    no    |
| db_disk_size                     | Tamanho do disco para o banco de dados                                                                                                                                                                                                                                | `number`       | `10`                     |    no    |
| db_instance_name                 | Nome da instancia do banco de dados                                                                                                                                                                                                                                   | `string`       | `"my-instance"`          |    no    |
| db_instance_type                 | Tipo de instancia do db                                                                                                                                                                                                                                               | `string`       | `"db-f1-micro"`          |    no    |
| db_name                          | Nome do banco de dados                                                                                                                                                                                                                                                | `string`       | `"my-db"`                |    no    |
| db_region                        | Regiao para a instancia do banco de dados                                                                                                                                                                                                                             | `string`       | `"us-central1"`          |    no    |
| db_user_name                     | Nome do usuario do banco de dados                                                                                                                                                                                                                                     | `string`       | `"root"`                 |    no    |
| db_version_engine                | Versao da engine do rds usada, veja as opções em 'https://cloud.google.com/sql/docs/db-versions?hl=pt-br'                                                                                                                                                             | `string`       | `"POSTGRES_16"`          |    no    |
| project_env                      | Abreviação do ambiente. Valores suportados: `sbx` para sandbox, `dev` para desenvolvimento, `hml` para homologação e `prd` para produção.                                                                                                                             | `string`       | n/a                      |   yes    |
| project_id                       | ID do projeto                                                                                                                                                                                                                                                         | `string`       | n/a                      |   yes    |
| random_password_length           | Quantidade de caracteres para o valor randomico                                                                                                                                                                                                                       | `number`       | `16`                     |    no    |
| random_password_override_special | Define quais caracteres especiais usar na geração do valor aleatorio                                                                                                                                                                                                  | `string`       | `"!#$%&*()-+"`           |    no    |
| random_password_special          | Inclui caracteres especiais na senha                                                                                                                                                                                                                                  | `bool`         | `true`                   |    no    |

## Outputs

| Name                   | Description                                   |
| ---------------------- | --------------------------------------------- |
| db                     | Dados - Banco de dados(Cloud SQL)             |
| db_certificate_id      | ID do certificado do banco de dados           |
| db_certificate_name    | Nome do certificado do banco de dados         |
| db_cluster             | Dados - Cluster(AlloyDB)                      |
| db_cluster_instance    | Dados - Instancia do Cluster(AlloyDB)         |
| db_database_engine     | Engine do banco de dados                      |
| db_deletion_protection | Proteção contra destruição pro banco de dados |
| db_id                  | ID do banco de dados                          |
| db_name                | Nome do banco de dados                        |
| db_region              | Regiao do banco de dados                      |
| db_user_id             | ID do usuario do banco de dados               |
| db_user_name           | Nome do usuario do banco de dados             |
| db_user_password       | Senha do usuario do banco de dados            |

<!-- END_TF_DOCS -->
