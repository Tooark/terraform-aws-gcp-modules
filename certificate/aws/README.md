# Módulo Certificate AWS

[IAC](../../README.md) / [Certificate](../README.md) / **[AWS](./README.md)**

Módulo de infraestrutura como código (IAC) para provisionamento de Load Balancer na AWS.

## Provider

- [**AWS**](../../aws/README.md)

## Requisitos

- [Terraform](https://www.terraform.io/downloads.html)

- [AWS CLI](https://aws.amazon.com/pt/cli/)

## Utilização

```hcl
module "certificate_aws" {
  source = "github.com/Grupo-Jacto/iac/certificate/aws?ref=v1.0.0"

  aws_account_id = "<ACCOUNT_ID>"
  project_name = "<PROJECT_NAME>"
  dns_name = "<YOUR-DNS-NAME>"
}
```

## Resources

| Name                                                                                                                                                            | Type     |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [aws_acm_certificate.certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate)                                  | resource |
| [aws_acm_certificate_validation.certificate_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_route53_record.route53_record_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record)                      | resource |
| [aws_route53_zone.route53_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone)                                       | resource |

## Inputs

| Name              | Description                                                                                                                               | Type     | Default        | Required |
| ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | -------- | -------------- | :------: |
| dns_name          | DNS Name para o a criação do certificado                                                                                                  | `string` | n/a            |   yes    |
| project_env       | Abreviação do ambiente. Valores suportados: `sbx` para sandbox, `dev` para desenvolvimento, `hml` para homologação e `prd` para produção. | `string` | `"dev"`        |    no    |
| project_name      | Nome do seu projeto                                                                                                                       | `string` | `"my-project"` |    no    |
| project_region    | Região do seu projeto                                                                                                                     | `string` | `"us-east-1"`  |    no    |
| validation_method | Tipo de validação para o dns do certificado                                                                                               | `string` | `"DNS"`        |    no    |

## Outputs

| Name             | Description                |
| ---------------- | -------------------------- |
| ceritifcate_name | Nome do dns no certificado |
| certificate      | Dados do certificado       |
| certificate_arn  | ID do certificado          |

<!-- END_TF_DOCS -->
