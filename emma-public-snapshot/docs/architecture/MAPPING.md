# Begriffe, Module, Ports und Pakete

**Status:** gueltig  
**Stand:** 2026-04-28  
**Product Truth:** [../product/PRODUCT_TRUTH.md](../product/PRODUCT_TRUTH.md)  
**Bezug:** ADR-04, ADR-05, ADR-08, TARGET_ARCHITECTURE, STATUS, MVP_SCOPE, SPECS_MVP

---

## 1. Zweck

Dieses Dokument ist die verbindliche Uebersetzung zwischen:

1. Funktionskatalog-Modulen M01-M16,
2. emma-Domaenen,
3. MVP-Scope 6/3/9,
4. Paket-/App-Struktur,
5. Ports, Fakes, Adaptern und App-Shell-Wiring.

Fuer Assistant-, Routing-, Auswahl-, Simulation- und Testlogik gilt ergaenzend die Product Truth:

```text
docs/product/PRODUCT_TRUTH.md
```

---

## 2. Verbindliche Architekturregeln

1. `apps/` importiert Pakete; Pakete importieren niemals `apps/`.
2. Domain-Pakete enthalten Fachlogik und sollen Dart-only bleiben.
3. Business-Logik gehoert nicht in Widgets.
4. Ports liegen in `package:emma_contracts`.
5. Fakes liefern MVP-/Testfaelle ohne bezahlte APIs und ohne Netzzwang.
6. Adapter importieren niemals App-Code.
7. Riverpod-State-Provider liegen in der App-Shell. Throw-by-default-Port-Provider in Feature-Wiring-Paketen sind als Override-Punkte erlaubt.
8. Neue Integrationen folgen dem Port-zuerst-Workflow: Port -> Fake -> Adapter -> Provider -> Bootstrap-Override.
9. Routing und Mapping fuer die App-interne KI sind Open-Data/Open-Source-first; Google Maps ist nur expliziter Fallback.
10. Buchung, Wallet, Zahlung, Reservierung und Aktivierung sind im MVP Simulation.
11. M07 nutzt gemaess ADR-08/EMM-221 kanonisch `domain_mobility_guarantee`; neue M07-Arbeit darf Legacy `domain_guarantee` migration_required_then_remove nicht als aktiven Pfad referenzieren.

---

## 3. Repo-Schichten

```text
apps/emma_app/          App-Shell: Bootstrap, Routing, Composition, Provider, Screens
packages/core/          Contracts, UI-Kit, Core, Testkit
packages/domains/       Fachliche Domain-Pakete
packages/features/      Wiederverwendbare Feature-Implementierungen
packages/adapters/      Realadapter und technische Integrationen
packages/fakes/         Fake-/Fixture-Implementierungen
services/bff_mobile/    Backend-for-Frontend
contracts/              API-, Event- und Schema-Contracts
```

---

## 4. Port- und Paket-Matrix — Integrationen

