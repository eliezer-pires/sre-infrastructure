terraform {
  required_version = ">= 1.6"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.60"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
  }
}

# Provider Vault: segredos de acesso ao Proxmox vêm do Vault (nunca de código)
provider "vault" {
  # endereço e token via env: VAULT_ADDR / VAULT_TOKEN
}

data "vault_kv_secret_v2" "proxmox" {
  mount = "secret"
  name  = "proxmox/api"
}

provider "proxmox" {
  endpoint  = "https://proxmox.intranet.local:8006/"
  api_token = data.vault_kv_secret_v2.proxmox.data["api_token"]
  insecure  = false
}

# ---- Exemplo: provisionar um File Server crítico com HA ----
module "fileserver" {
  source = "../../modules/vm-linux"

  vm_name     = "prd-fs-01"
  vmid        = 110
  target_node = "node1"
  cores       = 8
  memory      = 8192
  disk_size   = "100G"
  storage     = "pool-vm"
  ip_address  = "10.0.10.5/24"
  gateway     = "10.0.10.1"
  ha_enabled  = true

  ssh_public_keys = var.ansible_ssh_public_key

  tags = {
    ambiente    = "prd"
    funcao      = "fileserver"
    criticidade = "alta"
    gerenciado  = "terraform"
  }
}

# ---- Exemplo: VM de monitoramento (média criticidade) ----
module "observ" {
  source = "../../modules/vm-linux"

  vm_name     = "prd-monitor-01"
  vmid        = 118
  target_node = "node3"
  cores       = 8
  memory      = 16384
  disk_size   = "100G"
  ip_address  = "10.0.10.40/24"
  ha_enabled  = true

  ssh_public_keys = var.ansible_ssh_public_key

  tags = {
    ambiente    = "prd"
    funcao      = "observabilidade"
    criticidade = "alta"
    gerenciado  = "terraform"
  }
}
