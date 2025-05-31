# Módulos IAC para recursos na AWS

[IAC](../README.md) / **[AWS](./README.md)**

Módulos de infraestrutura como código (IAC) para provisionamento de recursos na AWS.

## Módulos

### [**S3**](../storage/aws/README.md)

Módulo para provisionamento de S3 buckets na AWS.

- **Requisitos**: [Lista de Requisitos](../storage/aws/README.md#requisitos)
- **Parâmetros**: [Lista de Parâmetros](../storage/aws/README.md#variáveis)
- **Saídas**: [Lista de Saídas](../storage/aws/README.md#outputs)
- **Uso**:

```hcl
  module "storage_aws" {
    source = "github.com/Grupo-Jacto/iac/storage/aws?ref=v1.0.0"
    
    aws_account_id = "<ACCOUNT_ID>"
    project_name = "<PROJECT_NAME>"
    project_env = "<PROJECT_ENV>"
  }
```

### [**RDS**](../db/aws/README.md)

Módulo para provisionamento de RDS na AWS.

- **Requisitos**: [Lista de Requisitos](../db/aws/README.md#requisitos)
- **Parâmetros**: [Lista de Parâmetros](../db/aws/README.md#variáveis)
- **Saídas**: [Lista de Saídas](../db/aws/README.md#outputs)
- **Uso**:

```hcl
  module "db_aws" {
    source = "github.com/Grupo-Jacto/iac/db/aws?ref=v1.0.0"

    aws_account_id = "<ACCOUNT_ID>"
    project_name = "<PROJECT_NAME>"
    project_env = "<PROJECT_ENV>"
  }
```

### [**Load_Balancer**](../lb/aws/README.md)

Módulo para provisionamento de RDS na AWS.

- **Requisitos**: [Lista de Requisitos](../lb/aws/README.md#requisitos)
- **Parâmetros**: [Lista de Parâmetros](../lb/aws/README.md#variáveis)
- **Saídas**: [Lista de Saídas](../lb/aws/README.md#outputs)
- **Uso**:

```hcl
  module "lb_aws" {
    source = "github.com/Grupo-Jacto/iac/lb/aws?ref=v1.0.0"

    aws_account_id = "<ACCOUNT_ID>"
    project_name = "<PROJECT_NAME>"
    project_env = "<PROJECT_ENV>"
    vpc_id = "<VPC_ID>"
  }
```

### [**EC2**](../vm/aws/README.md)

Módulo para provisionamento de RDS na AWS.

- **Requisitos**: [Lista de Requisitos](../vm/aws/README.md#requisitos)
- **Parâmetros**: [Lista de Parâmetros](../vm/aws/README.md#variáveis)
- **Saídas**: [Lista de Saídas](../vm/aws/README.md#outputs)
- **Uso**:

```hcl
  module "vm_aws" {
    source = "github.com/Grupo-Jacto/iac/vm/aws?ref=v1.0.0"

    aws_account_id = "<ACCOUNT_ID>"
    project_name = "<PROJECT_NAME>"
    project_env = "<PROJECT_ENV>"
    subnet_id = "<SUBNET_ID>"
  }
```

## Versões