| Integration | Port | Domain | Fake | Adapter | Feature/App-Ort | Provider/Override |
|---|---|---|---|---|---|---|
| Chat-Assistent | `ChatPort` OK | — | `fake_chat` OK | `adapter_gemini` OK | `apps/.../home` / `HomeChatNotifier` | `chatPortProvider`, Fake/Gemini |
| Assistant Intake | lokal/App-Service, Port optional spaeter | — | lokal deterministisch | — | `apps/.../home/domain/assistant_intake` | HomeChatState / HomeChatNotifier |
| Directions | `DirectionsPort` OK | — | `fake_maps` OK | `adapter_maps` Open-Data/Google-Fallback | Home/Journey | `directionsPortProvider` |
| POI / Orts-Suche | `PoiSearchPort` OK | — | `fake_maps` OK | `PoiNominatimAdapter` | App/Journey | `poiSearchPortProvider` |
| Routing | `RoutingPort` OK | `domain_journey` | `fake_maps`, `fake_realtime` | `adapter_trias` | `feature_journey` | `journeyRoutingPortProvider` |
| Tarif | `TariffPort` OK | `domain_rules` | `fake_tariff` OK | spaeter Realadapter moeglich | Journey/Ticketing/Tariff UI | `journeyTariffPortProvider` |
| Budget | `BudgetPort` OK | `domain_employer_mobility` | `fake_employer_mobility` geplant | — | Employer/Journey | `journeyBudgetPortProvider` |
| Ticketing | `TicketingPort` OK (typedef) | `domain_ticketing` | `fake_ticketing` / Stubs | spaeter Partner/PSP | `/ticketing`, `apps/.../tickets` | `ticketing_providers.dart` |
| Payments/Wallet | `PaymentsPort` geplant | `domain_wallet` WIP | `fake_payments` geplant | kein PSP im MVP | Auswahl/Booking Simulation | geplant |
| Mobility Guarantee | `MobilityGuaranteePort`, `RealtimePort`, `NotificationPort` geplant | `domain_mobility_guarantee` kanonisch | `fake_guarantee` geplant | spaeter Realtime-Adapter | M07 Banner/Flow geplant | geplant |

---

## 5. MVP-Domaenen-Matrix (ADR-04)

| Domaene | Modul | MVP-Scope | Domain | Fake | Feature/App-Ort | Status / Hinweis |
|---|---|---|---|---|---|---|
| `auth_and_identity` | M01 | vertikal | `domain_identity` | `fake_identity` | `feature_auth`, App-Auth | fortgeschritten |
| `customer_account` | M01-Teil | vertikal | `domain_identity` teilweise, `domain_customer_account` optional | `fake_customer_account` | App-Account | WIP |
| `employer_mobility` | M08 | vertikal | `domain_employer_mobility` | `fake_employer_mobility` geplant | `feature_employer_mobility`, App-Employer | fortgeschritten |
| `ticketing` | M03 | vertikal | `domain_ticketing` | `fake_ticketing` | `/ticketing`, `apps/.../tickets` | WIP; echte Buchung/PSP nicht MVP |
| `routing` | M02 | vertikal | `domain_journey` | `fake_maps`, `fake_realtime` | `feature_journey`, Home/Journey | erweitert durch Assistant/Journey Selection |
| `mobility_guarantee` | M07 | vertikal | `domain_mobility_guarantee` kanonisch | `fake_guarantee` geplant | M07 Flow geplant | kritisch; Legacy `domain_guarantee` migration_required_then_remove gemaess ADR-08/EMM-221 |
| `payments` | M10 | Querschnitt-minimal | `domain_wallet` WIP | `fake_payments` geplant | simulierte Wallet/Booking UX | nur Simulation |
| `settings_and_consent` | Querschnitt | Querschnitt-minimal | — | `fake_settings`/`fake_consent` | Settings/Consent | WIP |
| `tariff_and_rules` | M11 | Querschnitt-minimal | `domain_rules` | `fake_tariff` OK | Tariff/Journey/Ticketing | Preis-Pflicht fuer Auswahlrouten |

---

## 6. Post-MVP-Domaenen

| Domaene | Modul | Paket-/App-Stand | Hinweis |
|---|---|---|---|
| `ci_co` | M05 | Stub-Screen, kein Paket | Post-MVP |
| `on_demand` | M06-Teil | kein Paket | Auswahlmodus als Stub im MVP moeglich |
| `sharing_integrations` | M06-Teil | kein Paket | nextbike/cityflitzer als Routing-Test-/Auswahlfaelle, echte Integration Post-MVP |
| `taxi_integrations` | M06-Teil | kein Paket | Taxi als Stub/Testfall, echte Integration Post-MVP |
| `partnerhub` | M12 | `domain_partnerhub` leer | Post-MVP |
| `migration_factory` | M16 | kein Paket | Post-MVP |
| `crm_and_service` | M09 | `domain_customer_service` leer | Post-MVP |
| `analytics_and_reporting` | M14 | `domain_reporting` leer | Post-MVP |
| `support_and_incident_handling` | M13 | kein Paket | Post-MVP |

