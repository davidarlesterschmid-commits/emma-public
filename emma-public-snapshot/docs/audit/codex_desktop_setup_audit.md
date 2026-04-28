# Codex Desktop Setup Audit

Stand: 2026-04-24

Scope: Sicherer lokaler Setup-Audit fuer das emma-Repo. Keine Produktlogik
geaendert. Keine Dateien geloescht, verschoben, bereinigt, gestasht,
gemerged, gepullt oder gepusht.

## 1. Git-Zustand

- Arbeitsverzeichnis: `<LOCAL_USER_PATH>`
- Aktueller Branch: `main`
- Remote:
  - `origin` fetch: `https://github.com/davidarlesterschmid-commits/emma.git`
  - `origin` push: `https://github.com/davidarlesterschmid-commits/emma.git`
- Lokaler `HEAD`: `57fa2eeaffbdbe83f75c5c020d331055b2cfd357`
- Lokaler `origin/main`: `57fa2eeaffbdbe83f75c5c020d331055b2cfd357`
- Remote `origin/main` via `git ls-remote`: `57fa2eeaffbdbe83f75c5c020d331055b2cfd357`
- Ahead/Behind gegen `origin/main`: `0 ahead`, `0 behind`
- Arbeitsbaum: nicht sauber
- AGENTS.md: vorhanden

AGENTS.md-Pruefung:

- Enthalten: Linear ist Projekt-Wahrheit.
- Enthalten: GitHub ist Code-Wahrheit.
- Enthalten: ChatGPT ist strategische Denk-/Steuerungsinstanz.
- Enthalten: Codex arbeitet ticketgebunden.
- Enthalten: Branch/PR brauchen Linear-ID.
- Enthalten: keine destruktiven Aktionen, kleine reviewbare Aenderungen,
  Risk Classes R0-R5 und Reporting-Regeln.
- Vorschlag: `Stand: 2026-04-28` in AGENTS.md liegt aus Sicht dieses Audits
  in der Zukunft gegenueber `2026-04-24`; Datum bei naechstem passenden
  Linear-Issue pruefen.

## 2. Ungepushte Commits

Keine ungepushten Commits gegen `origin/main`.

`git log --oneline origin/main..HEAD` lieferte keine Eintraege.

## 3. Uncommitted Changes

Geaenderte getrackte Dateien vor diesem Audit:

| Datei | Diff-Stat |
| --- | ---: |
| `.github/pull_request_template.md` | `36 insertions(+), 2 deletions(-)` |
| `AGENTS.md` | `41 insertions(+), 0 deletions(-)` |

Gesamt-Diff-Stat vor diesem Audit:

```text
.github/pull_request_template.md | 38 +++++++++++++++++++++++++++++++++++--
AGENTS.md                        | 41 ++++++++++++++++++++++++++++++++++++++++
2 files changed, 77 insertions(+), 2 deletions(-)
```

Hinweis: Git meldete fuer `.github/pull_request_template.md`, dass LF beim
naechsten Git-Zugriff zu CRLF werden kann.

## 4. Untracked Dateien

Untracked Dateien vor diesem Audit:

| Datei | Groesse |
| --- | ---: |
| `docs/handoff/SESSION_HANDOFF_2026-04-24.md` | `9254` Bytes |
| `docs/operations/agent_operating_model.md` | `3606` Bytes |
| `docs/operations/automerge_policy.md` | `3234` Bytes |
| `docs/traceability/module_traceability_matrix.md` | `4275` Bytes |

Durch diesen Audit neu angelegt:

| Datei | Zweck |
| --- | --- |
| `docs/audit/codex_desktop_setup_audit.md` | Lokaler Codex-Setup-Audit |

## 5. Risiken

- R0/R1-Prozess- und Doku-Aenderungen liegen direkt auf `main`, nicht auf
  einem Linear-ID-Branch.
- Kein Linear-Issue-Key ist aus dem lokalen Branch ableitbar.
- Lokale Doku-Aenderungen sind nicht committed und koennen bei spaeteren
  Arbeiten Scope-Konflikte erzeugen.
- Die untracked Handoff-Datei behauptet im Inhalt `3 Commits vor origin/main`,
  waehrend Git aktuell `0 ahead`, `0 behind` zeigt. Das Dokument ist daher
  mindestens teilweise veraltet oder aus einem anderen Zeitpunkt.
- `.github/pull_request_template.md` hat eine Line-Ending-Warnung.
- AGENTS.md enthaelt ein zukunftiges Stand-Datum relativ zum Audit-Datum.

## 6. Erstellte/geaenderte Dateien

Durch diesen Auftrag erstellt:

- `docs/audit/codex_desktop_setup_audit.md`

Durch diesen Auftrag nicht geaendert:

- `.github/pull_request_template.md`
- `AGENTS.md`
- `docs/handoff/SESSION_HANDOFF_2026-04-24.md`
- `docs/operations/agent_operating_model.md`
- `docs/operations/automerge_policy.md`
- `docs/traceability/module_traceability_matrix.md`

## 7. Empfohlene naechste Linear-Issues

- `EMM-TBD Codex/Agent Operating Rules konsolidieren`: AGENTS.md,
  `docs/operations/agent_operating_model.md` und PR-Template gemeinsam
  pruefen, finalisieren und auf einen Branch mit Linear-ID bringen.
- `EMM-TBD Agent Merge- und Automerge-Policy dokumentieren`: untracked
  `docs/operations/automerge_policy.md` fachlich reviewen und als R0/R1-Doku
  einordnen.
- `EMM-TBD Modul-Traceability-Matrix reviewen`: untracked
  `docs/traceability/module_traceability_matrix.md` gegen M01-M14 und
  Definition of Done pruefen.
- `EMM-TBD Session-Handoff bereinigen`: untracked
  `docs/handoff/SESSION_HANDOFF_2026-04-24.md` aktualisieren oder archivieren;
  dabei die widerspruechliche Ahead-Angabe klaeren.

## 8. Blocker

- Kein konkretes Linear-Issue fuer diesen Audit-Auftrag angegeben; nach
  AGENTS.md ist ticketgebundenes Arbeiten Pflicht.
- Branch `main` enthaelt lokale uncommitted und untracked Aenderungen; kein
  Pull/Merge/Push sollte erfolgen, bis diese einem Linear-Issue und Branch
  zugeordnet sind.
