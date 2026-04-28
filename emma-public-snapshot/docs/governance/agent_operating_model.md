# Governance: Agent Operating Model

Stand: 2026-04-25

Kurznorm fuer ticketgebundene Agenten- und Contributor-Arbeit. **Vollstaendiger Ablauf, Rollen und Linear-Phasen** bleiben in [../operations/agent_operating_model.md](../operations/agent_operating_model.md). Dieses Dokument fasst die **Governance-Logik** zusammen.

## Quellen der Wahrheit

| Ebene | System | Regel |
| --- | --- | --- |
| **Projekt** (Scope, Prioritaet, Akzeptanz) | **Linear** | Linear ist die Projekt-Wahrheit. |
| **Code** (Branches, PRs, Merge-Historie) | **GitHub** | GitHub ist die Code-Wahrheit. |
| **Risikoklassifikation, Review-Outcomes, Merge-Gates** | Repo-Policies | R0–R5 und PASS / FAIL / GATE_REQUIRED: [review_policy.md](review_policy.md), [../operations/automerge_policy.md](../operations/automerge_policy.md), [../operations/review_merge_automation.md](../operations/review_merge_automation.md). |

Strategische Zerlegung und Steuerung (ChatGPT) sowie Dependency Gate, Context Snapshot und Issue-Vorlagen: siehe [../operations/agent_operating_model.md](../operations/agent_operating_model.md) und verlinkte Operationen.

## Zwingende Prinzipien

1. **Keine Arbeit ohne Linear-Issue** — vor erster sachlicher Umsetzung eindeutiges Issue; Branch und PR-Referenz mit Linear-ID; Details [../operations/dependency_gate.md](../operations/dependency_gate.md).
2. **Risikoklassen R0–R5** — jede Aenderung deklarieren; Merge-Pfad und Review-Pflicht folgen der Klasse — [review_policy.md](review_policy.md).
3. **Traceability** — betroffene **Module** und **Funktionen** fachlich benennen — [traceability_policy.md](traceability_policy.md).
4. **Review-Outcome** — jeder relevante Review endet mit genau einem Ergebnis: **PASS**, **FAIL** oder **GATE_REQUIRED** — [review_policy.md](review_policy.md).

## Fachliche Referenzen (keine neue Architektur)

- **Funktionskatalog v1.0:** [../product/PRODUKT.md](../product/PRODUKT.md) (konsolidiert; Archiv-Referenz: [../_archive/2026-04-consolidation/FUNKTIONSKATALOG_v1.0.md](../_archive/2026-04-consolidation/FUNKTIONSKATALOG_v1.0.md)).
- **Modultabelle (kanonisch M01–M16):** [../architecture/MAPPING.md](../architecture/MAPPING.md).
- **Gleichwertigkeit / Aequivalenz:** Backend-Matrix [../planning/equivalence_matrix_backends.md](../planning/equivalence_matrix_backends.md); weitere Paritaetsnachweise nach Specs/Linear (z. B. EMM-101, EMM-107) — [traceability_policy.md](traceability_policy.md).

## Verweis

Vollstaendiger Agent-Workflow, Rollen, Ticketfluss: [../operations/agent_operating_model.md](../operations/agent_operating_model.md). Gesamtindex: [../README.md](../README.md), [../../AGENTS.md](../../AGENTS.md).
