# MVP-Scope (Kurzreferenz)

**Massgeblich:** [ADR-04_mvp_domain_scope.md](../architecture/ADR-04_mvp_domain_scope.md) (Accepted).  
**Product Truth:** [../product/PRODUCT_TRUTH.md](../product/PRODUCT_TRUTH.md) fuer Assistant, Routing-Auswahl, Simulation und Tests.

## Vertikal (6) — produktionsnahe DoD

1. `auth_and_identity`  
2. `customer_account`  
3. `employer_mobility`  
4. `ticketing` (inkl. Anzeigepfad `subscriptions_and_d_ticket`)  
5. `routing`  
6. `mobility_guarantee`  

## Querschnitt minimal (3)

- `payments` — nur Minimal-Abstraktion Arbeitgeber-Abrechnung, kein voller PSP-Checkout. Im Home-Assistant-Flow sind Wallet-/Payment-Funktionen ausschliesslich Simulation.  
- `settings_and_consent` — DSGVO/Consent, Basis-Settings.  
- `tariff_and_rules` — **nur Lese-Tarif-Pfad** fuer Ticketing/Routing, kein Backoffice-Editor. Preis ist Pflichtbestandteil jeder Route im Auswahlbildschirm.  

## Post-MVP (9)

`ci_co`, `on_demand`, `sharing_integrations`, `taxi_integrations`, `partnerhub`, `migration_factory`, `crm_and_service`, `analytics_and_reporting`, `support_and_incident_handling`.

## Referenzkatalog 18 Domaenen

Detailliert inkl. Prioritaet und Abhaengigkeiten: [MVP_BACKLOG_18_DOMAINS.md](MVP_BACKLOG_18_DOMAINS.md) (Inventar/Referenz, nicht alles ist MVP-Pflicht).

## Home Assistant, Journey-Handoff und Auswahlbildschirm (Stand 2026-04-28)

Der Home Assistant ist MVP-relevant als lokaler, dialogisch-strukturierter Flow:

```text
User -> Chat oder Spracheingabe
     -> strukturierte Anfrage
     -> Validierung und Follow-ups
     -> JourneyReady
     -> Journey-Handoff vor Stub-Auswahl
     -> automatische Weiterleitung zum Auswahlbildschirm
     -> genau 1 Route je Mobilitaetsoption
     -> Preis + Zeit + Komfort
     -> simulierte Buchung / simuliertes Wallet
```

Verbindliche Regeln:

- Kein Stub ohne Journey-Kontext.
- Keine echte Buchung, Reservierung, Zahlung oder Aktivierung im MVP.
- Automatische Weiterleitung erfolgt nach erfolgreichem Handoff.
- Pro Mobilitaetsoption wird genau eine Route angezeigt.
- Preis kommt aus `TariffPort` / `domain_rules` oder `fake_tariff`.
- Default-Priorisierung: `OePNV > nextbike > cityflitzer > Shuttle > Taxi`.
- Nutzerpraeferenzen duerfen die Auswahl beeinflussen, muessen aber lokal/fake-first und nachvollziehbar bleiben.

## Routing-/Mapping-Policy

Die App-interne KI nutzt Routing und Mapping in dieser Reihenfolge:

1. Fake-/Fixture-Daten im MVP-Default
2. Open-Data/Open-Source bzw. kostenfreie APIs
3. Google Maps nur als expliziter Fallback

Google Maps darf niemals stillschweigender Default sein.

## Pflicht-Testfaelle Routing

Folgende Mobilitaetsoptionen sind verpflichtende Testfaelle fuer Open-Data/Open-Source bzw. kostenfreie Routing-APIs:

- OePNV
- nextbike
- cityflitzer
- Shuttle
- Taxi

Tests muessen ohne Google Maps laufen. Falls Open-Data nicht stabil verfuegbar ist, sind Fake-/Fixture-Daten zu verwenden.

## MVP-Pilot-Region, Dritt-Services, CI und simulierte Buchung (Stand: 2026-04-28)

Diese Abschnitt fasst **fachliche MVP-Grenzen** (ergaenzend **ADR-04**) zusammen; vollstaendiger Kontext: [../product/PRODUKT.md](../product/PRODUKT.md), [../product/PRODUCT_TRUTH.md](../product/PRODUCT_TRUTH.md). Technische **Architektur-** und **CI-**Konsequenzen: [ADR-06: Open-Data-Client und CI-Matrix](../architecture/ADR-06_mvp_open_data_client_and_ci_matrix.md), [ADR-07: Pilot-Regionen und Provider-Katalog](../architecture/ADR-07_mvp_pilot_regions_provider_catalogue.md). **Preis-Job-**Ablauf: [../operations/price_data_refresh_runbook.md](../operations/price_data_refresh_runbook.md).

| Thema | MVP-Entscheidung (Kurz) |
|--------|------------------------|
| Kostenpflichtige Dritt-APIs | **Nicht** im Default-Build. **Kostenlose/oeffentliche** APIs duerfen; Details ADR-03 + ADR-06. |
| Laufzeit-Daten in der Demo-App | Kostenlose Dienste primaer; Fakes Fallback bei Fehler/Offline. CI gegenteilig, siehe ADR-06. |
| Pilot-Regionen (MVP) | Nur Berlin und MDV; weitere Post-MVP. ADR-07. |
| Erst-Region | Kein Default — Nutzer muss Berlin oder MDV waehlen. |
| Ohne Region gewaehlt | Weiche Sperre (Overlay/Hinweis), App grosstenteils nutzbar; Risiko leerer Kataloge akzeptiert. ADR-07. |
| Regionswechsel | Dialog Kontext verwerfen / Abbrechen. ADR-07. |
| Anbieter je Region | Hybrid: OePNV + GBFS-System-Sharing wo sinnvoll; Taxi/On-Demand ohne stabilen Feed ueber feste Registry + Fake/Snapshot. ADR-07. |
| Simulierte multimodale Buchung (MVP) | Nur Simulation. Mindestens die Modi OePNV, nextbike, cityflitzer, Shuttle und Taxi muessen als Test-/Auswahlfaelle abbildbar sein. |
| Preis-Daten, Aktualitaet | Preis + Stand-/Gueltigkeitshinweis, keine URL im Hauptfluss; Preis kommt aus Tarifmodul/FakeTariff. |
| Sprache (Kern-UI) | DE + EN; rechts fuehrt DE. |
| Dokumentation dieser Entscheidungen | Product Truth in `docs/product/PRODUCT_TRUTH.md`; Scope hier; Technik in ADRs/SPECs. |
