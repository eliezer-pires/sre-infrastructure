variable "ansible_ssh_public_key" {
  description = "Chave SSH pública do usuário de automação injetada nas VMs via cloud-init"
  type        = string
  sensitive   = true
}
