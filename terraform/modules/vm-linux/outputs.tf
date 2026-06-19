output "vmid" {
  description = "ID da VM criada"
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "name" {
  description = "Nome da VM"
  value       = proxmox_virtual_environment_vm.this.name
}

output "ip_address" {
  description = "IP configurado via cloud-init"
  value       = var.ip_address
}

output "node" {
  description = "Node onde a VM foi provisionada"
  value       = proxmox_virtual_environment_vm.this.node_name
}

output "ha_enabled" {
  description = "Indica se a VM está sob HA"
  value       = var.ha_enabled
}
