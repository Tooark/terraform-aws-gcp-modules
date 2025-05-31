# Variaveis obrigatorias
variable "project_id" {
  type        = string
  default     = "ditie-cloud-laboratorio"
  description = "ID do projeto"
  validation {
    condition     = length(var.project_id) > 1
    error_message = "O project_id deve conter apenas:\n- letras minúsculas\n- número\n- hifén."
  }
}

variable "project_env" {
  type        = string
  default     = "dev"
  description = "Abreviação do ambiente. Valores suportados: `sbx` para sandbox, `dev` para desenvolvimento, `hml` para homologação e `prd` para produção."

  validation {
    condition     = var.project_env == null || can(regex("^(sbx|dev|hml|prd)$", var.project_env))
    error_message = "O project_env deve ser nulo ou um dos seguintes valores: 'sbx', 'dev', 'hml' ou 'prd'."
  }
}
# Service User
variable "use_service_user" {
  type        = bool
  description = "Ativa ou não a criação do usuario de serviço"
  default     = true
  validation {
    condition     = var.use_service_user == null ? contains(true, false, var.use_service_user) : true
    error_message = "O valor precisa ser 'true' ou 'false'"
  }
}
variable "service_user_name" {
  type        = string
  description = "Nome do usuario de serviço"
  default     = "my-su-compute-engine"
  validation {
    condition     = var.service_user_name == null || can(regex("^[a-z0-9][a-z0-9_-]{3,25}[a-z0-9]$", var.service_user_name))
    error_message = "O nome o usuario de serviço precisa ter apenas: \n- letras minúsculas\n- número\n- hifén."
  }
}

#Network
variable "create_vpc" {
  type        = bool
  default     = true
  description = "Ativa a criacao de uma nova vpc"
  validation {
    condition     = contains([true, false], var.create_vpc)
    error_message = "O valor precisa ser 'true' ou 'false'"
  }
}

variable "create_subnet" {
  type        = bool
  default     = true
  description = "Ativa a criacao de uma nova vpc"
  validation {
    condition     = contains([true, false], var.create_subnet)
    error_message = "O valor precisa ser 'true' ou 'false'"
  }
}

variable "exists_vpc" {
  type        = string
  default     = ""
  description = "Nome da vpc ja existente"
}

variable "exists_subnet" {
  type        = string
  default     = ""
  description = "Nome da subnet ja existente"
}

#VM
variable "vm_count" {
  type        = number
  default     = 1
  description = "Numero de instancias que deseja subir"
  validation {
    condition     = var.vm_count == null || var.vm_count > 0
    error_message = "A quantidade de vm's precisa ser maior que 0"
  }
}
variable "vm_name" {
  type        = string
  description = "Nome da vm: \n- letras minúsculas\n- número\n- hifén."
  default     = "my-vm"
  validation {
    condition     = var.vm_name == null || length(var.vm_name) > 0 || length(var.vm_name) <= 30
    error_message = "O nome da vm esta incorreto"
  }
}
variable "vm_machine_type" {
  type        = string
  description = "Tipo da instancia da vm, verifique todas as disponiveis em: https://cloud.google.com/compute/docs/machine-resource"
  default     = "e2-micro"
  validation {
    condition     = var.vm_machine_type == null || length(var.vm_machine_type) > 6 || can(regex("^[a-z0-9][a-z0-9_-]$"))
    error_message = "O tipo de instancia é invalido, consulte todos os tipos validos em: https://cloud.google.com/compute/docs/machine-resource"
  }
}
variable "vm_zone" {
  type        = string
  description = "Zona de disponibilidade da vm, consulte todas as zonas disponiveis em: https://cloud.google.com/compute/docs/regions-zones"
  default     = "us-central1-a"
  validation {
    condition     = var.vm_zone == null || !startswith("us|asia|africa|australia|europe|me|northamerica|southamerica|", var.vm_zone) || can(regex("^[a-z0-9]{4,30}"))
    error_message = "Zone invalida"
  }
}
variable "vm_image" {
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2004-lts"
  description = "Imagem a ser utilizada na vm com o formato aceito em 'https://cloud.google.com/compute/docs/images#gcloud'"
  validation {
    condition     = var.vm_image == null || length(var.vm_image) >= 10
    error_message = "O endereço da imagem está errada, verifique as imagens mais atuais disponiveis: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance"
  }
}
variable "vm_disk_interface" {
  type        = string
  default     = "NVME"
  description = "Tipo do disco ssd utilizado, por padrao o NVME é o mais rapido e barato"
  validation {
    condition     = var.vm_disk_interface == null || length(var.vm_disk_interface) > 0
    error_message = "Tipo de interface de disco incorreta"
  }
}
variable "vm_network_interface" {
  type        = string
  default     = "default"
  description = "Configurações da interface de rede da vm"
  validation {
    condition     = var.vm_network_interface == null || length(var.vm_network_interface) > 0
    error_message = "Interface de rede invalida"
  }
}
variable "vm_service_account_scopes" {
  type        = list(string)
  default     = ["cloud-platform"]
  description = "Permissao do usuario de serviço a apis da Google cloud. 'cloud-platform' por padrão com acesso a ALL Api's. Veja as opções em:\n https://cloud.google.com/sdk/gcloud/reference/alpha/compute/instances/set-scopes#--scopes"
  validation {
    condition     = var.vm_service_account_scopes == null || length(var.vm_service_account_scopes) > 0 || length(var.vm_service_account_scopes) <= 15
    error_message = "Nome das Api's com o padrão errado, deve conter:\n- letras minúsculas\n- hifén. Veja as opções disponiveis em:\n https://cloud.google.com/sdk/gcloud/reference/alpha/compute/instances/set-scopes#--scopes"
  }
}

#VM Firewall
variable "source_ranges" {
  type        = list(string)
  description = "Ranges liberados para ingress na regra de firewall"
  default     = ["0.0.0.0/0"]
  # validation {
  #   condition = var.source_ranges == null || can(regex("^(0-9).(0-9).(0-9).(0-9)./(0-9)"))
  #   error_message = "O range de ips precisar seguir o padrão: 10.0.0.0/24"
  # }
}
variable "vm_firewall_allow_protocols" {
  type        = string
  description = "Protocolos para liberação na regra de firewall, algumas opções de exemplo: ssh, tcp, udp, icmp, esp, ah, sctp, ipip, all"
  default     = "all"
  validation {
    condition     = var.vm_firewall_allow_protocols == null || can(regex("^[a-z]$")) || length(var.vm_firewall_allow_protocols) > 0
    error_message = "Protocolo precisa conter no usar caracteres minusculas"
  }
}
variable "vm_firewall_allow_ports" {
  type        = list(number)
  description = "Portas para liberação na regra de firewall, usar nos seguintes formatos: [22], [80, 443], and ['12345-12349']"
  default     = [80, 8080]
  validation {
    condition     = var.vm_firewall_allow_ports == null || length(var.vm_firewall_allow_ports) > 0
    error_message = "A porta precisa ser um numero, por padrão é liberado 80 e 8080"
  }

  # validation {
  #   condition = [var.vm_firewall_allow_ports > 0] || [var.vm_firewall_allow_ports <= 65.536]
  #   error_message = "O valor da porta precisa ser entre 0 e 65.536"
  # }
}