Hinweis: Fruehere direkte Cross-Domain-Kopplung `domain_journey -> domain_customer_service/domain_reporting` wurde architektonisch als Schuldenpunkt identifiziert und in Richtung journey-lokaler operationaler Artefakte entkoppelt. Neue Kopplungen duerfen nicht wieder eingefuehrt werden.

---

## 7. Konsolidierte Mapping-Tabelle M01-M16

| Modul | Titel | Domaene | MVP-Scope | Domain-Paket | Feature/App-Ort | Fake/Adapter |
|---|---|---|---|---|---|---|
| M01 | Nutzerkonto/Identitaet | `auth_and_identity`, `customer_account` | vertikal MVP | `domain_identity` | `feature_auth`, App-Account | `fake_identity`, `fake_customer_account` |
| M02 | Routing/Reiseauskunft | `routing` | vertikal MVP | `domain_journey` | `feature_journey`, Home/Journey, Auswahlbildschirm geplant | `fake_maps`, `fake_realtime`, `adapter_trias`, Open-Data |
| M03 | Ticketing/Produktkauf | `ticketing` | vertikal MVP | `domain_ticketing` | `/ticketing`, `apps/.../tickets` | `fake_ticketing`, Stubs |
| M04 | Abo/Deutschlandticket | `subscriptions_and_d_ticket` | in M03 mitgefuehrt | `domain_subscription` geplant | M03-Pfad | `fake_subscriptions` geplant |
| M05 | Check-in/Check-out | `ci_co` | Post-MVP | — | Stub | — |
| M06 | Partnerbuchung | `sharing/on_demand/taxi` | Post-MVP; im MVP als simulierte Auswahloptionen sichtbar | — / `domain_partnerhub` leer | Auswahlbildschirm/Stubs | Open-Data/Fake/Snapshot |
| M07 | Mobilitaetsgarantie | `mobility_guarantee` | vertikal MVP | `domain_mobility_guarantee` kanonisch | M07 Flow/Banner geplant | `fake_guarantee` geplant |
| M08 | Arbeitgebermobilitaet | `employer_mobility` | vertikal MVP | `domain_employer_mobility` | `feature_employer_mobility` | `fake_employer_mobility` geplant |
| M09 | Kundenservice/Support | `crm_and_service` | Post-MVP | `domain_customer_service` leer | ggf. Stub | — |
| M10 | Zahlungen/Belege | `payments` | Querschnitt-minimal | `domain_wallet` WIP | simulierte Wallet/Booking UX | `fake_payments` geplant |
| M11 | Tarifserver/Regelwerk | `tariff_and_rules` | Querschnitt-minimal | `domain_rules` | Tariff/Journey/Selection | `fake_tariff` OK |
| M12 | Partnerintegration | `partnerhub` | Post-MVP | `domain_partnerhub` leer | kein App-Feature-Ordner | spaeter Adapter |
| M13 | Benachrichtigungen | `support_and_incident_handling` | Post-MVP | — | — | — |
| M14 | Daten/Reporting | `analytics_and_reporting` | Post-MVP | `domain_reporting` leer | — | — |
| M15 | Barrierefreiheit/UX | Querschnitt | Querschnittspflicht | `emma_ui_kit` | alle UI-Pfade | — |
| M16 | Migration/Cut-over | `migration_factory` | Post-MVP | — | kein App-Feature-Ordner | — |
| — | Home Assistant / App-interne KI | Querschnitt | MVP-relevant | App-lokaler Service, spaeter ggf. Port | `apps/.../home/domain/assistant_intake`, `HomeChatNotifier` | lokal deterministisch, `fake_chat` Fallback |
| — | Journey Selection | Routing/Ticketing/Payments-Querschnitt | MVP-relevant | `domain_journey`, `domain_rules`, `domain_wallet` Simulation | Auswahlbildschirm geplant | FakeTariff/Fakes/Stubs |

