variable "vm_name" {
  description = "Nome da VM (seguir naming conventions, ex.: prd-fs-01)"
  type        = string
}

variable "vmid" {
  description = "ID numérico da VM no Proxmox"
  type        = number
}

variable "target_node" {
  description = "Node do cluster onde a VM será criada (ex.: node1)"
  type        = string
}

variable "template_name" {
  description = "Nome do template cloud-init base"
  type        = string
  default     = "debian-12-cloudinit"
}

variable "cores" {
  description = "Número de vCPUs"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memória em MB"
  type        = number
  default     = 4096
}

variable "disk_size" {
  description = "Tamanho do disco (ex.: 20G)"
  type        = string
  default     = "20G"
}

variable "storage" {
  description = "Pool de storage Ceph (ex.: pool-vm)"
  type        = string
  default     = "pool-vm"
}

variable "ip_address" {
  description = "Endereço IP em CIDR (ex.: 10.0.10.10/24)"
  type        = string
}

variable "gateway" {
  description = "Gateway da rede"
  type        = string
  default     = "10.0.10.1"
}

variable "vlan_tag" {
  description = "Tag de VLAN da interface de rede"
  type        = number
  default     = null
}

variable "ssh_public_keys" {
  description = "Chaves SSH públicas autorizadas (injetadas via cloud-init)"
  type        = string
  sensitive   = true
}

variable "ha_enabled" {
  description = "Define se a VM entra no grupo de HA"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags de governança"
  type        = map(string)
  default = {
    gerenciado = "terraform"
  }
}
