# emma Repo Migration Checklist v2

## Ziel
Schrittweiser Umbau des aktuellen emma-Repo in die Workspace-Struktur ohne Big Bang.

## Arbeitsprinzipien
- Bestehende Plattformordner der Flutter-App bleiben erhalten.
- Neue Struktur zuerst parallel aufbauen, dann Code schrittweise verschieben.
- Keine direkte Providerlogik in Features.
- Domänen bleiben Flutter-frei.
- Verträge und Testpfade früh anlegen.

## Phase 1 – Workspace Bootstrap
- [ ] Root-Dateien anlegen: `pubspec.yaml`, `melos.yaml`, `analysis_options.yaml`
- [ ] `.vscode`-Setup ergänzen
- [ ] `contracts/` und `docs/migration/` anlegen
- [ ] `dart pub get` erfolgreich im Root ausführen

## Phase 2 – Core herauslösen
- [ ] Gemeinsame Utilities aus bisherigem `lib/` nach `packages/core/emma_core` verschieben
- [ ] Reine UI-Bausteine nach `packages/core/emma_ui_kit` verschieben
- [ ] Prüfen, dass `emma_core` kein Flutter importiert

## Phase 3 – Erste Fachvertikale Journey
- [ ] Journey-Entities und Use-Case-nahe Logik nach `packages/domains/domain_journey` verschieben
- [ ] Journey-UI nach `packages/features/feature_journey` verschieben
- [ ] Routing-/Map-Aufrufe nach `packages/adapters/adapter_maps` verschieben
- [ ] App nur noch als Composition Root nutzen

## Phase 4 – Weitere Domänen vorbereiten
- [ ] Identity-Schnitt aus bestehendem Code identifizieren
- [ ] Wallet-/Budget-Schnitt identifizieren
- [ ] Rules-/Tarif-Schnitt identifizieren
- [ ] Partnerhub-/Provider-Schnitt identifizieren

## Phase 5 – BFF und Contracts
- [ ] Bestehende Mock-/API-Zugriffe katalogisieren
- [ ] Mobile BFF-Endpunkte definieren
- [ ] OpenAPI- und AsyncAPI-Skelette erweitern
- [ ] DTOs aus `contracts/` und `emma_contracts` ableiten

## Phase 6 – Testhärtung
- [ ] Smoke-Test für App grün
- [ ] Erste Unit-Tests für Domain-Pakete grün
- [ ] Erste Adaptertests grün
- [ ] Contract-Fixtures in Tests einbinden

## Manuelle Review-Punkte
- [ ] Importgraph prüfen: kein `features -> adapters`
- [ ] Importgraph prüfen: kein `domains -> flutter`
- [ ] Bestehende Architekturleichen im alten `lib/` markieren
- [ ] Offene Migrationsreste dokumentieren
