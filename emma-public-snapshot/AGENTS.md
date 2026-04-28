# AGENTS.md

README fuer AI-Coding-Agents (Claude Code, GitHub Copilot, Codex, Cursor, Antigravity, Jules).
**Vollstaendiger Doku-Index:** [docs/README.md](docs/README.md). **Claude-Kurzregeln:** [CLAUDE.md](CLAUDE.md). **Stand:** 2026-04-28.

## Truth Hierarchy

- Linear = project source of truth.
- GitHub = code source of truth.
- ChatGPT = strategic reasoning and prompt orchestration layer.
- **Operativer Kontext (Single Context Snapshot, EMM-139, Einfuehrung EMM-137):** [docs/operations/CONTEXT_SNAPSHOT.md](docs/operations/CONTEXT_SNAPSHOT.md) — versionierter Abgleich in den Linear-Phasen; kein Ersatz fuer EMM-127/EMM-132.

## Kontext emma

Flutter/Dart-Monorepo. Ziel: eine Mobilitaets-App fuer Mitteldeutschland. Android-first, iOS-uebertragbar. MVP ohne kostenpflichtige Dritt-APIs im Default-Build (Fakes, Open-Data, `--dart-define=USE_FAKES=true`).

## Agentenrollen

- ChatGPT: Strategie, Prompting, Governance und Entscheidungslogik. ChatGPT klaert Scope, Annahmen, Risiko, Modulbezug und Arbeitsauftraege.
- ChatGPT hat keine lokale Merge-Rolle und ist keine Repo-Wahrheit.
- Codex: primaerer deterministischer Repo-Executor fuer ticketgebundene Umsetzung, Doku, Tests, Commit, Push und PR. Codex arbeitet eng im vereinbarten Scope und darf R0/R1/R2 nach Gates policy-guarded agentisch mergen.
- Cursor: lokaler interaktiver Delivery-Agent fuer UI/Flutter und Mehrdateienarbeit. Cursor darf umsetzen, committen, pushen, PRs erstellen/aktualisieren und R0/R1/R2 nach Gates mergen; Desktop-Output ist nicht kanonisch.
- Antigravity: lokaler IDE-/UI-/Visual-Verification-/Orchestrierungsagent. Antigravity nutzt lokalen Kontext, UI, Browser/Visual Verification und MCPs, hat aber keine Code-/PR-Wahrheit; Ergebnis ist erst nach Commit/Push/PR oder Linear-Handoff kanonisch.
- Jules: PR-basierter Cloud-/GitHub-Executor fuer eng abgegrenzte R0/R1/R2-Tickets. Jules arbeitet ueber GitHub-Draft-PRs, darf nicht mergen, gilt nicht als Review-Gate und darf keine R3/R4/R5-Scope-Umsetzung ausfuehren.
- Claude: Review-/Gate-Agent fuer Architektur-, Spezifikations-, Testdesign- und Review-Fragen. Claude merged standardmaessig nicht; Ausnahme nur als explizit lokaler Execution-Agent mit denselben Gates.

## Mandatory Work Rules