---

## 8. Home Assistant und Journey Selection Mapping

Verbindlicher Produktfluss:

```text
User -> Home Assistant (Chat / Voice)
     -> StructuredTravelRequest
     -> Validierung + Follow-ups
     -> JourneyReadyInput
     -> Journey-Handoff vor Stub-Auswahl
     -> automatische Navigation zum Auswahlbildschirm
     -> genau 1 Route pro Mobilitaetsoption
     -> Preis + Zeit + Komfort
     -> simulierte Booking-/Wallet-Aktion
```

Mapping:

| Flow-Schritt | Code-/Paketort | Status |
|---|---|---|
| Chat-/Voice-Input | `apps/emma_app/lib/features/home` | Chat vorhanden, Voice-Modus vorbereitet |
| Strukturierte Anfrage | `apps/.../home/domain/assistant_intake` | vorhanden |
| Validierung/Follow-ups | `AssistantIntakeService` | vorhanden |
| Kontextfortschreibung | `AssistantIntakeService.process(previous: ...)` | Service vorhanden; App-Wiring Ticket EMM-97/Follow-up |
| JourneyReadyInput | Assistant-Modelle | vorhanden |
| Journey-Handoff | Home -> `domain_journey` / `feature_journey` | geplant EMM-97 |
| Auswahlbildschirm | Journey/App-Feature | geplant EMM-98 |
| Routing-/Tarif-Selektion | `domain_journey` + `domain_rules`/`fake_tariff` | geplant EMM-99 |
| Praeferenzen/Lernen | App/Core Persistence + Journey Selection | geplant EMM-100 |
| Routing-Testfaelle | Domains/Fakes/Testkit | geplant EMM-101 |

---

## 9. Mobilitaetsoptionen und Routing-Testfaelle

Verbindliche Mobilitaetsoptionen fuer Auswahl und Tests:

1. OePNV
2. nextbike
3. cityflitzer
4. Shuttle
5. Taxi

Default-Priorisierung:

```text
OePNV > nextbike > cityflitzer > Shuttle > Taxi
```

Jede Mobilitaetsoption braucht im MVP mindestens einen deterministischen Routing-Testfall. Tests muessen ohne Google Maps laufen. Wenn Open-Data nicht stabil verfuegbar ist, muessen Fake-/Fixture-Daten verwendet werden.

---

## 10. Routing-, Tarif- und Auswahlregeln

Pro Mobilitaetsoption wird genau eine Route angezeigt.

Bewertungskriterien:

- Preis
- Zeit / Geschwindigkeit
- Komfort

Default-Gewichtung:

```text
Preis: 40 %
Zeit: 40 %
Komfort: 20 %
```

Preisquelle:

- `TariffPort` / `domain_rules`
- im MVP `fake_tariff`

Google Maps darf fuer diese Auswahl nicht Default sein. Open-Data/Open-Source oder kostenfreie APIs sind primaer; Google ist nur Fallback mit expliziter Konfiguration.

---

## 11. Simulierte Booking-/Wallet-Zuordnung

Die Auswahl kann buchungsnahe Prozesse anzeigen, aber nur simuliert.

| Bereich | MVP-Verhalten | Paket-/App-Ziel |
|---|---|---|
| OePNV-Ticket | Stub/Simulation | `domain_ticketing`, `fake_ticketing` |
| nextbike | Stub/Simulation | `sharing_integrations` spaeter, MVP Fake/Snapshot |
| cityflitzer | Stub/Simulation | `sharing_integrations` spaeter, MVP Fake/Snapshot |
| Shuttle | Stub/Simulation | `on_demand` spaeter, MVP Stub |
| Taxi | Stub/Simulation | `taxi_integrations` spaeter, MVP Stub |
| Wallet/Payment | Simulation | `domain_wallet`, `fake_payments` geplant |

Nicht erlaubt ohne separates Gate:

