# emma Backlog-Traceability B01-B14

Stand: 2026-04-25  
Bezug: EMM-114, EMM-124, EMM-221, ADR-08, Risikoklasse R2/R3

Diese Matrix ist keine normative Moduldefinition. Sie dokumentiert die 14
Backlog-/Implementierungsnachweise aus EMM-114 und weist sie auf Repo-Pfade,
Ports, Fakes, Tests, MVP-Regeln und Gate-Status nach. Die kanonische
Modul-Taxonomie ist `M01-M16` in [MAPPING.md](MAPPING.md); die Spalte
`Mapping (MAPPING.md)` zeigt die Zuordnung zu dieser Wahrheit.

| Backlog | Mapping (MAPPING.md) | Package/Pfad | Port | Fake/Mock | Test | Status | Risiko | Gate | Offene Folgearbeit |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| B01 KI-Interaktionsschicht / emma Assistant | kein Mapping | `packages/core/emma_contracts` (`ChatPort`), `packages/fakes/fake_chat`, App-Home-Verweise | `ChatPort` | `fake_chat` | `fake_chat`-Tests vorhanden | R2-Nachweis vorhanden; kein neues `domain_assistant` | R2 | LLM-/API-Integration Gate erforderlich / nicht implementiert | Assistant-Intent-/Action-Grenzen spaeter in eigenem Ticket schaerfen |
| B02 Identitaet, Konto, Einwilligung und Praeferenzprofil | M01 | `packages/domains/domain_identity`, `packages/fakes/fake_identity`, `packages/fakes/fake_settings` | `AuthRepository`, `AccountRepository`, `ConsentSettingsPort` | `fake_identity`, `fake_settings` | Domain-/Fake-Tests vorhanden | Domain/Fake vorhanden | R2 | IAM/SSO/KYC Gate erforderlich / nicht implementiert | Consent- und Praeferenzprofil fachlich weiter ausbauen |
| B03 Kontext-, Routine- und Bedarfserkennung | kein Mapping | `packages/domains/domain_context` | `ContextRepository` | `packages/fakes/fake_context` | `domain_context`, `fake_context` | Neues minimales Skelett | R2 | Standort-/Kalenderautomatisierung Gate erforderlich / nicht implementiert | Signalquellen und Datenschutzfreigaben separat spezifizieren |
| B04 Mobilitaetsentscheidungs- und Planungs-Engine | M02 | `packages/domains/domain_planning`, bestehend `domain_journey` fuer Journey-nahe Services | `PlanningPort` | `packages/fakes/fake_planning`, bestehend `fake_maps` | `domain_planning`, `fake_planning`, bestehende Journey-Tests | Neues minimales Skelett plus bestehende Journey-Engine | R2 | Live-TRIAS/Produktivrouting Gate erforderlich / nicht implementiert | Planung gegen echte Open-Data-Adapter separat gate-pruefen |
| B05 Tarif-, Produkt- und Regelwerksmanagement | M11 | `packages/domains/domain_rules` | `ProductCatalogPort`, bestehend `TariffPort` | `fake_tariff` | `domain_rules`, `fake_tariff` | Produktkatalog-Port ergaenzt | R2 | Produktiver Tarifserver, Abo und CiCo Gate erforderlich / nicht implementiert | Tarif-/Abo-Kontrakte separat nach MAPPING M11 (Tarifserver/Regelwerk) und MAPPING M04 (Abo/D-Ticket) spezifizieren |
| B06 Buchungs-, Ticketing- und Transaktionsorchestrierung | M03, M10 | `packages/domains/domain_ticketing` | `TicketingRepository` / `TicketingPort` typedef | `fake_ticketing` | `domain_ticketing`, `fake_ticketing` | Simulierte Booking-/Ticketing-Grenze vorhanden | R2 | Echte Tickets, Zahlung, QR-/Barcode-Liveflow Gate erforderlich / nicht implementiert | Produktive Ticketing- und PSP-Flows separat R3+ planen |
| B07 Reiseakte und Journey-Orchestrator | M02 | `packages/domains/domain_journey` | `JourneyRepository`, Journey-Services | bestehende `fake_maps`, `fake_realtime` | bestehende `domain_journey`-Tests | Vorhandenes Domain-Paket wird genutzt | R2 | Produktive Orchestrierung/Partnerhandoffs Gate erforderlich / nicht implementiert | Technische Schulden aus `MAPPING.md` separat abbauen |
| B08 Echtzeitmonitoring und operative Reisebegleitung | M02, M07, M13 | `packages/domains/domain_realtime` | `RealtimeFeedPort` | `packages/fakes/fake_realtime` | `domain_realtime`, `fake_realtime` | Neues minimales Realtime-Skelett | R2 | Live-Feed Gate erforderlich / nicht implementiert | Feed-Auswahl, Betriebsregeln und Fallbacks separat klaeren |
| B09 Stoerfall- und Mobilitaetsgarantie-Engine | M07 | `packages/domains/domain_mobility_guarantee` kanonisch; Legacy `packages/domains/domain_guarantee` migration_required_then_remove | `MobilityGuaranteePort` geplant | `packages/fakes/fake_guarantee` | `domain_mobility_guarantee`, Legacy `domain_guarantee` migration_required_then_remove, `fake_guarantee` | ADR-08/EMM-221-Kanon gesetzt; Legacy-Pfad nur noch zu migrieren/entfernen | R2 | Ersatzleistung/Kostenwirkung Gate erforderlich / nicht implementiert | Neue M07-Arbeit ausschliesslich gegen `domain_mobility_guarantee`; Garantie-Regeln, Datenschutz und Kostenfreigabe R3+ |
| B10 Partnerhub und Integrationsmanagement | M12, M06 | `packages/domains/domain_partnerhub` | `PartnerCatalogPort` | `packages/fakes/fake_partnerhub` | `domain_partnerhub`, `fake_partnerhub` | Partner-Katalog-Skelett ergaenzt | R2 | Echte Partner-APIs Gate erforderlich / nicht implementiert | Partner-Onboarding und SLA-Modell separat spezifizieren |
| B11 Kundenkonto, Wallet, Payment und Mobilitaetsbudget | M10, M08, M01 | `packages/domains/domain_wallet` | `WalletSnapshotPort`, bestehend `BudgetPort` | `packages/fakes/fake_wallet`, bestehende Budget-Fakes | `domain_wallet`, `fake_wallet` | Wallet-Snapshot ergaenzt | R2 | Payment/PSP Gate erforderlich / nicht implementiert | PSP, Split-Payment und Belege R3+ planen |
| B12 Kundenservice-, Fall- und Eskalationsmanagement | M09 | `packages/domains/domain_customer_service` | `ServiceCaseRepository` | `packages/fakes/fake_customer_service` | `domain_customer_service`, `fake_customer_service` | ServiceCase-Skelett ergaenzt | R2 | CRM-/Eskalationsadapter Gate erforderlich / nicht implementiert | CRM-Prozesse und SLA separat klaeren |
| B13 Lern- und Optimierungsmodul | kein Mapping | `packages/domains/domain_learning` | `LearningRepository` | `packages/fakes/fake_learning` | `domain_learning`, `fake_learning` | Neues minimales Learning-Skelett | R2 | Personenbezogene Automatisierung/Profiling Gate erforderlich / nicht implementiert | Consent, Transparenz und Opt-in separat spezifizieren |
| B14 Reporting, Qualitaetssicherung und Betriebssteuerung | M14 | `packages/domains/domain_reporting` | `ReportingSnapshotPort` | `packages/fakes/fake_reporting` | `domain_reporting`, `fake_reporting` | Reporting-Snapshot ergaenzt | R2 | BI-/Partnerreporting-Adapter Gate erforderlich / nicht implementiert | Betriebsmetriken und Exportziele separat definieren |

## Gate-Regeln

- Produktive Adapter sind in EMM-114 nicht implementiert.
- Payment/PSP, IAM/SSO/KYC, Abo, CiCo, echte Ticketing-Transaktionen,
  echte Partner-APIs und Garantie mit Kostenwirkung bleiben Gate-pflichtig.
- Fakes sind deterministisch und duerfen keine Netz- oder API-Abhaengigkeit
  erzwingen.
- Bei Erweiterung ueber diese Matrix hinaus ist die Risikoklasse neu zu
  pruefen; bei unklarer Bewertung gilt die hoehere plausible Klasse.
