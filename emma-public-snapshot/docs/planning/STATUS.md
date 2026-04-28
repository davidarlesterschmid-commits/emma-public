# emma — Status und Planung (konsolidiert)

**Stand:** 2026-04-28 (Merge mit `main` + Feature-Branch)
**Herkunft:** Zusammenfuehrung von Implementierungsstatus, Repo-Snapshot und Roadmap-Notizen.

---

# Abschnitt 1 — Implementierungsstatus (laufend)

**Stand:** 2026-04-28
**Geltungsbereich:** emma-App MVP, 18-Domaenen-Modell, ADR-04-Scope
**Zielgruppe:** CTO, Produktverantwortung, Engineering-Lead
**Bezug:** [../product/PRODUKT.md](../product/PRODUKT.md) (Katalog-Teil), `ADR-04_mvp_domain_scope.md`,
`ADR-05_chat_and_directions_behind_ports.md`,
[../architecture/MAPPING.md](../architecture/MAPPING.md),
`MVP_BACKLOG_18_DOMAINS.md`, [MVP_PRODUCT_DECISIONS_2026-04-26.md](MVP_PRODUCT_DECISIONS_2026-04-26.md)

---

## Executive Summary

Der MVP folgt ADR-04: **6 vertikal ausgebaute Domaenen**, 3 Querschnitt-
minimal, 9 Post-MVP. Vier grosse ADRs (01..05) sind wirksam.
ADR-02 (Monorepo-Migration) und ADR-05 (Ports fuer Chat/Directions) sind
**erledigt**. ADR-03 (keine bezahlten APIs im MVP) ist ueber
`AppConfig.useFakes` wirksam. ADR-04 (MVP-Scope) ist akzeptiert.

**Ein-Satz-Status der 6 MVP-Domaenen:**

