variable "project_name" {
  type        = string
  description = "Nome do seu projeto"
  default     = "projeto-validando"
}
locals {
  env = ["dev", "desenvolvimento", "development", "prd", "prod", "production", "producao", "hml", "homol", "homologacao", "sbx"]
}
variable "project_env" {
  type        = string
  default     = "dev"
  description = "Abreviação do ambiente. Valores suportados: `sbx` para sandbox, `dev` para desenvolvimento, `hml` para homologação e `prd` para produção."
  validation {
    condition     = can(regex("^(dev|desenvolvimento|development|prd|prod|production|producao|hml|homol|homologacao|sbx)$", var.project_env))
    error_message = "O project_env deve ser um dos seguintes valores: 'sbx', 'dev', 'hml' ou 'prd'."
  }
}

variable "project_region" {
  type        = string
  description = "Região do seu projeto"
  default     = "us-east-1"
  validation {
    condition     = can(regex("^(us-east-[1-2]|us-west-[1-2]|eu-west-[1-2]|ap-southeast-[1-2])$", var.project_region))
    error_message = "Região inválida. Regioes aceitas: 'us-east-[1-2]', 'us-west-[1-2], 'eu-west-[1-2]','ap-southeast-[1-2]'"
  }
}
variable "filter_ami_name" {
  type        = string
  description = "Qual o tipo de filtro esta sendo feito, no caso padrão: 'name'"
  default     = "architecture"
}
variable "architecture_type_ami" {
  type        = list(string)
  description = "Path for ami installation"
  default     = ["x86_64"]
}
variable "vm_name" {
  type        = string
  description = "Nome da vm"
  default     = "my-vm"
  validation {
    condition     = var.vm_name == null || length(var.vm_name) > 0
    error_message = "O tamanho do nome é invalido"
  }
}
variable "instance_type" {
  type        = string
  description = "Tipo da instancia para a vm"
  default     = "t3a.micro" # Minimal type
  validation {
    condition     = var.instance_type == null || length(var.instance_type) > 5 && length(var.instance_type) <= 10
    error_message = "Consulte os tipos de instancia disponiveis em: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html"
  }
}
variable "associate_public_ip" {
  type        = bool
  description = "Associate public ip on Ec2"
  default     = true
  validation {
    condition     = var.associate_public_ip == null || contains([true, false], var.associate_public_ip)
    error_message = "O valor deste parametro precisar ser true ou false"
  }
}
variable "availability_zones_1" {
  type        = string
  description = "Região do seu projeto"
  default     = "us-east-1a"
  validation {
    condition     = var.availability_zones_1 == null || length(var.availability_zones_1) > 5 || can(regex(!startswith("^(?i)(us|eu|ap)$", var.availability_zones_1)))
    error_message = "Região inválida. Regioes aceitas: 'us-east-[1-2]', 'us-west-[1-2], 'eu-west-[1-2]','ap-southeast-[1-2]'"
  }
}
variable "availability_zones_2" {
  type        = string
  description = "Região do seu projeto"
  default     = "us-east-1b"
  validation {
    condition     = var.availability_zones_2 == null || length(var.availability_zones_2) > 5 || can(regex(!startswith("^(?i)(us|eu|ap)$", var.availability_zones_2)))
    error_message = "Região inválida. Regioes aceitas: 'us-east-[1-2]', 'us-west-[1-2], 'eu-west-[1-2]','ap-southeast-[1-2]'"
  }
}
variable "create_new_vpc" {
  type        = bool
  description = "Ativa a criacao de uma vpc nova para a vm"
  validation {
    condition     = contains([true, false], var.create_new_vpc)
    error_message = "O valor precisa ser 'true' para criar a vpc e 'false' caso nao deseje criar"
  }
}
variable "create_new_subnet" {
  type        = bool
  description = "Ativa a criacao de uma subnet nova para a vm"
  validation {
    condition     = contains([true, false], var.create_new_subnet)
    error_message = "O valor precisa ser 'true' para criar a subnet e 'false' caso nao deseje criar"
  }
}
variable "vpc_name" {
  type        = string
  default     = "my-vpc"
  description = "Nome da vpc"
  validation {
    condition     = length(lower(var.vpc_name)) > 0 && length(lower(var.vpc_name)) <= 25
    error_message = "O nome para a vpc precisa conter entre 1 e 25 caracteres minusculos"
  }
}
locals {
  vpc_id_obrigatorio = !var.create_new_vpc && var.vpc_id == ""
}
variable "vpc_id" {
  type        = string
  default     = ""
  description = "ID da vpc ja criada"
}
variable "subnet_name" {
  type        = string
  default     = "my-subnet"
  description = "Nome da subnet"
  validation {
    condition     = length(lower(var.subnet_name)) > 0 && length(lower(var.subnet_name)) <= 25
    error_message = "O nome para a subnet precisa conter entre 1 e 25 caracteres minusculos"
  }
}
variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Range de ips para a nova vpc"
  validation {
    condition     = can(regex("([0-9]{0,2}.[0-9]{0,2}.[0-9]{0,2}.[0-9]{0,2}/[0-32])", var.vpc_cidr_block))
    error_message = "O range para a vpc nao esta correto. Verifique se o range esta:\n- Disponivel em sua rede privada, nao tendo overlapping\n- O range segue o padrao de ranges privados como: 10.0.0.0/16 ou 172.16.0.0/16 ou 192.168.0.0/16"
  }
}

variable "exists_subnet_cidr_block" {
  type        = string
  default     = ""
  description = "Range de ip para a subnet existente seguindo o range de ip da sua vpc"
}
variable "subnet_id" {
  type        = string
  description = "ID of subnet to launch ec2"
  default     = ""
  validation {
    condition     = length(var.subnet_id) > 20 || length(var.subnet_id) <= 30
    error_message = "Id da subnet invalido"
  }
}
variable "ip_saida_internet_gateway" {
  type        = string
  default     = "0.0.0.0/0"
  description = "IP de saida para o internet gateway"
}

#VM
variable "vm_count" {
  type        = number
  description = "Quantidade de vms que precisa subir"
  default     = 1
  validation {
    condition     = var.vm_count > 0
    error_message = "A quantidade de vms precisa ser maior que 0"
  }
}

variable "public_key" {
  type        = string
  description = "Public key for instance key"
  #Example to use:
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
  validation {
    condition     = var.public_key == null || length(var.public_key) > 10
    error_message = "A chave publica é invalida"
  }
}
