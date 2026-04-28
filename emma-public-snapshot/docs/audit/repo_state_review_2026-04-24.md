# Repo State Review — Momentaufnahme 2026-04-24 Vormittag

> **HISTORISCH — nicht mehr "CURRENT".** Dieser Audit beschreibt den
> Repo-Stand vom **2026-04-24 Vormittag**. Zwischen Auditzeitpunkt und
> Nachmittag desselben Tages wurden 22 Commits auf `origin/main`
> gemerged, die mehrere der hier festgestellten Befunde bereits
> behoben haben:
>
> - **§C "Provider-Regelverletzung" in `feature_employer_mobility` und `feature_journey`** — behoben durch Commit `a85b156` (Provider-Hoist in App-Shell).
> - **§D "kein `domain_ticketing`, kein TicketingPort"** — behoben durch Commit `183bf0d` (fake_tariff + domain_ticketing).
> - **§D "kein `fake_identity`"** — behoben durch Commit `183bf0d`.
> - **§E "TariffPort-Signatur widerspricht SPEC M11"** — behoben durch Commit `183bf0d` (TariffPort jetzt mit `quote`/`listProducts` + `TariffQuote` in Cent).
> - **§E "double-Preise in Tarif-/Payment-Modellen"** — in Tarif-Pfad erledigt; in `Subscription`, `Payment`, `MobilityBudget`, `JobTicket` zu verifizieren (Restscope).
> - **Fehlende Gleichwertigkeitsmatrix** — durch User-Entscheidung "Option C" abgeloest (Pilot-Flows + Parity-Checkliste, siehe Task #56 / ADR-08 geplant).
> - **Ghost-Features unter `.dart_tool/build/generated/` fuer mobility_guarantee/partnerhub/migration** — im [Recovery-Report](RECOVERY_REPORT_2026-04.md) aufgeklaert; echte Quellen sind in `_recovery/from_c9572d0_2026-04-21/` gesichert.
>
> Was **noch gueltig** ist: §D "Ticketkauf/QR/D-Ticket/CI-CO unvollstaendig" (Kernrueckstand, Tasks #29 teilweise, #04 offen), §D "Multi-Profil nicht global", §D "Reales Echtzeit-/Stoerungs-Monitoring fehlt" (Task-#44-verwandt), §F "`.env` Sicherheits-Audit" (Task #52 offen).
>
> **Neuer, aktueller Audit-Zustand:** [../planning/STATUS.md](../planning/STATUS.md) (Stand nach Merge).
>
> Diese Datei wird **nicht mehr aktualisiert**. Ein Folge-Audit gegen den Post-Merge-Stand ist Teil der Task-Liste (#57-Folge).

Stand: 2026-04-24 (Vormittag, pre-consolidation)
Repo-Pfad geprueft: `<LOCAL_USER_PATH>`

Arbeitsannahmen:
- Der vom Auftrag genannte OneDrive-Pfad `<LOCAL_USER_PATH>` existiert in dieser Umgebung nicht. Das Audit wurde deshalb gegen den aktiven Git-Workspace ausgefuehrt.
- Als fachliche Source of Truth wurden verwendet: `docs/architecture/Modultabelle.xlsx` (14 Kernmodule), `docs/product/PRODUKT.md`, `docs/architecture/MAPPING.md`, `docs/planning/STATUS.md`, `docs/technical/SPECS_MVP.md` sowie die Archivstaende unter `docs/_archive/2026-04-consolidation/`.
- Eine eigenstaendige, getrackte Gleichwertigkeitsmatrix mit 67 Bestandsfunktionen war im aktuellen Repo nicht auffindbar. Die Gleichwertigkeitsbewertung unten ist deshalb aus Produktdoku, Modultabelle, Auftragsschwerpunkten und Code-Evidenz abgeleitet.

Verifizierte technische Basis:
- `dart analyze .` am 2026-04-24: gruener Lauf, keine Issues.
- Erfolgreich getestete Suites: `adapter_gemini`, `adapter_trias`, `domain_customer_service`, `domain_journey`, `domain_reporting`, `fake_chat`, `fake_maps`, `adapter_maps`, `emma_ui_kit`, `feature_employer_mobility`, `feature_journey`, `apps/emma_app`.
- `apps/emma_app/integration_test/` enthaelt nur `.gitkeep`; es gibt keine echten App-Integrationstests und keinen `driver/`-Ordner.
- `dart run melos run test:*` ist in diesem Terminal nicht non-interaktiv nutzbar, weil Melos einen Package-Auswahlprompt oeffnet; deshalb wurden die Testlaeufe paketweise ausgefuehrt.

## A. Executive Summary

- Der Workspace ist strukturell sauberer als der dokumentierte Altstand: 1 aktive App (`apps/emma_app`), 23 aktive Workspace-Member insgesamt, klare Paketgruppen unter `packages/{core,domains,features,adapters,fakes}`, 1 Service (`services/bff_mobile`), zentrale Vertrage unter `contracts/`, konsolidierte Doku unter `docs/`.
- Der staerkste reale Bereich ist heute nicht Ticketing oder Abo, sondern `domain_journey` plus `feature_journey`: 8-Phasen-Modell, JourneyCase/JourneyState, DemandRecognition-, OptionOrchestration-, BookingExecution-, PaymentIntent- und Reaccommodation-Logik sind als Domainenmodelle und Services vorhanden und getestet.
- Die App-Oberflaeche bildet das fachliche Zielbild "KI uebernimmt vollstaendige Mobilitaetsabwicklung" noch nicht ab. Sichtbar und aktiv geroutet sind nur Home-Chat, Login, Profil, `/journey` und das alte `/trips`. Phase 3 bis 8 der Journey sind zwar modelliert, aber fuer Endnutzer kaum oder gar nicht durchgaengig erreichbar.
- Kritische fachliche Muss-Themen bleiben unter Sollstand: Ticketkauf, Produktkatalog, QR-/Barcode-Ticketanzeige, D-Ticket/Abo, Check-in/Check-out, Notifications, echtes Echtzeitmonitoring, Partnerhub, Sharing/On-Demand/Taxi und echte Partnertransaktionen.
- Es gibt eine deutliche Doku-vs.-Code-Divergenz: aktuelle Docs sprechen weiterhin von `melos.yaml` und von getrackten Feature-Pfaden fuer `mobility_guarantee`, `partnerhub` und `migration`; diese Pfade wurden im getrackten Code seit 2026-04-16/2026-04-23 entfernt. Stale Build-Artefakte unter `.dart_tool/build/generated/...` lassen diese Features trotzdem noch sichtbar erscheinen.
- Architekturregel "Provider nur in der App-Shell" ist bei Auth inzwischen verbessert, aber nicht konsistent umgesetzt: `feature_auth` wurde in die App-Shell gehievt, `feature_journey` und `feature_employer_mobility` halten weiterhin Provider in Paketen.
- Gesamtklassifikation gegen die 14 Kernmodule: 1 Modul `abgedeckt`, 9 Module `vorbereitet`, 1 Modul `luecke`, 3 Module `widerspruechlich`.

Struktursnapshot:
- Aktive App: `apps/emma_app`
- Aktive Packages: `adapter_gemini`, `adapter_maps`, `adapter_trias`, `emma_contracts`, `emma_core`, `emma_testkit`, `emma_ui_kit`, `domain_customer_service`, `domain_employer_mobility`, `domain_identity`, `domain_journey`, `domain_partnerhub`, `domain_reporting`, `domain_rules`, `domain_wallet`, `fake_chat`, `fake_maps`, `fake_realtime`, `feature_auth`, `feature_employer_mobility`, `feature_journey`
- Aktiver Service: `services/bff_mobile`
- Doku-Ordner: `docs/architecture`, `docs/migration`, `docs/planning`, `docs/product`, `docs/technical`, `docs/_archive`
- Skripte: `tools/scripts/emma-git-bash.sh`, `tools/scripts/sync_instructions.ps1`, `tools/scripts/sync_instructions.sh`, `tools/scripts/Test-EmmaFeatureCoverage.ps1`
- Verdrahtete App-Routen: `/`, `/login`, `/account`, `/journey`, `/journey/detail`, `/trips`, `/trips/detail`

## B. Was hat sich verbessert?

- Gegenueber dem Altstand bis 2026-04-16 wurde fachliche Journey-Logik aus app-lokalen Stubs in `packages/domains/domain_journey` und `packages/features/feature_journey` ueberfuehrt. Das ist eine echte Verbesserung von Architektur und Testbarkeit.
- `feature_auth` wurde bereinigt: die frueher dokumentierte Provider-Regelverletzung ist fuer Auth faktisch behoben. App-Shell-Wiring liegt jetzt in `apps/emma_app/lib/features/auth/presentation/providers/auth_providers.dart`, waehrend `feature_auth` nur noch Daten-/Widget-Bausteine liefert.
- Chat und Directions liegen jetzt sauber hinter Ports (`ChatPort`, `DirectionsPort`) mit Fake-First-Wiring in `bootstrap.dart`. Damit ist ADR-03/ADR-05 im Code deutlich besser verankert als im Altstand.
- Neue reale bzw. neue formal aktive Workspace-Bausteine seit dem 2026-04-16-Stand: `adapter_gemini`, `fake_chat`, `fake_maps`, `domain_customer_service`, `domain_employer_mobility`, `domain_reporting`, `feature_auth`, `feature_employer_mobility`.
- Testabdeckung wurde deutlich verbessert: neue Widget-/Unit-Tests fuer Auth, Home-Chat, Journey-Screens, Journey-Domainservices, FakeChat/FakeDirections, UI-Kit und Employer Mobility sind vorhanden und laufen grün.
- Das Repo ist importseitig sauberer als der fruehe Altstand: keine `package:emma_app/...`-Imports in `packages/**` oder `services/**` gefunden.

## C. Was hat sich verschlechtert?

- Seit dem 2026-04-16-Stand wurden getrackte app-lokale Featurepfade fuer `mobility_guarantee`, `partnerhub` und `migration` geloescht, ohne dass gleichwertige getrackte Ersatzpakete sichtbar waeren. Die Docs referenzieren diese Themen weiterhin, der aktuelle Code aber nicht.
- Die sichtbare Endkundenfuehrung ist fachlich schmaler als das Zielbild: `/journey` ist hinzugekommen, aber es existiert weiterhin parallel das Legacy-`/trips`. Viele andere Screens (`Tickets`, `Payments`, `CustomerService`, `DataReporting`, `Subscriptions`, `Notifications`, `CheckInOut`) sind nicht im Router angebunden.
- Die Naming-Lage ist irrefuehrend geworden: mehrere Klassen heissen `RemoteDataSource`, `Service`, `RoutingPort` oder `Adapter`, liefern aber in Wahrheit Demo-Hardcodes oder `UnimplementedError`. Das erhoeht das Risiko falscher Reifeeinschaetzungen.
- Die Doku driftet hinterher: `melos.yaml` wird mehrfach als kanonische Datei genannt, obwohl die aktuelle Melos-Konfiguration in `pubspec.yaml` liegt. Ebenso nennen `STATUS.md`, `ENTWICKLER.md`, `trip_boundary_mapping_rules.md` und Archivdokumente teils Pfade oder Zustande, die im getrackten Code nicht mehr stimmen.

Mock-/Placeholder-Loesungen mit "echt klingenden" Namen:
- `packages/adapters/adapter_trias/lib/src/trias_service.dart`: harter Demo-Rueckgabewert mit `Future.delayed`, keine echte TRIAS-Anbindung.
- `packages/adapters/adapter_trias/lib/src/trias_routing_adapter.dart`: vollstaendig `UnimplementedError`.
- `apps/emma_app/lib/features/trips/data/datasources/trip_remote_datasource.dart`: "RemoteDataSource" mit lokalem Mock-Trip- und Mock-Location-Output.
- `packages/features/feature_employer_mobility/lib/src/data/{benefit,budget,job_ticket}_remote_datasource.dart`: allesamt harte Mockdaten hinter Dio-Interfaces.
- `packages/features/feature_auth/lib/src/data/auth_remote_datasource.dart`: Mock-Login/OAuth mit Fake-Usern.
- `apps/emma_app/lib/features/tariff_rules/data/repositories/tariff_repository_impl.dart`: lokaler Mock statt Tarifserver-/Produktkatalog-Logik.
- `apps/emma_app/lib/features/subscriptions/data/datasources/subscription_remote_datasource.dart`: Placeholder/`UnimplementedError`.

## D. Kritische fachliche Luecken

- Ticketing/Product Catalog: Es existiert kein `domain_ticketing`, kein `TicketingPort`, kein Produktkatalog, keine QR-/Barcode-Ticketanzeige, keine Tickethistorie mit pruefbarem Wallet-Objekt. `TicketsScreen` zeigt nur aus `JourneyCase` abgeleitete Booking-Intents.
- D-Ticket/Abo: `SubscriptionScreen` ist Placeholder, `SubscriptionRemoteDataSource` ist TODO/Unimplemented. Ein mockiges D-Ticket existiert nur als `JobTicket` in Employer Mobility, nicht als konsistente Abo-/Wallet-Loesung.
- Check-in/Check-out: Nur Platzhalter-Screen, keinerlei Tarif-/Lifecycle- oder Statuslogik.
- Notifications: Nur Platzhalter-Screen, keine Push-/Local-Notification-Infrastruktur, kein `NotificationPort`.
- Echtzeit/Stoerungen: Kein `RealtimePort`, kein Ereignisstream, keine aktive Betriebsbegleitung. `fake_realtime` liefert aktuell kein echtes Realtime-Monitoring fuer Usertrips.
- Partner-/Transaktionsadapter: Nur Chat/Directions koennen optional gegen reale Fremdservices laufen. Routing ist mit `TriasRoutingPort` fachlich vorbereitet, technisch aber weiter Demo/Hardcode. Sharing, On-Demand und Taxi sind im UI/Domainmodell nur angedeutet.
- Multi-Profil Privat/Arbeitgeber: `ProfileMode` existiert in Employer Mobility, ist aber nicht global ueber Auth, Konto, Ticketing, Payment und Journey transaktionssicher verbunden.
- Kundenservice und Reporting: Es gibt Domainenobjekte und passive Screens, aber kein CRM-/Service-Backend, keine Eskalations-SLAs, keine KPI-/Audit-Pipeline.
- Gleichwertigkeitsmatrix: Die behauptete 67er-Matrix ist im Repo nicht als eigenstaendige getrackte Quelle vorhanden. Das blockiert eine wirklich zeilenweise Paritaetsfreigabe.

## E. Architektur- und Modul-ID-Widersprueche

- `melos.yaml` wird in mehreren aktiven Docs genannt, existiert im Repo aber nicht. Die aktuelle Melos-7-Konfiguration lebt in `pubspec.yaml`.
- `apps/emma_app/README.md` beschreibt `apps/emma_app` noch als unvollstaendiges Zielverzeichnis vor `flutter create .`; tatsaechlich sind die Plattformordner laengst vorhanden.
- `docs/technical/trip_boundary_mapping_rules.md` spricht an einer Stelle noch davon, dass `adapter_trias` "noch anzulegen" sei; das Package ist bereits aktiv.
- `docs/planning/STATUS.md` und `docs/architecture/MAPPING.md` referenzieren teils weiterhin `mobility_guarantee`, `partnerhub` und `migration` als sichtbare Feature-Pfade, obwohl diese im getrackten App-Code entfernt wurden.
- `JourneyCase` kommentiert den Lifecycle noch als "5-phase journey", waehrend `JourneyPhase` sowie die Modultabelle eindeutig ein 8-Phasen-Modell fuehren.
- `TariffPort` im Code (`getAvailableTariffs()`) widerspricht der in `docs/technical/SPECS_MVP.md` beschriebenen Soll-Schnittstelle (`quote`, `listProducts`, Pflichtfelder, cent-genaue Preise).
- `TariffRule`, `Subscription`, `Payment`, `MobilityBudget`, `JobTicket` arbeiten mit `double`-Preisen, obwohl die Tarif-/Payment-Spec durchgaengig cent-genaue Ganzzahlen nahelegt.
- Das Zielbild "Provider nur in der App-Shell" ist nur teilweise realisiert: Auth ist bereinigt, `feature_journey` und `feature_employer_mobility` tragen weiterhin Provider in Paketen.
- Es bestehen absichtliche Parallelstrukturen fuer Routing: kanonisches `/journey` plus Legacy-`/trips`. Das ist aktuell technisch funktionsfaehig, aber fachlich doppelt und migrationsseitig riskant.

## F. Datenmuell-/Altstandsliste mit Pfad, Kategorie, Risiko, Empfehlung

Hinweis: Die explizit angefragten Ordner `_recovery`, `_emma_reference`, `_emma_review`, `duplicate_candidates`, `merge_candidates`, `parity_checks`, `model_conflicts`, `manifests` sowie alte `technical_shell`-/`AndroidStudioProjects`-Stande sind im aktuellen Git-Workspace nicht vorhanden.

| Pfad | Kategorie | Risiko | Empfehlung |
|---|---|---|---|
| `docs/_archive/2026-04-consolidation/` | Referenz/Altstand | Niedrig; wertvoll fuer Nachvollziehbarkeit, aber nicht als aktuelle Wahrheit verwenden | Behalten, explizit read-only behandeln |
| `apps/emma_app/.dart_tool/build/generated/emma_app/lib/features/mobility_guarantee/` | loeschverdaechtig, aber vor Loeschung zu pruefen | Hoches Fehlinterpretationsrisiko; suggeriert ein getracktes Feature, das im Repo nicht mehr existiert | Vor jeder Loeschung pruefen, ob Artefakt nur aus alten Buildstaenden stammt; nicht als Evidenz zaehlen |
| `apps/emma_app/.dart_tool/build/generated/emma_app/lib/features/partnerhub/` | loeschverdaechtig, aber vor Loeschung zu pruefen | Wie oben; Ghost-Feature | Vor Loeschung pruefen, danach aus Audit-/Suchpfaden ausschliessen |
| `apps/emma_app/.dart_tool/build/generated/emma_app/lib/features/migration/` | loeschverdaechtig, aber vor Loeschung zu pruefen | Wie oben; Ghost-Feature | Vor Loeschung pruefen, danach aus Audit-/Suchpfaden ausschliessen |
| `apps/emma_app/build/` | tatsaechlich entbehrlich, sofern nicht importiert/referenziert | Niedrig; typischer Build-Auswurf, aber Suchlaerm | Nicht committen, bei Bedarf lokal neu erzeugen |
| `packages/**/build/` | tatsaechlich entbehrlich, sofern nicht importiert/referenziert | Niedrig; Suchlaerm und false positives | Weiter ignorieren; nicht als Fachstand werten |
| `.dart_tool/` und `packages/**/.dart_tool/` | tatsaechlich entbehrlich, sofern nicht importiert/referenziert | Mittel; stale generated code verschleiert echten Stand | Fuer Audits konsequent ausschliessen |
| `apps/emma_app/linux/flutter/ephemeral/` | tatsaechlich entbehrlich, sofern nicht importiert/referenziert | Mittel; enthaelt Plugin-Symlinks mit eigenen `integration_test`- und `analysis_options`-Dateien, die aktive Struktur verfaelschen | Nicht in Struktur-/Testzaehlung der App aufnehmen |
| `apply_output.txt` | generierter Report | Niedrig; rein lokales Agent-/Tooling-Artefakt | Vor Loeschung pruefen; nicht produktrelevant |
| `dryrun_output.txt` | generierter Report | Niedrig; rein lokales Agent-/Tooling-Artefakt | Vor Loeschung pruefen; nicht produktrelevant |
| `.idea/` und `*.iml` | loeschverdaechtig, aber vor Loeschung zu pruefen | Niedrig bis mittel; IDE-spezifischer Litter im Repo-Root | Lokal halten oder sauber ignorieren; nicht fachlich werten |
| `.env` und `apps/emma_app/.env` | loeschverdaechtig, aber vor Loeschung zu pruefen | Mittel; potenziell irrefuehrend, da Build laut Doku auf `--dart-define` setzt | Pruefen, ob noch lokal benoetigt; ansonsten nicht fuer App-Wiring heranziehen |
| `tools/scripts/Test-EmmaFeatureCoverage.ps1` | Test-/Audit-Artefakt | Niedrig; fachlich hilfreich, aber kein Runtime-Code | Behalten; optional spaeter gegen aktuelle 14er-Modultabelle nachziehen |
| `docs/planning/STATUS.md` | aktive Dokumentation | Mittel; aktive Quelle mit teils stale Pfaden/Regelverletzungen | Aktualisieren, bevor neue Priorisierungsentscheidungen darauf basieren |
| `docs/migration/migration_checklist_v2.md` | aktive Dokumentation | Mittel; referenziert `melos.yaml` als anzulegende Datei | Auf aktuellen Workspace-Stand anheben |
| `docs/technical/trip_boundary_mapping_rules.md` | aktive Dokumentation | Mittel; beschreibt alte bzw. halbstale Boundary-Zustaende | Gegen heutige `domain_journey`-/`feature_journey`-Struktur aktualisieren |

## G. Traceability-Tabelle 14 Module

| # | Modul | Vorhandene Packages/Dateien | Vorhandene Screens | Services/Use Cases/Ports | Vorhandene Tests | Status | Konkrete Gaps | Empfohlener naechster Schritt |
|---|---|---|---|---|---|---|---|---|
| 1 | KI-Interaktionsschicht / emma Assistant | `apps/.../home/*`, `emma_contracts` (`ChatPort`, `DirectionsPort`), `fake_chat`, `fake_maps`, `adapter_gemini`, `adapter_maps` | `HomeScreen` | `HomeChatNotifier`, `FakeChatAdapter`, `GeminiChatAdapter`, `FakeDirectionsAdapter`, `GoogleMapsDirectionsAdapter` | `home_chat_notifier_test`, `fake_chat_adapter_test`, `gemini_chat_adapter_test`, `fake_directions_adapter_test`, `google_maps_directions_adapter_test` | vorbereitet | Kein echtes Hand-off in Ticketing/Journey-Phasen, keine tiefe Intent-Aufloesung, keine proaktive Journey-Steuerung | Chat direkt an `JourneyCase`/Orchestrator anbinden statt nur Prompt-Aufbereitung |
| 2 | Identitaet, Konto, Einwilligung und Praeferenzprofil | `domain_identity`, `feature_auth`, `apps/.../auth`, `apps/.../account` | `LoginScreen`, `ProfileScreen` | `AuthNotifier`, `AuthRepositoryImpl`, `AuthRemoteDataSourceImpl`, `AccountRepositoryImpl` | `auth_notifier_test` | vorbereitet | Kein Consent-Modul, kein Datenexport/Kontoloeschungspfad, keine globale Mehrprofilfaehigkeit, keine PaymentMethod-/Wallet-Verwaltung | Identitaet/Konto/Consent sauber trennen und fehlende Account-Use-Cases modellieren |
| 3 | Kontext-, Routine- und Bedarfserkennung | `domain_journey` (`demand_recognition_models.dart`, `demand_recognition_engine.dart`), `home_chat_notifier.dart` | indirekt `HomeScreen`, `JourneyStepScreen` (nicht geroutet) | `DemandRecognitionEngine`, `UserIntent`, Journey-Phase 1 | `journey_services_smoke_test` (compile/smoke), indirekt Journey-Tests | vorbereitet | Keine echte Kalender-/Standort-/Wetter-/Realtime-Integration; aktuelle App nutzt Heuristik statt Context Engine | `DemandRecognitionEngine` an reale oder klare Fake-Kontextquellen haengen und in der App sichtbar machen |
| 4 | Mobilitaetsentscheidungs- und Planungs-Engine | `domain_journey`, `feature_journey`, `adapter_trias`, `apps/.../trips` | `AppJourneySearchScreen`, `JourneySearchScreen`, `JourneyOptionDetailScreen`, `TripSearchScreen`, `TripDetailScreen` | `OptionOrchestrationEngine`, `TravelOptionSelectionService`, `RoutingPort`, `TriasRoutingPort` | `journey_search_screen_test`, `journey_option_detail_screen_test`, `journey_services_smoke_test`, `journey_summary_service_test` | vorbereitet | Reale Datenbasis fehlt; Intermodalitaet/Partnermodi nur im Modell; Parallelwelt `/trips` vs `/journey` | Legacy `trips` abbauen und `/journey` als alleinigen Planungspfad fachlich schliessen |
| 5 | Tarif-, Produkt- und Regelwerksmanagement | `domain_rules`, `emma_contracts/lib/src/ports/tariff_port.dart`, `apps/.../tariff_rules/*` | `TariffScreen` (nicht geroutet) | `TariffPort`, `TariffRepositoryImpl` | keine spezifischen Tariftests | widerspruechlich | Port-Signatur widerspricht SPEC M11; nur Mockdaten; keine Produktliste/Quotes/Versionierung; Geldmodell in `double` | TariffPort und Domainmodelle auf SPEC M11 heben, cent-genaue Preise und Tests einfuehren |
| 6 | Buchungs-, Ticketing- und Transaktionsorchestrierung | `domain_journey` (`booking_intent.dart`, `booking_execution_engine.dart`, `payment_intent.dart`, `payment_intent_service.dart`), `apps/.../tickets`, `apps/.../payments` | `TicketsScreen`, `PaymentsScreen`, `JourneyStepScreen` (nicht geroutet) | `BookingIntentService`, `BookingExecutionEngine`, `PaymentIntentService` | `journey_services_smoke_test` | vorbereitet | Kein `domain_ticketing`, kein `TicketingPort`, kein QR/Barcode, keine echte Commit-/Rollback-Anbindung fuer Endnutzer | Ticketing als eigene Domane/Port explizit einfuehren und UI an echte Statusobjekte haengen |
| 7 | Reiseakte und Journey-Orchestrator | `domain_journey` (`JourneyCase`, `JourneyState`, Contracts, MasterOrchestrator), `feature_journey` (`journey_provider.dart`, `journey_repository_impl.dart`) | `JourneyStepScreen`/`JourneyStepWidget` vorhanden, aber in App nicht geroutet | `JourneyRepository`, `JourneyNotifier`, `JourneyContractMapper`, `MasterOrchestrator`, 8 Journey-Phasen | `journey_case_test`, `journey_contract_mapper_test`, `journey_step_screen_test`, `journey_summary_service_test` | abgedeckt | Endnutzerzugang unvollstaendig; Repository baut statische Demo-Reise statt echter persistierter Reiseakte | `JourneyScreen` in die App routen und echte Persistenz-/Session-Bindung nachziehen |
| 8 | Echtzeitmonitoring und operative Reisebegleitung | `domain_journey` (`ReaccommodationService`, Phase `activeMonitoring`), `fake_realtime`, `apps/.../trips/trip_detail_screen.dart` | `TripDetailScreen` zeigt Mock-Stoerungen | Reaccommodation-/Monitoring-Metadaten im JourneyCase | keine dedizierten Realtime-/Monitoring-Tests | luecke | Kein `RealtimePort`, kein Eventstream, keine aktive Reisebegleitung, `fake_realtime` ist kein Usertrip-Monitoring | RealtimePort + Monitoring-Source definieren und aktive Reisebegleitung im UI sichtbar machen |
| 9 | Stoerfall- und Mobilitaetsgarantie-Engine | Journey-Phase-4-Modelle in `domain_journey`, Specs in `docs/technical/SPECS_MVP.md`; kein getracktes `domain_mobility_guarantee` | kein getrackter Garantie-Screen/Banner | `ReaccommodationService` setzt Garantie-Flags, aber keine Claim-Engine/Ports | keine dedizierten Garantie-Tests | widerspruechlich | Docs und Build-Artefakte suggerieren Featurepraesenz; getrackter Code fuer Garantie-Feature fehlt | Entscheidung treffen: bewusst entfernt oder neu als echtes Paket/Feature aufbauen |
| 10 | Partnerhub und Integrationsmanagement | `domain_partnerhub` mit `PartnerProfile`; Adapter-Pakete vorhanden (`adapter_maps`, `adapter_trias`, `adapter_gemini`) | kein getrackter Partnerhub-Screen | keine Registry/SLA-/Onboarding-Logik | keine Partnerhub-Tests | widerspruechlich | Partnerhub im Doku-Zielbild stark, im Code fast leer; alter App-Featurepfad wurde entfernt | Minimales Canonical Scope fuer Partnerhub definieren oder Doku/Priorisierung zurueckbauen |
| 11 | Kundenkonto, Wallet, Payment und Mobilitaetsbudget | `domain_wallet`, `domain_employer_mobility`, `feature_employer_mobility`, `apps/.../payments`, `apps/.../subscriptions` | `ProfileScreen`, `EmployerMobilityScreen`, `PaymentsScreen`, `SubscriptionScreen` | `BudgetPort`, `budgetRepositoryProvider`, `ProfileMode`, JobTicket/Budget/Benefit-Repos | `profile_mode_notifier_test` | vorbereitet | Wallet/Payment nur modelliert, nicht transaktional; Abo und Jobticket parallel statt konsolidiert; ProfileMode nicht global | Wallet/Payment/Abo-Schnitt zwischen Identity, Employer Mobility, Ticketing und Payments sauber normieren |
| 12 | Kundenservice-, Fall- und Eskalationsmanagement | `domain_customer_service`, `apps/.../customer_service`, `feature_journey` exportiert `supportCasesProvider` | `CustomerServiceScreen` | `SupportCase`, passive Fallanzeige aus JourneyCase | `support_case_test` | vorbereitet | Kein CRM, keine Eskalationswege, keine SLA-/Backoffice-Anbindung, Screen nicht geroutet | SupportCase-Quelle und Eskalations-Flow ausserhalb des Demo-JourneyState verankern |
| 13 | Lern- und Optimierungsmodul | Journey-Phase `optimization`, Reporting-/Context-Blueprints in `JourneyRepositoryImpl`, `DemandRecognitionEngine`/`OptionOrchestrationEngine` nutzen Praeferenzkontext | kein eigener Screen | keine persistente Lernengine, nur modellierte Optimierungsphase | keine dedizierten Lern-Tests | vorbereitet | Kein echter Closed Loop fuer Praeferenzen, Routinen, Outcome-Lernen oder A/B-Optimierung | Lernscope explizit auf Post-MVP oder klaren Minimalpfad herunterbrechen |
| 14 | Reporting, Qualitaetssicherung und Betriebssteuerung | `domain_reporting`, `apps/.../data_reporting`, `journey_provider.dart`, `tools/scripts/Test-EmmaFeatureCoverage.ps1` | `DataReportingScreen` | `ReportingEvent`, Journey-Reporting-Events, Audit-/Coverage-Skript | `reporting_event_test` | vorbereitet | Kein Reporting-Sink, keine KPI-/SLA-Dashboards, Screen nicht geroutet | Reporting-Scope in betriebliche Mindestevents und KPI-Nachweise zerlegen |

## H. Gleichwertigkeitspruefung Bestandsapps

Hinweis: Mangels getrackter 67er-Gleichwertigkeitsmatrix ist dies eine abgeleitete Bewertung gegen Modultabelle, Produktkatalog und Code-Evidenz.

| Funktion | Status | Evidenz im Repo | Bewertung / Gap |
|---|---|---|---|
| Routing / Reiseauskunft | vorbereitet | `/journey`, `/trips`, `domain_journey`, `feature_journey`, `adapter_trias`, Tests | Funktioniert als Demo-/Vorbereitungsstand, aber nicht gleichwertig zu produktiven Bestandsauskuenften |
| Echtzeit / Stoerungen | verschlechtert | Mock-Stoerungen in `TripDetailScreen`, Garantie-/Monitoring-Modelle | Kein echter Echtzeitadapter, keine betriebliche Reisebegleitung |
| Ticketkauf | verschlechtert | `TicketsScreen`, Booking-/Payment-Intents in `domain_journey` | Kein echter Kauf, keine Produktauswahl, kein Ticket-Wallet, keine Pruefbarkeit |
| D-Ticket / Abo | verschlechtert | `SubscriptionScreen` Placeholder; D-Ticket nur als `JobTicket`-Mock | Kein konsolidierter Abo-/D-Ticket-Pfad |
| Check-in / Check-out | verschlechtert | `CheckInOutScreen` coming soon | Reiner Platzhalter |
| On-Demand | luecke | nur Erwahnungen in Docs/Providernamen/Partnertexten | Keine eigene Domane, kein UI-Flow, keine Buchung |
| Sharing | luecke | `Benefit`-Katalog, Partnernamen in TravelOptions | Keine echte Sharing-Anbindung oder Buchungsstrecke |
| Taxi | luecke | nur in Garantie-/Produktdocs angedeutet | Keine Integration, kein Preis-/Dispatch-Pfad |
| Arbeitgebermobilitaet / Mobilitaetsbudget | vorbereitet | `feature_employer_mobility`, `domain_employer_mobility`, Budget/Benefit/JobTicket, Tests | Gute strukturelle Vorbereitung, aber weiter Mockdaten und ohne globale Transaktionswirkung |
| Kundenservice | vorbereitet | `domain_customer_service`, `CustomerServiceScreen`, SupportCases aus JourneyState | Fälle werden nur angezeigt, nicht operativ bearbeitet |
| Payment / Belege | vorbereitet | `PaymentsScreen`, `PaymentIntentService`, ReceiptDraft | Belegentwurf vorhanden, aber kein PSP, keine Persistenz, kein echter Checkout |
| Notifications | luecke | `NotificationsScreen` Placeholder | Keine operative Nachrichteninfrastruktur |

Spezifisch kritische Auftragsthemen:
- Produktkatalog: nicht vorhanden; Tarif-/Produktlogik ist Mock und nicht kaufbar.
- QR-/Barcode-Ticketanzeige: nicht vorhanden.
- Multi-Profil Privat/Arbeitgeber: nur lokal im Employer-Feature vorbereitet, nicht Ende-zu-Ende.
- Echte Partner-/Echtzeitadapter vs. Mock: Chat/Directions optional echt; Routing, Employer, Tarif, Ticketing, Realtime faktisch weiter mock/placeholder.

## I. Empfohlene naechste 10 Schritte

1. Source-of-Truth konsolidieren: fehlende 67er-Gleichwertigkeitsmatrix in das Repo holen oder den Referenzpfad verbindlich benennen.
2. Doku auf Ist-Code ziehen: `STATUS.md`, `ENTWICKLER.md`, `trip_boundary_mapping_rules.md`, `apps/emma_app/README.md` korrigieren; `melos.yaml`-Verweise entfernen.
3. Bewusst entscheiden, ob `mobility_guarantee`, `partnerhub` und `migration` absichtlich aus dem getrackten Code entfernt wurden oder wieder als kanonische Features aufgebaut werden sollen.
4. `/trips` gegen `/journey` bereinigen: entweder sauberen Migrationsplan definieren oder die Parallelwelt explizit als Legacy markieren und aus dem MVP-Sollstand ausnehmen.
5. `TariffPort` und Tarifmodelle auf SPEC M11 heben; cent-genaue Geldwerte durchsetzen; Produktkatalog/Quote statt nur `getAvailableTariffs()`.
6. Ticketing explizit abspalten: `domain_ticketing`, `TicketingPort`, Ticket-Instance, Produktkatalog, Wallet-/QR-/Barcode-Anzeige definieren.
7. Abo-/D-Ticket-Ownership klaeren: `subscriptions`, `job_ticket`, `payments` und `identity` zu einem konsistenten Vertrags-/Wallet-Modell zusammenfuehren.
8. Realtime-/Notification-Boundary definieren: `RealtimePort`, `NotificationPort`, minimale Fake-Implementierung und klare App-Anbindung fuer Monitoring/Garantie.
9. Architekturregel durchziehen: Provider aus `feature_journey` und `feature_employer_mobility` in die App-Shell heben oder die Regel offiziell lockern.
10. Echte Integrations- und Journey-Tests ergaenzen: `integration_test` statt `.gitkeep`, plus mindestens ein End-to-End-Fall fuer Home -> Journey -> Ticket/Payment/Support.

## J. Blocker / offene Entscheidungen

- Pfadblocker: Der im Auftrag genannte OneDrive-Repo-Pfad ist lokal nicht vorhanden. Das Audit basiert auf dem aktiven Git-Workspace `<LOCAL_USER_PATH>`.
- Quellenblocker: Eine eigenstaendige Gleichwertigkeitsmatrix mit 67 Funktionen ist im Repo nicht auffindbar. Ohne diese bleibt die Paritaetsbewertung fachlich begruendet, aber nicht zeilenweise verifizierbar.
- Governance-Blocker: Es ist unklar, was aktuell verbindlich gewinnt, wenn Modultabelle (14), Funktionskatalog (16), 18-Domaenen-Modell und `STATUS.md` einander widersprechen.
- Scope-Blocker: Unklar ist, ob die entfernten Features `mobility_guarantee`, `partnerhub` und `migration` absichtlich aus dem MVP-Arbeitsscope gefallen sind oder nur technisch verloren gegangen sind.
- Integrations-Blocker: Unklar ist die Produktentscheidung fuer echte Adapter bei Routing, Tarif, Realtime, Partnertransaktion und Notifications. Ohne diese Entscheidung bleibt vieles nur "vorbereitet".
