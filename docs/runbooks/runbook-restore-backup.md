# Runbook — Restore de VM via Proxmox Backup Server

> ⚠️ Comandos e IDs são exemplos sanitizados.

## Sintoma / Alerta
- VM corrompida, excluída acidentalmente, ou rollback necessário após mudança malsucedida.
- Falha que o HA não resolve (corrupção lógica, não falha de hardware).

## Impacto
- Indisponibilidade do serviço até a conclusão do restore.
- Possível perda de dados desde o último backup (ver RPO em [`../06-disaster-recovery.md`](../06-disaster-recovery.md)).

## Pré-requisitos
- Storage PBS adicionado e acessível no Proxmox VE.
- Identificar o snapshot a restaurar.

## Diagnóstico / Localizar backup
```bash
# Listar snapshots de uma VM (exemplo VMID 110) no datastore ds-daily
proxmox-backup-client snapshot list --repository user@pbs@10.0.30.10:ds-daily | grep vm/110
```

## Resolução

### A) Restore pela CLI do Proxmox VE
```bash
# Restaurar a VM 110 a partir do backup para o storage Ceph (pool-vm)
qmrestore <backup-volume> 110 --storage pool-vm

# Exemplo de referência de volume:
# pbs:backup/vm/110/2026-06-19T03:00:00Z
```

### B) Restore para nova VMID (validar antes de substituir)
```bash
qmrestore <backup-volume> 999 --storage pool-vm
# Validar a VM 999 isoladamente; se OK, promover/substituir.
```

### C) Restore de arquivo individual (file-level)
```bash
# Montar o snapshot e copiar arquivos específicos sem restaurar a VM inteira
proxmox-backup-client mount vm/110/<snapshot> root.pxar /mnt/restore \
  --repository user@pbs@10.0.30.10:ds-daily
```

## Verificação
1. VM inicia corretamente: `qm start 110`.
2. Serviço respondendo e dados íntegros (validar com o responsável pelo serviço).
3. Integração (ex.: AD, DNS) funcional.
4. Reativar HA da VM se aplicável.

## Pós-incidente
- Registrar tempo real de recuperação (alimenta a métrica **MTTR**).
- Abrir **postmortem** se houve impacto a usuários (ver [`../postmortems/`](../postmortems/)).

## Escalonamento
- Backup mais recente também corrompido / verify falhando → escalar para responsável de backup e avaliar snapshot anterior.
