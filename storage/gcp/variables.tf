# Variáveis obrigatórias para o módulo de Storage Bucket
variable "project_id" {
  type        = string
  description = "ID do projeto"
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9_-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "O project_id deve conter apenas:\n- letras minúsculas\n- número\n- hifén."
  }
}
variable "name" {
  type        = string
  description = "Nome do Storage Bucket."
  validation {
    condition     = !strcontains(var.name, "goog") && !strcontains(var.name, "g00g") && !strcontains(var.name, "gogl") && !strcontains(var.name, "g0gl")
    error_message = "O nome do bucket não pode conter 'goog', 'g00g', 'gogl', 'g0gl'."
  }
  validation {
    condition     = length(regex("^[a-z0-9][a-z0-9_-]{1,61}[a-z0-9]$", var.name)) > 0
    error_message = "O nome do bucket deve:\n- Conter entre 3 e 63 caracteres.\n- Apenas letras minúsculas, número, hifén e underline.\n- Iniciar e terminar com letra ou número."
  }
}
variable "labels" {
  type = object({
    owner      = string
    technician = string
  })
  description = "Labels adicionais para o recurso. Parametros `owner` e `technician` são obrigatórios."
  validation {
    condition     = can(regex("^[a-z][a-z0-9_-]{0,62}$", var.labels.owner))
    error_message = "O label owner deve:\n- Conter entre 2 e 63 caracteres.\n- Iniciar com letras minúsculas.\n- Apenas letras minúsculas, número, hifén e underline."
  }
  validation {
    condition     = can(regex("^[a-z][a-z0-9_-]{0,62}$", var.labels.technician))
    error_message = "O label technician deve:\n- Conter entre 2 e 63 caracteres.\n- Iniciar com letras minúsculas.\n- Apenas letras minúsculas, número, hifén e underline."
  }
}

