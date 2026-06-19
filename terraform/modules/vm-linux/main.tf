terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.60"
    }
  }
}

# Módulo: cria uma VM Linux clonada de template cloud-init.
# Sanitizado para portfólio — sem credenciais nem endereços reais.

resource "proxmox_virtual_environment_vm" "this" {
  name      = var.vm_name
  vm_id     = var.vmid
  node_name = var.target_node

  tags = [for k, v in var.tags : "${k}-${v}"]

  clone {
    vm_id = data.proxmox_virtual_environment_vms.template.vms[0].vm_id
    full  = true
  }

  cpu {
    cores = var.cores
    type  = "host"
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.storage
    interface    = "scsi0"
    size         = tonumber(replace(var.disk_size, "G", ""))
  }

  network_device {
    bridge  = "vmbr0"
    vlan_id = var.vlan_tag
  }

  # Configuração via cloud-init (IP estático + chave SSH)
  initialization {
    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }

    user_account {
      keys     = [var.ssh_public_keys]
      username = "ansible"
    }
  }

  agent {
    enabled = true
  }

  lifecycle {
    ignore_changes = [
      network_device, # evita drift por reordenação do Proxmox
    ]
  }
}

data "proxmox_virtual_environment_vms" "template" {
  filter {
    name   = "name"
    values = [var.template_name]
  }
}

# Habilita HA para a VM, quando solicitado
resource "proxmox_virtual_environment_haresource" "this" {
  count = var.ha_enabled ? 1 : 0

  resource_id = "vm:${var.vmid}"
  state       = "started"
  group       = "ha-critical"
  comment     = "Gerenciado por Terraform"

  depends_on = [proxmox_virtual_environment_vm.this]
}
