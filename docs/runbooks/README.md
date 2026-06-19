# Runbooks

Procedimentos operacionais padronizados para resposta a incidentes e tarefas recorrentes. Cada runbook é **acionável**, **testado** e referenciado pelos alertas correspondentes.

## Estrutura de um runbook

1. **Sintoma / alerta** — o que dispara o procedimento.
2. **Impacto** — o que está em risco.
3. **Diagnóstico** — como confirmar a causa.
4. **Resolução** — passos para resolver.
5. **Verificação** — como confirmar que voltou ao normal.
6. **Escalonamento** — quando e para quem escalar.

## Índice

| Runbook | Cenário |
|---|---|
| [runbook-node-offline.md](runbook-node-offline.md) | Um nó do cluster Proxmox ficou offline |
| [runbook-failover-ha.md](runbook-failover-ha.md) | Validar/forçar failover HA de VM crítica |
| [runbook-restore-backup.md](runbook-restore-backup.md) | Restaurar uma VM a partir do PBS |

> ⚠️ Comandos e endereços são **exemplos sanitizados**.
