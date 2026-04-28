# Entwickler- und Tooling-Guide (konsolidiert)

**Herkunft:** ehem. `vscode_dev_and_test_guide.md`, `fake_first_strategy.md`, `WORKSPACE_MIGRATION.md` (siehe `docs/_archive/2026-04-consolidation/`).

**Git Bash (Kurzbefehle):** Im Repo-Root `bash tools/scripts/emma-git-bash.sh help` — ruft u. a. `melos run analyze` und `flutter run …` mit `USE_FAKES=true` (ohne manuelles `PATH`-Setup fuer `melos`, siehe [../../tools/README.md](../../tools/README.md)).

---
# VS-Code-Dev- und Test-Guide

Arbeitsumgebung fuer emma unter VS Code mit GitHub Copilot Chat (Claude-Backend).
Fokus: Flutter-App bauen, debuggen und testen ohne Android-Emulator-Pflicht
und ohne kostenpflichtige Drittpartei-APIs.

## Voraussetzungen (einmalig)

1. **Flutter SDK 3.24+**, manuell installiert unter `C:\dev\flutter`.
   `C:\dev\flutter\bin` in `PATH` eintragen (User-PATH, nicht System).
2. **Dart SDK** kommt mit Flutter.
3. **VS Code Extensions**:
   - `Dart-Code.dart-code`
   - `Dart-Code.flutter`
   - `GitHub.copilot`
   - `GitHub.copilot-chat`
4. **Git Bash** (kommt mit Git-for-Windows).
5. **Melos**: `dart pub global activate melos`.

Kein Android Studio noetig, solange Tests ueber Chrome oder Windows-Desktop
laufen. Android-Emulator ist optional.

## Erste Inbetriebnahme

In PowerShell oder VS-Code-Integrated-Terminal:

```powershell
cd <LOCAL_USER_PATH>
melos bootstrap
melos run analyze
melos run test:unit
melos run test:flutter
```

Alle vier Schritte muessen gruen sein, bevor Feature-Arbeit beginnt.

## Empfohlene VS-Code-Tasks

`.vscode/tasks.json` enthaelt (nach Erstinitialisierung via
`tools/scripts/init_vscode_tasks.ps1`):

| Task Label                | Command                                |
|---------------------------|----------------------------------------|
| emma: bootstrap           | `melos bootstrap`                      |
| emma: analyze             | `melos run analyze`                    |
| emma: format              | `melos run format`                     |
| emma: test:unit           | `melos run test:unit`                  |
| emma: test:flutter        | `melos run test:flutter`               |
| emma: test:integration    | `flutter test integration_test` (in emma_app) |
| emma: run web             | `flutter run -d chrome --dart-define=USE_FAKES=true` |
| emma: run windows         | `flutter run -d windows --dart-define=USE_FAKES=true` |

Ausfuehren via `Ctrl+Shift+P` → "Tasks: Run Task".

## App lokal starten

### Option A — Chrome (empfohlen, keine Emulator-Installation)

```powershell
cd apps\emma_app
flutter run -d chrome --dart-define=USE_FAKES=true
```

### Open-Data: Chat-Directions und POIs ohne Google (ohne USE_FAKES)

Wenn `USE_FAKES=false` und **kein** `GOOGLE_MAPS_API_KEY` gesetzt ist, haengt
die App `DirectionsOpenDataAdapter` ein: **Nominatim** (Geocoding, ODbL) +
**OSRM**-Demo (Strasse/Fuss, BSD-2-Clause). `PoiSearchPort` nutzt Nominatim
(bei `USE_FAKES=true`: [FakePoiSearchAdapter](../../packages/fakes/fake_maps/lib/src/fake_poi_search_adapter.dart)).

Optionale Host-Overrides (eigene Infrastruktur):

```bash
flutter run -d chrome \
  --dart-define=USE_FAKES=false \
  --dart-define=NOMINATIM_BASE_URL=https://nominatim.openstreetmap.org \
  --dart-define=OSRM_BASE_URL=https://router.project-osrm.org \
  --dart-define=NOMINATIM_USER_AGENT=emma/0.1\ \(Kontakt:\ you@example.com\)
```

