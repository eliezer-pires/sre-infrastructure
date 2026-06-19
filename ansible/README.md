# Ansible — Configuração

Configuração idempotente de SOs e serviços após o provisionamento pelo Terraform (fluxo **provision → configure**).

> ⚠️ Exemplos sanitizados. Inventário real e `vault-pass` estão no `.gitignore`.

## Estrutura

```
ansible/
├── ansible.cfg
├── inventory/
│   └── hosts.example.yml      # Inventário de exemplo (copiar para hosts.yml)
├── roles/
│   ├── common-linux/          # Baseline de hardening + pacotes base
│   │   └── tasks/main.yml
│   └── monitoring-agent/      # node_exporter + envio de logs ao Graylog
│       └── tasks/main.yml
└── playbooks/
    └── site.yml               # Playbook principal
```

## Uso

```bash
# Validar sintaxe
ansible-playbook playbooks/site.yml --syntax-check

# Dry-run (check mode)
ansible-playbook -i inventory/hosts.yml playbooks/site.yml --check --diff

# Aplicar
ansible-playbook -i inventory/hosts.yml playbooks/site.yml
```

## Princípios aplicados

- **Idempotência** — reexecutar não altera estado já correto.
- **Roles reutilizáveis** — `common-linux`, `monitoring-agent`, etc.
- **Segredos via Ansible Vault / HashiCorp Vault** — nada em texto plano.
- **Integração com Terraform** — inventário dinâmico do Proxmox alimenta o Ansible.