# Variáveis opcionais para o módulo de Storage Bucket, já possuem valores padrões
variable "project_env" {
  type        = string
  description = "Abreviação do ambiente. Valores suportados: `sbx` para sandbox, `dev` para desenvolvimento, `hml` para homologação e `prd` para produção."
  default     = null

  validation {
    condition     = var.project_env == null || can(regex("^(sbx|dev|hml|prd)$", var.project_env))
    error_message = "O project_env deve ser nulo ou um dos seguintes valores: 'sbx', 'dev', 'hml' ou 'prd'."
  }
}
variable "location" {
  type        = string
  description = "Localização macro (multi-region) que o serviço vai estar hospedado. Valores suportados: `ASIA` para regiões na Ásia, `EU` para regiões na UE ou `US` para regiões nos EUA. [Multirregião](https://cloud.google.com/storage/docs/locations?hl=pt-br#location-mr)."
  default     = null

  validation {
    condition     = var.location == null || can(regex("^(ASIA|EU|US)$", var.location))
    error_message = "O location deve ser nulo ou um dos seguintes valores: 'ASIA', 'EU' ou 'US'."
  }
}
variable "region" {
  type        = string
  description = "Região especifica que o serviço vai estar hospedado. [Regiões](https://cloud.google.com/storage/docs/locations?hl=pt-br#available-locations)."
  default     = null

  validation {
    condition     = var.region == null || !startswith(var.region != null ? var.region : "", "africa") || can(regex("^africa-(south[1]))$", var.region))
    error_message = "O region para África tem suporte para: 'africa-south1'."
  }

  validation {
    condition     = var.region == null || !startswith(var.region != null ? var.region : "", "asia") || can(regex("^asia-(east[12]|northeast[1-3]|south[12]|southeast[12])$", var.region))
    error_message = "O region para Ásia, Índia ou Indonésia tem suporte para: 'asia-east1', 'asia-east2', 'asia-northeast1', 'asia-northeast2', 'asia-northeast3', 'asia-south1', 'asia-south2', 'asia-southeast1' ou 'asia-southeast2'."
  }

  validation {
    condition     = var.region == null || !startswith(var.region != null ? var.region : "", "australia") || can(regex("^australia-(southeast[1-2])$", var.region))
    error_message = "O region para Austrália tem suporte para: 'australia-southeast1' ou 'australia-southeast2'."
  }

  validation {
    condition     = var.region == null || !startswith(var.region != null ? var.region : "", "europe") || can(regex("^europe-(central[2]|north[1]|southwest[1]|west[1-4]|west[6]|west[8-9]|west[10]|west[12])$", var.region))
    error_message = "O region para Europa tem suporte para: 'europe-central2', 'europe-north1', 'europe-southwest1', 'europe-west1', 'europe-west2', 'europe-west3', 'europe-west4', 'europe-west6', 'europe-west8', 'europe-west9', 'europe-west10' ou 'europe-west12'."
  }

  validation {
    condition     = var.region == null || !startswith(var.region != null ? var.region : "", "me") || can(regex("^me-(central[1-2]|west[1])$", var.region))
    error_message = "O region para Oriente Médio tem suporte para: 'me-central1', 'me-central2' ou 'me-west1'."
  }

  validation {
    condition     = var.region == null || !startswith(var.region != null ? var.region : "", "northamerica") || can(regex("^northamerica-(northeast[1-2])$", var.region))
    error_message = "O region para América do Norte tem suporte para: 'northamerica-northeast1' ou 'northamerica-northeast2'."
  }

  validation {
    condition     = var.region == null || !startswith(var.region != null ? var.region : "", "southamerica") || can(regex("^southamerica-(east[1]|west[1])$", var.region))
    error_message = "O region para América do Sul tem suporte para: 'southamerica-east1' ou 'southamerica-west1'."
  }

  validation {
    condition     = var.region == null || !startswith(var.region != null ? var.region : "", "us") || can(regex("^us-(central[1]|east[1]|east[4-5]|south[1]|west[1-4])$", var.region))
    error_message = "O region para América do Norte tem suporte para: 'us-central1', 'us-east1', 'us-east4', 'us-east5', 'us-south1', 'us-west1', 'us-west2', 'us-west3' ou 'us-west4'."
  }

  validation {
    condition     = var.region == null || can(regex("^(africa|asia|australia|europe|me|northamerica|southamerica|us)", var.region))
    error_message = "O region tem que estar entre as regiões: 'africa', 'asia', 'australia', 'europe', 'me', 'northamerica', 'southamerica' ou 'us'."
  }
}
variable "class" {
  type        = string
  description = "Tipo de storage que será aplicado ao bucket. Valores suportados: `STANDARD`, `NEARLINE`, `COLDLINE` ou `ARCHIVE`."
  default     = "STANDARD"

  validation {
    condition     = can(regex("^(STANDARD|NEARLINE|COLDLINE|ARCHIVE)$", var.class))
    error_message = "O class deve ser um dos seguintes valores: 'STANDARD', 'NEARLINE', 'COLDLINE' ou 'ARCHIVE'."
  }
}
variable "autoclass" {
  type        = bool
  description = "Ativa ou desativa a classe de armazenamento automática."
  default     = false
  validation {
    condition     = contains([true, false], var.autoclass)
    error_message = "A autoclass precisa ser ativada com 'true' ou 'false'"
  }
}
variable "autoclass_terminal" {
  type        = string
  description = "Classe de armazenamento final para a classe de armazenamento automática."
  default     = "NEARLINE"

  validation {
    condition     = can(regex("^(NEARLINE|ARCHIVE)$", var.autoclass_terminal))
    error_message = "O autoclass_terminal deve ser nulo ou um dos seguintes valores: 'NEARLINE' ou 'ARCHIVE'."
  }
}
variable "public_prevention" {
  type        = string
  description = "Ativa ou desativa a prevenção de acesso público."
  default     = "inherited"
  validation {
    condition     = contains(["inherited", "enforced"], var.public_prevention)
    error_message = "O valor para ativar ou não a prevenção de acesso publico é 'inherited'(para acesso interno) ou 'enforced'(para acesso publico)"
  }
}
variable "uniform_access" {
  type        = bool
  description = "Ativa ou desativa o acesso uniforme ao bucket."
  default     = true
  validation {
    condition     = contains([true, false], var.uniform_access)
    error_message = "O valor para ativar ou não o acesso uniforme ao bucket é 'true' ou 'false'"
  }
}
variable "force_destroy" {
  type        = bool
  description = "Força exclusão do bucket mesmo contendo arquivos."
  default     = true
  validation {
    condition     = contains([true, false], var.force_destroy)
    error_message = "O valor para ativar ou não forçar destruir é 'true' ou 'false'"
  }
}
variable "cors_age" {
  type        = number
  description = "Tempo em segundos que cache de segurança fica no navegador."
  default     = 3600

  validation {
    condition     = var.cors_age > 0 && var.cors_age <= 86400
    error_message = "A validade do CORS deve ser estar entre 1 e 86400 segundos (24 horas)."
  }
}
variable "cors_origin" {
  type        = list(string)
  description = "Lista de origens que o cors aceita."
  default     = ["*"]
  validation {
    condition = alltrue([for origin in var.cors_origin :
    contains(["GET", "HEAD", "PUT", "POST", "DELETE", "*"], origin)])
    error_message = "O valor precisa ser um dos seguintes:\n'GET', 'HEAD', 'PUT', 'POST', 'DELETE', '*'"
  }
}
variable "cors_method" {
  type        = list(string)
  description = "Lista de métodos que o cors do bucket aceita."
  default     = ["GET"]
  validation {
    condition = length(var.cors_method) >= 1 || alltrue([for method in var.cors_method :
    contains(["GET", "HEAD", "PUT", "POST", "DELETE", "*"], method)])
    error_message = "O valor precisa ser entre:\n'GET', 'HEAD', 'PUT', 'POST', 'DELETE'"
  }
}
variable "cors_header" {
  type        = list(string)
  description = "Lista de cabeçalhos que o cors do bucket aceita."
  default     = ["Access-Control-Allow-Origin"]
  validation {
    condition = alltrue([for header in var.cors_header :
      contains([
        "Access-Control-Allow-Origin",
        "Accept-Charset",
        "Accept-Encoding",
        "Access-Control-Request-Headers",
        "Access-Control-Request-Method",
        "Connection",
        "Content-Length",
        "Cookie",
        "Cookie2",
        "Date",
        "DNT",
        "Expect",
        "Host",
        "Keep-Alive",
        "Origin",
        "Referer",
        "Set-Cookie",
        "TE",
        "Trailer",
        "Transfer-Encoding",
        "Upgrade",
        "Via",
        "*"
    ], header)])
    error_message = "Os valores precisam ser entre:\n'Accept-Charset'\n'Accept-Encoding'\n'Access-Control-Request-Headers'\n'Access-Control-Request-Method'\n'Connection'\n'Content-Length'\n'Cookie'\n'Cookie2'\n'Date'\n'DNT'\n'Expect'\n'Host'\n'Keep-Alive'\n'Origin'\n'Referer'\n'Set-Cookie'\n'TE'\n'Trailer'\n'Transfer-Encoding'\n'Upgrade'\n'Via'\n'*'"
  }
}
variable "website" {
  type        = bool
  description = "Ativa ou desativa o website do bucket."
  default     = false
  validation {
    condition     = contains([true, false], var.website)
    error_message = "O valor para ativar ou não website é 'true' ou 'false'"
  }
}
variable "website_main" {
  type        = string
  description = "Arquivo que será utilizado como página principal do bucket, (index.html por padrão)."
  default     = "index.html"
  validation {
    condition     = can(regex("([a-z0-9]{1,15}\\.(html|htm|php|asp|jsp|cgi|shtml))", var.website_main))
    error_message = "O arquivo para o website deve conter o seguinte padrão: <nome>.<extensao> onde extensao pode ser: html, htm, php, asp, jsp, cgi ou shtml"
  }
}
variable "website_error" {
  type        = string
  description = "Arquivo que será utilizado como página não encontrado do bucket, (404.html por padrão)."
  default     = "404.html"
  validation {
    condition     = can(regex("([a-z0-9]{1,15}\\.(html|htm|php|asp|jsp|cgi|shtml))", var.website_error))
    error_message = "O arquivo para o website deve conter o seguinte padrão: <nome>.<extensao> onde extensao pode ser: html, htm, php, asp, jsp, cgi ou shtml"
  }
}