| # | Domaene            | Kernreife fuer DoD | Hauptblocker                                            |
|---|--------------------|--------------------|---------------------------------------------------------|
| 1 | auth_and_identity  | 85 %               | `domain_identity`-Barrel (#35), SecureStorage-Port (#23), `fake_identity` optional haerten (#36) |
| 2 | customer_account   | 50 %               | Konto-Loesch-/Export, ggf. `domain_customer_account`    |
| 3 | employer_mobility  | 75 %               | Budget-Engine, Split-Payment; `fake_employer_mobility` offen |
| 4 | ticketing          | 35 %               | PSP, DoD-Integrationstest; M03-UI doppelt (Journey+`/ticketing`) |
| 5 | routing            | 70 %               | M11-DoD (Tarif sichtbar in Routing-UI), `fake_realtime`  |
| 6 | mobility_guarantee | 15 %               | SPECS_MVP (M07) angenommen, Ports und Engine ausstehend        |

## Wirksame ADRs

| ADR     | Thema                                   | Status        |
|---------|-----------------------------------------|---------------|
| ADR-01  | App-Shell produktionsreif                | Umgesetzt     |
| ADR-02  | Monorepo-Migration (6 Schritte)          | Erledigt      |
| ADR-03  | MVP ohne bezahlte APIs                   | Wirksam, USE_FAKES=true default |
| ADR-04  | MVP-Domaenen-Scope: 6 statt 18           | Akzeptiert    |
| ADR-05  | Chat + Directions hinter Ports (3a/3b/3c) | Erledigt      |
| ADR-06  | Open-Data/CI-Matrix (Laufzeit vs. CI)    | Accepted      |
| ADR-07  | Pilot-Regionen Berlin/MDV, Hybrid       | Accepted      |

## Strukturzustand

- Monorepo konsolidiert: `apps/emma_app/` + `packages/{core,domains,
  features,adapters,fakes}/`.
- `emma_contracts` enthaelt u. a.: `ChatPort`, `DirectionsPort`,
  `RoutingPort`, `TariffPort`, `BudgetPort`, `TicketingPort` (typedef
  auf `domain_ticketing.TicketingRepository`).
- `emma_ui_kit` enthaelt u. a. `EmmaScaffold`, `FakeModeBanner`
  (neu seit 3c).
- Bootstrap ueberschreibt Ports ueber `ProviderScope`:
  `directionsPortProvider`, `chatPortProvider`, `journeyRoutingPortProvider`,
  `journeyTariffPortProvider`, `journeyBudgetPortProvider`,
  `authDioProvider`, `authSecureStorageProvider`,
  `employerDioProvider`, `employerSecureStorageProvider`.
- Riverpod-**State** in der App-Shell: `auth_providers`, `.../employer_mobility/.../employer_mobility_providers` (reexport [employer_providers.dart](../../apps/emma_app/lib/core/employer_providers.dart)), [journey_providers.dart](../../apps/emma_app/lib/core/journey_providers.dart); reexport in `core/providers.dart` moeglich.
- `feature_journey` exportiert `JourneyNotifier` und Throw-Default-Port-`Provider` in [feature_journey_ports.dart](../../packages/features/feature_journey/lib/src/wiring/feature_journey_ports.dart) (Bootstrap-Override, siehe [TASK_37_AUTH_PROVIDER_HOIST.md](TASK_37_AUTH_PROVIDER_HOIST.md)). Tasks #46/#47: obsolet.

---

## Domaenen-Status im Detail

Reihenfolge: ADR-04-Kategorie, dann Prio aus `MVP_BACKLOG_18_DOMAINS.md`.

### Vertikal ausgebaut (6) — MVP-Hauptscope

#### 1. auth_and_identity (Prio 1, M01-Teil) — 85 %

- `domain_identity` vorhanden (User-, UserAccount-Entitaeten).
- `feature_auth`: Login-/Account-UI, Repos, kein Riverpod im Paket-Barrel; Wiring in
  `apps/emma_app/lib/features/auth/presentation/providers/` und `.../view_models/auth_notifier.dart`.
- `fake_identity`: 3 Demokonten, siehe [packages/fakes/fake_identity/](../../packages/fakes/fake_identity/); Hardening optional.
- Offene Punkte:
  - Task #35: `domain_identity`-Barrel auf `show`-Filter heben.
  - Task #23: `SecureStorage`-Port von `flutter_secure_storage`-Impl
    trennen.
- Entscheidung gegen Auth-Port im MVP: Begruendung in Task-37-Analyse.
- Task #37 umgesetzt (Provider-Hoist).

#### 2. customer_account (Prio 2, M01-Teil) — 50 %

- Stammdaten-Anzeige im Profil (Account-Screen) vorhanden.
- Paket `fake_customer_account` **existiert** (5 Rechnungs-Fixtures pro
  Demo-User, Tests in `packages/fakes/fake_customer_account/test/`).
- App-Shell: `AccountRepository` / `InvoiceListPort` bei `USE_FAKES` ueber
  `auth_account_providers.dart` an Fake-Repo angebunden; Route
  `/account/invoices` + [InvoiceListScreen](../../apps/emma_app/lib/features/account/presentation/screens/invoice_list_screen.dart).
- Mock-Auth: Session-Token `emma_sess_v1` in
  [auth_repository_impl.dart](../../packages/features/feature_auth/lib/src/data/auth_repository_impl.dart)
  traegt User-Id **und** E-Mail, damit `pilot@emma.de` / `user-pilot-002`
  zu den Fake-Fixtures passt.
- Weiter offen: eigenes `domain_customer_account` laut Architekturziel,
  Konto-Loesch-Pfad, Datenexport, Produktiv-Adapter.
- Task #27.

#### 3. employer_mobility (Prio 3, M08) — 78 %

- `domain_employer_mobility` und `feature_employer_mobility` vorhanden (UI parametrisiert;
  Riverpod in `apps/emma_app/lib/features/employer_mobility/presentation/providers/`,
  reexport [employer_providers.dart](../../apps/emma_app/lib/core/employer_providers.dart)).
- [EmployerMobilityHost](../../apps/emma_app/lib/features/employer/presentation/employer_mobility_host.dart)
  mappt auf [EmployerMobilityScreenShell](../../apps/emma_app/lib/features/employer_mobility/presentation/screens/employer_mobility_screen_shell.dart).
- Jobticket-Anzeige und Benefit-Katalog laufen gegen Repository-Impls.
- Budget-Engine ist noch unscharf (Monatsabrechnung, Carry-Over).
- `fake_employer_mobility` fehlt; DIO- und Secure-Storage-Bindung ueber
  App-Provider-Overrides in `bootstrap.dart`.
- Split-Payment-Abstraktion an `payments` offen.
- Task #28.

#### 4. ticketing (Prio 4, M03) — 35 %

- [domain_ticketing](../../packages/domains/domain_ticketing/): UC-IDs + `TicketingLineItem` + Katalog-Entities.
- [fake_ticketing](../../packages/fakes/fake_ticketing/) (Demo-Produkte, wo vorhanden).
- `TicketingPort` in [ticketing_port.dart](../../packages/core/emma_contracts/lib/src/ports/ticketing_port.dart) (typedef auf `TicketingRepository`).
- Doppel-UI: Route `/ticketing` + [TicketingCatalogHost](../../apps/emma_app/lib/features/ticketing/presentation/ticketing_catalog_host.dart) (siehe [ticketing_providers.dart](../../apps/emma_app/lib/core/ticketing_providers.dart));
  [tickets_screen](../../apps/emma_app/lib/features/tickets/) bündelt UC-TICK-01..03, UC-01 an M11 `FareDecision`.
- Offen: DoD-Integrationstest, vollster Kauf-PSP, ggf. Konsolidierung der beiden Ticket-UIs. Task #29.

#### 5. routing (Prio 5, M02) — 65 %

- `domain_journey` + `feature_journey`; `JourneyNotifier` + Port-`Provider` in Paket, App-Selektoren in
  [journey_providers.dart](../../apps/emma_app/lib/core/journey_providers.dart);
  [journey_happy_path_test.dart](../../apps/emma_app/test/integration/journey_happy_path_test.dart) nutzt
  [provider_overrides.dart](../../apps/emma_app/lib/bootstrap/provider_overrides.dart).
- M11-Preis: [fake_tariff](../../packages/fakes/fake_tariff/), `JourneyRepositoryImpl` mit `quote()`.
- Bestehende Adapter: `adapter_trias` (real), `fake_maps`,
  `fake_realtime`.
- Intermodalitaet nur in Ansaetzen; Echtzeit-Fallbacks basic.
- M11-Preispfad: `fake_tariff` + `domain_rules` Engine; `JourneyRepositoryImpl` bezieht `quote()` (siehe [../technical/SPECS_MVP.md](../technical/SPECS_MVP.md) M11-DoD).
- Task #30 (Station-ID-Abgleich mit vollem Routing bleibt Follow-up).

#### 6. mobility_guarantee (Prio 6, M07) — 15 %

- [../technical/SPECS_MVP.md](../technical/SPECS_MVP.md) (Abschnitt M07) als Spec liegt.
- Engine, Ports (`MobilityGuaranteePort`, `RealtimePort`,
  `NotificationPort`) ausstehend.
- Startseite: kurzer M07-Hinweis-Card im [HomeScreen](../../apps/emma_app/lib/features/home/presentation/screens/home_screen.dart)
  (kein operatives Garantie-Produkt).
- **Hinweis:** Es gibt keinen Ordner `features/mobility_guarantee/` im
  aktuellen `emma_app`-Tree; Sichtbarkeit nur indirekt (z. B. Chat-
  Stichwoerter in `fake_chat`, `domain_journey`-Services in MVP-Ansaetzen).
- Task #31.

---

### Querschnitt-minimal (3) — MVP-Infrastruktur

#### payments (M10) — 0 % — nur Abstraktion

- `domain_wallet` existiert als leeres Domain-Paket.
- Kein PSP-Anschluss, kein Checkout.
- Im MVP nur als Abstraktion, um employer_mobility-Abrechnung modellieren
  zu koennen. `fake_payments` geplant (in-memory Ledger).
- Nicht-Ziel MVP: PSP-Integration.

#### settings_and_consent — 45 %

- Routen in [app_routes.dart](../../apps/emma_app/lib/routing/app_routes.dart):
  `/settings`, `/settings/consent`; UI unter
  `apps/emma_app/lib/features/settings_consent/`.
- Paket [fake_settings](../../packages/fakes/fake_settings/) mit
  `FakeConsentSettingsAdapter` (in-memory, Defaults, Tests in
  `packages/fakes/fake_settings/test/`).
- App-Tests: [settings_consent_screen_test.dart](../../apps/emma_app/test/features/settings_consent/settings_consent_screen_test.dart).
- Noch lueckenhaft: vollstaendiger DSGVO-Banner-Flow, Consent-Historie,
  Tiefenintegration mit Analytics (Post-MVP) — Flags werden lokal
  gespeichert, ausserhalb der App nicht synchronisiert.

#### tariff_and_rules (M11) — 70 % (Prioritaet: **zuerst**; Architektur **fest**)

- **Entscheid 2026-04-25:** Tarif-Engine **self-built**; Rohdaten aus **frei im Netz
  verfuegbaren** Quellen (GTFS/Open-Data, oeffentliche Zoneninfos, ggf. OSM) in
  versionierte **YAML/JSON-Fixtures**; Details und Pflege: [M11_TARIFF_ARCHITECTURE_DECISION.md](M11_TARIFF_ARCHITECTURE_DECISION.md)
  + [../technical/SPECS_MVP.md](../technical/SPECS_MVP.md) (M11 §0).
- `domain_rules`: `TariffEngine` + YAML-Loader, Unit-Tests in `domain_rules` / `fake_tariff`.
- `emma_contracts`: `TariffPort` mit `quote` / `listProducts` + `TariffQuote` (Cent, `priceSourceKind`/`ruleSetVersion`).
- `fake_tariff`: `FakeTariffAdapter` + Fixture; `TariffRepositoryImpl` und Journey nutzen den Pfad.
- Offen: vollstaendiger SPECS_MVP-DoD (Integrations-UI-Tarifpreis, `ruleTrace` nur Debug), Station-Sync.

---

### Post-MVP (9) — nicht im aktuellen Arbeitsscope

Diese Domaenen sind in MVP-Stubs sichtbar oder komplett noch nicht
angelegt. Stubs **duerfen keinen Nutzer-Traffic auf nicht-funktionierende
Pfade lenken**.

| Domaene                        | Paket-Zustand                               | Post-MVP-Scope (grob)                                   |
|--------------------------------|---------------------------------------------|---------------------------------------------------------|
| ci_co                          | Stub-Screen                                 | CI/CO-Flow, Tagesdeckel, Positioning                    |
| on_demand                      | kein Paket                                   | Flex-/Ridepooling-Buchung                               |
| sharing_integrations           | kein Paket                                   | GBFS-Anbindung, Reservierung                            |
| taxi_integrations              | kein Paket                                   | Taxi-Dispatch, Festpreis/Taxameter                      |
| partnerhub (M12)               | `domain_partnerhub` (leer), **kein App-Feature-Ordner** (rueckgebaut, siehe [Recovery-Report](../audit/RECOVERY_REPORT_2026-04.md) §B.2) | Adapter-Registry, SLA-Monitoring         |
| migration_factory (M16)        | **kein Paket, kein App-Feature-Ordner** (Alt-Stub rueckgebaut, siehe [Recovery-Report](../audit/RECOVERY_REPORT_2026-04.md) §B.3) | Alt-zu-Neu-Mapping, Cutover, Rollback    |
| crm_and_service (M09)          | `domain_customer_service` (leer)             | Anliegen/Tickets, Nachrichten                           |
| analytics_and_reporting (M14)  | `domain_reporting` (leer)                    | Event-Erfassung Consent-gesteuert                       |
| support_and_incident_handling (M13) | kein Paket                             | Stoerungs-Banner, Push                                  |

---

## Offene Entscheidungen mit Dringlichkeit

*Product-/MVP-Abnahme: verbindlich [MVP_PRODUCT_DECISIONS_2026-04-26.md](MVP_PRODUCT_DECISIONS_2026-04-26.md) (u. a. Use-Case-IDs, Verwalter-Minimum, M07-Mindest-Scope, Trennmodell Tarif, Engineering-Defaults K).*

| # | Thema                                                | Status / Deadline         | Quelle / Hinweis                                       |
|---|------------------------------------------------------|---------------------------|--------------------------------------------------------|
| ~~1~~ | ~~Tarifserver-Architektur: self-built vs. eingekauft~~ | **erledigt** 2026-04-25 | [M11_TARIFF_ARCHITECTURE_DECISION.md](M11_TARIFF_ARCHITECTURE_DECISION.md) |
| 2 | Secret-Handling `GOOGLE_MAPS_API_KEY`, `GEMINI_API_KEY` im Release-Build | **offen (techn./Ops)** vor TestFlight/Play-Beta; Default: `dart-define`, nie im Repo | ADR-05 |
| 3 | Fake-First fuer 6 Vertikalen vs. `CLAUDE.md` | **entschieden MVP:** s. [K] in [MVP_PRODUCT_DECISIONS_2026-04-26.md](MVP_PRODUCT_DECISIONS_2026-04-26.md) | — |
| 4 | PSP-Entscheidung M10 (echtes Geld) | **nach MVP-Feature-Abnahme**; kein Blocker solange `fake_payments` | [MVP_PRODUCT_DECISIONS_2026-04-26.md](MVP_PRODUCT_DECISIONS_2026-04-26.md) **K** |
| 5 | OIDC/SSO-Entry-Point | **vor oeffentlichem Beta/Prod**; **nicht** MVP-Blocker fuer 6-Vertikalen-Abnahme | [MVP_PRODUCT_DECISIONS_2026-04-26.md](MVP_PRODUCT_DECISIONS_2026-04-26.md) **K** |

---

## Offene Regel- und Architekturverletzungen

| Verletzung                                                        | Ort                                                                          | Task                   |
|-------------------------------------------------------------------|------------------------------------------------------------------------------|------------------------|
| `ProfileEditWidget`: `ConsumerStatefulWidget` im Paket (kosmetisch) | `packages/features/feature_auth/.../profile_edit_widget.dart`              | optional |
| ~~employer / journey: State-Provider~~ | App-Shell; Port-Throws in `wiring` | erledigt (ehem. #46/#47) |
| ~~Flutter-SDK-Abhaengigkeit in Domain-Paket~~                      | ~~`packages/domains/domain_journey` (haengt an `emma_ui_kit`)~~              | **erledigt** (nicht mehr reproduzierbar; `dart analyze` gruen am 2026-04-26) |
| ~~Cross-Domain-Import~~                                            | ~~`domain_journey` -> `domain_customer_service`~~                            | **erledigt** (kein Import in `domain_journey`; `dart analyze` gruen am 2026-04-26) |

Erledigt seit 2026-04-24:

- `feature_auth` Provider-Hoist (Task #37) — Provider in
  `apps/emma_app/lib/features/auth/presentation/providers/auth_providers.dart`,
  Paket-Barrel Riverpod-frei.
- `feature_employer_mobility` / `feature_journey` — State-Provider in App-Shell
  (`employer_providers.dart`, `journey_providers.dart`, vgl. Historie 2026-04-24
  (3)); ehem. Task #46/#47.

---

## Naechste Schritte nach Inkrement-Logik

**Kurzfristig (Wochen):**

1. M11-DoD: Tarif/Preis in Routing-UI sichtbar, `ruleTrace` (SPECS M11 §11).
2. M03: `fake_ticketing` / UC-02+03-Stub, Ticket-UI-Pfade konsolidieren; `domain_identity`-Barrel (#35).
3. `fake_identity` optional haerten (Task #36); Secret-Handling Release (Task #43).
4. Pre-Commit-Hook `melos run analyze` (Task #33).
5. ADR-05-Follow-ups #44, #45 pruefen.

**Mittelfristig (Sprints):**

1. M03 Ticketing vertiefen: Tarif/PSP, Widget-Tests, ggf. DoD-Integrationstest
   (Grundgeruest: `domain_ticketing`, Fake, Route `/ticketing` vorhanden).
2. M07 Mobility Guarantee MVP (Engine + Fake + Banner).
3. customer_account: Konto-Loesch-Pfad, Datenexport, `domain_customer_account`
   (Rechnungsliste-Route [InvoiceListScreen] existiert bereits im Fake-Modus).
4. employer_mobility Budget-Engine ausbauen, `fake_employer_mobility` evaluieren.

**Nach MVP:**

1. PSP-Integration.
2. OIDC/SSO.
3. Echt-Adapter fuer GTFS-RT-/TRIAS-Stoerungen.
4. Erweiterung auf Post-MVP-Domaenen.

---

## Historie der wesentlichen Aenderungen

- 2026-04-24 (Cross-Agent-Konsolidierung, nach 22-Commit-Merge): Externes Audit [../audit/repo_state_review_2026-04-24.md](../audit/repo_state_review_2026-04-24.md) (vormals `repo_state_review_CURRENT.md`, jetzt datumsfixiert) und neuer [Recovery-Report](../audit/RECOVERY_REPORT_2026-04.md) eingeflossen. Ghost-Feature-Eintraege in MAPPING.md (M06/M07/M12/M16) korrigiert — App-Feature-Ordner existieren nicht mehr; `_recovery/from_c9572d0_2026-04-21/` als Quellmaterial fuer Wiederaufbau in Task #31 dokumentiert. Tasks #46, #47 (Provider-Hoists) wegen Remote-Umsetzung geschlossen.
- 2026-04-28: `main` merge (M11, `fake_identity`, `domain_ticketing`, Open-Source-Maxime) mit Stand aus `main` (Open-Data-Directions/POI, `fake_ticketing`+Route `/ticketing`, ADR-06/07, Linear-Traceability); Konflikte in STATUS/MAPPING aufgeloest. Employer/Journey: App-Shell-Provider, Port-Wiring in `wiring/`.
- 2026-04-27: [MVP_PRODUCT_DECISIONS_2026-04-26.md](MVP_PRODUCT_DECISIONS_2026-04-26.md) — UC-TICK, AG-Rollen, M07, Entscheidung **K**.
- 2026-04-25: **Tarif-Architektur M11** — `M11_TARIFF_ARCHITECTURE_DECISION.md`, SPECS_MVP.
- 2026-04-24: Open-Data `Directions`/`PoiSearch`; Task #37 Hoists; `journeyRepositoryProvider` in [provider_overrides.dart](../../apps/emma_app/lib/bootstrap/provider_overrides.dart). Rechnungsliste, Session-Token v1, Journey-Integration-Test. #46/#47 obsolet.
- 2026-04-23: Volle Aktualisierung nach ADR-05 3c-Abschluss. Struktur
  auf ADR-04-Kategorien umgestellt. Prozent-Reifegrade neu geschaetzt.
  Referenzen auf [../architecture/MAPPING.md](../architecture/MAPPING.md),
  [../technical/SPECS_MVP.md](../technical/SPECS_MVP.md) (M07/M11), `TASK_37_AUTH_PROVIDER_HOIST.md` eingefuegt.
- 2026-04-16: vorherige Fassung, 14-Feature-Modulsicht, ueberholt.

---

# Abschnitt 2 — Repo-Snapshot (historisch, 2026-04-14)
# emma Repo – Zustandsanalyse und Aufräumplan

**Ursprüngliches Datum:** 2026-04-14  
**Aktualisiert:** 2026-04-16 — alle Anomalien aus Sektion 3 erledigt  
**Status:** ✅ ABGESCHLOSSEN — Bereinigung vollständig durchgeführt

---

## 1. Was gehört in <LOCAL_USER_PATH>

| Pfad | Zweck | Bewertung |
|------|-------|-----------|
| `GitHub\emma\` | Aktives Flutter-Mono-Repo | ✅ Kern, bleibt |
| `.android\avd\` | Flutter-Emulator (Android Virtual Device) | ✅ Dev-Tool |
| `.gradle\` | Gradle-Daemon-Cache | ✅ Build-Tool-Cache |
| `AndroidStudioProjects\yourmanagement\` | Separates Kotlin/Compose-Lernprojekt | ⚠️ Nicht emma-bezogen — noch auszulagern |

**Nicht mehr vorhanden (korrekt ausgelagert):**
- `Recovered_Local\` → `<LOCAL_USER_PATH>` ✅
- `OneDrive_Altstruktur\` → `<LOCAL_USER_PATH>` ✅

---

## 2. emma Repo – Aktueller Zielzustand (Stand 2026-04-16)

```
GitHub\emma\
├── apps\
│   └── emma_app\               Flutter-App (Workspace-Member) ✅
├── packages\
│   ├── core\
│   │   ├── emma_core\          Foundation ✅
│   │   ├── emma_contracts\     Shared Interfaces ✅
│   │   ├── emma_ui_kit\        UI-Komponenten ✅
│   │   └── emma_testkit\       Test-Helfer ✅
│   ├── domains\
│   │   ├── domain_identity\    Auth/Identity ✅
│   │   ├── domain_journey\     Routing-Domäne (workspace-integriert) ✅ CANONICAL
│   │   ├── domain_rules\       Tariflogik ✅
│   │   ├── domain_wallet\      Zahlungen/Wallet ✅
│   │   └── domain_partnerhub\  Partneranbindung ✅
│   ├── features\
│   │   └── feature_journey\    Journey-Feature-Impl ✅
│   ├── fakes\
│   │   └── fake_realtime\      Fake-Services für Tests ✅
│   └── adapters\
│       └── adapter_maps\       Kartenanbindung ✅
├── services\
│   └── bff_mobile\             Backend-for-Frontend ✅
├── contracts\                  API-/Event-Contracts (OpenAPI, AsyncAPI, JSON Schema) ✅
├── _recovery\                  Altbestände, archiviert ✅
├── melos.yaml                  Mono-Repo-Tooling ✅
├── pubspec.yaml                Workspace-Root (SDK ^3.6.0) ✅ CANONICAL
├── .ALTSTAND.yaml              Alt-Workspace-Definition (SDK 3.11) — Referenz ✅
├── AGENTS.md                   Coding-Agent-Guidance ✅ (aktualisiert 2026-04-16)
├── README.md                   ✅ (neu geschrieben 2026-04-16)
└── Test-EmmaFeatureCoverage.ps1  Coverage-Audit ✅
```

---

## 3. Anomalien — Aktionsplan und Erledigungsstatus

### A – Erledigt (2026-04-16)

| # | Anomalie | Aktion | Status |
|---|----------|--------|--------|
| 1 | `Test-EmmaFeatureCoverage.fixed (1).ps1` | Gelöscht | ✅ |
| 2 | `pubspec.workspace_bootstrap.yaml` | Umbenannt → `.ALTSTAND.yaml` | ✅ |
| 3 | `stack_integration.tar.gz` und `stack_integration/` | Nach `_recovery/` verschoben | ✅ |
| 4 | `packages/domains/journey/` (standalone) neben `domain_journey/` | Leere Schale entfernt, `journey_intent.dart` + `journey_summary_service.dart` bereits in `domain_journey` integriert | ✅ |
| 5 | 660+ OneDrive-Sync-Duplikate (`(2)`–`(6)`-Suffixe) | Alle gelöscht | ✅ |
| 6 | Root-`lib/`-Altstruktur (187 Dart-Dateien) | Nach `_recovery/altstaende/lib_root_altstruktur/` archiviert | ✅ |
| 7 | 18 leere Altpakete direkt in `packages/` | Entfernt | ✅ |
| 8 | `src/modules/` (TypeScript) | Nach `_recovery/src_typescript_altstand/` archiviert | ✅ |
| 9 | Obsolete `.bat`/`.ps1`-Scripte | Nach `_recovery/scripts_altstand/` archiviert | ✅ |

### B – Noch offen

| # | Anomalie | Empfehlung |
|---|----------|------------|
| 10 | `.ALTSTAND.yaml` vs `pubspec.yaml` | SDK-Migration auf ^3.11 + neue Workspace-Glob-Syntax noch nicht durchgeführt — low priority |
| 11 | `AndroidStudioProjects\yourmanagement\` | In `<LOCAL_USER_PATH>` auslagern |
| 12 | `apps\emma_app\build\` | Prüfen ob vollständig in `.gitignore` |

---

## 4. emma Zielarchitektur – Nachweisbar

| Quelle | Inhalt |
|--------|--------|
| `CLAUDE.md` (global) | Vollständige Architekturspezifikation: MVVM, 19 Domänenmodule, 5 emma-Kernbausteine |
| `melos.yaml` | Mono-Repo-Workspace: `apps/**`, `packages/**`, `services/**` |
| `pubspec.yaml` | 14 aktive Workspace-Members, Abhängigkeiten (Riverpod, GoRouter, Freezed, SecureStorage) |
| `packages/domains/` | domain_identity, domain_journey, domain_rules, domain_wallet, domain_partnerhub |
| [STATUS.md](STATUS.md) (dieses Dokument, Abschnitt 1) | Modul-für-Modul-Bewertung, Critical-Path-Identifikation |
| [../product/PRODUKT.md](../product/PRODUKT.md) | Fachliches Lastenheft + Funktionskatalog (16 Module) |
| [../architecture/MAPPING.md](../architecture/MAPPING.md) | Mapping Module → packages/ |
| `AGENTS.md` | Agent-Guidance: Modulstruktur, Architekturregeln, Melos-Befehle |

---

## 5. Nächster sinnvoller Schritt

`git add -A && git commit -m "chore: repo cleanup + docs update — remove sync duplicates, migrate to packages/"` ausführen.  
Danach: M03 (Ticketing) und M10 (Payments) als Critical-Path-Kickoff starten.

---

# Abschnitt 3 — Roadmap / Next Steps (Stand 2026-04-08)

## MVP-Roadmap nach Modultabelle

**Ursprünglicher Stand:** 2026-04-08 | **Bestätigt:** 2026-04-16 (nach Workspace-Migration, inhaltlich unverändert gültig)

Basis:
- Modul-Audit (Abschnitt 4 in diesem Dokument, archiviert: `docs/_archive/2026-04-consolidation/MODUL_AUDIT_2026-04-08.md`)
- `<LOCAL_USER_PATH> Ablage ([REDACTED])\emma\Modultabelle.xlsx`

Leitprinzip:
- Zuerst wird die Modultabelle im MVP fachlich möglichst vollständig abgebildet.
- In Phase 1 werden nur Funktionalitäten umgesetzt, die wir selbst bauen oder aus frei abrufbaren Internetquellen speisen können.
- Drittanbieter-APIs werden in Phase 1 nicht vorausgesetzt, aber alle betroffenen Prozesse werden trotzdem bis zum externen Handoff vollständig modelliert.
- In Phase 2 werden diese bereits definierten Handoffs auf echte Partner- und Betriebs-APIs gelegt.

## Phase 1: MVP ohne Drittabhängigkeiten

Ziel:
Alle 14 Module aus der Modultabelle so weit abbilden, dass emma fachlich end-to-end denkbar und im Produkt erlebbar ist, auch wenn einzelne Schritte vor externer Ausführung an einem API-Handoff stoppen.

### Priorität A: Die interne emma-Kernlogik vollständig machen

Betroffene Module:
- 1 KI-Interaktionsschicht
- 3 Bedarfserkennung
- 4 Planungs-Engine
- 7 Reiseakte und Journey-Orchestrator
- 8 Reisebegleitung
- 9 Mobilitätsgarantie
- 13 Lern- und Optimierungsmodul

Zielbild:
- emma kann Anfrage, Bedarf, Planung, Entscheidung, Reisezustand, Störung, Garantie und Lernsignal intern durchgängig verarbeiten.
- Jeder Schritt erzeugt saubere Zustände, Entscheidungen und Folgeaktionen.
- Wo externe Daten fehlen, werden sie über kontrollierte interne Quellen, Testdaten oder frei verfügbare Internetdaten ersetzt.

Konkrete Arbeitspakete:
- Home/Assistant von Chat-UI zu echter Orchestrierungsoberfläche ausbauen
  - strukturierte User Intents
  - Rückfragen
  - erklärbare Handlungsempfehlungen
- Bedarfserkennung mit real nutzbaren Input-Kanälen erweitern
  - manuelle Routinen
  - Zeit-/Standortkontext
  - optionale frei abrufbare Wetter-/Lagedaten
- Journey Engine aus statischen Blueprint-Repositories herauslösen
  - Journey Case als persistierbarer Zustand
  - Phasenübergänge
  - Ereignismodell
  - Statushistorie
- Reisebegleitung und Garantie vollständig intern definieren
  - Trigger
  - Alternativen
  - Kostenwirkung
  - Nutzerkommunikation
  - Service-Handoff
- Lernmodul als interne Feedback-Schleife anlegen
  - Präferenzanpassung
  - Routinen
  - Outcome-Signale

Definition of Done:
- Eine Journey kann intern von Anfrage bis Abschluss durchlaufen
- Jede Phase produziert strukturierte Zustände statt Demo-Text
- Monitoring-, Garantie- und Lernpfade sind fachlich implementiert und testbar
- Alle Handoffs zu späteren APIs sind als eigene Schnittstellen/Ports definiert

### Priorität B: Regelwerk, Konto und Wallet im Eigenbau tragfähig machen

Betroffene Module:
- 2 Identität, Konto, Einwilligung und Präferenzprofil
- 5 Tarif-, Produkt- und Regelwerksmanagement
- 11 Kundenkonto, Wallet, Payment und Mobilitätsbudget

Zielbild:
- Nutzerkonto, Präferenzen, Einwilligungen, interne Zahlungslogik, Budget- und Regelprüfung funktionieren ohne externe Produktivsysteme.
- Statt echter PSP- oder IAM-Anbindung existieren saubere Domain-Modelle und lokale/mockbare Infrastrukturschnittstellen.

Konkrete Arbeitspakete:
- Identitätsmodul funktional ausbauen
  - Profil
  - Präferenzen
  - Consent
  - Rollen/Freigaben
  - Barrierefreiheitsoptionen
- Regelwerksmodul aus Demo-Berechnung zu echter interner Fachinstanz entwickeln
  - Tarifregel
  - Produktregel
  - Berechtigungsprüfung
  - Garantieschwellen
  - Versionierung im lokalen Datenmodell
- Wallet/Payment/Budget intern vollständig modellieren
  - Zahlungsart als internes Objekt
  - Payment Intent
  - Belegentwurf
  - Budgetprüfung
  - Kostenzuordnung privat/Arbeitgeber
- Alle externen Handoffs definieren
  - IAM-Handoff
  - PSP-Handoff
  - Arbeitgeber-Handoff

Definition of Done:
- Konto, Präferenzen, Regelprüfung und Budgetlogik sind lokal nutzbar
- Kosten- und Berechtigungsentscheidungen laufen intern deterministisch
- Payment- und Wallet-Prozesse sind vollständig modelliert, auch wenn der Ausführungsschritt später an eine externe API delegiert wird

### Priorität C: Ticketing, Support, Reporting und Partnerfähigkeit prozessual fertig machen

Betroffene Module:
- 6 Buchungs-, Ticketing- und Transaktionsorchestrierung
- 10 Partnerhub und Integrationsmanagement
- 12 Kundenservice-, Fall- und Eskalationsmanagement
- 14 Reporting, Qualitätssicherung und Betriebssteuerung

Zielbild:
- Auch ohne echte Dritt-APIs sind alle operativen Prozesse bis zum Ende ausdefiniert.
- Externe Abhängigkeiten sitzen nur noch an klaren Adapter-Grenzen.

Konkrete Arbeitspakete:
- Ticketing- und Transaktionsorchestrierung intern abschließen
  - Booking Intent
  - Reservierungsstatus
  - Aktivierungsstatus
  - Transaktionsfehler
  - Rollback-/Retry-Modell
- Partnerhub als Integrationsrahmen bauen
  - Partnertypen
  - Capability-Matrix
  - Vertrags-/SLA-Metadaten
  - technische Adapter-Ports
- Kundenservice-Prozesse vollständig definieren
  - Fallanlage
  - Fallklassifikation
  - Bezug auf Journey/Transaktion/Garantie
  - Eskalationsregeln
  - Abschlusszustände
- Reporting und Betriebssteuerung auf strukturierte Events heben
  - Audit Trail
  - KPI-Eventmodell
  - SLA-Sicht
  - Qualitätskennzahlen

Definition of Done:
- Jede Journey kann in einen Ticketing-/Payment-/Support-Prozess übergeben werden
- Jeder Prozess hat definierte Endzustände, Fehlerzustände und Übergabeobjekte
- Reporting kann alle Kernprozesse intern nachvollziehen
- Integrationen sind als Adapter vorgesehen, aber nicht mehr fachlich unklar

## Phase 1.5: MVP-Abnahme gegen die Modultabelle

Ziel:
Die Modultabelle nicht nur technisch zu mappen, sondern als fachliche Checkliste gegen das MVP abzunehmen.

Prüfung pro Modul:
- Gibt es eine sichtbare Produktfunktion oder einen internen Prozess dafür?
- Ist der Prozess bis zum Ende modelliert?
- Ist klar, wo interne Logik endet und wo später ein externer Handoff beginnt?
- Gibt es Testfälle oder dokumentierte Szenarien?

Ergebnis:
- Modulstatus je Excel-Modul: `MVP erfüllt`, `MVP teilweise`, `nur Handoff modelliert`
- Offene Punkte werden explizit als API- oder Partnerabhängigkeit markiert

## Phase 2: API-gebundene Funktionalitäten anschließen

Ziel:
Die in Phase 1 vorbereiteten Handoffs gegen echte externe Systeme austauschen, ohne die Fachlogik neu zu entwerfen.

Priorisierte API-Wellen:

1. Frei verfügbare oder direkt abrufbare Datendienste
- Routing-/Realtime-Quellen
- Wetter-/Kontextdaten
- frei nutzbare Lage- oder Geodaten

2. Produktive Betriebs- und Partner-APIs
- Ticketing
- Payment/PSP
- IAM/Consent
- Arbeitgeber-/Benefit-Systeme
- CRM/Support
- Push-/Messaging

3. Steuerungs- und Reporting-Systeme
- BI
- SLA-Monitoring
- Audit-/Monitoring-Plattformen

Definition of Done:
- Jeder externe Adapter ersetzt einen vorhandenen internen Port
- Fachlogik bleibt unverändert, nur die Infrastruktur wird ausgetauscht
- Für jeden Adapter existieren Timeout-, Fehler-, Retry- und Fallback-Regeln

## Empfohlene Umsetzungsreihenfolge

1. Journey-Kern stabilisieren: Assistant, Bedarfserkennung, Orchestrator, Reiseakte
2. Regelwerk, Konto, Budget und Wallet intern fertig modellieren
3. Ticketing-/Transaktionsprozess bis zum API-Handoff komplett machen
4. Reisebegleitung, Garantie und Service-Eskalation vollständig anschließen
5. Reporting, Audit Trail und Betriebskennzahlen nachziehen
6. Erst danach echte Dritt-APIs schrittweise auf die vorbereiteten Ports legen

## Sofort sinnvoller Startpunkt

Der beste nächste konkrete Strang ist:

`User Intent -> Demand Recognition -> Option Selection -> Fare/Budget Check -> Booking Intent -> Payment Intent -> Journey State Update -> Support/Reporting Event`

Warum genau dieser Strang:
- Er deckt den größten Teil der Modultabelle fachlich ab
- Er benötigt in der ersten Ausbaustufe keine zwingende Drittintegration
- Er zwingt uns, alle späteren API-Handoffs sauber zu definieren
- Er macht schnell sichtbar, welche Module nur UI sind und welche schon echte Fachlogik tragen

---

# Abschnitt 4 — Modul-Audit (Excel Modultabelle.xlsx, 2026-04-08)
# Modul-Audit gegen `Modultabelle.xlsx`

**Ursprünglicher Stand:** 2026-04-08  
**Aktualisiert:** 2026-04-16 (nach Workspace-Migration)  
**Strukturhinweis:** Code-Verweise gelten für die neue Mono-Repo-Struktur. Domain-Logik liegt in `packages/domains/`, Feature-UI in `apps/emma_app/lib/features/`. Der Root-`lib/`-Ordner wurde nach `_recovery/` archiviert.

Quelle Soll-Bild: `<LOCAL_USER_PATH> Ablage ([REDACTED])\emma\Modultabelle.xlsx`

Bewertungsmaßstab:
- `Nicht abgebildet`: kein belastbares Gegenstück im Code
- `Teilweise abgebildet`: Screen/Struktur vorhanden, aber wenig oder keine fachliche Logik
- `Funktional als Prototyp`: echte Logik vorhanden, aber stark mock-/demo-basiert oder mit großen Integrationslücken
- `Weitgehend funktionsfähig`: zusammenhängende Logik mit belastbaren Tests/Flows, aber nicht automatisch produktionsreif

## Audit-Tabelle

| Excel-Modul | Abgebildet in emma | Zuordnung im Code | Funktionsstand | Belege | Wesentliche Lücken |
|---|---|---|---|---|---|
| 1. KI-Interaktionsschicht / emma Assistant | Ja | `home`, `integrations/maps` | Funktional als Prototyp | `lib/features/home/presentation/screens/home_screen.dart`, `lib/integrations/maps/maps_service.dart`, `lib/core/router/app_router.dart` | Chat ist direkt an Gemini und Google Maps gekoppelt, aber ohne eigene Orchestrierungslogik, Reiseakte-Anbindung oder robuste Fehler-/Fallback-Pfade |
| 2. Identität, Konto, Einwilligung und Präferenzprofil | Ja | `auth_and_identity`, `account` | Funktional als Prototyp | `lib/features/auth_and_identity/presentation/screens/login_screen.dart`, `lib/features/auth_and_identity/presentation/providers/auth_provider.dart`, `lib/features/auth_and_identity/data/repositories/auth_repository_impl.dart` | Login/OAuth und lokaler Token-Flow sind vorhanden, aber Remote-Logik ist mock-basiert; Consent, Präferenzen, Barrierefreiheit, Zahlungsarten und Freigabelogik fehlen weitgehend |
| 3. Kontext-, Routine- und Bedarfserkennung | Ja | `journey_engine` | Funktional als Prototyp | `lib/features/journey_engine/domain/services/demand_recognition_engine.dart`, `test/journey_engine/demand_recognition_engine_test.dart` | Gute Fachlogik und Tests, aber keine echte Anbindung an Kalender, Geräte, Wetter oder Betriebslage; Ergebnisse basieren auf strukturierten Eingaben statt realen Datenquellen |
| 4. Mobilitätsentscheidungs- und Planungs-Engine | Ja | `journey_engine`, `trips`, `integrations/trias` | Funktional als Prototyp | `lib/features/journey_engine/domain/services/option_orchestration_engine.dart`, `lib/features/trips/presentation/screens/trip_result_screen.dart`, `lib/integrations/trias/trias_service.dart`, `test/journey_engine/option_orchestration_engine_test.dart` | Entscheidungslogik ist vorhanden, aber Routing- und Echtzeitquellen sind stub/mock-basiert; keine belastbare End-to-End-Planung im UI |
| 5. Tarif-, Produkt- und Regelwerksmanagement | Ja | `tariff_rules`, Teile von `journey_engine` | Funktional als Prototyp | `lib/features/tariff_rules/presentation/screens/tariff_screen.dart`, `lib/features/tariff_rules/data/repositories/tariff_repository_impl.dart`, `lib/features/journey_engine/data/repositories/journey_repository_impl.dart` | Tariflogik existiert nur als sehr einfache Demo; keine Versionierung, kein echtes Regelwerk, keine Produktlogik und keine belastbare Berechtigungsprüfung |
| 6. Buchungs-, Ticketing- und Transaktionsorchestrierung | Teilweise | `tickets`, `journey_engine`, rudimentär `payments` | Funktional als Prototyp | `lib/features/tickets/presentation/screens/tickets_screen.dart`, `lib/features/journey_engine/domain/services/booking_execution_engine.dart`, `test/journey_engine/booking_execution_engine_test.dart`, `lib/features/payments/domain/entities/payment.dart` | Starke fachliche Modellierung in der Journey-Engine, aber kein echtes Ticketing-Feature, keine PSP-Integration, keine Reservierungsadapter und keine belegbare Transaktionskette im Produkt |
| 7. Reiseakte und Journey-Orchestrator | Ja | `journey_engine` | Weitgehend funktionsfähig | `lib/features/journey_engine/data/repositories/journey_repository_impl.dart`, `lib/features/journey_engine/contracts/orchestrator/master_orchestrator.dart`, `lib/features/journey_engine/presentation/providers/journey_provider.dart`, `test/journey_engine/journey_repository_test.dart`, `test/journey_engine/contracts/master_orchestrator_test.dart` | Stärkstes Modul im Repo; dennoch aktuell blueprint-/mock-getrieben statt an produktive Reise-, Buchungs- und Echtzeitdaten gekoppelt |
| 8. Echtzeitmonitoring und operative Reisebegleitung | Teilweise | `journey_engine`, `trips`, `notifications` | Teilweise abgebildet | `lib/features/journey_engine/data/repositories/journey_repository_impl.dart`, `lib/integrations/trias/trias_service.dart`, `lib/features/notifications/presentation/screens/notifications_screen.dart` | Monitoring ist nur als Journey-Phase und Demo-Daten modelliert; es fehlen laufende Überwachung, Push/Dialog-Aussteuerung und echte Betriebsereignis-Verarbeitung |
| 9. Störfall- und Mobilitätsgarantie-Engine | Ja | `mobility_guarantee`, `journey_engine` | Funktional als Prototyp | `lib/features/mobility_guarantee/presentation/screens/guarantee_screen.dart`, `lib/features/mobility_guarantee/data/repositories/guarantee_repository_impl.dart`, `lib/features/journey_engine/data/repositories/journey_repository_impl.dart` | Garantie-Regeln und Eskalation sind vorhanden, aber nur mock-basiert; Anspruchsprüfung, Ersatzpfade, Kostenlogik und operative Auslösung fehlen end-to-end |
| 10. Partnerhub und Integrationsmanagement | Ja | `partnerhub` | Funktional als Prototyp | `lib/features/partnerhub/presentation/screens/partnerhub_screen.dart`, `lib/features/partnerhub/presentation/providers/partner_provider.dart`, `lib/features/partnerhub/data/repositories/partner_repository_impl.dart` | Partnerverwaltung ist strukturiert, aber nur mit Mock-Repository; kein Adapter-Framework, kein SLA-Monitoring, kein echtes Onboarding |
| 11. Kundenkonto, Wallet, Payment und Mobilitätsbudget | Teilweise | `auth_and_identity`, `employer_mobility`, `payments` | Teilweise abgebildet | `lib/features/employer_mobility/presentation/screens/employer_mobility_screen.dart`, `lib/features/employer_mobility/data/repositories/budget_repository_impl.dart`, `lib/features/payments/presentation/screens/payments_screen.dart`, `lib/features/payments/domain/entities/payment.dart` | Budget und Arbeitgeberbezug sind prototypisch sichtbar, aber Wallet, Zahlungsarten, Belege, konsolidierte Kostenzuordnung und echtes Payment fehlen |
| 12. Kundenservice-, Fall- und Eskalationsmanagement | Teilweise | `customer_service`, geringe Überschneidung mit `journey_engine`/`mobility_guarantee` | Teilweise abgebildet | `lib/features/customer_service/presentation/screens/customer_service_screen.dart`, `lib/features/journey_engine/data/repositories/journey_repository_impl.dart` | Nur Platzhalter-Screen; keine Fallanlage, keine CRM-Anbindung, keine Nachbearbeitung, keine Eskalationssteuerung |
| 13. Lern- und Optimierungsmodul | Nein, nur angedeutet | statische Hinweise in `journey_engine` | Nicht abgebildet | `lib/features/journey_engine/data/repositories/journey_repository_impl.dart` | Es gibt keine eigene Lernlogik, kein Analytics-Feedback, keine Präferenzaktualisierung außerhalb statischer Blueprint-Daten |
| 14. Reporting, Qualitätssicherung und Betriebssteuerung | Teilweise | `data_reporting`, `core/services` | Teilweise abgebildet | `lib/features/data_reporting/presentation/screens/data_reporting_screen.dart`, `lib/core/services/monitoring_service.dart`, `lib/core/services/logging_service.dart` | Reporting-Screen ist Platzhalter; Monitoring/Logging bestehen nur aus `print`-Wrappern, ohne KPI-Modell, SLA-Auswertung, Audit-Trails oder Betriebsdashboard |

## Größte Lücken mit Go-Live-Relevanz

1. Buchungs-, Ticketing- und Payment-Kette ist nicht durchgängig implementiert.
   Ohne echtes Ticketing, Zahlungsauslösung, Reservierungsadapter und Transaktionspersistenz ist das Kernversprechen der Plattform nicht live-fähig, auch wenn die Journey-Engine den Ablauf schon fachlich modelliert.

2. Operative Echtzeitbegleitung und Störfallbehandlung enden aktuell vor der echten Ausführung.
   Monitoring, Benachrichtigung, Garantie-Auslösung und Service-Übergabe sind im Modell sichtbar, aber nicht an reale Laufzeitdaten oder Prozesse angebunden.

3. Querschnittsmodule für Wallet/Support/Reporting fehlen als belastbare Betriebsbasis.
   Gerade Kundenservice, Reporting und Payment/Beleglogik sind für einen produktiven Betrieb notwendig, im Repo aber überwiegend noch Platzhalter oder sehr dünne Prototypen.

## Doku-Widersprüche zum aktuellen Code

- Die älteren Statusdokumente im Repo unterschätzen den aktuellen UI-Stand an mehreren Stellen.
  Router und Screens für `subscriptions`, `payments`, `customer_service`, `check_in_out`, `notifications` und `data_reporting` existieren inzwischen, auch wenn sie meist noch Platzhalter sind.

- Umgekehrt überschätzen einzelne Markdown-Dokumente die fachliche Reife.
  Mehrere Features sind strukturell sauber angelegt, nutzen aber weiterhin Mock-Repositories, Demo-Daten oder statische Blueprints statt echter Integrationen.

## Testlage

- Positiv: `melos run test:unit` und `melos run test:flutter` sind im
  Workspace-Default gruen (Journey-Domain, Feature-Pakete, `emma_app`,
  u. a. `fake_settings`, `fake_customer_account`).

- `apps/emma_app/test/integration/journey_happy_path_test.dart` deckt den
  Journey-Happy-Path mit Produktions-[ProviderScope]-Overrides ab.
  Vollstaendige Geraete-Integrationstests (`flutter test integration_test`)
  erfordern einen Linux/Android/iOS-Build (CI/Entwicklerrechner).

- Diese Audit-Tabelle (2026-04-16) bezieht sich teils auf aeltere Pfade
  (`journey_engine` auf App-Ebene). Aktuelle Fachlogik fuer Journey liegt in
  `packages/domains/domain_journey` und `packages/features/feature_journey`.