Hinweis: Nominatim verlangt einen aussagekraeftigen `User-Agent`; die
öffentliche OSRM-Demo ist nur fuer Entwicklung gedacht — fuer Last
eigenen OSRM/Router betreiben.

Chrome DevTools koppelt automatisch. Hot-Reload `r`, Hot-Restart `R` im
Terminal.

### Option B — Windows-Desktop

```powershell
flutter config --enable-windows-desktop
cd apps\emma_app
flutter run -d windows --dart-define=USE_FAKES=true
```

### Option C — Android-Emulator (optional)

Nur wenn Android-Studio und SDK bereits installiert sind.

```powershell
flutter emulators --launch <Emulator-Name>
cd apps\emma_app
flutter run --dart-define=USE_FAKES=true
```

## Tests ausfuehren

### Unit- und Widget-Tests

- Editor-Gutter: "Run test" / "Debug test" direkt an der Test-Funktion.
- Test-Explorer-View (links): alle Tests im Workspace, Filter per Paket.

### Integration-Tests

```powershell
cd apps\emma_app
flutter test integration_test --dart-define=USE_FAKES=true
```

### Alle Tests ueber Melos

```powershell
melos run test:unit         # pure Dart in domain_* und contract_*-Paketen
melos run test:flutter      # Widget-/Integration in feature_* und App
```

## Debugging

- Breakpoints via Klick auf Zeilennummer.
- `F5` startet Debug auf Default-Device (Chrome, falls konfiguriert).
- `launch.json` liefert Flavor-Konfigurationen (dev, stage, prod-fake).
- Flutter DevTools (DevTools-Button im Debug-Panel): Widget-Inspector,
  Timeline, Memory.

## GitHub Copilot Chat Nutzung

- Repo-weite Instructions: `.github/copilot-instructions.md` wird
  **automatisch** bei jeder Chat-Anfrage geladen.
- Inline-Slash-Commands: `/tests`, `/explain`, `/fix`, `/doc`.
- `@workspace` Prefix zwingt Copilot, den Repo-Kontext einzubeziehen.
- Fuer Bau-/Aenderungsauftraege die 9-Sektionen-Lieferstruktur aus
  `CLAUDE.md` referenzieren (siehe dort: Ziel, Annahmen, Fachliche
  Einordnung, Architekturentscheidung, Umsetzungsstand, Code, Tests,
  Offene Punkte, Naechster sinnvoller Schritt).

## Gotchas

- **Null-Byte-Pollution** bei grossen File-Rewrites ueber automatisierte
  Writer: Check per PowerShell
  `(Get-Content file.dart -Raw) -match "`0"` — muss `False` sein.
- **virtiofs-unlink-Block** ist ein Relikt aus der Cowork-Linux-Sandbox
  und im reinen VS-Code-Workflow irrelevant.
- **Melos `NoScriptException`**: Der `melos:`-Block muss in `pubspec.yaml`
  stehen. Eine alte `melos.yaml` wird von Melos 7 ignoriert.
- **Flutter-Web-Build-Cache**: Bei unerklaerlichen Fehlern
  `flutter clean && flutter pub get` im `apps/emma_app/`-Verzeichnis.
- **Path-Laenge unter Windows**: Wenn `pub get` ueber 260 Zeichen
  bricht, `git config --global core.longpaths true` setzen.
- **USE_FAKES-Flag** / Fakes: Im schnellen **CI-** **Gate** und in **Unit-/** **Widget-** **Tests** bleibt der Fake-**Modus** **Vorrang** (keine zwingende Live-**Netz-** **Abhaengigkeit**), siehe [ADR-06](../architecture/ADR-06_mvp_open_data_client_and_ci_matrix.md). In der laufenden **Demo-** **App** duerfen kostenlose, oeffentliche Dienste (z. B. **GTFS**) **direkt** genutzt werden, **Fakes** dienen **als** **Offline-/**Fehler- **Fallback** (ADR-06). **Ohne** `USE_FAKES=true` kann das bisherige Verhalten (leere **Adapter-**Stubs) in Teilen noch **bestehen;** Anpassung **gehoert** zu **Build-**/**Shell-** **Tasks** (nicht in diesem **Guide** final).