# Variáveis referentes ao IAM de acesso public para Storage Bucket
variable "iam_public" {
  type        = bool
  description = "Ativa ou desativa a permissão de visualização publica dos objetos do bucket"
  default     = true
  validation {
    condition     = contains([true, false], var.iam_public)
    error_message = "O valor para o IAM ser publico precisa ser entre 'true' e 'false'"
  }
}
variable "iam_member_viewer" {
  type        = list(string)
  description = "Lista de members para dar acesso de ver objetos do bucket. Valores tem que iniciar com: `user:`, `serviceAccount:`, `group:` ou `domain:`."
  default     = []

  validation {
    condition     = length(var.iam_member_viewer) == 0 || alltrue([for member in var.iam_member_viewer : can(regex("^(user:|serviceAccount:|group:|domain:)", member))])
    error_message = "Os valores em iam_member_viewer tem que iniciar com o tipo de membro: 'user:', 'serviceAccount:', 'group:' ou 'domain:'."
  }
}
variable "iam_member_creator" {
  type        = list(string)
  description = "Lista de members para dar acesso de criar objetos do bucket. Valores tem que iniciar com: `user:`, `serviceAccount:`, `group:` ou `domain:`."
  default     = []

  validation {
    condition     = length(var.iam_member_creator) == 0 || alltrue([for member in var.iam_member_creator : can(regex("^(user:|serviceAccount:|group:|domain:)", member))])
    error_message = "Os valores em iam_member_creator tem que iniciar com o tipo de membro: 'user:', 'serviceAccount:', 'group:' ou 'domain:'."
  }
}
variable "iam_member_admin" {
  type        = list(string)
  description = "Lista de members para dar acesso de administrar objetos do bucket. Valores tem que iniciar com: `user:`, `serviceAccount:`, `group:` ou `domain:`."
  default     = []

  validation {
    condition     = length(var.iam_member_admin) == 0 || alltrue([for member in var.iam_member_admin : can(regex("^(user:|serviceAccount:|group:|domain:)", member))])
    error_message = "Os valores em iam_member_admin tem que iniciar com o tipo de membro: 'user:', 'serviceAccount:', 'group:' ou 'domain:'."
  }
}

