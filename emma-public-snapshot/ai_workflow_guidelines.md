# AI Workflow Guidelines - Projekt `emma`

Verbindliche Master-Referenz fuer alle KI-Agenten (ChatGPT, Antigravity, Jules, Claude) im emma Operating Model. Diese Datei ist die einzige Wahrheit fuer Rollenverteilung, Scope-Grenzen, Risiko- und Gate-Logik.

**Stand:** 2026-04-27 - Linear: EMM-228 (umgesetzt), EMM-229 / EMM-230 / EMM-231 / EMM-232 (Akzeptanzaspekte eingearbeitet).

## 1. Projekt-Wahrheiten (System Truths)

Diese Quellen sind nicht verhandelbar:

| Wahrheit | Quelle | Bedeutung |
| :--- | :--- | :--- |
| Projekt-Wahrheit | **Linear** | Issues, Scope, Status, Risiko, Gate-Status. Keine Arbeit ohne Linear-Issue. |
| Code-Wahrheit | **GitHub** (`emma`-Repo) | Implementierung, PRs, Branches, CI-Status. |
| Strategische Steuerung | **ChatGPT** | Global Orchestrator: Operating Model, Scope-Schnitt, Gate-Entscheidungen. |
| Fachliche Vollstaendigkeit | **Modultabelle (M01-M14)** | Pflichtumfang Module. |
| Funktionale Anforderungen | **Funktionskatalog v1.0** | Muss-/Soll-Funktionen je Modul. |
| Lueckenpruefung | **Gleichwertigkeitsmatrix** | 1:1-UEbernahme- und Gap-Referenz gegen Bestandswelten. |
| Architektur-Wahrheit | **Zielarchitektur** (siehe `CLAUDE.md`, `AGENTS.md`, ADR-Index) | Keine parallele Architektur, keine Sackgassen. |

Wenn eine Quelle fehlt oder nicht geprueft wurde, ist sie als `nicht geprueft` zu markieren. Keine impliziten Annahmen.

## 2. Rollenverteilung im Multi-Agent Operating Model

Hybrides Modell mit klarer Hierarchie und Scope-Grenzen.

| Instanz | Rolle | Befugnis | Grenze |
| :--- | :--- | :--- | :--- |
| **ChatGPT** | Global Orchestrator | Operating-Model-Hoheit, Scope-Schnitt, Risikoklassifizierung, Gate-Vergabe, Architektur-Letztentscheid. | Keine direkte Code-Aenderung. Keine Repo-Schreibrechte. |
| **Antigravity (Local)** | Scoped Orchestrator & UI-Lead | Lokale Orchestrierung, Plan + Umsetzung **innerhalb eines genehmigten Scope Envelope**. UI-Lead, Browser-Subagent, visuelle Verifikation. Erstellt `implementation_plan.md`. | **Nur** innerhalb des Scope Envelope. Keine Architekturentscheidungen ausserhalb der Zielarchitektur. Keine Secrets / CI / Branch-Protection / Repo-Settings. |
| **Jules (Cloud)** | Execution Engine | Asynchrone Backend-Logik, Refactorings, Unit-Tests, Draft-PRs **nur fuer freigegebene Tasks**. CI-Auto-Fixing innerhalb des Tasks. | Nur Draft-PRs. Kein Merge. Keine Aufgaben ohne Linear-ID + freigegebenem Scope. Keine Massenaenderungen ohne expliziten Auftrag. |
| **Claude (emma Developer & Quality Gate)** | Entwicklung, Review, Test, Architektur | Implementierung R0-R2, Review-Verdict (PASS / FAIL / GATE_REQUIRED), Architektur- und Test-Bewertung, Traceability-Pruefung. R3+ nur Analyse / Plan / Gate-Vorbereitung. | Keine Umsetzung R3+ ohne Gate. Keine Secrets / CI / Rechte. |
| **Linear** | Project Management | Single Source of Truth fuer Issues, Scope, Status, Risiko, Module/Funktions-Referenz. | - |
| **GitHub** | Code-Basis | Branches, PRs, CI, Releases. | - |

## 3. Scope Envelope (verbindlich)

Der **Scope Envelope** ist die formale Schranke, innerhalb derer Antigravity bzw. ein anderer Scoped Orchestrator autonom arbeiten darf.

Ein Scope Envelope wird durch ein Linear-Issue definiert und enthaelt zwingend:

- **Linear-ID** (z. B. `EMM-228`)
- **Risikoklasse** (R0-R5)
- **Ziel** (was wird erreicht)
- **Modul-/Funktionsreferenz** (M01-M14, ggf. Funktionskatalog-ID wie `M03-F01`, ggf. Bestandsfunktion aus Gleichwertigkeitsmatrix)
- **Scope** (was darf geaendert werden, welche Dateien / Pakete / Domaenen)
- **Nicht-Scope** (was darf nicht angefasst werden)
- **Akzeptanzkriterien**
- **Checks** (welche Tests / Repo-Health-Checks)
- **Gate-Status** (offen / freigegeben / abgelehnt)