## Referenz-Commands Cheat-Sheet

```powershell
# Bootstrap
melos bootstrap

# Qualitaetsgate
melos run analyze; melos run format; melos run test:unit; melos run test:flutter

# Lokaler Run im Fake-Modus
cd apps\emma_app ; flutter run -d chrome --dart-define=USE_FAKES=true

# Integration-Test
cd apps\emma_app ; flutter test integration_test --dart-define=USE_FAKES=true
```

---

# Fake-First-Strategie
# Fake-First-Strategie

Grundsatz: **Jede Domaene liefert vor dem echten Adapter einen Fake-Adapter.**
Fakes leben unter `packages/fakes/fake_<name>/` und implementieren dasselbe
Port-Interface wie der spaetere Produktiv-Adapter.

Bezug: `ADR-03_mvp_without_paid_apis.md`, `DEFINITION_OF_DONE.md`.

## Architektur-Platzierung

```
  feature_<X>          (UI + ViewModel)
        |
        v
  domain_<X>_repository      (Interface)
        ^
        |
        +--- fake_<X>     (MVP-Impl, immer bau- und testbar)
        +--- adapter_<X>  (Phase-2-Impl, echte Partner-API)
```

App-Shell entscheidet per `AppConfig.useFakes` (Default `true`), welche
Impl via Riverpod eingehaengt wird. Ports liegen zentral in
`package:emma_contracts/emma_contracts.dart` (u. a. `InvoiceListPort` für
Rechnungs-Demos). Kundenkonto-Fakes: `package:fake_customer_account` — die
Mock-Auth-IDs sind `user-demo-001` / `user-pilot-002` (Keys der eingebetteten
JSON-Fixtures).

## Open-Data- und Fixture-Quellen je Partner / Domaene

**MVP-Regel (ADR-03):** Soweit sinnvoll **Open-Source-Stacks und Open-Data**; **Google Maps** (Directions/Places/Tiles) **erst ab Livegang** mit Keys und Vertrag — im MVP-Default `USE_FAKES=true` bzw. TRIAS/OSM/Open-Data. Siehe [ADR-03_mvp_without_paid_apis.md](../architecture/ADR-03_mvp_without_paid_apis.md) (Abschnitt Open-Source-Maxime).

| Domaene / Partner         | MVP-Fake-Quelle                                              | Lizenz        |
|---------------------------|--------------------------------------------------------------|---------------|
| Fahrplan (MDV)            | GTFS-Static Export via MDV-OpenData / DELFI                  | CC-BY 4.0     |
| Karten-Tiles              | OpenStreetMap via `flutter_map` + Tile-Proxy oder offline    | ODbL 1.0      |
| Routing (ÖPNV)            | OSRM-Public-Demo / GraphHopper-Test / Offline-Fixture-Routes | BSD-2-Clause  |
| Haltestellen              | MDV-Stops-CSV / OVAL-ODP                                      | CC-BY 4.0     |
| Geocoding                 | Nominatim (Public mit Rate-Limit, sonst Fixture)             | ODbL 1.0      |
| Wetter                    | Brightsky.dev (DWD-Daten)                                     | CC-BY 4.0     |
| Sharing (Fahrrad/Scooter) | GBFS-Public-Feeds (nextbike, TIER)                           | GBFS / CC0    |
| Carsharing                | JSON-Fixture (teilAuto ohne freien Feed)                      | proprietaer-Fixture |
| On-Demand                 | JSON-Fixture                                                  | intern        |
| Taxi                      | JSON-Fixture + Pseudo-Dispatch                                | intern        |
| Ticketing (Barcode/QR)    | JSON-Fixture + Pseudo-QR (kein VDV-KA-Signing im MVP)         | intern        |
| D-Ticket-Pruefung         | Fake-Regel-Engine aus YAML-Konfig                             | intern        |
| Tarifserver               | YAML-basiertes Regelwerk in `fake_tariff/fixtures/`           | intern        |
| Payments                  | In-Memory-Ledger, Pseudo-PSP (kein Stripe/Adyen)              | intern        |
| Realtime-Events (CI/CO,   | `fake_realtime` — Timer-basiert, Fixture-Events               | intern        |
|  Verspaetungen)           |                                                               |               |
| Identitaet / OIDC         | Lokaler Pseudo-OIDC-Flow im `fake_identity`                   | intern        |
| Kundenkonto (Rechnungen) | `fake_customer_account` (Fixtures) + `InvoiceListPort`         | intern        |

