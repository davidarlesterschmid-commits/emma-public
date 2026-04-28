# Task #37 — feature_auth Riverpod-Provider in App-Shell heben

**Status:** umgesetzt  
**Stand:** 2026-04-24 (Analyse 2026-04-23; Erweiterung Employer+Journey-Hoist 2026-04-24)  
**Bezug:** `CLAUDE.md` ("Riverpod-Provider nur in App-Shell, nicht in
packages/**"), `ADR-05_chat_and_directions_behind_ports.md` (3a/3b/3c
als Muster), [../architecture/MAPPING.md](../architecture/MAPPING.md)

## Ergebnis (Auth)

- Provider leben in
  `apps/emma_app/lib/features/auth/presentation/providers/auth_providers.dart`
  (`authRepositoryProvider`, `accountRepositoryProvider`,
  `userAccountProvider`) und
  `apps/emma_app/lib/features/auth/presentation/view_models/auth_notifier.dart`
  (`authNotifierProvider`).
- Paket-Barrel `packages/features/feature_auth/lib/feature_auth.dart`
  exportiert nur Typen (`AuthRepositoryImpl`, `AccountRepositoryImpl`,
  Datasource-Klassen, UI-Primitives), keine Riverpod-Symbole.
- `grep '^(final|const).*Provider<' packages/features/feature_auth/**`
  liefert keine Treffer.
- Konsumenten (`profile_screen`, `tickets_screen`, `login_screen`,
  `auth_notifier_test`) zeigen auf den App-Shell-Pfad.

## Ergebnis (Folge-Hoists, Stand Repo)

- **Arbeitgebermobilität:** `apps/emma_app/lib/features/employer_mobility/presentation/providers/employer_mobility_providers.dart`
- **Journey:** `apps/emma_app/lib/features/journey/presentation/providers/journey_providers.dart`
- Zentraler Re-Export: `apps/emma_app/lib/core/providers.dart`

## 1. Ziel (erreicht)

Riverpod-**Provider-Instanzen** liegen nicht mehr in
`packages/features/feature_*` (keine `Provider<` / `NotifierProvider` /
`FutureProvider` in `packages/**/lib` fuer auth, employer_mobility, journey).

- **Auth:** `apps/emma_app/lib/features/auth/presentation/providers/auth_providers.dart` (Wiring zu `feature_auth`-Impls).
- **Arbeitgebermobilität:** `apps/emma_app/lib/features/employer_mobility/presentation/providers/employer_mobility_providers.dart` (u. a. `employerDioProvider`, Budget-/Benefit-/Jobticket-/Profil-Provider); Shell-Widgets mappen `AsyncValue` auf die parameterisierte UI in `feature_employer_mobility`.
- **Journey:** `apps/emma_app/lib/features/journey/presentation/providers/journey_providers.dart` (u. a. `journeyTariffPortProvider`, `journeyCaseProvider`, abgeleitete Selectors); `feature_journey` exportiert u. a. `JourneyRepositoryImpl` und portfreie Screens.

Hinweis: Frueher geplante Follow-up-Tasks **#46** (employer) / **#47** (journey) sind im **aktuellen** Repo durch den Hoist abgedeckt; aeltere Tickets mit denselben Nummern ggf. in Linear schliessen oder umbenennen.

## 2. Nicht-Ziele (unverändert)

- Kein vollständiger `AuthPort`-Einzug im MVP (siehe ursprüngliche Begründung in der Analyse).
- Fachliche Auth-/Journey-Flows unverändert; nur **Wo** die DI liegt.

## 3. Verifikation (manuell / CI)

- `Grep` auf `Provider<` / `NotifierProvider` in `packages/features/*/lib` → 0 (ausser ggf. generiertem Code).
- `dart analyze` auf `apps/emma_app`, `feature_employer_mobility`, `feature_journey` grün.
- `flutter test` in `apps/emma_app` und in betroffenen Paketen grün.

Hinweis: Root-`melos run analyze` kann wegen bekannten Workspace-`pubspec.yaml`-Glob-Warnungen scheitern; zielgerichtetes Analyze auf die obigen Pakete ist massgeblich.

## 4. Optionale Nacharbeiten

- `ProfileEditWidget` in `feature_auth` nutzt `ConsumerStatefulWidget` — reines `StatefulWidget` würde die letzte `flutter_riverpod`-Abhängigkeit im Widget entfernen (kosmetische Regelhärtung, kein Blocker).
- `domain_identity`-Barrel **#35**, `fake_identity` **#36**, `SecureStorage`-Port **#23** bleiben separate Tasks.

## 5. Archivierte Analyse (2026-04-23)

Die ursprüngliche detaillierte Soll/Migrationsbeschreibung (inkl. geplanter
`auth_providers.dart` unter `lib/core/`) galt dem damaligen
**Ist** in `feature_auth`. Faktische Pfade: siehe Abschnitt 1 oben
(`lib/features/auth/...` statt nur `lib/core/auth_providers.dart` — gleiche
Rolle, andere Ablage).