Ohne vollstaendigen Scope Envelope darf Antigravity nicht in Umsetzung gehen. Erweiterungen des Envelope erfordern eine neue Freigabe durch den Global Orchestrator (ChatGPT) oder den Menschen.

## 4. Linear-ID-Pflicht

- Keine Arbeit ohne Linear-Issue.
- Jeder Commit, Branch, PR, Plan und jede Memory-Aenderung referenziert die Linear-ID.
- Branch-Namen folgen `<linear-id>-<kurzbeschreibung>` (z. B. `emm-228-ai-workflow-guidelines`).
- PR-Titel beginnt mit `[EMM-XYZ]`.
- Wenn keine passende Modul-/Funktionsreferenz moeglich ist, ist der Punkt im Issue als **GAP** zu markieren.

## 5. Risikoklassen R0-R5

Jede Arbeit traegt genau eine Risikoklasse. Bei Unsicherheit gilt: **hoehere Klasse waehlen.**

| Klasse | Bedeutung | Erlaubter Modus |
| :--- | :--- | :--- |
| **R0** | Reine Doku, Meta, Kommentare. Kein Build betroffen. | Direkte Umsetzung. Reduzierte Checks per `docs/operations/test_scope_policy.md`. |
| **R1** | Doku, Tests-only, Struktur, kleine Refactorings ohne Verhaltensaenderung. | Direkte Umsetzung. Reduzierte Checks zulaessig, Begruendung im PR. |
| **R2** | Feature / Fix innerhalb bestehender Architektur. | Umsetzung mit Tests oder begruendeter Ausnahme. Volle Checks (`analyze`, `test:unit`, `test:flutter`). |
| **R3** | Architekturberuehrung, neue Domaene, neue Ports, Migrationen, Querschnitts-Eingriffe. | **Nur Analyse, Plan, Gate-Vorbereitung.** Keine Umsetzung ohne Gate. |
| **R4** | Aenderungen mit Auswirkung auf Zielarchitektur, Vertraege, Tarif-/Regelwerks-Logik, Datenmodell, Multi-Modul-Brueche. | **Gate Pflicht.** Plan + ADR + Migrationspfad + Risikolog. |
| **R5** | Sicherheit, Datenschutz, Secrets, Identitaet, CI/CD, Branch-Protection, Repo-Settings, Build-/Release-Pipeline. | **Gate Pflicht und expliziter menschlicher Auftrag.** Kein Agent darf R5 autonom umsetzen. |

## 6. PR-Gates

Verbindliche Gates fuer jeden Pull Request:

1. **Linear-Gate:** PR referenziert eine offene Linear-ID; Risiko und Modulbezug stehen im Issue.
2. **Architektur-Gate:** Aenderung liegt innerhalb der Zielarchitektur (siehe `CLAUDE.md` / `AGENTS.md` / ADRs). Keine parallele Architektur. Keine Verletzung der Monorepo-Importregeln (`apps/` -> Pakete; Pakete niemals -> `apps/`).
3. **Scope-Gate:** Aenderungen liegen innerhalb des freigegebenen Scope Envelope. Out-of-Scope-Diffs werden zurueckgewiesen.
4. **Quality-Gate:** Default-Checks (`melos run analyze`, `test:unit`, `test:flutter`, ggf. `integration_test`). Reduzierte Checks nur nach `docs/operations/test_scope_policy.md` mit Begruendung.
5. **Traceability-Gate:** Modul-/Funktionsreferenz vorhanden oder als GAP markiert.
6. **Risiko-Gate:** R3+ erfordert dokumentiertes Gate-Approval; ohne Approval kein Merge.
7. **Hygiene-Gate:** Keine Secrets, keine Massenformatierung, kein `print` / `debugPrint` ausserhalb Logger, keine `export` ohne `show`-Filter in Barrels.

Merge erst nach allen sieben Gates plus menschlicher Freigabe.

## 7. Jules-Draft-PR-Regeln

Jules darf ausschliesslich Draft-PRs erstellen und nur unter folgenden Bedingungen:

- Linear-Issue ist im Status `freigegeben` und besitzt einen vollstaendigen Scope Envelope.
- Risiko ist R0, R1 oder R2. R3+ ist Jules untersagt.
- Branch-Name und PR-Titel tragen die Linear-ID.
- PR-Beschreibung enthaelt: geaenderte Dateien, Tests, CI-Status, Modul-/Funktionsreferenz, Risikoklasse, Hinweis auf Scope Envelope.
- Keine Aenderungen an Secrets, CI-Workflows, Branch-Protection oder Repo-Settings.
- Keine Massenaenderungen (>X Dateien) ohne ausdruecklichen Auftrag.
- PR bleibt **Draft** bis menschliche Freigabe; kein Self-Merge.

