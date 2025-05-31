output "vm" {
  value = [for vm in google_compute_instance.vm : {
    name         = vm.name
    id           = vm.id
    machine_type = vm.machine_type
    zone         = vm.zone
    image        = var.vm_image
    hostname     = vm.hostname
    service_user = vm.service_account
  }]
  description = "Dados da vm"
}

output "service_user" {
  value       = google_service_account.service_account_vm.display_name
  description = "Dados do usuario de serviço"
}

output "service_user_vm_id" {
  value       = google_service_account.service_account_vm.account_id
  description = "ID do usuario de serviço pra vm"
}

output "service_user_vm_name" {
  value       = google_service_account.service_account_vm.display_name
  description = "Nome do usuario de serviço para a vm"
}

output "vm_id" {
  value = [for vm in google_compute_instance.vm : {
    id = vm.id
  }]
  description = "ID da vm"
}

output "vm_name" {
  value = [for vm in google_compute_instance.vm : {
    name = vm.name
  }]
  description = "Nome da vm"
}

output "vm_machine_type" {
  value = [for vm in google_compute_instance.vm : {
    machine_type = vm.machine_type
  }]
  description = "Tipo da instancia sendo usada na vm"
}

output "vm_zone" {
  value = [for vm in google_compute_instance.vm : {
    zone = vm.zone
  }]
  description = "Zona da vm"
}

output "vm_image" {
  value       = var.vm_image
  description = "Imagem sendo usada na vm"
}

output "vm_private_ip" {
  value = [for ip in google_compute_instance.vm : {
    private_ip = ip.network_interface
  }]
  description = "Ip privado da vm"
}

#VM Firewall
output "vm_firewall_id" {
  value       = google_compute_firewall.vm_firewall.id
  description = "ID da regra de firewall para a vm"
}

output "vm_firewall_name" {
  value       = google_compute_firewall.vm_firewall.name
  description = "Nome da regra de firewall para a vm"
}

output "vm_firewall_allowed_protocol" {
  value       = var.vm_firewall_allow_protocols
  description = "Protocolos liberados para a regra da vm"
}

output "vm_firewall_allow_ports" {
  value       = var.vm_firewall_allow_ports
  description = "Portas liberadas na regra de firewall para a vm"
}