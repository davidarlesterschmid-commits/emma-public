# Label-Katalog (Referenz) — EMM-227

Zum Anlegen im GitHub-UI; Farben frei wählbar (z. B. `risk/*` in Orange/Rot).

| Label | Beispielfarbe (optional) | Zweck |
| --- | --- | --- |
| `risk/R0` | `#C5DEF5` | geringstes Risiko |
| `risk/R1` | `#FEF2C0` | kleine Änderung |
| `risk/R2` | `#F9D0C4` | Review erforderlich, kein Automerge |
| `risk/R3` | `#D93F0B` | hoch, kein Automerge |
| `public-safe` | `#0E8A16` | Inhalt explizit für public Repo ok |
| `no-automerge` | `#B60205` | nur manueller Merge |
| `dependencies` | `#0366D6` | z. B. Dependabot (mit `risk/R0` + `public-safe` kombinierbar) |

Nur **ein** prägnantes Risk-Label pro PR wählen, um Mehrdeutigkeiten zu vermeiden (Workflow prüft auf Vorhandensein von R0**oder** R1 und lehnt R2/R3 für Automerge ab).
