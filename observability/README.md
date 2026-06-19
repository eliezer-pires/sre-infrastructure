# Observability — Configurações de Exemplo

Configs sanitizadas que materializam a estratégia descrita em [`../docs/05-observabilidade.md`](../docs/05-observabilidade.md).

```
observability/
├── prometheus/
│   ├── prometheus.yml          # Scrape configs (node, pve, cadvisor, blackbox)
│   └── alerts/
│       └── proxmox-alerts.yml  # Regras de alerta alinhadas aos SLOs
├── grafana/
│   └── README.md               # Dashboards (orientação)
└── graylog/
    └── README.md               # Inputs e streams (orientação)
```

Os três pilares:

- **Métricas** → Prometheus + exporters.
- **Logs** → Graylog (Syslog/GELF/Beats).
- **Visualização/Alertas** → Grafana + Zabbix.

Thresholds e SLOs em [`../docs/04-slo-sli.md`](../docs/04-slo-sli.md).
