# Grafana — Visualização e Correlação

Camada de visualização que unifica **métricas (Prometheus)** e **logs (Graylog)**.

## Datasources (exemplo)
- Prometheus — `http://10.0.10.40:9090`
- Graylog — via plugin/datasource de logs

## Dashboards recomendados
- **Cluster Proxmox** — nós online, CPU/RAM, status do Ceph.
- **PBS** — taxa de sucesso de backup, uso de datastore, dias desde verify.
- **Serviços críticos** — disponibilidade e latência (AD/DNS, File Server, GitLab, Nextcloud).
- **Visão SRE** — SLOs e consumo de error budget.

## Critério de maturidade
Conseguir fazer *troubleshooting* de um incidente simulado **usando apenas o Grafana**.

> Os JSONs reais dos dashboards devem ser exportados e versionados aqui (`grafana/dashboards/`). Mantidos fora deste exemplo por conterem dados do ambiente.
