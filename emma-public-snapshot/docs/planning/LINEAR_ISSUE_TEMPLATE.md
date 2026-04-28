# Linear — Issue-Vorlage und Agent-Regeln (MCP)

**Zweck:** Konsistente Linear-Issues (Projekt-Wahrheit) und **zuverlaessige** Erstellung per MCP/API — ohne leere `save_issue`-Calls und ohne Endlos-Retries.

**Bezug:** [AGENTS.md](../../AGENTS.md) (Traceability, Linear-ID in Branch/PR).

---

## 1. Copy-Paste: Issue-Body (Markdown)

Titel in Linear **separat** setzen: `[R0] …` bis `[R4] …` nach Risiko (siehe unten). Projekte/Meilensteine in der Linear-UI waehlen.

```markdown
## Ziel

(Ein Satz: was soll nach Merge/Release wahr sein?)

## Risikoklasse

R0 | R1 | R2 | R3 | R4 | R5 — kurz begruenden (R0 = nur Doku/kein Code).

## Kontext

(Optional: Links zu ADR, PR, vorherigem Issue, Repo-Pfad)

## Scope

- …
- …

## Nicht-Scope

- …

## Akzeptanzkriterien

- [ ] …
- [ ] …

## Tests / Checks

- `melos run analyze`
- `melos run test:unit`
- `melos run test:flutter`
- (weitere, falls zutreffend)

## Abhaengigkeiten

(Optional: blockiert von / blockiert …)

## Links Repo

- `pfad/zur/datei` — …
```

---

## 2. Zwei-Schritt-Empfehlung (MCP, lange Texte)

1. **Issue anlegen** mit **kurzer** `description` (Ziel in 1–3 Zeilen + **ein** zentraler Link, z. B. ADR oder `docs/...`).
2. **Ersten Kommentar** an dasselbe Issue haengen: **vollstaendiger** Text nach Abschnitt 1 (Scope, Akzeptanz, Tabelle) — so bleibt der Create-Call klein und Parameter werden nicht abgeschnitten.

---

## 3. Regeln fuer AI-Agenten (bindend)

| Regel | Inhalt |
|--------|--------|
| **Stopp** | Maximal **2** fehlgeschlagene `create issue`-Versuche (z. B. `title is required`), dann **abbrechen** und Nutzer/Template informieren. |
| **Ein Call = ein Issue** | Keine parallelen Creates in einer Nachricht mit riskanten Megablocken. |
| **Pflichtparameter** | Jedes Create: **Titel** + **Team** + **Beschreibung** (darf kurz sein). |
| **Kein leerer Call** | Nie `save_issue` ohne sichtbaren Titel-String aufrufen. |
| **Fallback** | Ein **Parent-Issue** + **ein Kommentar** mit nummerierter Checkliste (8 Nachfolger, etc.) statt 8x riskanter API-Retry. |
| **Linear-ID in Git** | Branch/PR mit `EMM-…` laut [AGENTS.md](../../AGENTS.md). |

---

## 4. Typische Projekte (emma, Stand 2026-04)

- **P1 – Repo Baseline & Traceability** — Doku, CI, ADR-Abgleich, Analyse
- **P2 – App v1.0 Core Journey** — UI-Flows, Home, Journey
- **M04 / Routing** — eigenes Projekt laut Backlog, Milestones in Linear waehlen

Team: **Emma_app_MDMA** (Key `EMM`).

---

## 5. Checkliste vor „Issue fertig“

- [ ] Risiko R0–R5 gesetzt
- [ ] Scope / Nicht-Scope klar
- [ ] Akzeptanz testbar
- [ ] Repo-Links mit `main`-faehigen Pfaden
- [ ] Branch-Name in Linear (optional) geprueft
