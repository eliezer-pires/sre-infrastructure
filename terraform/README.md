# Terraform — Provisionamento

Provisionamento declarativo de VMs no Proxmox VE, com **state remoto** (MinIO/S3) e **locking** (PostgreSQL).

> ⚠️ Exemplos sanitizados. Não contêm credenciais nem endereços reais. Provider de referência: [`bpg/proxmox`](https://registry.terraform.io/providers/bpg/proxmox/latest).

## Estrutura

```
terraform/
├── modules/
│   └── vm-linux/          # Módulo reutilizável de VM Linux (cloud-init)
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── environments/
    └── producao/
        ├── backend.tf     # State no MinIO (S3) + lock
        ├── main.tf        # Uso do módulo
        └── terraform.tfvars.example
```

## Fluxo de trabalho

```bash
cd environments/producao
cp terraform.tfvars.example terraform.tfvars   # preencher valores reais (não versionar)

terraform init      # configura backend MinIO/S3
terraform fmt -check
terraform validate
terraform plan -out tfplan
terraform apply tfplan
```

## Princípios aplicados

- **State remoto e travado** — evita conflitos e perda de state (Fase 3).
- **Segredos via Vault** — nada de credencial em código (`.tfvars` está no `.gitignore`).
- **Módulos reutilizáveis** — `vm-linux` parametriza criação de VMs.
- **Tags de governança** — `gerenciado = "terraform"` distingue recursos sob IaC.
- **CI** — `validate` + `plan` automáticos em cada merge request (ver `.gitlab-ci.yml`).