- Keine Arbeit ohne Linear-Issue.
- Branches muessen eine Linear-ID enthalten, bevorzugt `EMM-123`.
- Bevorzugte Branch-Schemata: `codex/EMM-123-short-scope`, `cursor/EMM-123-short-scope`, `antigravity/EMM-123-short-scope`, `jules/EMM-123-short-scope`, `docs/EMM-123-short-scope`.
- Branch, PR und Commit-/PR-Kontext muessen die Linear-ID enthalten.
- Codex, Cursor und Antigravity duerfen ticketgebunden **stagen (nur explizite Pfade, nie `git add .`)**, committen, pushen und Pull Requests erstellen, wenn Branch, PR und Bericht die Linear-ID enthalten.
- Jules darf ticketgebunden Draft-PRs erstellen oder aktualisieren, aber nie mergen, nie Auto-Merge aktivieren und keine R3/R4/R5-Scope-Umsetzung ausfuehren.
- `antigravity/*` ist lokaler Handoff-/Arbeitsbranch, nicht finaler Abschluss ohne kanonisches Artefakt.
- `jules/*` erzeugt einen Draft-PR. Jules-PRs bleiben Draft, bis Scope, PR-Body, Checks und Handoff bestaetigt sind.
- Pro Linear-Issue darf hoechstens ein aktiver Jules-PR existieren; Duplicate-PRs muessen geschlossen oder klar als ersetzt kommentiert werden.
- Linear-IDs gehoeren nicht in Paketnamen, Imports, Klassen, Domainmodelle oder Runtime-Logik.
- Nicht loeschen, verschieben oder mass-formatieren, ausser das Issue erlaubt es explizit.
- Keine parallele Architektur einfuehren.
- Modulgrenzen nicht ohne R3/R4-Gate aendern.
- Identity, Payment, Wallet, Rules, Booking, Guarantee, Partnerhub oder Migrationen nicht ohne Risikoklassifikation anfassen.
- Kleine, reviewbare Aenderungen bevorzugen.
- Immer geaenderte Dateien, Tests und Blocker berichten.
- Cursor-Desktop-Output ist nicht kanonisch; Ergebnis zusaetzlich als PR-Kommentar, Linear-Kommentar oder Repo-Datei mit `changed_files[]`, `checks_run[]`, `commit_sha`, `pr_url`, `blocker[]` dokumentieren.
- Antigravity-Desktop-/IDE-Output ist nicht kanonisch; kanonisch wird er erst durch Commit/PR oder Linear-Handoff mit `changed_files[]`, `checks_run[]`, `commit_sha`, `pr_url`, `blocker[]`.
- Jules-Output ist nur der Draft-PR plus maschinenlesbarer PR-/Linear-Handoff; Chat-/Job-Logs ersetzen keine GitHub- oder Linear-Dokumentation.
- **Dependency Gate (EMM-132):** Vor erster sachlicher Umsetzung pruefen, ob das Issue die noetigen Eingaben hat. Bei fehlenden Inputs: **STOP**, Zustand **BLOCKED_BY_INPUT** in Linear; Details [docs/operations/dependency_gate.md](docs/operations/dependency_gate.md) (keine Doppelung der EMM-127-Templates).
- **Single Context Snapshot (EMM-139, Einfuehrung EMM-137):** Kanonischer Startkontext und Drift-Regeln in [docs/operations/CONTEXT_SNAPSHOT.md](docs/operations/CONTEXT_SNAPSHOT.md). **START** muss die **Snapshot-Version** dokumentieren; **REVIEW REQUEST** muss **Snapshot-Version** und **Main-SHA (Snapshot)** nennen; **GATE OUTCOME** prueft den Snapshot gegen PR/Diff; **ABSCHLUSS** aktualisiert den Snapshot oder begruendet die Auslassung. Bei Abweichung: **BLOCKED_BY_CONTEXT_DRIFT** (nicht **BLOCKED_BY_INPUT**; Details im Snapshot-Dokument und in [docs/operations/review_merge_automation.md](docs/operations/review_merge_automation.md)).
- **Neue Linear-Issues (MCP/API):** Vorlage, Zwei-Schritt-Muster, Stopp nach max. 2 fehlgeschlagenen Create-Versuchen: [docs/planning/LINEAR_ISSUE_TEMPLATE.md](docs/planning/LINEAR_ISSUE_TEMPLATE.md).
- **PR-Hygiene:** Pro Issue moeglichst ein aktiver PR; Draft-PRs regelmaessig triagieren; vor **Ready for review** gegen `main` integrieren. Details: [docs/operations/pr_hygiene.md](docs/operations/pr_hygiene.md). **Wann** Merge, Cherry-pick oder Schliessen: [docs/operations/branch_outcome_policy.md](docs/operations/branch_outcome_policy.md).
- **Connector-/MCP-Fallbacks:** GitHub-MCP/Connector ist Pflicht fuer PR-/Code-Status; Linear-MCP/Connector ist Pflicht fuer Issue-/Projektstatus. Fehlender Linear-Zugriff blockiert mit **BLOCKED_BY_LINEAR_ACCESS**; fehlender GitHub-Zugriff mit **BLOCKED_BY_GITHUB_ACCESS**; inkonsistenter MCP-Zustand mit **BLOCKED_BY_MCP_STATE**; nicht belegbarer lokaler Zustand mit **BLOCKED_BY_LOCAL_STATE**; Snapshot-Abweichungen mit **BLOCKED_BY_CONTEXT_DRIFT**.
- **Token-Effizienz:** Single Context Snapshot vor langen Agentenlaeufen nutzen, Linear-Issue zuerst lesen, minimale Referenzdateien statt Vollrepo-Lesung verwenden, wenn moeglich PR-Diff statt Vollrepo lesen, Ask Linear fuer Issue-Status, GitHub fuer PR-/Code-Status, ChatGPT nur fuer Entscheidung/Bewertung/Prompting, kurze maschinenlesbare Handoffs bevorzugen.
- **Daily Review & Retro Gate (EMM-227):** Verbindlicher Tagesabschluss vor Sessionende. Pflichtbestandteile: OPL-Abgleich, Linear-/GitHub-Truth-Sync, Tokenoekonomie und Fehlerkommentar-Hygiene. Output Contract maschinenlesbar in Linear (z. B. am Anker EMM-227). Details: [docs/operations/daily_review_retro.md](docs/operations/daily_review_retro.md).
- **Fehlerkommentar-Regel:** Wenn Linear-/PR-Kommentare oder Tool-Aktionen fehlschlagen, in Ersatzkommentaren **keine URLs** verwenden. Stattdessen Issue-/PR-bezogene Kurzreferenzen (`EMM-XXX`, `PR#NNN`, `Branch: <name>`, `Snapshot: <version>`) nutzen. Details: [docs/operations/daily_review_retro.md](docs/operations/daily_review_retro.md).
- **Agent Output Contract:** Codex, Cursor, Antigravity und Jules liefern zum Abschluss `changed_files[]`, `checks_run[]`, `branch`, `commit_sha`, `pushed: true/false`, `pr_url_or_number`, `pr_created_or_updated: true/false`, `merge_done: true/false`, `closed_prs[]`, `blocker[]`. Freitext ist Zusatz, nicht Abschluss. Desktop-/UI-only Output ist ungueltig. Cloud-only Output ist ungueltig, wenn kein PR-/Linear-Artefakt existiert. Fehlender Commit/Push/PR muss als Blocker gemeldet werden.

