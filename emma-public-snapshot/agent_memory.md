# Agent Memory - emma Project

Dies ist eine Zusammenfassung der Architektur-Richtlinien und Core-Technologien für das Projekt "emma", abgeleitet aus der Repository-Dokumentation (insbesondere `TARGET_ARCHITECTURE.md`, `MAPPING.md`, `AGENTS.md` und `README.md`).

## Core-Technologien

- **Framework:** Flutter
- **Sprache:** Dart (Null-safe, immutable Modelle)
- **Monorepo-Tooling:** Melos (`dart pub workspace` in `pubspec.yaml`)
- **Architektur-Muster:** Port- und Adapter-Architektur (Clean Architecture Ansatz).
  - UI, Domain und Data bleiben getrennt.
  - Ports liegen in `package:emma_contracts`.
  - Repositories und fachliche Modelle liegen in den jeweiligen `domain_*` Paketen.
  - Implementierungen für externe Systeme liegen in `adapters/` oder `fakes/`.

## State-Management

- **Technologie:** Riverpod
- **Konvention:** Riverpod-Provider-Deklarationen gehören im Zielbild in die App-Shell (`apps/emma_app/lib/.../presentation/providers/`).
- **Ausnahmen:** Throw-by-default-Port-Provider in Feature-Wiring-Paketen, die per Bootstrap überschrieben werden. Keine neuen Riverpod-State-Provider in Fach-Paketen (Ausnahmen aus Legacy wie `feature_auth` etc. sind Tech-Schulden und kein Standard).
- **Navigation:** GoRouter

## Architektur- & Code-Konventionen (Styling/Regeln)

- **Abhängigkeiten:** `apps/` importiert Pakete; Pakete importieren niemals `apps/`.
- **UI:** Keine Business-Logik in Widgets.
- **MVP-Default (Fake-First):** Der MVP-Default nutzt Fakes (`fakes/`) oder Open-Data und setzt keine kostenpflichtigen Dritt-APIs (wie Google Maps) zwingend voraus (diese gelten nur als Fallback).
- **Entwicklungsfluss:** Neuer Code folgt dem Port-zuerst-Workflow (Port, Fake, Adapter, App-Shell-Provider, Bootstrap-Override).
- **Barrels:** Keine unbegrenzten Barrels; kein `export` ohne `show` oder definierte Schnittstelle.
- **Code-Library/Traceability:** Linear ist Projekt-Wahrheit (Scope, Akzeptanz), GitHub ist Code-Wahrheit.
