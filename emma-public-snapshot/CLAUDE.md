# CLAUDE.md

Kompakte Betriebsanweisung fuer Claude-Sessions. **Vollstaendige, agent-neutrale Regeln:** [AGENTS.md](AGENTS.md). **Dokumentations-Index:** [docs/README.md](docs/README.md). Token-sparsam halten. **Stand (Agent-Regeln):** 2026-04-28.

## Rolle

Staff Mobile Engineer / Principal-Level fuer die emma-App.  
Liefer-Format (9 Sektionen) nur bei echten Bau- und Architekturauftraegen; sonst knapp.

## Zielbild

Eine emma-App fuer Mitteldeutschland. MVP ohne kostenpflichtige APIs (Fakes + Open-Data). Android-first. **MVP-Scope:** [docs/planning/MVP_SCOPE.md](docs/planning/MVP_SCOPE.md) (ADR-04).

## Harte Regeln

- Monorepo: `apps/` importiert Pakete; Pakete importieren niemals `apps/`.
- MVVM, Domain/Data/UI getrennt. Keine Business-Logik in Widgets.
- Ports in `package:emma_contracts`. Repositories in `domain_*`. Impls in `adapters/` oder `fakes/`.
- Riverpod-`Provider`/`NotifierProvider`-Instanzen nur in **App-Shell** (`apps/emma_app/.../presentation/providers/`). `feature_auth`, `feature_employer_mobility`, `feature_journey` sind **ohne** Paket-Provider (Task #37 erledigt); andere Features bei Abweichung bewusst ausnahmsweise, sonst nachziehen.
- Fake-First: Chat/Directions verbindlich (ADR-05); Tarif M11: `fake_tariff` + `domain_rules` — siehe [docs/technical/SPECS_MVP.md](docs/technical/SPECS_MVP.md) (M11), [docs/planning/M11_TARIFF_ARCHITECTURE_DECISION.md](docs/planning/M11_TARIFF_ARCHITECTURE_DECISION.md).
- Keine kostenpflichtige API im MVP-Default-Build. **Open-Source/Open-Data-Maxime** im MVP: keine Google Maps als Soll-Architektur; Freischaltung erst Livegang (ADR-03).

## Pflicht-Check vor jedem Commit

- **Default (Code/Build betroffen):** `melos run analyze`, `test:unit`, `test:flutter`; ggf. `integration_test`. Falls `melos` nicht im `PATH`: `dart pub global run melos run <script>`.
- **R0/R1 nur-Doku / nur-Meta:** reduzierte Checks nur nach [docs/operations/test_scope_policy.md](docs/operations/test_scope_policy.md) — im PR **Check-Strategie + Begruendung + Ersatzchecks** dokumentieren.
- Kein `print`/`debugPrint` ausserhalb Logger.

## Dateizeiger (Kanon nach Konsolidierung 2026-04)

| Thema | Datei |
|--------|--------|
| Agent-Regeln, Setup | [AGENTS.md](AGENTS.md) |
| Produkt (Lastenheft + Katalog) | [docs/product/PRODUKT.md](docs/product/PRODUKT.md) |
| Status, Roadmap, Audit | [docs/planning/STATUS.md](docs/planning/STATUS.md) |
| MVP-Scope Kurz | [docs/planning/MVP_SCOPE.md](docs/planning/MVP_SCOPE.md) |
| DoD | [docs/planning/DEFINITION_OF_DONE.md](docs/planning/DEFINITION_OF_DONE.md) |
| MVP Product-Entscheidungen (verbindlich) | [docs/planning/MVP_PRODUCT_DECISIONS_2026-04-26.md](docs/planning/MVP_PRODUCT_DECISIONS_2026-04-26.md) |
| DoD-Follow-on-Checkliste | [docs/planning/CHECKLIST_MVP_FOLLOWON_DECISIONS.md](docs/planning/CHECKLIST_MVP_FOLLOWON_DECISIONS.md) |
| Dev, Fake-First, Shell | [docs/technical/ENTWICKLER.md](docs/technical/ENTWICKLER.md) |
| SPECs M07/M11 | [docs/technical/SPECS_MVP.md](docs/technical/SPECS_MVP.md) |
| Kernprozess / Domain-Objekte | [docs/architecture/PROCESS_MVP.md](docs/architecture/PROCESS_MVP.md) |
| Ports, Begriffe, Module | [docs/architecture/MAPPING.md](docs/architecture/MAPPING.md) |
| JSON-Schema vs. Code | [docs/architecture/CONTRACTS_VS_CODE.md](docs/architecture/CONTRACTS_VS_CODE.md) |
| ADR-Index | [docs/architecture/ADR_README.md](docs/architecture/ADR_README.md) |
| ADR-03 … 07 | `docs/architecture/ADR-0*_*.md` |
| Preis-Job-Runbook (MVP) | [docs/operations/price_data_refresh_runbook.md](docs/operations/price_data_refresh_runbook.md) |
| PR-Hygiene (Zombie-PRs, Drafts) | [docs/operations/pr_hygiene.md](docs/operations/pr_hygiene.md) |
| Branch-Ergebnis (Merge / Cherry-pick / Schliessen) | [docs/operations/branch_outcome_policy.md](docs/operations/branch_outcome_policy.md) |
| Linear Issue-Vorlage (MCP) | [docs/planning/LINEAR_ISSUE_TEMPLATE.md](docs/planning/LINEAR_ISSUE_TEMPLATE.md) |
| Single Context Snapshot, BLOCKED_BY_CONTEXT_DRIFT (EMM-139) | [docs/operations/CONTEXT_SNAPSHOT.md](docs/operations/CONTEXT_SNAPSHOT.md) |

## Verbotenes

- `package:emma_app/...` in `packages/**`.
- `export` ohne `show`-Filter in Barrels.
- `Write` auf grosse Dateien ohne Null-Byte-Check.
- Tarif-Logik in UI. Kostenpflichtige APIs im MVP-Default.

## Tooling

- Melos-Config: `pubspec.yaml` → `melos:`. Fake-Default: `--dart-define=USE_FAKES=true`.
- Windows: `git config --global core.longpaths true`. Null-Byte-Check nach Mass-Rewrites.
- Git Bash: [tools/scripts/emma-git-bash.sh](tools/scripts/emma-git-bash.sh) (`help`, `analyze`, `run-chrome`, …).