## Repo-Layout

```text
apps/emma_app/          App-Shell (Routing, Bootstrap, Riverpod)
packages/
  core/                 emma_core, emma_contracts, emma_ui_kit, emma_testkit
  domains/              domain_* (je nach Scope)
  features/             feature_*
  adapters/             adapter_*
  fakes/                fake_*
services/bff_mobile/    BFF (Dart/Shelf)
contracts/              openapi, asyncapi, jsonschema, fixtures
docs/                   zentrale Dokumentation (siehe docs/README.md)
docs/_archive/          ersetzte Einzeldateien (Referenz)
tools/scripts/          emma-git-bash.sh, sync_instructions.* (siehe tools/README)
```

## Setup

Voraussetzung: Flutter SDK passend zum `pubspec` Workspace SDK, Dart per Flutter.

```bash
dart pub global activate melos
dart pub get
```

Optional, wenn `melos` im PATH verfuegbar ist: `melos bootstrap`.

## Tageskommandos

```bash
melos run analyze
melos run format
melos run test:unit
melos run test:flutter
```

### Pflicht-Checks (Melos) — risikobasierte Testbreite

**Default:** Vor Merge/PR gelten fuer Code-/Build-beeinflussende Aenderungen die **vollen** Melos-Checks wie oben.

**Ausnahme (absichtlich weniger teuer):** Nur fuer **R0/R1**, nur wenn die Aenderung **keinen** Dart-/Build-/Tooling-Pfad beruehrt (typisch: reine Doku, reine GitHub-Templates, Link-Fixes). Dann **reduzierte** Breite zulaessig, aber **nur** mit nachvollziehbarer Begruendung und dokumentierten Ersatzchecks im PR (siehe [docs/operations/test_scope_policy.md](docs/operations/test_scope_policy.md)).

**Wenn unsicher:** **volle** Checks fahren oder Risikoklasse/Outcome konservativer waehlen (`GATE_REQUIRED` / R2) — `melos` ist billiger als ein regressionsreicher Merge.

Lokaler App-Start (Chrome):

```bash
cd apps/emma_app
flutter run -d chrome --dart-define=USE_FAKES=true
```

Details: [docs/technical/ENTWICKLER.md](docs/technical/ENTWICKLER.md).

**Git Bash / WSL (Wrapper):** `bash tools/scripts/emma-git-bash.sh help` nutzt u. a. `dart pub global run melos ...`; siehe [tools/README.md](tools/README.md). **Ohne `melos` im PATH:** `dart pub global run melos run analyze` statt `melos run analyze`.

## Architekturregeln

