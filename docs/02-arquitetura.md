# 02 — Arquitetura

> ⚠️ Todos os endereços IP, hostnames e identificadores abaixo são **fictícios** (sanitizados). A sub-rede usada nos exemplos é `10.0.10.0/24`.

## Arquitetura Atual (estado inicial)

Antes do projeto, o ambiente consistia em um cluster de virtualização com backups internos ao SO e gestão majoritariamente manual.

```mermaid
flowchart TB
    subgraph Cluster["Cluster Proxmox VE (2 nós)"]
        N1[Node 1]
        N2[Node 2]
    end
    subgraph Storage["Storage SAN"]
        ST1[(Storage A)]
        ST2[(Storage B)]
    end
    N1 --> ST1
    N2 --> ST2
    N1 -. backup interno ao SO .-> ST1
    N2 -. backup interno ao SO .-> ST2
```

**Limitações:**

- Sem HA — falha de um nó exige migração manual.
- Backup apenas de dados; sem reprovisionamento automatizado.
- Sem state versionado, sem gestão central de segredos, sem observabilidade unificada.

## Arquitetura Alvo (estado desejado)

```mermaid
flowchart TB
    subgraph GitOps["GitOps"]
        GIT[Git / GitLab CI]
    end

    subgraph IaC["IaC"]
        TF[Terraform]
        ANS[Ansible]
        VAULT[HashiCorp Vault]
    end

    subgraph Cluster["Cluster Proxmox VE — 3 Nós (HA)"]
        N1[Node 1]
        N2[Node 2]
        N3[Node 3]
        CEPH[(Ceph — Storage Distribuído)]
        N1 & N2 & N3 --- CEPH
    end

    subgraph DR["Backup & DR"]
        PBS[Proxmox Backup Server]
        MINIO[(MinIO — S3 / TF State)]
        PG[(PostgreSQL — State Lock)]
    end

    subgraph Obs["Observabilidade"]
        PROM[Prometheus]
        GRAF[Grafana]
        GRAY[Graylog]
        ZBX[Zabbix]
    end

    GIT --> TF & ANS
    TF --> Cluster
    ANS --> Cluster
    TF -. state .-> MINIO
    TF -. lock .-> PG
    TF & ANS -. segredos .-> VAULT
    Cluster --> PBS
    Cluster --> Obs
    Obs --> AL[Alertas / Email]
```

### Componentes-chave

| Componente | Função | Garante |
|---|---|---|
| **Proxmox VE (3 nós)** | Virtualização + cluster | Quórum e HA |
| **Ceph** | Storage distribuído replicado | Disponibilidade do dado entre nós |
| **Proxmox HA** | Failover automático de VMs | MTTR baixo em falha de nó |
| **Proxmox Backup Server** | Backup deduplicado e verificado | Restore garantido |
| **Terraform** | Provisionamento declarativo | Infra reproduzível |
| **Ansible** | Configuração idempotente | Consistência de SO/serviços |
| **Vault** | Segredos centralizados | Redução de risco |
| **MinIO + PostgreSQL** | State remoto + locking | State seguro e travado |
| **Prometheus/Grafana/Graylog/Zabbix** | Observabilidade | Detecção rápida |

## Inventário (exemplo sanitizado)

Tabela ilustrativa de como o inventário é documentado na Fase 0. **Valores fictícios.**

| VMID | Nome | Node | vCPU | RAM | Disco | IP | Função | Criticidade | HA |
|---|---|---|---|---|---|---|---|---|---|
| 101 | svc-monitor-ct | node1 | 2 | 4 GiB | 20 GB | 10.0.10.31 | Monitoramento | Baixa | CT |
| 102 | svc-ipam | node1 | 4 | 4 GiB | 20 GB | 10.0.10.22 | Doc. de Redes | Média | CT |
| 110 | svc-fileserver | node1 | 8 | 8 GiB | 100 GB | 10.0.10.5 | File Server | **Alta** | ✔ |
| 112 | svc-dc01 | node1 | 8 | 16 GiB | 64 GB | 10.0.10.1 | AD / DNS / DHCP | **Alta** | ✔ |
| 114 | svc-gitlab | node2 | 8 | 32 GiB | 100 GB | 10.0.10.43 | CI / Registry | **Alta** | ✔ |
| 116 | svc-iac | node2 | 8 | 8 GiB | 100 GB | 10.0.10.41 | Terraform/Ansible | Média | ✔ |
| 117 | svc-itsm | node2 | 8 | 16 GiB | 100 GB | 10.0.10.42 | Inventário/ITSM | **Alta** | ✔ |
| 118 | svc-observ | node3 | 8 | 16 GiB | 100 GB | 10.0.10.40 | Observabilidade | **Alta** | ✔ |
| 122 | svc-ntp | node3 | 2 | 4 GiB | 20 GB | 10.0.10.15 | Servidor de Hora | **Alta** | ✔ |

### Convenção de criticidade

- **Alta** — serviço cuja indisponibilidade impacta toda a operação → HA obrigatório + backup frequente.
- **Média** — impacto parcial → backup diário, HA recomendado.
- **Baixa** — impacto local → backup periódico.

Ver também [`07-naming-conventions.md`](07-naming-conventions.md).
