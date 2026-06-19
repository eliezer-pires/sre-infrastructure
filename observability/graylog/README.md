# Graylog — Logging Centralizado

Stack: **Graylog + Elasticsearch/OpenSearch + MongoDB**.

## Inputs
- **Syslog UDP/TCP** (porta 1514) — SOs Linux/Windows, firewall, switches.
- **GELF** — aplicações.
- **Beats** — agentes Filebeat onde aplicável.

## Streams (por fonte)
Separar o fluxo por origem facilita retenção e dashboards:

| Stream | Fonte | Retenção (exemplo) |
|---|---|---|
| `stream-proxmox` | Nós Proxmox / PBS | 90 dias |
| `stream-linux` | VMs Linux | 60 dias |
| `stream-windows` | VMs Windows / AD | 90 dias |
| `stream-network` | Firewall / switches | 30 dias |

## Integração
- Padrões de log (ex.: `Failed backups`, `Failed logins/min`) geram alertas via Zabbix.
- Grafana consome o Graylog como datasource para correlação com métricas.

> Exemplos sanitizados. Os pipelines/extractors reais não estão versionados aqui.