1. `apps/` importiert Pakete; Pakete importieren niemals `apps/`.
2. UI/Domain/Data getrennt. Keine Business-Logik in Widgets.
3. Ports in `package:emma_contracts`. Repositories in `domain_*`. Implementierungen in `adapters/` oder `fakes/`.
4. Riverpod-Instanzen (`Provider`, `NotifierProvider`, `FutureProvider`, ...) gehoeren im Zielbild nur in die App-Shell unter `apps/emma_app/lib/.../presentation/providers/`. `feature_auth`, `feature_employer_mobility` und `feature_journey` bleiben ohne Paket-Provider; andere `feature_*`-Abweichungen sind Tech-Schuld, nicht Standard.
5. Fake-First / keine bezahlten APIs im MVP-Default-Build: ADR-03, ADR-05, ADR-06 und ADR-07 gelten. Oeffentliche kostenlose APIs duerfen zur Laufzeit mit Fakes als Fallback genutzt werden; Google Maps / Gemini erst zum Livegang.
6. Null-safe Dart, immutable Modelle.

## Definition of Done

M01-M16 aus [docs/architecture/MAPPING.md](docs/architecture/MAPPING.md) sind die kanonische fachliche Modul-Taxonomie. B01-B14 aus [docs/architecture/module_traceability.md](docs/architecture/module_traceability.md) sind Backlog-/Implementierungsnachweise und ersetzen keine normative Moduldefinition. Die 6 vertikalen MVP-Domains aus ADR-04 sind Delivery- und Abnahmeschnitte. Diese Sichten konkurrieren nicht, sondern ergaenzen sich.

Eine Funktion ist done, wenn sie:

- fachlich M01-M16 zugeordnet ist,
- technisch im Repo auffindbar ist,
- getestet ist,
- dokumentiert ist.

Fuer die 6 vertikalen MVP-Domains gilt zusaetzlich [docs/planning/DEFINITION_OF_DONE.md](docs/planning/DEFINITION_OF_DONE.md).

## Risk Classes

Die verbindlichen Risikoklassen R0-R5 und Merge-Gates stehen in [docs/operations/automerge_policy.md](docs/operations/automerge_policy.md).

- R0: reine Doku-/Meta-Aenderung ohne Produktverhalten.
- R1: niedriges Risiko ohne Runtime-Logik.
- R2: kleine Feature- oder Fix-Aenderung innerhalb bestehender Struktur.
- R3: Architektur- oder Modulgrenzen-Impact.
- R4: kritischer Domain-, Daten-, Release- oder Betriebs-Impact.
- R5: destruktive, sicherheitsrelevante, externe oder irreversible Aenderung.

Agentenbetrieb und Rollenfluss sind in [docs/operations/agent_operating_model.md](docs/operations/agent_operating_model.md) beschrieben.

Agentenmatrix und Tool-Grenzen fuer Antigravity, Jules und bestehende Rollen: [docs/operations/agent_tool_matrix.md](docs/operations/agent_tool_matrix.md).

Review-/Merge-Ablauf fuer R0-R2 und die zugehoerigen PR-/Linear-Kommentar-Templates sind in [docs/operations/review_merge_automation.md](docs/operations/review_merge_automation.md) beschrieben.

Session-Start- und Branch-Sync-Protokoll (ohne Template-Duplikate, EMM-127-konform): [docs/operations/session_start_and_branch_sync.md](docs/operations/session_start_and_branch_sync.md).

Dependency Gate: Input-Pflicht vor Umsetzung (EMM-132, EMM-130 Lifecycle-Bezug): [docs/operations/dependency_gate.md](docs/operations/dependency_gate.md).

Single Context Snapshot (Governance, EMM-139, Einfuehrung EMM-137): [docs/operations/CONTEXT_SNAPSHOT.md](docs/operations/CONTEXT_SNAPSHOT.md).

Erster dokumentierter End-to-End-Agentenlauf (Ticketfluss in der Praxis, Referenz EMM-87): [docs/operations/first_e2e_run.md](docs/operations/first_e2e_run.md).

**Cursor IDE:** Einrichtung und Querverweise: [docs/operations/cursor_setup.md](docs/operations/cursor_setup.md). Editor-Projektregeln (Kurz, Kanon bleibt diese Datei): [.cursor/rules/emma-agent-rules.mdc](.cursor/rules/emma-agent-rules.mdc).

## Review Request Format

Review-Anfragen an Claude muessen als PR- oder Linear-Kommentar strukturiert sein und mindestens enthalten:

