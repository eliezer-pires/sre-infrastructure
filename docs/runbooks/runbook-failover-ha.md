# Runbook — Failover HA de VM Crítica

> ⚠️ Comandos e IDs são exemplos sanitizados.

## Sintoma / Alerta
- VM crítica indisponível, ou
- Necessidade de **manutenção planejada** de um nó (drenar VMs antes).

## Impacto
- Indisponibilidade temporária do serviço durante a migração (segundos a poucos minutos).

## Pré-requisitos
- VM deve estar incluída no grupo HA. Conferir:
  ```bash
  ha-manager status
  ha-manager config
  ```

## Resolução

### A) Failover automático (falha de nó)
O `ha-manager` detecta o nó indisponível, executa *fencing* e reinicia a VM em outro nó. **Nenhuma ação manual** além de acompanhar:
```bash
ha-manager status        # acompanhar estado do recurso (started/relocate)
```

### B) Migração planejada (manutenção)
Drenar o nó migrando as VMs para outro:
```bash
# Migração ao vivo de uma VM (exemplo VMID 110) para node2
qm migrate 110 node2 --online

# Ou colocar o nó em manutenção HA (drena recursos HA)
ha-manager crm-command node-maintenance enable node1
```

### C) Forçar relocação de um recurso HA
```bash
ha-manager migrate vm:110 node2
```

## Verificação
1. `ha-manager status` mostra o recurso `started` no nó de destino.
2. Serviço respondendo (health check / Grafana).
3. Sem alertas pendentes.

## Pós-manutenção
Reabilitar o nó:
```bash
ha-manager crm-command node-maintenance disable node1
```

## Escalonamento
- VM não inicia no nó de destino (recurso `error`) → verificar storage Ceph e logs (`journalctl -u pve-ha-lrm`), escalar se persistir.
