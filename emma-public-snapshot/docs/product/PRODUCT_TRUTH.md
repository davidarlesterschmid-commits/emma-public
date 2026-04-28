# emma Product Truth

**Status:** verbindliche Produkt- und Systemwahrheit fuer Assistant, Routing, Auswahl, Simulation und Tests  
**Stand:** 2026-04-28  
**Linear:** EMM-96 bis EMM-101  
**Aenderungsart:** Produkt-/Architektur-Konsolidierung, keine Runtime-Aenderung

---

## 1. Zweck

Dieses Dokument ist die zentrale Produktwahrheit fuer den Home Assistant, die Journey-Vorbereitung, die Routing-Auswahl, simulierte Buchung/Wallet und Open-Data-Testbarkeit.

Andere Doku-Dateien muessen damit konsistent sein:

- `docs/architecture/TARGET_ARCHITECTURE.md`
- `docs/architecture/MAPPING.md`
- `docs/planning/STATUS.md`
- `docs/planning/MVP_SCOPE.md`
- `docs/technical/SPECS_MVP.md`

---

## 2. End-to-End Produktfluss

```text
User -> Home Assistant (Chat / Voice)
     -> strukturierte Anfrage (lokal)
     -> Validierung
     -> Follow-ups, falls erforderlich
     -> JourneyReady
     -> Journey-Handoff vor Stub-Auswahl
     -> automatische Weiterleitung zum Auswahlbildschirm
     -> genau 1 Route pro Mobilitaetsoption
     -> Preis + Zeit + Komfort
     -> simulierte Buchung / simuliertes Wallet
```

---

## 3. Home Assistant

Der Home Assistant ist dialogisch und strukturiert.

Er muss:

- Chat- und vorbereitete Voice-Eingaben aufnehmen.
- lokal ohne externe KI-Pflicht funktionieren.
- strukturierte Reiseanfragen erzeugen.
- fehlende Pflichtfelder validieren.
- Follow-up-Fragen stellen.
- bei vollstaendiger Anfrage einen `JourneyReadyInput` erzeugen.

Pflichtfelder fuer MVP:

- Startort
- Zielort
- Zielzeit oder relevante Zeitangabe

---

## 4. Journey-Handoff

Der Handoff an Journey erfolgt **vor** jeder Stub-, Buchungs- oder Wallet-Auswahl.

Regel:

```text
Keine Buchungsoption ohne Journey-Kontext.
```

Der Handoff erzeugt einen nachvollziehbaren Journey-Kontext aus `JourneyReadyInput`. Erst danach duerfen Auswahlbildschirm, Routing-Selektion und simulierte Buchungsoptionen sichtbar werden.

---

## 5. Auswahlbildschirm

Nach erfolgreichem Journey-Handoff fuehrt die App automatisch auf einen Auswahlbildschirm.

Dort gilt:

- pro Mobilitaetsoption genau eine Route
- Preis sichtbar
- Dauer sichtbar
- Komfortindikator sichtbar
- Simulation-/Stub-Hinweis sichtbar
- keine echte Buchung, Reservierung, Zahlung oder Aktivierung

---

## 6. Mobilitaetsoptionen und Priorisierung

Verbindliche Mobilitaetsoptionen:

1. OePNV
2. nextbike
3. cityflitzer
4. Shuttle
5. Taxi

Default-Priorisierung:

```text
OePNV > nextbike > cityflitzer > Shuttle > Taxi
```

Nutzerpraeferenzen duerfen diese Reihenfolge beeinflussen, muessen aber nachvollziehbar bleiben.

---

## 7. Routing-Selektion

Die App waehlt je Mobilitaetsoption genau eine Route.

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

Multimodalitaet wird nur genutzt, wenn Nutzerpraeferenzen sie erlauben.

---

## 8. Tariflogik

Jede Route braucht einen voraussichtlichen Preis.

Preisquelle:

- internes Tarifmodul (`TariffPort` / `domain_rules`)
- im MVP alternativ `fake_tariff`

Preisangaben sind MVP-Schaetzungen, keine Preisgarantie.

---

## 9. Routing-/Mapping-Policy

Die App-interne KI nutzt Routing und Mapping in dieser Reihenfolge:

1. Fake-/Fixture-Daten im MVP-Default
2. Open-Data/Open-Source oder kostenfreie APIs
3. Google Maps nur als expliziter Fallback

Google Maps darf niemals stillschweigender Default sein.

---

## 10. Simulierte Buchung und Wallet

Alle Buchungs- und Wallet-Funktionen sind im MVP Simulation.

Simuliert werden:

- Buchungsfreigabe
- Zahlungsfreigabe
- Zahlungsstatus
- Beleg / Receipt
- Ticket- oder Reservierungsstatus
- Split-Payment / Budgetpruefung

Nicht erlaubt ohne separates Gate:

- echte Buchung
- echte Reservierung
- echte Zahlung
- PSP-Anbindung
- Partner-/Ticketing-Produktivadapter
- Aktivierung eines echten Tickets

---

## 11. Routing-Testfaelle

Die folgenden Mobilitaetsoptionen sind verpflichtende Testfaelle fuer Routing mit Open-Data/Open-Source bzw. kostenfreien APIs:

- OePNV
- nextbike
- cityflitzer
- Shuttle
- Taxi

Tests muessen ohne Google Maps laufen und deterministisch reproduzierbar sein. Falls Open-Data nicht stabil verfuegbar ist, sind Fake-/Fixture-Daten zu verwenden.

---

## 12. Nutzerpraeferenzen und Lernen

Die App soll Praeferenzen lokal persistieren und aus Nutzung sowie Standort lernen.

MVP-Grenze:

- lokale Persistenz reicht
- kein Backend-Profil erforderlich
- kein komplexes ML-Modell erforderlich
- keine Cross-Device-Synchronisation erforderlich

Praeferenzen umfassen mindestens:

- bevorzugte Mobilitaetsoptionen
- erlaubte Multimodalitaet
- Gewichtung Preis/Zeit/Komfort
- Verhalten aus vorherigen Auswahlen

---

## 13. Definition of Done

Ein Assistant-/Routing-/Auswahl-Inkrement ist nur fertig, wenn:

- Assistant Intake strukturierte Anfrage erzeugt.
- fehlende Felder zu Follow-ups fuehren.
- Journey-Handoff vor Stub-Auswahl erfolgt.
- automatische Weiterleitung zum Auswahlbildschirm erfolgt.
- pro Mobilitaetsoption genau eine Route angezeigt wird.
- jede Route einen Preis aus Tarifmodul oder FakeTariff hat.
- Booking und Wallet klar als Simulation gekennzeichnet sind.
- Open-Data-first technisch testbar ist.
- Tests fuer OePNV, nextbike, cityflitzer, Shuttle und Taxi vorhanden sind.

---

## 14. Offene Produktfeinheiten

Noch zu entscheiden oder feinzugranulieren:

- Fallback bei fehlenden Open-Data-Routen: empfohlener Default = Stub + Hinweis.
- Konfigurierbarkeit der Gewichtung Preis/Zeit/Komfort.
- Multimodalitaetslevel, z. B. mono, ein Wechsel, frei.
