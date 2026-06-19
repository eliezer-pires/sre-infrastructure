# Postmortem — Indisponibilidade do File Server por falha de nó

> ⚠️ Exemplo **baseado em situação real** para fins de portfólio. Dados sanitizados.

## Resumo
| Campo | Valor |
|---|---|
| **Data** | 2026-03-12 |
| **Duração** | 00:04 (4 minutos) |
| **Severidade** | SEV2 |
| **Serviços afetados** | File Server (`prd-fs-01`) |
| **Autor(es)** | Equipe SRE |
| **Status** | Fechado |

## Impacto
- Acesso ao compartilhamento de arquivos indisponível por ~4 minutos para usuários da rede de servidores.
- Nenhuma perda de dados (Ceph replicado).
- **MTTR real: 4 min** — dentro da meta de ≤ 5 min. *(Antes do projeto, esse cenário levava ~24h.)*

## Linha do Tempo
| Horário | Evento |
|---|---|
| 14:02 | Falha de hardware (fonte) no `node1` |
| 14:02 | Alerta `ProxmoxNodeDown` disparado (Prometheus → Zabbix → email) |
| 14:03 | Proxmox HA executa fencing do `node1` |
| 14:03 | VM `prd-fs-01` reiniciada automaticamente no `node2` |
| 14:06 | Serviço de arquivos respondendo; alerta limpo |

## Causa Raiz
Falha física da fonte de alimentação do `node1`, derrubando o nó. Sem relação com mudança de software.

## Detecção
Automática, em < 1 minuto, via alerta `ProxmoxNodeDown`. A cadeia de observabilidade funcionou conforme projetado.

## Resolução
Nenhuma ação manual foi necessária para restaurar o serviço — o **Proxmox HA** migrou a VM automaticamente. O reparo do hardware foi tratado em janela de manutenção posterior (ver [runbook de nó offline](../runbooks/runbook-node-offline.md)).

## O que foi bem / O que foi mal
- ✅ Bem: HA funcionou; MTTR dentro do SLO; detecção automática rápida; sem perda de dados.
- ❌ Mal: a VM `prd-fs-01` levou ~3 min para o serviço estar totalmente responsivo após boot (cold start de cache).
- 🍀 Sorte: a falha ocorreu em um nó por vez; quórum preservado.

## Itens de Ação
| # | Ação | Tipo | Responsável | Prazo | Status |
|---|---|---|---|---|---|
| 1 | Avaliar warm cache / pré-aquecimento no boot do file server | mitigação | SRE | 2026-03-26 | Concluído |
| 2 | Substituir fonte e revisar redundância de energia dos nós | prevenção | Infra | 2026-03-19 | Concluído |
| 3 | Adicionar painel "tempo até serviço responsivo" no Grafana | detecção | SRE | 2026-04-02 | Em andamento |
