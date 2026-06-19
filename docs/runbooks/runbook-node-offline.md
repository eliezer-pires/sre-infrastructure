# Runbook — Nó do Cluster Proxmox Offline

> ⚠️ Comandos e IPs são exemplos sanitizados.

## Sintoma / Alerta
- Alerta `ProxmoxNodeDown` (Prometheus/Zabbix): `Nodes online < 3`.
- Nó aparece com status `offline` / `?` na interface do Proxmox.

## Impacto
- Perda de capacidade do cluster. Se um segundo nó cair, há **risco de perda de quórum** e parada de VMs HA.
- VMs HA do nó afetado já devem estar migrando automaticamente.

## Diagnóstico
1. Confirmar quais nós respondem:
   ```bash
   pvecm status        # estado do quórum (Corosync)
   pvecm nodes         # lista de nós e votos
   ```
2. Verificar conectividade de rede ao nó afetado:
   ```bash
   ping 10.0.0.3       # IP de gerência do node3 (exemplo)
   ```
3. Verificar saúde do Ceph (dados podem estar degradados/recuperando):
   ```bash
   ceph -s             # HEALTH_OK / HEALTH_WARN / HEALTH_ERR
   ```
4. Acesso físico/IPMI: verificar energia, hardware, console.

## Resolução
- **Se for problema de rede:** restaurar conectividade (switch/cabo/VLAN `vlan-cluster`). O nó reingressa automaticamente.
- **Se for falha de SO/serviço:** acessar via console/IPMI e reiniciar serviços:
  ```bash
  systemctl restart corosync
  systemctl restart pve-cluster
  ```
- **Se for falha de hardware:** o HA já migrou as VMs críticas. Iniciar reparo/substituição do hardware. Não forçar nada que comprometa o quórum dos nós restantes.

## Verificação
1. `pvecm status` mostra o nó novamente `online` e quórum saudável.
2. `ceph -s` retorna `HEALTH_OK` (aguardar recuperação/rebalance).
3. Alerta limpa no Prometheus/Zabbix.
4. VMs do nó operacionais (verificar no Grafana).

## Escalonamento
- Ceph permanece em `HEALTH_ERR` após o nó voltar → escalar para responsável de storage.
- Risco iminente de perda de quórum (2 nós offline) → escalar imediatamente (prioridade máxima).
