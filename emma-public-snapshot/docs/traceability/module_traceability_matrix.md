# Module Traceability Matrix

Stand: 2026-04-24

Diese Matrix ordnet Repo-Bereiche zu Verantwortlichkeiten, Dokumenten und Ticketbezug. Sie ist ein Arbeitsinstrument fuer Linear-, GitHub- und Agenten-Traceability; sie ersetzt keine Architekturentscheidung.

## Nutzung

- Jeder PR nennt die betroffenen Module im PR-Template.
- Bei neuen Modulen, Ports, Contracts oder fachlichen Grenzen wird diese Matrix aktualisiert.
- Linear bleibt Projekt-Wahrheit; GitHub bleibt Code-Wahrheit.
- Linear-IDs gehoeren in Branches, PRs und Beschreibungen, nicht in Paketnamen, Klassen oder Runtime-Logik.

## Matrix

| Repo-Bereich | Zweck | Primaere Doku | Typische Risikoklasse | Traceability-Regel |
| --- | --- | --- | --- | --- |
| `apps/emma_app/` | App-Shell, Routing, Bootstrap, App-nahe Provider | `AGENTS.md`, `docs/technical/ENTWICKLER.md` | R2-R4 | PR nennt betroffene Screens/Provider und relevante Domain |
| `packages/core/emma_core/` | Kernhilfen und gemeinsam genutzte Basislogik | `docs/architecture/MAPPING.md` | R2-R4 | Aenderungen brauchen Modulbezug und Regressionstest |
| `packages/core/emma_contracts/` | Ports, Schnittstellen und gemeinsame Contracts | `docs/architecture/CONTRACTS_VS_CODE.md` | R3-R5 | Contract-Folgen und Adapter/Fake-Auswirkungen dokumentieren |
| `packages/core/emma_ui_kit/` | Wiederverwendbare UI-Bausteine | `docs/technical/ENTWICKLER.md` | R1-R3 | Betroffene Features und visuelle Regression nennen |
| `packages/core/emma_testkit/` | Gemeinsame Testhilfen | `docs/planning/DEFINITION_OF_DONE.md` | R1-R3 | Konsumenten und Testauswirkungen nennen |
| `packages/domains/domain_*` | Fachlogik und Repositories | `docs/architecture/MAPPING.md`, `docs/planning/MVP_SCOPE.md` | R3-R5 | Domain, Use Case und Contract-Bezug nennen |
| `packages/features/feature_*` | Feature UI/Presentation ohne Business-Logik in Widgets | `AGENTS.md`, `docs/architecture/MAPPING.md` | R2-R4 | Feature, App-Shell-Provider und Domain-Abhaengigkeit nennen |
| `packages/adapters/adapter_*` | Implementierungen externer oder lokaler Ports | `docs/architecture/ADR_README.md` | R3-R5 | Port, Provider, Fallback und Kostenrisiko nennen |
| `packages/fakes/fake_*` | Fake-First Implementierungen fuer MVP-Default | `docs/architecture/ADR-03_mvp_without_paid_apis.md` | R1-R3 | Fake-Verhalten, Fixture-Bezug und Testpfad nennen |
| `services/bff_mobile/` | Mobile BFF mit Dart/Shelf | `docs/technical/ENTWICKLER.md` | R3-R5 | API-/Contract-Folgen und Betriebsrisiko nennen |
| `contracts/` | OpenAPI, AsyncAPI, JSON Schema, Fixtures | `docs/architecture/CONTRACTS_VS_CODE.md` | R3-R5 | Schema-Version, Consumer und Testdaten nennen |
| `docs/` | Produkt-, Architektur-, Betriebs- und Planungsdoku | `docs/README.md` | R0-R2 | Normative Doku-Aenderungen mit Linear-Issue verbinden |
| `.github/` | PR-Template, Workflows, GitHub-Agentenhinweise | `docs/operations/agent_operating_model.md` | R0-R4 | Keine neue CI erzwingen, wenn nicht explizit beauftragt |
| `tools/` | Skripte fuer Entwicklung, Sync und Hilfsablaeufe | `tools/README.md` | R1-R4 | Skriptwirkung, Plattform und Ausfuehrung dokumentieren |

## MVP-Vertikalen

| Vertikale / Thema | Primaere Bereiche | Wichtige Doku | Hinweis |
| --- | --- | --- | --- |
| Journey / Routing | `feature_journey`, `domain_*`, App-Shell | `docs/technical/trip_boundary_mapping_rules.md` | Provider-Zielbild in App-Shell beachten |
| Ticketing | `domain_ticketing`, Contracts, Fakes | `docs/planning/MVP_PRODUCT_DECISIONS_2026-04-26.md` | Tarif-Logik nicht im UI-Layer |
| Tarif / Preis | `domain_rules`, `fake_tariff`, Contracts | `docs/operations/price_data_refresh_runbook.md` | Fake-First und Open-Data-Regeln beachten |
| Auth | `feature_auth`, App-Shell, Contracts | `docs/planning/TASK_37_AUTH_PROVIDER_HOIST.md` | Keine Paket-Provider in `feature_auth` |
| Employer Mobility | `feature_employer_mobility`, Domain, App-Shell | `docs/planning/MVP_SCOPE.md` | Provider-Hoist-Zielbild beachten |

## Pflege

- Neue Zeilen nur ergaenzen, wenn ein neuer stabiler Repo-Bereich oder eine neue fachliche Vertikale entsteht.
- Keine Linear-ID dauerhaft in diese Matrix eintragen, ausser eine Doku explizit ein historisches Ticket referenziert.
- Bei Widerspruch gelten `AGENTS.md`, ADRs und die aktuelle Linear-Entscheidung.