Verstoesse fuehren dazu, dass der PR geschlossen oder unter `branch_outcome_policy.md` abgewickelt wird.

## 8. Architektur-Schutzregeln

Diese Regeln gelten fuer alle Agenten und ueberlagern individuelle Tasks:

- Keine parallele Architektur. Aenderungen folgen der Zielarchitektur (Feature-first, MVVM, Domain/Data/UI-Trennung, Ports in `package:emma_contracts`, Repos in `domain_*`, Impls in `adapters/` oder `fakes/`).
- Riverpod-Provider-Instanzen leben nur in der App-Shell (siehe `CLAUDE.md`).
- Keine Business-Logik in Widgets. Keine Tarif-Logik in UI.
- Fake-First gemaess ADR-05; keine kostenpflichtigen APIs im MVP-Default-Build (ADR-03).
- Keine harten Kopplungen an einen einzelnen Partner; Partneradapter sind austauschbar.
- Keine Aenderung an Secrets, CI, Rechten, Branch-Protection oder Repo-Settings ohne expliziten R5-Auftrag.
- Keine Halluzination ueber Fremdsysteme; nicht belegte Faehigkeiten sind als Annahme zu kennzeichnen.
- Keine Massenaenderungen ohne Auftrag.

## 9. Onboarding-Protokoll (Cold Start)

Jeder neu startende Agent fuehrt zwingend folgenden Lese-Lauf durch, bevor er Aenderungen vorschlaegt:

1. **Repo-Read:** `README.md`, `CLAUDE.md`, `AGENTS.md`, `docs/README.md`.
2. **Architektur:** `docs/architecture/MAPPING.md`, `docs/architecture/ADR_README.md`, relevante ADRs (insb. ADR-03, ADR-04, ADR-05).
3. **Planung & Status:** `docs/planning/STATUS.md`, `docs/planning/MVP_SCOPE.md`, `docs/planning/DEFINITION_OF_DONE.md`.
4. **Linear:** Aktuellen Issue + Modulbezug abrufen (MCP).
5. **Memory-Update:** `agent_memory.md` (Tech-Stack, State-Management, Styling, Konventionen) bestaetigen oder aktualisieren.

Im ersten Schritt sind keine Code-Aenderungen erlaubt.

## 10. Tooling & Environment

- **Monorepo:** Flutter / Dart, Melos. Default-Checks: `melos run analyze`, `melos run test:unit`, `melos run test:flutter`. Fallback: `dart pub global run melos run <script>`.
- **Fake-Build:** `--dart-define=USE_FAKES=true`.
- **Windows:** `git config --global core.longpaths true`. Null-Byte-Check nach Mass-Rewrites.
- **Jules-CLI:** `jules login` oder `npx jules`. Globaler NPM-Pfad in PATH. Docker (Elevated) lokal verfuegbar.
- **Antigravity:** Browser-Subagent fuer visuelle Verifikation gegen `localhost`; Screenshots im PR.
- **MCP-Anbindungen:** Linear, GitHub, Notion, Slack, Atlassian (siehe Plugin-Konfiguration).

## 11. Liefer- und Reviewmodi

**Entwicklungsmodus (R0-R2):** Code, Tests, Doku, Struktur. Vollstaendiger Output (Linear-Issue, Risiko, Ziel, Annahmen, Modul-/Funktionsreferenz, betroffene Dateien, Aenderungen, Tests, Risiken, Commit Message, PR Body).

**Entwicklungsmodus (R3+):** Analyse, Plan, ADR-Entwurf, Gate-Vorbereitung. Keine Umsetzung.

**Reviewmodus:** Verdict `PASS` / `FAIL` / `GATE_REQUIRED`, Struktur: Risikoklasse, geprueft, nicht geprueft, Blocker, Hinweise, Test-/Traceability-Bewertung, Merge-Empfehlung, Linear-Kommentar.

## 12. Verbotenes (Kurzliste)

- Arbeit ohne Linear-Issue.
- Umsetzung R3+ ohne Gate.
- Aenderung an Secrets, CI, Branch-Protection, Repo-Settings ohne R5-Auftrag.
- Parallele Architektur, Tarif-Logik in UI, kostenpflichtige APIs im MVP-Default.
- `package:emma_app/...` in `packages/**`.
- `export` ohne `show`-Filter in Barrels.
- Massenaenderungen ohne Auftrag.
- Implizite Annahmen ohne Kennzeichnung.

---

Aenderungen an dieser Datei selbst sind R1/R2 und brauchen ein Linear-Issue plus PR-Gate.
