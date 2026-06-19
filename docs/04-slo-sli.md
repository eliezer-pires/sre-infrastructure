# 04 — SLIs, SLOs e Error Budgets

Confiabilidade tratada como **funcionalidade mensurável**. Este documento define o que medimos (SLI), as metas (SLO) e como usamos o orçamento de erro (error budget).

## Conceitos

- **SLI (Service Level Indicator)** — métrica que reflete a saúde do serviço (ex.: disponibilidade, latência, taxa de sucesso de backup).
- **SLO (Service Level Objective)** — meta para o SLI em uma janela de tempo (ex.: 99,9% de disponibilidade/mês).
- **Error Budget** — `100% − SLO`. Quanto de indisponibilidade é "permitido". Esgotou o orçamento → congela mudanças e prioriza confiabilidade.

## Indicador Norte do Projeto: MTTR

| Indicador | Baseline | Meta | Janela |
|---|---|---|---|
| **MTTR** (recuperação de serviço crítico) | ~24 h | **≤ 5 min** (HA) / **≤ 30 min** (restore) | Por incidente |

## SLOs por Serviço

| Serviço | SLI | SLO | Error Budget (mês) |
|---|---|---|---|
| Active Directory / DNS / DHCP | Disponibilidade | 99,95% | ~22 min |
| File Server | Disponibilidade | 99,9% | ~43 min |
| GitLab CI | Disponibilidade | 99,5% | ~3,6 h |
| Nextcloud | Latência p95 | < 2 s | — |
| Backup (PBS) | Taxa de sucesso 24h | ≥ 99% | — |

## Métricas Críticas por Componente

### Proxmox VE Cluster

| Métrica | Warning | Critical | Fonte |
|---|---|---|---|
| Nodes online | < 3 | < 2 | Prometheus (`pve_exporter`) |
| Ceph health | != HEALTH_OK | HEALTH_ERR | Prometheus |
| CPU usage cluster | > 80% | > 95% | Prometheus |
| RAM usage cluster | > 85% | > 95% | Prometheus |
| VM count drift | mudança > 5 VMs | — | Prometheus |

### Proxmox Backup Server

| Métrica | Warning | Critical | Fonte |
|---|---|---|---|
| Backup success rate 24h | < 95% | < 85% | Zabbix (script) |
| Datastore usage | > 80% | > 90% | Zabbix |
| Days since last verify | > 14 | > 30 | Zabbix |
| Failed backups count | > 1 | > 3 | Graylog |

### GitLab

| Métrica | Warning | Critical | Fonte |
|---|---|---|---|
| Runners available | < 2 | = 0 | Prometheus (`gitlab-exporter`) |
| Jobs in queue | > 20 | > 50 | Prometheus |
| Pipeline success rate | < 90% | < 75% | Prometheus |
| Git storage usage | > 80% | > 95% | Prometheus |

### Nextcloud

| Métrica | Warning | Critical | Fonte |
|---|---|---|---|
| Response time p95 | > 2 s | > 5 s | Prometheus (`blackbox_exporter`) |
| Active users | queda > 50% | queda > 80% | Prometheus (`nextcloud-exporter`) |
| DB connections | > 100 | > 200 | Prometheus (`postgres_exporter`) |
| Redis hit rate | < 80% | < 60% | Prometheus |
| Failed logins/min | > 10 | > 50 | Graylog |

## Política de Error Budget

1. **Budget saudável (> 50%):** mudanças e novas features podem prosseguir normalmente.
2. **Budget baixo (10–50%):** aumentar rigor — revisões obrigatórias, deploys menores.
3. **Budget esgotado (0%):** **congelamento de mudanças**. Foco total em estabilidade até o serviço voltar ao SLO.

## Validação de Sucesso (Observabilidade)

Antes de considerar a observabilidade madura, deve-se conseguir:

- Ver em tempo real CPU/RAM/Disco dos 3 nós Proxmox.
- Ser alertado em **< 2 minutos** se um nó ficar offline.
- Correlacionar um alerta do Zabbix com logs do Graylog no Grafana.
- Ter dashboards para todos os serviços críticos.
- Fazer troubleshooting de incidente simulado **usando apenas o Grafana**.
