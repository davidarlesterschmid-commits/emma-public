# Governance: Review- und Merge-Policy (Kern)

Stand: 2026-04-25

Dieses Dokument fasst die **verbindliche Review- und Merge-Logik** fuer Governance-Zwecke. Normative Details, PR-/Linear-Templates und EMM-127-Vorgaben: [../operations/review_merge_automation.md](../operations/review_merge_automation.md). Risikotabelle und Automerge-Grenzen: [../operations/automerge_policy.md](../operations/automerge_policy.md).

## Projektkontext

- **Linear = Projekt-Wahrheit** (Scope, Akzeptanz, priorisierte Klaerung).
- **GitHub = Code-Wahrheit** (umgesetzter Stand, PR, Review, Merge-Commit).
- Jede umsetzbare Aenderung ist an ein **Linear-Issue** gebunden; **keine Arbeit ohne Issue** — siehe [../operations/dependency_gate.md](../operations/dependency_gate.md).

## Risikoklassen R0–R5 (Kurz)

| Klasse | Bedeutung (Kurz) | Merge |
| --- | --- | --- |
| R0 | Meta/Doku, kein Produktverhalten | Self-Merge moeglich bei erfuellten Gates |
| R1 | niedrig, keine Runtime-Logik in der Kernform | Self-Merge moeglich bei Gates |
| R2 | begrenzte Aenderung im bestehenden Modul/Scope | **Claude-Review mit PASS** vor Merge |
| R3 | Architektur / Modulgrenzen | nur manuell (Maintainer) |
| R4 | kritischer Domain-, Daten-, Release- oder Betriebs-Impact | nur manuell |
| R5 | destruktiv, sicherheitsrelevant, extern, irreversibel | nur manuell, explizite Entscheidung |

Bei unklarer Einordnung gilt die **hoeher plausible** Klasse. **Automerge** formal nur fuer **R0–R2** und nur wenn alle Gates der Klasse erfuellt sind — Details [../operations/automerge_policy.md](../operations/automerge_policy.md).

## Review-Outcomes: PASS / FAIL / GATE_REQUIRED

Jeder (Self- oder Claude-)Review, der fuer Merge-Entscheidungen herangezogen wird, endet mit **genau einem** Outcome:

| Outcome | Bedeutung (Governance) |
| --- | --- |
| **PASS** | Kriterien erfuellt; Merge gemaess R-Klasse zulaessig, sofern weitere Linear-/PR-Pflichten erfuellt sind. |
| **FAIL** | Blocker; **kein** Merge bis zur Korrektur und erneutem Review. |
| **GATE\_REQUIRED** | zusaetzliches Gate / Hochstufung / Maintainer-Entscheidung noetig; kein forciertes „weiter“ gegen die Policy. |

Volltext-Regeln, Blockerlisten und Zusammenspiel mit Linear-Phasen: [../operations/review_merge_automation.md](../operations/review_merge_automation.md).

## Verknuepfung Traceability

Aenderungen an Modul- oder Funktionszuordnung: **Traceability** pruefen — [traceability_policy.md](traceability_policy.md).

## Verweis

Agentenfluss, `START` / `REVIEW REQUEST` / `GATE OUTCOME` / `ABSCHLUSS`: [../operations/agent_operating_model.md](../operations/agent_operating_model.md).
