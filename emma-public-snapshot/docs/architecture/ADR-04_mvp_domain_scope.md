# ADR-04 — MVP-Domaenen-Scope: 6 statt 18

Status: accepted
Datum: 2026-04-23
Kontext: ADR-03 (MVP ohne bezahlte APIs), CLAUDE.md, `mvp_priority_order`

## Kontext

Die emma-Domaenenliste umfasst 18 Domaenen. Ein produktionsreifer
Vollausbau aller 18 Domaenen im MVP ist unter Fake-First-Bedingungen
nicht leistbar und widerspricht dem priorisierten Markteintritt ueber
Arbeitgebermobilitaet. Bisher wurde der 18-Domaenen-Vollausbau als
formales MVP-Ziel gefuehrt (Task #21), obwohl die faktische Prioritaet
und Kapazitaet auf wenige Kern-Domaenen beschraenkt ist. Diese Diskrepanz
erzeugt Scope-Creep, stale Tasks und unklare DoD-Anwendung.

## Entscheidung

Der MVP wird auf drei Kategorien aufgeteilt:

### Vertikal ausgebaute MVP-Domaenen (6)

Diese Domaenen werden bis zur produktions-nahen Definition of Done
ausgebaut (eigene UI, eigener State, Fake oder Adapter, Tests, Fehler-
und Leer-Zustaende, Accessibility, i18n):

1. `auth_and_identity`
2. `customer_account`
3. `employer_mobility`
4. `ticketing` (inkl. Anzeigepfad `subscriptions_and_d_ticket`)
5. `routing`
6. `mobility_guarantee`

Begruendung: deckt den priorisierten Markteintritt (Arbeitgeber-
mobilitaet), das Ein-App-Kernversprechen (Routing, Ticketkauf,
Kundenkonto) und das emma-Kernversprechen Mobilitaetsgarantie ab.

### Querschnitt / nur minimal noetig (3)

Diese Domaenen sind nicht eigenstaendiger MVP-Produktscope, werden aber
in der kleinstmoeglichen Form mitgebaut, weil sonst MVP nicht lauffaehig
oder nicht compliant waere:

- `payments` — nur Minimal-Abstraktion ueber Arbeitgeber-Abrechnung.
  Kein eigener Checkout, kein eigener PSP-Anschluss.
- `settings_and_consent` — DSGVO-Pflicht-UI, Consent-Banner,
  Basis-Settings. Keine vertikale Ausbauarbeit.
- `tariff_and_rules` — nur Lese-Tarif-Pfad fuer Ticketing. Kein
  Regelwerks-Editor, kein Backoffice-Pfad im MVP.

### Post-MVP-Backlog (9)

Diese Domaenen werden im MVP bewusst NICHT ausgebaut. Stubs oder leere
Navigations-Knoten sind zulaessig, sofern sie keinen Nutzer-Traffic auf
nicht-funktionierende Pfade lenken:

- `ci_co`
- `on_demand`
- `sharing_integrations`
- `taxi_integrations`
- `partnerhub`
- `migration_factory`
- `crm_and_service`
- `analytics_and_reporting`
- `support_and_incident_handling`

## Konsequenzen

- Task #21 ("MVP-Vollumsetzung 18 Domaenen") wird durch 6 scoped Tasks
  ersetzt (je Domaene eine).
- Die Produktkommunikation (Funktionskatalog, Pitch) muss klarstellen:
  MVP ist Arbeitgebermobilitaet + Kern-Mobilitaet, keine
  Vollabdeckung aller Bestandswelten.
- `docs/planning/MVP_BACKLOG_18_DOMAINS.md` bleibt als Post-MVP-
  Referenz bestehen, ist aber nicht mehr der MVP-Arbeitsplan.
- DoD-Anwendung (aus `docs/planning/DEFINITION_OF_DONE.md`) gilt
  verbindlich nur fuer die 6 vertikal ausgebauten Domaenen.
- Bestehende Arbeit in Post-MVP-Domaenen (z.B. `domain_journey`,
  `domain_reporting`, `domain_customer_service`, `domain_wallet`)
  bleibt als Infrastruktur erhalten, weil sie als Abhaengigkeit der
  6 MVP-Domaenen bereits benutzt wird. Sie wird aber nicht als eigener
  Produktscope ausgebaut.

## Offene Folgeentscheidungen

- Fake-First-Pflicht: verbindlich fuer die 6 oder Regel aus CLAUDE.md
  streichen. Eigene Entscheidung, siehe Task-Liste.
- Pre-Commit-Hook fuer `melos run analyze`: eigene Entscheidung, siehe
  Task-Liste.
- Reihenfolge der 6 MVP-Tasks: Default folgt `mvp_priority_order`
  (1–6), kann aber bei technischen Abhaengigkeiten angepasst werden.