- Linear-Issue und PR-Link.
- **Snapshot-Version** und **Main-SHA (Snapshot)** gemaess [docs/operations/CONTEXT_SNAPSHOT.md](docs/operations/CONTEXT_SNAPSHOT.md) (siehe EMM-127 **REVIEW REQUEST** in [docs/operations/review_merge_automation.md](docs/operations/review_merge_automation.md)).
- Zielhandlung: Review, Merge-Empfehlung, Risikoentscheidung oder No-Merge-Begruendung.
- Deklarierte Risikoklasse R0-R5 mit kurzer Begruendung.
- Scope und betroffene Dateien oder Repo-Bereiche.
- Akzeptanzkriterien und relevante Gates aus [docs/operations/automerge_policy.md](docs/operations/automerge_policy.md).
- Ausgefuehrte Tests, vorhandene GitHub-Checks oder begruendete Auslassung.
- Gewuenschter Review-Fokus: Architektur, Tests, Spezifikation, Regression, Traceability oder Governance.
- Hinweis, ob ein Auto-Merge nach PASS beabsichtigt ist.

## Claude Response Format

Claude-Reviews muessen mit genau einem Outcome enden: `PASS`, `FAIL` oder `GATE_REQUIRED`.

Pflichtfelder:

- Outcome: `PASS` / `FAIL` / `GATE_REQUIRED`
- Risikoklasse deklariert und Risikoklasse laut Review.
- Gepruefter Scope und relevante Regelquellen.
- Befunde mit Blockern getrennt von Hinweisen.
- Merge-Empfehlung: `Merge`, `Nicht mergen` oder `Hochstufen auf R3+`.
- Evidenz: gepruefte Dateien, Tests, Checks, Referenzen.

Das vollstaendige PR-Kommentar-Template steht in [docs/operations/review_merge_automation.md](docs/operations/review_merge_automation.md).

## Merge Decision Rule

- R0 und R1 duerfen von Codex oder Cursor selbst gemerged werden, wenn PR-Template, Self-Check, vorhandene Checks oder begruendete Auslassung sowie Linear `GATE OUTCOME` + `ABSCHLUSS` vollstaendig sind.
- R2 darf nur nach LLM-Gate `PASS` eines API-Providers, passenden Tests, keinen offenen P1/P2-Punkten sowie Linear `GATE OUTCOME` + `ABSCHLUSS` selbst gemerged werden.
- R3, R4 und R5 duerfen nie automatisch oder selbststaendig durch Agenten gemerged werden. Maintainer-Entscheidung ist Pflicht.
- `FAIL` blockiert den Merge bis zur Korrektur und erneutem Review.
- `GATE_REQUIRED` blockiert Auto-Merge und hebt den PR auf die hoehere plausible Risikoklasse.
- Vor jedem Merge muss im Linear-Issue ein `GATE OUTCOME` mit `PASS` stehen; der Reviewer prueft den Snapshot gegen PR/Diff (siehe `GATE OUTCOME` in [docs/operations/review_merge_automation.md](docs/operations/review_merge_automation.md)). Nach dem Merge muss der Merge-Commit-SHA im Linear `ABSCHLUSS` dokumentiert werden; zusaetzlich wird `docs/operations/CONTEXT_SNAPSHOT.md` aktualisiert oder die **Auslassung** einer Aktualisierung im `ABSCHLUSS` begruendet.

## MVP-Prioritaet

Reihenfolge und Abhaengigkeiten: [docs/planning/MVP_BACKLOG_18_DOMAINS.md](docs/planning/MVP_BACKLOG_18_DOMAINS.md). Arbeits-Scope: [docs/planning/MVP_SCOPE.md](docs/planning/MVP_SCOPE.md). Verbindliche Product-Entscheidungen: [docs/planning/MVP_PRODUCT_DECISIONS_2026-04-26.md](docs/planning/MVP_PRODUCT_DECISIONS_2026-04-26.md).

## Verbotenes

- `package:emma_app/...` Imports in `packages/**`.
- Business-Logik in Widgets.
- Unbegrenzte Barrels: kein `export` ohne `show`.
- Kostenpflichtige APIs als MVP-Pflicht oder im MVP-Default-Build.
- Loeschungen, Verschiebungen oder Massenformatierungen ohne explizites Ticket und passendes Gate.
- Tarif-Logik im UI-Layer.

## Lieferformat

Bei Bau-Auftraegen: 9 Sektionen (Ziel, Annahmen, fachliche Einordnung, Architekturentscheidung, Umsetzungsstand, Code, Tests, offene Punkte, naechster Schritt). Siehe [CLAUDE.md](CLAUDE.md).
