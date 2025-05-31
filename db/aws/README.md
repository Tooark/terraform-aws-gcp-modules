# Módulo Database AWS

[IAC](../../README.md) / [DB](../README.md) / **[AWS](./README.md)**

Módulo de infraestrutura como código (IAC) para provisionamento de RDS na AWS.

## Provider

- [**AWS**](../../aws/README.md)

## Requisitos

- [Terraform](https://www.terraform.io/downloads.html)

- [AWS CLI](https://aws.amazon.com/pt/cli/)

## Utilização

```hcl
module "db_aws" {
  source = "github.com/Grupo-Jacto/iac/db/aws?ref=v1.0.0"

  aws_account_id = "<ACCOUNT_ID>"
  project_name = "<PROJECT_NAME>"
  project_env = "<PROJECT_ENV>"
}
```

## Resources

| Name                                                                                                                                             | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------ | -------- |
| [aws_db_instance.db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)                                    | resource |
| [aws_db_parameter_group.parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group)         | resource |
| [aws_rds_cluster.db_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster)                            | resource |
| [aws_rds_cluster_instance.db_cluster_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) | resource |

## Inputs

| Name                               | Description                                                                                                                                                     | Type           | Default                                        | Required |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ---------------------------------------------- | :------: |
| aws_account_id                     | ID da sua conta AWS                                                                                                                                             | `number`       | n/a                                            |   yes    |
| db_allocated_storage               | Quantidade de storage a ser utilizado                                                                                                                           | `number`       | `25`                                           |    no    |
| db_availability_zone               | Zonas de disponibilidade para o banco de dados (Ex: 'us-east-1a','us-east-1b','us-east-1c','us-east-1d' ou 'us-west-1a','us-west-1b','us-west-1c','us-west-1d') | `string`       | `"us-east-1a"`                                 |    no    |
| db_backup_retention_period         | Tempo de retenção de backup do banco de dados em dias                                                                                                           | `number`       | `7`                                            |    no    |
| db_cluster_availability_zones      | Zonas de disponibilidade para o banco de dados (Ex: 'us-east-1a','us-east-1b','us-east-1c','us-east-1d' ou 'us-west-1a','us-west-1b','us-west-1c','us-west-1d') | `list(string)` | `[ "us-east-1a", "us-east-1b", "us-east-1c" ]` |    no    |
| db_cluster_count_instances         | Quantidade de instancias para o cluster                                                                                                                         | `number`       | `1`                                            |    no    |
| db_cluster_preferred_backup_window | Intervalo de tempo para executar o backup caso esteja ativo (ex: '07:00-09:00'AM)                                                                               | `string`       | `"07:00-09:00"`                                |    no    |
| db_database_name                   | Nome do database dentro do banco de dados                                                                                                                       | `string`       | `"my-db"`                                      |    no    |
| db_engine                          | Engine do banco de dados selecionado (Mysql, Postgresql, Oracle ou Sql Server)                                                                                  | `string`       | `"postgres"`                                   |    no    |
| db_engine_version                  | Versão da engine (Ex: mysql -> 8.x - 5.x postgresql -> 16.x e etc)                                                                                              | `string`       | `"16.3"`                                       |    no    |
| db_instance_class                  | Instancia do banco de dados                                                                                                                                     | `string`       | `"db.t4g.medium"`                              |    no    |
| db_multi_az                        | Ativar mais zonas de disponibilidade para o banco de dados                                                                                                      | `bool`         | `false`                                        |    no    |
| db_password                        | Senha do usuario root do banco de dados                                                                                                                         | `string`       | `"}8ky9#V-mS]F~jb]t7'&"`                       |    no    |
| db_resource_type                   | Tipo de recurso a ser criado ('db' -> para bancos Mysql, Postgresql, Oracle ou Sql Server 'db_cluster' para bancos Aurora MySql e Aurora Postgresql)            | `string`       | `"db"`                                         |    no    |
| db_skip_final_snapshot             | Pular a criação do backup final ao destruir o banco de dados                                                                                                    | `bool`         | `true`                                         |    no    |
| db_storage_encrypted               | Ativar a criptografia de storage                                                                                                                                | `bool`         | `true`                                         |    no    |
| db_timeout_create                  | Tempo para executar um create em algum recurso do banco de dados (Ex: 10s para segundos, 10m para minutos e 10h para horas)                                     | `string`       | `"0s"`                                         |    no    |
| db_timeout_delete                  | Tempo para executar um delete em algum recurso do banco de dados (Ex: 10s para segundos, 10m para minutos e 10h para horas)                                     | `string`       | `"0s"`                                         |    no    |
| db_timeout_update                  | Tempo para executar um update em algum recurso do banco de dados (Ex: 10s para segundos, 10m para minutos e 10h para horas)                                     | `string`       | `"0s"`                                         |    no    |
| db_username                        | Nome do usuario root do banco de dados                                                                                                                          | `string`       | `"root"`                                       |    no    |
| pg_family                          | Familia de parametros da engine escolhida no banco de dados                                                                                                     | `string`       | `"postgres16"`                                 |    no    |
| pg_name                            | Nome do grupo de parametros                                                                                                                                     | `string`       | `"my-parameter-group"`                         |    no    |
| project_env                        | Ambiente do seu projeto. Ex: prd,prod,dev,hml,homol                                                                                                             | `string`       | n/a                                            |   yes    |
| project_name                       | Nome do seu projeto                                                                                                                                             | `string`       | n/a                                            |   yes    |
| project_region                     | Região do seu projeto                                                                                                                                           | `string`       | `"us-east-1"`                                  |    no    |

## Outputs

| Name                       | Description                                   |
| -------------------------- | --------------------------------------------- |
| db                         | Dados - Banco de dados(RDS)                   |
| db_allocated_storage       | Espaço em disco alocado para o banco de dados |
| db_availability_zone       | Zonas de disponibilidade do banco de dados    |
| db_backup_retention_period | Tempo de retenção de backup do banco de dados |
| db_cluster                 | Dados - Cluster banco de dados(RDS Cluster)   |
| db_cluster_instance        | n/a                                           |
| db_engine                  | Engine do banco de dados                      |
| db_instance_class          | Tipo da instancia do banco de dados           |
| db_name                    | Nome da instancia do banco de dados           |
| db_parameter_group         | Dados - Grupo de parametros do banco de dados |
| db_skip_final_snapshot     | Pular imagem final do banco de dados          |
| db_subnet_group            | Grupo de subnets do banco de dados            |
| db_username                | Nome do usuario root do banco de dados        |
