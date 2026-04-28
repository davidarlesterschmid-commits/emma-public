# emma — Dokumentation

Einstieg und Navigation. Technische/Produkt-Inhalte sind nach Thema buendig zusammengefuehrt (Konsolidierung 2026-04-23; ADR-/Status-Aenderungen fortlaufend — siehe `docs/planning/STATUS.md`, `docs/architecture/MAPPING.md`).

## Schnellstart

| Thema | Dokument |
|--------|----------|
| **Coding-Agents, Setup, Tageskommandos** | [../AGENTS.md](../AGENTS.md) |
| **Claude-spezifisch, kurz** | [../CLAUDE.md](../CLAUDE.md) |
| **MVP-Scope 6+3+9** | [planning/MVP_SCOPE.md](planning/MVP_SCOPE.md) |
| **Produkt (Lastenheft + Funktionskatalog v1.0)** | [product/PRODUKT.md](product/PRODUKT.md) |
| **Implementierungsstand, Roadmap, Modul-Audit** | [planning/STATUS.md](planning/STATUS.md) |
| **Definition of Done (pro Domäne)** | [planning/DEFINITION_OF_DONE.md](planning/DEFINITION_OF_DONE.md) |
| **MVP-Folgethemen-Checkliste (Ticketing, Payments, …)** | [planning/CHECKLIST_MVP_FOLLOWON_DECISIONS.md](planning/CHECKLIST_MVP_FOLLOWON_DECISIONS.md) |
| **MVP Product-Entscheide (verbindlich)** | [planning/MVP_PRODUCT_DECISIONS_2026-04-26.md](planning/MVP_PRODUCT_DECISIONS_2026-04-26.md) |
| **EMM-XXX Mock End-to-End Journey MVP** | [planning/EMM-XXX_END_TO_END_JOURNEY_MVP.md](planning/EMM-XXX_END_TO_END_JOURNEY_MVP.md) |
| **Fake-First, VS Code, Shell, Migration (konsolidiert)** | [technical/ENTWICKLER.md](technical/ENTWICKLER.md) |
| **SPECs M07/M11 (Garantie, Tarif Lese-Pfad)** | [technical/SPECS_MVP.md](technical/SPECS_MVP.md) |
| **Kernprozess, Domain-Objekte (Architekturpaket)** | [architecture/PROCESS_MVP.md](architecture/PROCESS_MVP.md) |
| **Ports, Begriffe, Feature↔Modul (konsolidiert)** | [architecture/MAPPING.md](architecture/MAPPING.md) |
| **B01-B14 Backlog-Traceability (Mapping nach M01-M16)** | [architecture/module_traceability.md](architecture/module_traceability.md) |
| **JSON-Schema vs. Code (Kurz)** | [architecture/CONTRACTS_VS_CODE.md](architecture/CONTRACTS_VS_CODE.md) |
| **ADR-Index** | [architecture/ADR_README.md](architecture/ADR_README.md) |
| **Runbook: Preisdaten-Refresh (MVP)** | [operations/price_data_refresh_runbook.md](operations/price_data_refresh_runbook.md) |
| **Domaenen-Backlog-Referenz (18)** | [planning/MVP_BACKLOG_18_DOMAINS.md](planning/MVP_BACKLOG_18_DOMAINS.md) |
| **Auth Provider-Hoist (Task)** | [planning/TASK_37_AUTH_PROVIDER_HOIST.md](planning/TASK_37_AUTH_PROVIDER_HOIST.md) |
| **M11 Tarif: Architektur (self-built, Open-Data)** | [planning/M11_TARIFF_ARCHITECTURE_DECISION.md](planning/M11_TARIFF_ARCHITECTURE_DECISION.md) |
| **Linear: Issue-Vorlage & MCP-Regeln** | [planning/LINEAR_ISSUE_TEMPLATE.md](planning/LINEAR_ISSUE_TEMPLATE.md) |
| **EmmaTrip ↔ Journey** | [technical/trip_boundary_mapping_rules.md](technical/trip_boundary_mapping_rules.md) |
| **Migrations-Checkliste** | [migration/migration_checklist_v2.md](migration/migration_checklist_v2.md) |
| **Skripte (Sync, Git-Bash-Helper)** | [../tools/README.md](../tools/README.md) — u. a. [../tools/scripts/emma-git-bash.sh](../tools/scripts/emma-git-bash.sh) |

