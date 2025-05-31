# Módulo Virtual Machine AWS

[IAC](../../README.md) / [vm](../README.md) / **[AWS](./README.md)**

Módulo de infraestrutura como código (IAC) para provisionamento de EC2 na AWS.

## Provider

- [**AWS**](../../aws/README.md)

## Requisitos

- [Terraform](https://www.terraform.io/downloads.html)

- [AWS CLI](https://aws.amazon.com/pt/cli/)

- [AWS Keypair to VM](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html)

## Utilização

```hcl
module "vm_aws" {
  source = "github.com/Grupo-Jacto/iac/vm/aws?ref=v1.0.0"

  aws_account_id = "<ACCOUNT_ID>"
  project_name = "<PROJECT_NAME>"
  project_env = "<PROJECT_ENV>"

  #New network
  create_new_subnet = "<true-or-false>"
  create_new_vpc = "<true-or-false>"

  #Exists network
  vpc_id = "<YOUR-VPC-ID-IF-EXISTS>"
  subnet_id = "<YOUR-SUBNET-ID-IF-EXISTS>"

  #VM
  key_name = "<YOUR-KEYPAIR-NAME>"
}
```

## Resources

| Name                                                                                                                                 | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [aws_default_route_table.rt_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table) | resource    |
| [aws_instance.vm-instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)                     | resource    |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)             | resource    |
| [aws_subnet.vm-subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)                           | resource    |
| [aws_vpc.vpc-main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)                                  | resource    |
| [aws_ami.choose_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)                             | data source |
| [aws_key_pair.keypair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/key_pair)                      | data source |
| [aws_subnet.exist-subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet)                     | data source |
| [aws_vpc.exist-vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc)                              | data source |

## Inputs

| Name                      | Description                                                                                                                               | Type           | Default                                                                                                                                                                                                                                                                                                                                                                                                            | Required |
| ------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :------: |
| architecture_type_ami     | Path for ami installation                                                                                                                 | `list(string)` | `[ "x86_64" ]`                                                                                                                                                                                                                                                                                                                                                                                                     |    no    |
| associate_public_ip       | Associate public ip on Ec2                                                                                                                | `bool`         | `true`                                                                                                                                                                                                                                                                                                                                                                                                             |    no    |
| availability_zones        | Região do seu projeto                                                                                                                     | `string`       | `"us-east-1a"`                                                                                                                                                                                                                                                                                                                                                                                                     |    no    |
| create_new_subnet         | Ativa a criacao de uma subnet nova para a vm                                                                                              | `bool`         | n/a                                                                                                                                                                                                                                                                                                                                                                                                                |   yes    |
| create_new_vpc            | Ativa a criacao de uma vpc nova para a vm                                                                                                 | `bool`         | n/a                                                                                                                                                                                                                                                                                                                                                                                                                |   yes    |
| filter_ami_name           | Qual o tipo de filtro esta sendo feito, no caso padrão: 'name'                                                                            | `string`       | `"architecture"`                                                                                                                                                                                                                                                                                                                                                                                                   |    no    |
| instance_type             | Tipo da instancia para a vm                                                                                                               | `string`       | `"t3a.micro"`                                                                                                                                                                                                                                                                                                                                                                                                      |    no    |
| ip_saida_internet_gateway | IP de saida para o internet gateway                                                                                                       | `string`       | `"0.0.0.0/0"`                                                                                                                                                                                                                                                                                                                                                                                                      |    no    |
| key_name                  | Key name to access your ec2 instance                                                                                                      | `string`       | `"teste"`                                                                                                                                                                                                                                                                                                                                                                                                          |    no    |
| project_env               | Abreviação do ambiente. Valores suportados: `sbx` para sandbox, `dev` para desenvolvimento, `hml` para homologação e `prd` para produção. | `string`       | `"dev"`                                                                                                                                                                                                                                                                                                                                                                                                            |   yes    |
| project_name              | Nome do seu projeto                                                                                                                       | `string`       | `"projeto-validando"`                                                                                                                                                                                                                                                                                                                                                                                              |   yes    |
| project_region            | Região do seu projeto                                                                                                                     | `string`       | `"us-east-1"`                                                                                                                                                                                                                                                                                                                                                                                                      |    no    |
| public_key                | Public key for instance key                                                                                                               | `string`       | `"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"` |    no    |
| subnet_cidr_block         | Range de ip para a subnet seguindo o range de ip da sua vpc                                                                               | `string`       | `"10.0.1.0/24"`                                                                                                                                                                                                                                                                                                                                                                                                    |    no    |
| subnet_id                 | ID of subnet to launch ec2                                                                                                                | `string`       | `""`                                                                                                                                                                                                                                                                                                                                                                                                               |    no    |
| subnet_name               | Nome da subnet                                                                                                                            | `string`       | `"my-subnet"`                                                                                                                                                                                                                                                                                                                                                                                                      |    no    |
| vm_count                  | Quantidade de vms que precisa subir                                                                                                       | `number`       | `1`                                                                                                                                                                                                                                                                                                                                                                                                                |    no    |
| vm_name                   | Nome da vm                                                                                                                                | `string`       | `"my-vm"`                                                                                                                                                                                                                                                                                                                                                                                                          |    no    |
| vpc_cidr_block            | Range de ips para a nova vpc                                                                                                              | `string`       | `"10.0.0.0/16"`                                                                                                                                                                                                                                                                                                                                                                                                    |    no    |
| vpc_id                    | ID da vpc ja criada                                                                                                                       | `string`       | `""`                                                                                                                                                                                                                                                                                                                                                                                                               |    no    |
| vpc_name                  | Nome da vpc                                                                                                                               | `string`       | `"my-vpc"`                                                                                                                                                                                                                                                                                                                                                                                                         |    no    |

## Outputs

| Name               | Description |
| ------------------ | ----------- |
| vm_ami_name        | n/a         |
| vm_arn             | n/a         |
| vm_id              | n/a         |
| vm_info            | n/a         |
| vm_instance_type   | n/a         |
| vm_name            | n/a         |
| vm_private_ip      | n/a         |
| vm_public_ip       | n/a         |
| vm_region          | n/a         |
| vm_subnet_attached | n/a         |

<!-- END_TF_DOCS -->