## Code-Konvention fuer Fakes

- Klasse: `<Name>FakeRepository implements <Name>Repository`.
- Fixtures: `lib/src/fixtures/*.json` oder `*.yaml`, ueber
  `rootBundle.loadString` im Test oder direkt aus Paket-Asset.
- Deterministisch: kein `Random()` ohne festen Seed, keine
  `DateTime.now()` ohne Clock-Injection via `emma_core.Clock`.
- Event-Streams: ueber `fake_realtime.EventBus`, nicht direkt
  `StreamController` im Fake.
- Logging: `emma_core.Logger`, nie `print`.
- Public-API nur via Barrel exportiert, `show`-Filter immer explizit.

## Beispiel-Skelett eines Fakes

```dart
// packages/fakes/fake_identity/lib/fake_identity.dart
library fake_identity;

export 'src/identity_fake_repository.dart' show IdentityFakeRepository;

// packages/fakes/fake_identity/lib/src/identity_fake_repository.dart
import 'package:emma_contracts/emma_contracts.dart';
import 'package:domain_identity/domain_identity.dart';

class IdentityFakeRepository implements IdentityRepository {
  IdentityFakeRepository({List<UserAccount>? seed})
      : _accounts = List.of(seed ?? _defaultSeed);

  final List<UserAccount> _accounts;

  static final _defaultSeed = <UserAccount>[
    UserAccount.demo(id: 'u-emp-001', role: UserRole.employee),
    UserAccount.demo(id: 'u-adm-001', role: UserRole.admin),
    UserAccount.demo(id: 'u-mig-001', role: UserRole.migrationCandidate),
  ];

  @override
  Future<UserAccount?> findById(String id) async =>
      _accounts.where((a) => a.id == id).firstOrNull;

  @override
  Future<Session> login(Credential c) async {
    final account = _accounts.firstWhere(
      (a) => a.email == c.email,
      orElse: () => throw const AuthFailure.invalidCredentials(),
    );
    return Session.forAccount(account);
  }
  // ...
}
```

## Umschalt-Logik in der App-Shell

```dart
// apps/emma_app/lib/bootstrap/bootstrap.dart (Ausschnitt)
final identityRepositoryProvider = Provider<IdentityRepository>((ref) {
  final cfg = ref.watch(appConfigProvider);
  if (cfg.useFakes) {
    return IdentityFakeRepository();
  }
  return IdentityAdapter(ref.watch(apiClientProvider)); // Phase 2
});
```

## Weg zum Echtbetrieb (Phase 2, out-of-scope MVP)

1. Vertrag mit Partner abgeschlossen, API-Credentials verfuegbar.
2. Echten Adapter in `packages/adapters/adapter_<name>/` bauen.
3. Adapter implementiert dasselbe `*Port`-Interface.
4. App-Wiring im Provider per `AppConfig.useFakes=false` umschalten.
5. Fake-Paket bleibt als CI-Artefakt bestehen — Regressionstests
   laufen weiterhin gegen Fakes.

---

# Workspace-Migration (abgeschlossen, Archiv-Historie)
# emma Workspace-Migration — Abgeschlossen

**Status:** ✅ ABGESCHLOSSEN  
**Datum:** 2026-04-16  
**Durchgeführt:** Manuell + KI-gestützt

