# Definition of Done — emma-MVP (produktions-nah)

Eine Domaene gilt erst dann als **MVP-fertig**, wenn alle sechs Artefakt-
Gruppen existieren und ihre Qualitaetsgates gruen sind. Kurz-Checkliste pro
Domaene in `docs/planning/MVP_BACKLOG_18_DOMAINS.md`.

Bezug: `ADR-03_mvp_without_paid_apis.md`, `../technical/ENTWICKLER.md` (Fake-First), [ADR-04](../architecture/ADR-04_mvp_domain_scope.md), [MVP_SCOPE.md](MVP_SCOPE.md).

## 1. Domain-Paket `packages/domains/domain_<name>/`

- `lib/domain_<name>.dart` — Barrel mit `show`-Filter (keine bare `export`).
- `lib/src/entities/*.dart` — immutable Entities, Equatable-basiert, null-safe.
- `lib/src/value_objects/*.dart` — IDs, Money, DateRange, Geo-Koordinaten.
- `lib/src/repositories/*_repository.dart` — abstrakte Interfaces.
- `lib/src/services/*.dart` — reine Domain-Dienste (ohne IO).
- `test/*_test.dart` — Pure-Dart-Tests fuer Entities + Services, `package:test`.

## 2. Fake-Paket `packages/fakes/fake_<name>/`

- `lib/fake_<name>.dart` — Barrel.
- `lib/src/*_fake_repository.dart` — In-Memory- oder JSON-Fixture-basierte
  Repo-Impl, implementiert Domain-Repo-Interface.
- `lib/src/fixtures/` — mindestens 5 realistische Datensaetze, deterministisch.
- `lib/src/*_fake_event_stream.dart` — wo relevant, Timer-basierte
  Event-Simulation ueber `fake_realtime`.
- `test/*_fake_test.dart` — Smoketest: Fixture laden, Query, Result pruefen.

## 3. Feature-Paket `packages/features/feature_<name>/`

- `lib/feature_<name>.dart` — Barrel.
- `lib/src/presentation/screens/*_screen.dart` — Happy-Path-Screen mit
  **Loading-, Error-, Empty-Zustand**. Parameterisiert (kein Riverpod im Paket).
- `lib/src/presentation/widgets/*.dart` — kleine Widgets, einzeln testbar.
- `lib/src/presentation/state/*_state.dart` — immutable UI-State-Klassen.
- `lib/src/presentation/view_models/*_view_model.dart` — `ChangeNotifier`-
  oder `StateNotifier`-basiert, parameterisiert mit Repo und Nav-Callbacks.
- `lib/l10n/app_de.arb` + `app_en.arb` — alle sichtbaren Strings lokalisiert.
- A11y: `Semantics`-Labels auf allen interaktiven Elementen,
  `MergeSemantics` in Kachel-Widgets, Tap-Target min. 48x48 dp.
- `test/` — mindestens 1 Widget-Test pro Screen, 1 pro komplexem Widget.

## 4. App-Wiring `apps/emma_app/lib/`

- Riverpod-Provider-Bridge (`Consumer(...)` in `feature_<name>_providers.dart`),
  die Fake-Repo als Default einhaengt.
- Route in `lib/routing/app_routes.dart` + Navigation aus Haupt-Shell.
- `AppConfig.useFakes` respektiert; falls `false`, Echt-Adapter (spaeter).

## 5. Integration-Test `apps/emma_app/integration_test/`

- `<domain>_happy_path_test.dart` — `IntegrationTestWidgetsFlutterBinding`,
  durchlaeuft den Happy-Path-Screen, loest mindestens eine Aktion aus,
  assertet sichtbare Zustandsaenderung.
- Falls Realtime-Abhaengigkeit: `fake_realtime`-Events werden waehrend des
  Tests deterministisch abgespielt.

## 6. Dokumentation

- Eintrag in `docs/planning/STATUS.md` auf `MVP-fertig`.
- Falls neue Annahme ueber Bestandswelten: Nachtrag in
  `docs/architecture/CONTRACTS_VS_CODE.md` (und bei Bedarf Schema-Briefing).
- Falls neue Port- oder Contract-Aenderung: Nachtrag in
  `contracts/openapi/` oder `contracts/asyncapi/`.

## Qualitaetsgates (muss alle gruen sein)

- `melos run analyze` — kein `info`/`warning`/`error` im betroffenen Paket.
- `melos run format` — idempotent.
- `melos run test:unit` — gruen.
- `melos run test:flutter` — gruen fuer betroffenes Feature-Paket.
- `flutter test integration_test` in `apps/emma_app/` — gruen fuer den
  betroffenen Happy-Path.
- Kein `print`/`debugPrint` in Paket-Code (nur `emma_core`-Logger).
- Keine Secrets/Tokens im Repo.
- i18n-Strings in `app_de.arb` und `app_en.arb` keine Platzhalter-TODOs.

## Nicht Teil der MVP-DoD

- Echte Partner-Adapter (kommen in Phase 2).
- Produktions-Betriebshandbuch / Runbooks (kommen mit Phase-2-Release-Gate).
- Physische iOS-Deployments (Android-first, iOS bleibt nur bau- und
  analysefaehig).
