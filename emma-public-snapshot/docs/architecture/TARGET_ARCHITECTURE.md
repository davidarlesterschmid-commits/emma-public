# emma Zielarchitektur

**Status:** gueltig als konsolidierter Architektur-Einstiegspunkt  
**Stand:** 2026-04-28  
**Linear:** EMM-87 / EMM-88 / EMM-96  
**Quelle:** `MAPPING.md`, `STATUS.md`, `AGENTS.md`, `apps/emma_app/lib`, `packages/**/lib`  
**Aenderungsart:** Konsolidierung plus verbindliche Routing-/Booking-Policy

---

## 1. Zweck

Dieses Dokument beschreibt die aktuelle Zielarchitektur von emma aus dem Repo-Stand. Es dient als Einstiegspunkt fuer Architektur-, Delivery- und Agentenarbeit.

Massgebliche Detailquellen bleiben:
- `docs/architecture/MAPPING.md`
- `docs/planning/STATUS.md`
- `docs/planning/MVP_BACKLOG_18_DOMAINS.md`
- `docs/planning/MVP_SCOPE.md`
- `docs/planning/MVP_PRODUCT_DECISIONS_2026-04-26.md`
- `docs/technical/SPECS_MVP.md`
- `AGENTS.md`

---

## 2. Verbindliche Wahrheiten

- Linear ist Projekt-Wahrheit.
- GitHub ist Code-Wahrheit.
- `MAPPING.md` ist die verbindliche Uebersetzung zwischen Produkt-, Architektur- und Code-Sprache.
- `STATUS.md` ist die verbindliche Fortschritts- und Reifegrad-Sicht.
- Dieses Dokument ist die konsolidierte Architektur-Sicht im Repo.

---

## 3. Architekturprinzipien

1. `apps/` importiert Pakete; Pakete importieren niemals `apps/`.
2. UI, Domain und Data bleiben getrennt.
3. Business-Logik gehoert nicht in Widgets.
4. Ports liegen in `package:emma_contracts`.
5. Repositories und fachliche Modelle liegen in `domain_*`.
6. Implementierungen fuer externe Systeme liegen in `adapters/` oder `fakes/`.
7. Riverpod-Provider-Deklarationen liegen im Zielbild in der App-Shell. Ausnahmen sind Throw-by-default-Port-Provider in Feature-Wiring-Paketen, die per Bootstrap ueberschrieben werden.
8. Der MVP-Default nutzt Fakes oder Open-Data und setzt keine kostenpflichtigen Dritt-APIs voraus.
9. Neue Integrationen folgen dem Port-zuerst-Workflow: Port, Fake, Adapter, App-Shell-Provider, Bootstrap-Override.
10. Neue Domain-Logik gehoert in `packages/domains/domain_*`, nicht direkt in die App.
11. Routing und Mapping fuer die App-interne KI sind Open-Data/Open-Source-first. Google Maps ist nur Fallback, nicht Default.
12. Buchung, Wallet, Zahlung und Aktivierung werden im MVP ausschliesslich simuliert. Es findet keine echte Transaktion statt.

---

## 4. Routing-/Mapping-Policy fuer App-interne KI

Die App-interne KI darf Routing-, Mapping- und Ortslogik nur ueber folgende Prioritaet nutzen:

1. Fake-/Fixture-Daten im MVP-Default.
2. Open-Data/Open-Source bzw. kostenfreie APIs, z. B. Nominatim/OSRM oder vergleichbare offene Dienste.
3. Google Maps nur als expliziter Fallback, wenn Open-Data nicht ausreicht und ein API-Key bewusst konfiguriert wurde.

Google Maps darf nicht stillschweigend Default sein. Jede Nutzung muss im Bootstrap/Config-Pfad als Fallback erkennbar bleiben.

---

## 5. Booking-/Wallet-Policy

Die drei Buchungsoptionen des Home Assistant sind ausschliesslich simulierte Antwortmoeglichkeiten:

- OePNV-Ticket buchen (Stub)
- Taxi als Ersatz buchen (Stub)
- On-Demand Shuttle (Stub)

Sie werden nur angeboten, wenn die Anfrage `journeyReady` ist oder Routing buchungsnahe Folgeprozesse benoetigt. Die Optionen duerfen keine echte Buchung, Zahlung, Aktivierung oder Reservierung ausloesen.

Wallet-nahe Funktionen im MVP sind Simulationen:

- Zahlungsfreigabe: simuliert
- Zahlungsstatus: simuliert
- Beleg/Receipt: simuliert
- Split-Payment: simuliert
- Budget-/Wallet-Pruefung: simuliert

Produktive PSP-, Ticketing-, Partner- oder Wallet-Adapter brauchen ein separates Gate.

---

## 6. Repo-Schichten

```text
apps/emma_app/          App-Shell: Bootstrap, Routing, Composition, Provider, Screens
packages/core/          Core-Bausteine: contracts, ui-kit, core, testkit
packages/domains/       Fachliche Domain-Pakete
packages/features/      Feature-Pakete und wiederverwendbare Feature-UI/-State-Maschinen
packages/adapters/      Realadapter und externe technische Integrationen
packages/fakes/         Fake-Adapter und Demo-/Testdaten fuer MVP und Tests
services/bff_mobile/    Backend-for-Frontend
contracts/              API-, Event- und Schema-Contracts
```

---

## 7. Home Assistant Ziel-UX

Der Home-Screen bildet den lokalen, dialogisch-strukturierten Assistant Flow ab:

```text
User -> Chat oder Spracheingabe -> strukturierte Anfrage -> Validierung -> Follow-ups / Buchungsvorbereitung -> Journey-ready Input -> simulierte Buchungsoptionen
```

Bestehende UX-Elemente bleiben erhalten:
- FakeModeBanner
- M07-Hinweis
- QuickNav
- Chat
- Routing-Antworten

Die Spracheingabe ist als Input-Modus vorgesehen; echte Speech-to-Text-Integration ist ein separates Inkrement.

---

## 8. Critical Path

1. M03 Ticketing: Produktkauf ist noch nicht kauf-/zahlungsfaehig. PSP, Integrationstest und UI-Konsolidierung fehlen.
2. M10 Payments: Nur Abstraktion vorhanden; kein PSP, kein Checkout, kein produktives Split-Payment.
3. M07 Mobility Guarantee: Fachlich zentral, aber technisch erst rudimentaer sichtbar; Ports, Engine und Fake fehlen.
4. M04 Subscriptions/D-Ticket: Go-Live-relevant fuer Stammkunden, aber Domain und Feature sind noch geplant.
5. M02/M11 Integration: Tarifpreis muss im Routing-Kontext sichtbar und nachvollziehbar werden.

---

## 9. Regeln fuer kuenftige Aenderungen

1. Jede Architektur- oder Modulgrenzen-Aenderung ist mindestens R3.
2. Buchungs-, Wallet-, PSP- oder echte Partnerintegration ist mindestens R4 und braucht separates Gate.
3. Keine neue Domain ohne Eintrag in `MAPPING.md`.
4. Keine neue Integration ohne Port-zuerst-Workflow.
5. Keine Business-Logik in App-Screens oder Widgets.
6. Keine neuen Riverpod-State-Provider in Paketen, ausser Throw-by-default-Port-Wiring nach bestehendem Muster.
7. Keine Post-MVP-Stubs, die produktive Nutzerfuehrung suggerieren.
8. Jede R3/R4-Aenderung muss `TARGET_ARCHITECTURE.md`, `MAPPING.md` oder `STATUS.md` pruefen und bei Bedarf aktualisieren.
