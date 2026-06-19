# 01 — Visão Geral

## Contexto

Este projeto documenta a implementação de **Site Reliability Engineering (SRE)** e **Infraestrutura como Código (IaC)** em um datacenter on-premises de missão crítica, operando em modo *air-gapped* (sem acesso à internet — intranet-first).

O ambiente hospeda serviços essenciais para a continuidade operacional: diretório de identidade (Active Directory), DNS, DHCP, servidor de arquivos, sistemas de documentos, inventário de ativos, monitoramento e ferramentas de TI.

## Visão Executiva

> Esta transição — de **gerenciamento manual** para **IaC** — é inevitável para a evolução da garantia de confiabilidade dos serviços e da continuidade de negócio.

A operação atual é confiável no dia a dia, mas **frágil diante de falhas**: a recuperação depende de procedimentos manuais, conhecimento tácito e tempo. O objetivo do projeto é transformar essa operação em uma plataforma onde a recuperação é **automatizada, previsível e testada**.

## O Problema Central

Os backups eram realizados **apenas internamente nos sistemas operacionais**. Isso garante a recuperação dos *dados*, porém:

- Não há mecanismo para acelerar o **reprovisionamento** da VM/serviço.
- A reconstrução de um serviço exige reinstalação e reconfiguração manuais.
- O **MTTR (Mean Time To Recovery) médio era de ~24 horas**.

## O Objetivo

Reduzir o **MTTR para uma média de ~5 minutos**, através de:

1. Backups deduplicados, verificados e com restore testado (PBS).
2. Alta disponibilidade com failover automático (Proxmox HA + Ceph).
3. Provisionamento e configuração 100% reproduzíveis via código (Terraform + Ansible).
4. Observabilidade que detecta falhas em menos de 2 minutos.

## Princípios Norteadores

| Princípio | Significado prático |
|---|---|
| **Intranet-first** | Toda solução funciona sem internet. Mirrors e registries internos. |
| **Incremental** | Implementação em fases pequenas e validadas, sem *big bang*. |
| **Pragmático** | Evitar complexidade desnecessária; escolher a ferramenta mais simples que resolve. |
| **Auditável** | Logs centralizados e *state* versionado; toda mudança é rastreável. |
| **Recuperável** | Disaster Recovery considerado desde o design, não como reflexão tardia. |

## Conceitos de SRE Aplicados

- **SLI / SLO / Error Budget** — confiabilidade medida e orçada (ver [`04-slo-sli.md`](04-slo-sli.md)).
- **Toil reduction** — automação de tarefas repetitivas via IaC.
- **Observabilidade** — logs + métricas + dashboards unificados (ver [`05-observabilidade.md`](05-observabilidade.md)).
- **Runbooks** — procedimentos operacionais padronizados (ver [`runbooks/`](runbooks/)).
- **Postmortems sem culpa** — aprendizado estruturado a partir de incidentes (ver [`postmortems/`](postmortems/)).
- **Checkpoints Go/No-Go** — nenhuma fase avança sem validação da anterior.

## Próximos documentos

- [`02-arquitetura.md`](02-arquitetura.md) — arquitetura atual vs. alvo.
- [`03-roadmap.md`](03-roadmap.md) — as 12 fases de implementação.
