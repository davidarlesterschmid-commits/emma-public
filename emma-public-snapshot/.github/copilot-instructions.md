<!-- AUTOGENERIERT via tools/scripts/sync_instructions.ps1 - NICHT direkt editieren. Quelle: AGENTS.md -->
# AGENTS.md

README fuer AI-Coding-Agents (Claude Code, GitHub Copilot, Codex, Cursor, Jules).  
**Vollstaendiger Doku-Index:** [docs/README.md](docs/README.md). **Claude-Kurzregeln:** [CLAUDE.md](CLAUDE.md).

## Kontext emma

Flutter/Dart-Monorepo. Ziel: eine Mobilitaets-App fuer Mitteldeutschland. Android-first, iOS-uebertragbar. MVP ohne kostenpflichtige Dritt-APIs im Default-Build (Fakes, Open-Data, `--dart-define=USE_FAKES=true`).

## Repo-Layout

```
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
tools/scripts/         emma-git-bash.sh, sync_instructions.* (siehe tools/README)
```

## Setup

Voraussetzung: Flutter SDK (passend zu `pubspec` workspace SDK), Dart per Flutter.

```bash
dart pub global activate melos
dart pub get   # oder: melos bootstrap
```

## Tageskommandos

```bash
melos run analyze
melos run format
melos run test:unit
melos run test:flutter
```

Lokaler App-Start (Chrome):

```bash
cd apps/emma_app
flutter run -d chrome --dart-define=USE_FAKES=true
```

Details: [docs/technical/ENTWICKLER.md](docs/technical/ENTWICKLER.md).

**Git Bash / WSL (Wrapper):** `bash tools/scripts/emma-git-bash.sh help` (nutzt `dart pub global run melos …`; siehe [tools/README.md](tools/README.md)).

## Linear-/GitHub-Traceability

- Jeder Code-Branch und Pull Request muss eine Linear-ID im Format `TEAM-123` enthalten; fuer emma bevorzugt `EMM-123`.
- Branch-Schema: `codex/EMM-123-kurzer-scope`, `EMM-123-kurzer-scope` oder der von Linear erzeugte Branchname wie `name/emm-123-kurzer-scope`.
- PR-Titel enthaelt die ID eindeutig, z. B. `[EMM-123] Ticketing-Port einfuehren`.
- PR-Beschreibungen nutzen `.github/pull_request_template.md` und verlinken das Linear-Issue.
- Linear-IDs gehoeren nicht in Paketnamen, Imports, Klassen, Domainmodelle oder Runtime-Logik.

## Architekturregeln (harte Kante)

1. `apps/` importiert Pakete; Pakete importieren niemals `apps/`.
2. UI/Domain/Data getrennt. Keine Business-Logik in Widgets.
3. Ports in `package:emma_contracts`. Repositories in `domain_*`. Impls in `adapters/` oder `fakes/`.
4. Riverpod-Provider: Zielbild **nur App-Shell**; bekannte Abweichung `feature_auth` / Journey / employer → Task #37.
5. **Fake-First / keine bezahlten APIs (MVP-Default):** ADR-03, ADR-05; Details [docs/technical/ENTWICKLER.md](docs/technical/ENTWICKLER.md) (Abschnitt Fake-First), [docs/architecture/ADR-04_mvp_domain_scope.md](docs/architecture/ADR-04_mvp_domain_scope.md) (6+3+9).
6. Null-safe Dart, immutable Modelle.

## Definition of Done

[docs/planning/DEFINITION_OF_DONE.md](docs/planning/DEFINITION_OF_DONE.md) — gilt verbindlich fuer die **6 vertikalen** MVP-Domains (ADR-04).

## MVP-Prioritaet

Reihenfolge / Abhaengigkeiten: [docs/planning/MVP_BACKLOG_18_DOMAINS.md](docs/planning/MVP_BACKLOG_18_DOMAINS.md) (Inventar). **Arbeits-Scope:** [docs/planning/MVP_SCOPE.md](docs/planning/MVP_SCOPE.md).

## Verbotenes

- `package:emma_app/...` in `packages/**`
- Business-Logik in Widgets
- `export` ohne `show` in Barrels
- Kostenpflichtige APIs im MVP-Default-Build
- Mass-Rewrites ohne Null-Byte-Check
- Tarif-Logik im UI-Layer

## Lieferformat

Bei Bau-Auftraegen: 9 Sektionen (Ziel, Annahmen, fachliche Einordnung, Architekturentscheidung, Umsetzungsstand, Code, Tests, offene Punkte, naechster Schritt). Siehe [CLAUDE.md](CLAUDE.md).
