# EMM-XXX Mock End-to-End Journey MVP

**Risk Class:** R2  
**Stand:** 2026-04-25  
**Scope:** deterministischer Mock-Flow ohne produktive Drittintegration.

## Ziel

Der MVP-Flow fuehrt eine Journey mock-basiert durch:

1. Startscreen-Shortcut `Reise suchen`
2. Eingabe von Start und Ziel
3. deterministische Routenplanung ueber `FakeJourneyRoutingAdapter`
4. Routenauswahl
5. simulierte Buchung
6. Reiseakte im Journey-Orchestrator
7. simulierter Stoerfall
8. Fallback-Angebot
9. Abschluss der Mock-Reise

## Beruehrte Module

- `apps/emma_app`: App-Shell-Routing, Provider-Overrides, Journey-Screen-Wiring.
- `packages/features/feature_journey`: Repository-Orchestrierung, Notifier-Aktionen, MVP-Aktionsleiste.
- `packages/domains/domain_journey`: `JourneyRepository`-Port um mockbare End-to-End-Aktionen erweitert.
- `packages/fakes/fake_maps`: deterministischer `RoutingPort` fuer den MVP-Default-Build.

## Nicht-Scope

- keine TRIAS-, Tarifserver-, PSP-, Ticketing-, Taxi-, On-Demand- oder Partnerhub-Produktivintegration
- keine echten Tickets, Zahlungen, Reservierungen oder externen Partner-Handoffs
- keine neue Garantie-Engine ausserhalb der vorhandenen `ReaccommodationService`-Logik
- keine UI-Neugestaltung

## Tests

- App-Shell-Widgettest: Happy Path bis Abschluss.
- App-Shell-Widgettest: Stoerfall aktiviert Fallback-Angebot.
- Bestehende Domain-/Feature-Tests bleiben relevant fuer Services und UI-Smoke.

## Restrisiken

- `domain_journey` enthaelt weiterhin bekannte Cross-Domain-Imports; diese Arbeit vertieft das nicht, raeumt es aber auch nicht auf.
- Die Mock-Buchung erzeugt Status- und Reporting-Artefakte, aber keine echte Ticket- oder Payment-Ausfuehrung.
- Realtime/Stoerung ist ein explizit simulierter Nutzer-/Testschritt, kein laufender Monitor.

## Naechste sinnvolle Tickets

- M03: Ticketing-Handoff und Belegentwurf sauber als Port modellieren.
- M07: Garantie-Engine mit eigener Policy-/Eligibility-Logik und Tests ausbauen.
- M14: Reporting-Events aus Journey-MVP in eine einheitliche Audit-/KPI-Sicht bringen.