- echte Buchung
- echte Reservierung
- echte Zahlung
- PSP-Integration
- Partner-/Ticketing-Produktivadapter
- Aktivierung eines echten Tickets

---

## 12. Ports im Ist und geplant

### Ist

- `ChatPort`
- `DirectionsPort`
- `PoiSearchPort`
- `RoutingPort`
- `TariffPort`
- `BudgetPort`
- `TicketingPort`
- `InvoiceListPort`
- `ConsentSettingsPort`

### Geplant / offen

- `PaymentsPort`
- `MobilityGuaranteePort`
- `RealtimePort`
- `NotificationPort`
- `AssistantIntakePort` nur wenn der lokale App-Service spaeter paket-/adapterfaehig gemacht wird

Ein expliziter `AuthPort` bleibt fuer den MVP bewusst nicht gezogen.

---

## 13. Technische Schulden / Architekturverletzungen

| Thema | Ort | Status / Hinweis |
|---|---|---|
| `ProfileEditWidget` als `ConsumerStatefulWidget` | `feature_auth` | optional/kosmetisch |
| ~~Flutter-/UI-Abhaengigkeit in Domain~~ | ~~`domain_journey` / `emma_ui_kit`~~ | **erledigt** (nicht mehr reproduzierbar; `dart analyze` gruen am 2026-04-26) |
| ~~Cross-Domain-Importe aus `domain_journey`~~ | ~~ehem. `domain_customer_service` / `domain_reporting`~~ | **erledigt** (keine Imports; weiterhin: nicht wieder einfuehren, lokale Journey-Artefakte bevorzugen) |
| Doppelte Ticketing-UI | `/ticketing` + `apps/.../tickets` | Konsolidierung/kanonischer Flow offen |
| M07 Wiederaufbau / Legacy-Pfad | `_recovery/.../mobility_guarantee`, `domain_guarantee` migration_required_then_remove | ADR-08/EMM-221: `domain_mobility_guarantee` ist kanonisch; R3-Folgearbeit |
| Booking/Wallet Simulation | `domain_wallet` / `fake_payments` | noch nicht voll implementiert |

---

## 14. Verbindlichkeit

1. Neue Domaenen, Module oder neue Querschnittsflows werden zuerst hier und/oder in `PRODUCT_TRUTH.md` eingetragen, dann Code.
2. Wenn Product Truth und dieses Mapping widersprechen, ist das Mapping zu aktualisieren; Product Truth fuehrt fuer Assistant/Routing/Selection.
3. Wenn Funktionskatalog und 18-Domaenen-Modell kollidieren, gewinnt das 18-Domaenen-Modell fuer Architekturarbeit.
4. Wenn ADR-04-Scope und 18-Domaenen-Backlog kollidieren, gewinnt ADR-04 fuer den MVP-Arbeitsplan.
5. R3/R4-Aenderungen muessen `TARGET_ARCHITECTURE.md`, `MAPPING.md`, `STATUS.md` und `PRODUCT_TRUTH.md` pruefen.
6. M07-Aenderungen muessen ADR-08/EMM-221 beachten: `domain_mobility_guarantee` ist kanonisch; `domain_guarantee` ist nur als Legacy mit `migration_required_then_remove` zu referenzieren.

---

## 15. Querverweise

- Product Truth: [../product/PRODUCT_TRUTH.md](../product/PRODUCT_TRUTH.md)
- Zielarchitektur: [TARGET_ARCHITECTURE.md](TARGET_ARCHITECTURE.md)
- MVP-Scope: [../planning/MVP_SCOPE.md](../planning/MVP_SCOPE.md)
- Status/Planung: [../planning/STATUS.md](../planning/STATUS.md)
- Technische Specs: [../technical/SPECS_MVP.md](../technical/SPECS_MVP.md)
- ADR-04: [ADR-04_mvp_domain_scope.md](ADR-04_mvp_domain_scope.md)
- ADR-05: [ADR-05_chat_and_directions_behind_ports.md](ADR-05_chat_and_directions_behind_ports.md)
