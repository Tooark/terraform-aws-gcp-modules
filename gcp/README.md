# Módulos IAC para recursos na GCP

[IAC](../README.md) / **[GCP](./README.md)**

Módulos de infraestrutura como código (IAC) para provisionamento de recursos na AWS.

## Módulos

### [**Cloud Storage**](../storage/gcp/README.md)

Módulo para provisionamento de S3 buckets na AWS.

- **Requisitos**: [Lista de Requisitos](../storage/gcp/README.md#requisitos)
- **Parâmetros**: [Lista de Parâmetros](../storage/gcp/README.md#variáveis)
- **Saídas**: [Lista de Saídas](../storage/gcp/README.md#outputs)
- **Uso**:

```hcl
  module "storage_gcp" {
    source = "github.com/Grupo-Jacto/iac/storage/gcp?ref=v1.0.0"

    project_id = "<PROJECT_ID>"
    name       = "<BUCKET_NAME>"
    location   = "<LOCATION>" # ex: "para região especifica utilizar parâmetro 'region'"
  }
```

### [**Cloud SQL e AlloyDB**](../db/gcp/README.md)

Módulo para provisionamento de RDS na AWS.

- **Requisitos**: [Lista de Requisitos](../db/gcp/README.md#requisitos)
- **Parâmetros**: [Lista de Parâmetros](../db/gcp/README.md#variáveis)
- **Saídas**: [Lista de Saídas](../db/gcp/README.md#outputs)
- **Uso**:

```hcl
  module "db_gcp" {
    source = "github.com/Grupo-Jacto/iac/db/gcp?ref=v1.0.0"

    project_id = "<PROJECT_ID>"
    project_env = "<PROJECT_ENV>"
  }
```

### [**Load_Balancer**](../lb/gcp/README.md)

Módulo para provisionamento de RDS na AWS.

- **Requisitos**: [Lista de Requisitos](../lb/gcp/README.md#requisitos)
- **Parâmetros**: [Lista de Parâmetros](../lb/gcp/README.md#variáveis)
- **Saídas**: [Lista de Saídas](../lb/gcp/README.md#outputs)
- **Uso**:

```hcl
  module "lb_gcp" {
    source = "github.com/Grupo-Jacto/iac/lb/gcp?ref=v1.0.0"

    project_id = "<PROJECT_ID>"
    project_env = "<PROJECT_ENV>"
  }
```

### [**Compute Engine**](../vm/gcp/README.md)

Módulo para provisionamento de RDS na AWS.

- **Requisitos**: [Lista de Requisitos](../vm/gcp/README.md#requisitos)
- **Parâmetros**: [Lista de Parâmetros](../vm/gcp/README.md#variáveis)
- **Saídas**: [Lista de Saídas](../vm/gcp/README.md#outputs)
- **Uso**:

```hcl
  module "vm_gcp" {
    source = "github.com/Grupo-Jacto/iac/vm/gcp?ref=v1.0.0"

    project_id = "<PROJECT_ID>"
    project_env = "<PROJECT_ENV>"
  }
```
