# Postmortems

Análises **sem culpa** (*blameless*) de incidentes. O objetivo é aprender com a falha e melhorar o sistema — **nunca atribuir culpa a pessoas**.

## Quando escrever um postmortem
- Incidente que impactou usuários ou serviços críticos.
- Violação de SLO / consumo significativo de error budget.
- Ativação de DR (failover, restore).
- *Near miss* relevante (quase incidente com aprendizado).

## Princípios
- **Blameless:** foco em processos e sistemas, não em indivíduos.
- **Factual:** linha do tempo baseada em evidências (logs, métricas, alertas).
- **Acionável:** toda conclusão gera itens de ação com responsável e prazo.

## Arquivos
- [`template-postmortem.md`](template-postmortem.md) — modelo a copiar.
- [`exemplo-postmortem.md`](exemplo-postmortem.md) — exemplo preenchido (fictício).
