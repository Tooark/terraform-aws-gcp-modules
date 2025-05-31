output "vm_info" {
  value = [for vm in aws_instance.vm-instance : {
    id            = vm.id
    region        = vm.availability_zone
    name          = vm.tags["Name"]
    arn           = vm.arn
    instance_type = vm.instance_type
    ami_name      = data.aws_ami.choose_ami.name # Corrigido: Usando o nome da AMI
    private_ip    = vm.private_ip
    public_ip     = vm.public_ip
  }]
}

output "vm_id" {
  value = [for vm in aws_instance.vm-instance : {
    id = vm.id
  }]
}

output "vm_region" {
  value = [for vm in aws_instance.vm-instance : {
    zone = vm.availability_zone
  }]
}

output "vm_name" {
  # value = var.project_tags["Name"]
  value = [for vm in aws_instance.vm-instance : {
    name = vm.tags["Name"]
  }]
}

output "vm_arn" {
  value = [for vm in aws_instance.vm-instance : {
    arn = vm.arn
  }]
}

output "vm_instance_type" {
  value = [for vm in aws_instance.vm-instance : {
    instance_type = vm.instance_type
  }]
}

output "vm_ami_name" {
  value = var.filter_ami_name
}

output "vm_private_ip" {
  value = [for vm in aws_instance.vm-instance : {
    private_ip = vm.private_ip
  }]
}

output "vm_public_ip" {
  value = [for vm in aws_instance.vm-instance : {
    public_ip = vm.public_ip
  }]
}

output "vm_subnet_attached" {
  value = [for vm in aws_instance.vm-instance : {
    subnets_attached = vm.subnet_id
  }]
}