# Variáveis referentes ao IAM de acesso admin para Storage Bucket
variable "storage_account_create" {
  type        = bool
  description = "Ativa ou desativa a criação de uma conta de serviço para o bucket"
  default     = true
  validation {
    condition     = contains([true, false], var.storage_account_create)
    error_message = "O valor para a criação de conta precisa ser entre 'true' e 'false'"
  }
}
variable "storage_account_condition" {
  type        = bool
  description = "Ativa ou desativa a condição de acesso ao bucket"
  default     = false
  validation {
    condition     = contains([true, false], var.storage_account_condition)
    error_message = "O valor para a ativação de condição de acesso no bucket precisa ser entre 'true' e 'false'"
  }
}
variable "storage_account_member" {
  type        = string
  description = "Membro para dar acesso ao bucket"
  default     = null
}
variable "storage_account_iam_role" {
  type        = string
  description = "Permissão de Administrador de Objeto do Storage"
  default     = "roles/storage.objectAdmin"
}

# Variáveis referentes as configurações key do Storage Bucket
variable "storage_account_key_private_type" {
  type        = string
  description = "Tipo de chave privada a ser criada"
  default     = "TYPE_GOOGLE_CREDENTIALS_FILE"
}
variable "storage_account_key_public_type" {
  type        = string
  description = "Tipo de chave publica a ser criada"
  default     = "TYPE_X509_PEM_FILE"
}