---

## Was migriert wurde

Die emma-App wurde von einer flachen Root-Struktur (`lib/features/` direkt im Repo-Root) in eine saubere Dart-Pub-Workspace-Mono-Repo-Struktur überführt.

### Vorher

```
emma/
├── lib/
│   ├── core/           (Foundation, Router, Services)
│   └── features/       (18 Feature-Ordner direkt im Root-lib/)
├── android/
├── ios/
└── pubspec.yaml        (App-pubspec direkt im Root)
```

### Nachher (Zielzustand)

```
emma/
├── apps/emma_app/               Flutter-App als Workspace-Member
├── packages/
│   ├── core/                    emma_core, emma_contracts, emma_ui_kit, emma_testkit
│   ├── domains/                 domain_identity, domain_journey, domain_rules, domain_wallet, domain_partnerhub
│   ├── features/                feature_journey
│   ├── adapters/                adapter_maps
│   └── fakes/                   fake_realtime
├── services/bff_mobile/         Backend-for-Frontend
├── contracts/                   API- und Event-Contracts
├── melos.yaml                   Mono-Repo-Tooling
└── pubspec.yaml                 Workspace-Root (SDK ^3.6.0, 14 Members)
```

---

## Durchgeführte Schritte

| # | Aktion | Status |
|---|--------|--------|
| 1 | Flutter-App nach `apps/emma_app/` verschoben | ✅ |
| 2 | Domain-Packages unter `packages/domains/` angelegt | ✅ |
| 3 | Core-Packages unter `packages/core/` angelegt | ✅ |
| 4 | `melos.yaml` als Workspace-Orchestrierer eingeführt | ✅ |
| 5 | `pubspec.yaml` Root auf Workspace-Root umgestellt | ✅ |
| 6 | `lib/`-Altstruktur nach `_recovery/altstaende/lib_root_altstruktur/` archiviert | ✅ |
| 7 | 660+ OneDrive-Sync-Duplikate (`(2)`, `(3)`, … `(6)`-Suffixe) gelöscht | ✅ |
| 8 | Leere Altpakete direkt in `packages/` (ohne Unterordner) entfernt | ✅ |
| 9 | `stack_integration/` nach `_recovery/stack_integration_dir/` archiviert | ✅ |
| 10 | TypeScript-Altstand (`src/modules/`) nach `_recovery/` archiviert | ✅ |
| 11 | Obsolete Batch-/PS1-Scripte nach `_recovery/scripts_altstand/` archiviert | ✅ |

---

## Aktive Workspace-Members (14)

```yaml
workspace:
  - apps/emma_app
  - packages/core/emma_core
  - packages/core/emma_ui_kit
  - packages/core/emma_contracts
  - packages/core/emma_testkit
  - packages/domains/domain_journey
  - packages/domains/domain_identity
  - packages/domains/domain_wallet
  - packages/domains/domain_rules
  - packages/domains/domain_partnerhub
  - packages/features/feature_journey
  - packages/adapters/adapter_maps
  - packages/fakes/fake_realtime
  - services/bff_mobile
```

---

## Offene Folgeschritte (Migration abgeschlossen, Implementierung läuft)

Die strukturelle Migration ist erledigt. Offene Punkte betreffen Implementierungsfortschritt, nicht Struktur:

- Kritische Module M03 (Ticketing), M10 (Payments), M04 (Abo) noch nicht implementiert
- `domain_wallet` angelegt, Payment-Logik noch nicht ausgebaut
- `domain_rules` angelegt, Tarifserver-Architektur noch zu entscheiden (self-built vs. eingekauft)

→ Vollstaendiger Status in [../planning/STATUS.md](../planning/STATUS.md)

---

## Archiviert

Die alte `pubspec.workspace_bootstrap.yaml` ist als `.ALTSTAND.yaml` im Repo-Root erhalten und dokumentiert den Migrationspfad auf SDK 3.11 + neue Workspace-Glob-Syntax (noch nicht durchgeführt).
