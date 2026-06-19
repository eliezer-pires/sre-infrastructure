# 07 — Naming Conventions

Convenções de nomenclatura padronizam recursos, facilitam automação (IaC) e tornam a operação previsível. **Exemplos sanitizados.**

## Princípios

- Tudo em **minúsculas**, separado por **hífen** (`kebab-case`).
- Nomes **descritivos** e **determinísticos** (geráveis por código).
- Sem caracteres especiais, acentos ou espaços.

## VMs e Containers

Padrão: `<ambiente>-<função>-<sequência>`

| Elemento | Valores | Exemplo |
|---|---|---|
| ambiente | `prd` (produção), `hml` (homologação), `lab` | `prd` |
| função | `dc`, `fs`, `web`, `db`, `gitlab`, `monitor`, `vault`, `proxy` | `dc` |
| sequência | `01`, `02`, ... | `01` |

Exemplos: `prd-dc-01`, `prd-fs-01`, `hml-web-02`, `prd-gitlab-01`.

## Hosts Físicos (Nodes)

Padrão: `node<N>` → `node1`, `node2`, `node3`.

## Redes / VLANs

Padrão: `vlan-<função>` e sub-redes documentadas (valores fictícios).

| VLAN | Função | Sub-rede (exemplo) |
|---|---|---|
| vlan-mgmt | Gerência | 10.0.0.0/24 |
| vlan-srv | Servidores | 10.0.10.0/24 |
| vlan-cluster | Tráfego Ceph/Corosync | 10.0.20.0/24 |
| vlan-bkp | Backup (PBS) | 10.0.30.0/24 |

## Recursos de Storage / Ceph

- Pools Ceph: `pool-<uso>` → `pool-vm`, `pool-ct`.
- Datastores PBS: `ds-<uso>` → `ds-daily`, `ds-weekly`.

## Repositórios e Módulos IaC

- Repositórios: `iac-terraform`, `iac-ansible`.
- Módulos Terraform: `vm-linux`, `vm-windows`, `network`.
- Roles Ansible: `common-linux`, `common-windows`, `docker`, `monitoring-agent`.

## Tags (Terraform / Proxmox)

Todo recurso provisionado recebe tags mínimas:

```hcl
tags = {
  ambiente    = "prd"
  funcao      = "fileserver"
  criticidade = "alta"
  gerenciado  = "terraform"
}
```

A tag `gerenciado = "terraform"` permite distinguir recursos sob IaC de recursos legados durante a migração.