## Agenten, Linear, Betrieb

Fuer **AI-Coding-Agents** (Cursor, Codex, Claude, ...) und menschliche Contributors gilt:

- **Linear** ist **Projekt-Wahrheit** (Scope, Akzeptanz, Prioritaet). **Keine Code- oder Doku-Aenderung** ohne zugehoeriges **Linear-Issue**; Branch-Namen tragen die **EMM-...**-ID, PR-Titel oder -Body referenzieren sie.
- **GitHub** ist **Code-Wahrheit** (Branches, PRs, Merge-Historie). Nach sinnvollem Abschluss: **Status in Linear dokumentieren** (Fortschritt, PR-Link, bei Merge: Squash-Commit, Risikoklasse, Review-Outcome, Scope, naechster Schritt - siehe unten).
- Vollstaendiger Kanon: [../AGENTS.md](../AGENTS.md). Kurz-Regeln in der IDE: [../.cursor/rules/emma-agent-rules.mdc](../.cursor/rules/emma-agent-rules.mdc).

| Thema | Dokument |
|--------|----------|
| Agenten-Workflow, Issue-Pflicht, Linear <-> Git | [operations/agent_operating_model.md](operations/agent_operating_model.md) |
| **Daily Review & Retro Gate** (Tagesabschluss, OPL/Truth-Sync, Tokenoekonomie, Fehlerkommentar-Regel, EMM-227) | [operations/daily_review_retro.md](operations/daily_review_retro.md) |
| Session-Start, Branch-Sync, Branch-Lifecycle | [operations/session_start_and_branch_sync.md](operations/session_start_and_branch_sync.md) |
| **PR-Hygiene** (keine offenen Zombies, `main`-Sync) | [operations/pr_hygiene.md](operations/pr_hygiene.md) |
| **Branch-Ergebnis** (Merge / Cherry-pick / Schliessen, Wann-Regeln) | [operations/branch_outcome_policy.md](operations/branch_outcome_policy.md) |
| PR-/Merge-Checks, **Linear-Kommentar-Templates** | [operations/review_merge_automation.md](operations/review_merge_automation.md) |
| Auto-Merge, Risikoklassen R0-R5 | [operations/automerge_policy.md](operations/automerge_policy.md) |
| Test-Scope (wann volle `melos`-Checks noetig sind) | [operations/test_scope_policy.md](operations/test_scope_policy.md) |
| Cursor-IDE: Git, Push, **Linear nach Merge** | [operations/cursor_setup.md](operations/cursor_setup.md) |
| Session-Start, Branch-Sync (EMM-127-konform) | [operations/session_start_and_branch_sync.md](operations/session_start_and_branch_sync.md) |
| Dependency Gate, **BLOCKED_BY_INPUT** (EMM-132) | [operations/dependency_gate.md](operations/dependency_gate.md) |
| Single Context Snapshot, **BLOCKED_BY_CONTEXT_DRIFT** (EMM-139, Einfuehrung EMM-137) | [operations/CONTEXT_SNAPSHOT.md](operations/CONTEXT_SNAPSHOT.md) |

## ADRs (Volltext)

- [ADR-03_mvp_without_paid_apis.md](architecture/ADR-03_mvp_without_paid_apis.md)  
- [ADR-04_mvp_domain_scope.md](architecture/ADR-04_mvp_domain_scope.md)  
- [ADR-05_chat_and_directions_behind_ports.md](architecture/ADR-05_chat_and_directions_behind_ports.md)  
- [ADR-06_mvp_open_data_client_and_ci_matrix.md](architecture/ADR-06_mvp_open_data_client_and_ci_matrix.md)  
- [ADR-07_mvp_pilot_regions_provider_catalogue.md](architecture/ADR-07_mvp_pilot_regions_provider_catalogue.md)  

## Archiv

Ueberholte Pfade, die in konsolidierte Dateien eingegangen sind: [\_archive/2026-04-consolidation](_archive/2026-04-consolidation).
