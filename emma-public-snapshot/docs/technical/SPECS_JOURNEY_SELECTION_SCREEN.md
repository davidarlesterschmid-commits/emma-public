# SPECS — Journey Selection Screen

**Status:** gueltig fuer EMM-98  
**Stand:** 2026-04-28  
**Linear:** [EMM-98](https://example.invalid/emma-app-mdma/issue/EMM-98/r4-auswahlbildschirm-automatische-weiterfuhrung-mit-je-1-route-pro)  
**Projektbezug:** emma App v1.0 Core Journey / Gleichwertigkeit, Regelwerk und BMM  
**Risikoklasse:** R4, weil zentraler UX-/Journey-Flow, automatische Navigation und buchungsnahe Simulation betroffen sind.

---

## 1. Zweck

Diese Spezifikation definiert den Auswahlbildschirm nach erfolgreichem Assistant -> Journey-Handoff. Der Screen macht das Ergebnis der Planungs-Engine aus EMM-99 nutzbar: pro Mobilitaetsoption genau eine Route, inklusive Preis, Dauer, Komfort-/Zuverlaessigkeitshinweis, Fallback-/Simulation-Status und anschliessender simulierten Wallet-/Booking-Vorbereitung.

---

## 2. Voraussetzungen

EMM-98 darf erst umgesetzt werden, wenn mindestens folgende Artefakte fachlich vorliegen:

- EMM-97: validierter Journey-Handoff vor Stub-/Booking-Auswahl.
- EMM-99: PlanningSelectionResult / Routing-Selektion.
- EMM-108: Produkt-/Tarifkontext.
- EMM-109: Subscription-/D-Ticket-Kontext.
- EMM-105: Wallet-/Credential-Modell fuer Simulation und Nachweisstatus.

---

## 3. Leitentscheidungen

1. Nach `journeyReady` erfolgt automatische Navigation zum Auswahlbildschirm.
2. Der Nutzer sieht genau fuenf Mobilitaetsoptionen: OePNV, nextbike, cityflitzer, Shuttle, Taxi.
3. Pro Mobilitaetsoption wird genau eine Route angezeigt.
4. Optionen werden nie ausgeblendet; fehlende Daten erscheinen als Fallback-/Stub-Card.
5. Jede Card zeigt Preis, Dauer, Komfort-/Zuverlaessigkeitshinweis und Statuslabel.
6. Alle Buchungen, Reservierungen, Wallet- und Ticketaktionen bleiben Simulation.
7. Home-Screen-Funktionen duerfen nicht zurueckentwickelt werden.

---

## 4. Navigation

### 4.1 Trigger

```text
Home Assistant -> JourneyReadyInput -> Journey-Handoff -> PlanningSelectionResult -> automatische Navigation
```

### 4.2 Keine Navigation bei unvollstaendiger Anfrage

Wenn der Assistant noch Follow-ups benoetigt:

```text
→ Home-Chat bleibt aktiv
→ kein Selection Screen
→ kein Stub/Booking
```

### 4.3 Route

Vorgeschlagene interne Route:

```text
/journey/selection
```

Die konkrete App-Routing-Implementierung bleibt der bestehenden Navigation anzupassen.

---

## 5. Screen-Aufbau

### 5.1 Header

- Start und Ziel
- Zeitwunsch
- kurzer Hinweis, wenn Fake/Fallback/Simulation aktiv ist

### 5.2 RouteCards

Reihenfolge:

1. OePNV
2. nextbike
3. cityflitzer
4. Shuttle
5. Taxi

### 5.3 Footer / Aktion

- Route auswaehlen
- Simulation starten
- Zurueck zum Assistant
- Details / Warum diese Route?

---

## 6. RouteCard Pflichtfelder

| Feld | Pflicht | Beschreibung |
|---|---|---|
| Mobilitaetsoption | ja | OePNV, nextbike, cityflitzer, Shuttle, Taxi. |
| Kurzbeschreibung | ja | z. B. Umstieg, Dauer, Fahrzeug-/Partnerhinweis. |
| Preis | ja | voraussichtlicher Preis oder `inkludiert` mit Trace. |
| Dauer | ja | Minuten oder Zeitspanne. |
| Komfort/Zuverlaessigkeit | ja | kompakter Indikator. |
| Fallback-/Stub-Hinweis | ja, wenn zutreffend | `keine Daten verfuegbar`, `Simulation`, `Fake`. |
| Subscription-Hinweis | wenn zutreffend | z. B. `D-Ticket beruecksichtigt`. |
| CTA | ja | `Auswaehlen`, spaeter `Simulierte Buchung vorbereiten`. |

---

## 7. UI-Zustaende

| Zustand | Verhalten |
|---|---|
| `loading` | Planung wird vorbereitet. |
| `ready` | 5 Cards sichtbar. |
| `partialFallback` | einzelne Cards sind Stub/Fallback. |
| `allFallback` | alle 5 Cards sichtbar, aber als Fallback markiert. |
| `simulationPending` | Nutzer hat Route gewaehlt; simulierte Wallet-/Booking-Vorbereitung laeuft. |
| `simulationSuccess` | simuliertes Ticket/WalletItem vorbereitet. |
| `simulationFailed` | Fehlerzustand mit Retry/Zurueck. |

---

## 8. Simulation und Wallet-Anbindung

Route-Auswahl fuehrt nicht zu echter Buchung.

Flow:

```text
RouteCard auswaehlen
→ Simulation pending
→ WalletItem / DisplayCredential fake oder missing gemaess EMM-105
→ Erfolg oder Fehler anzeigen
```

Pflicht:

- Simulation muss sichtbar gekennzeichnet sein.
- Kein PSP.
- Kein produktives Ticket.
- Kein Partner-Call.

---

## 9. Fallback-/Stub-Darstellung

Wenn eine Option keine echte oder Fake-Route hat:

```text
Card bleibt sichtbar
Label: keine Daten verfuegbar
CTA: Details / Alternative pruefen
kein produktiver Buchungs-CTA
```

Fallback-Cards duerfen nicht wie belastbare Routen wirken.

---

## 10. Home-Screen Regression Guard

EMM-98 darf folgende Home-Funktionen nicht entfernen oder verschlechtern:

- Begruessungs-/Brandingbereich.
- Quick Shortcuts / Kurzverknuepfungen.
- Chat-/Textinput.
- Spracheingabe-Entry, soweit vorhanden.
- FakeMode-/Simulation-Hinweise.
- Follow-up-Dialog bei unvollstaendiger Anfrage.
- Journey-ready-Status.

---

## 11. Nicht-Scope

- Keine echte Buchung.
- Keine echte Zahlung.
- Keine produktive Ticketaktivierung.
- Keine externe Routing-/Partner-API.
- Keine neue Design-System-Architektur.
- Keine Massenformatierung.
- Keine Entfernung bestehender Home-/Journey-Funktionen.

---

## 12. Akzeptanzkriterien

1. Nach validiertem Journey-Handoff erfolgt automatische Navigation zum Auswahlbildschirm.
2. Bei unvollstaendiger Anfrage bleibt der Nutzer im Assistant-Follow-up.
3. Auswahlbildschirm zeigt genau fuenf Mobilitaetsoptionen in definierter Reihenfolge.
4. Jede Option zeigt maximal eine Route.
5. Jede Card enthaelt Preis, Dauer, Status/Fallback und Simulation-/Fake-Hinweis.
6. Auswahl einer Route startet nur Simulation.
7. Fallback-/Stub-Cards bleiben sichtbar, aber nicht als produktiv nutzbar.
8. Home-Screen-Funktionalitaeten bleiben erhalten.
9. Tests oder Review-Nachweis bestaetigen keine UX-Regression.

---

## 13. Testfaelle

| Test | Erwartung |
|---|---|
| JourneyReady -> Navigation | Selection Screen wird automatisch angezeigt. |
| Incomplete Journey -> no navigation | Follow-up bleibt im Home Assistant. |
| Ready Result | 5 Cards sichtbar. |
| Reihenfolge | OePNV, nextbike, cityflitzer, Shuttle, Taxi. |
| Fallback Card | Hinweis `keine Daten verfuegbar` sichtbar. |
| D-Ticket OePNV | Subscription-Hinweis sichtbar, falls Trace vorhanden. |
| Route auswaehlen | Simulation pending/success, keine echte Buchung. |
| Home Regression | Home-Chat, Shortcuts, Voice/Text Entry bleiben vorhanden. |

---

## 14. Claude-Gate fuer R4

Claude PASS ist vor Merge erforderlich.

Review-Fragen:

1. Wird Navigation nur nach validiertem Handoff ausgeloest?
2. Sind exakt 5 Optionen sichtbar?
3. Wird keine echte Buchung/Zahlung ausgelöst?
4. Sind Fallbacks deutlich gekennzeichnet?
5. Bleibt Home-Screen-UX erhalten?
6. Gibt es keine neue Architektur ausserhalb Scope?

---

## 15. Agentenauftrag

**Cursor**

- UI-/Navigation-Umsetzung auf Ticket-Branch.
- Keine produktiven Adapter.
- Keine Entfernung bestehender Home-Funktionen.
- Widget-/Flow-Tests, soweit im Repo-Setup moeglich.

**Codex**

- ViewModel-/State-/Fixture-Unterstuetzung und Tests.
- Keine UI-Architektur-Neuerfindung.

**Claude**

- R4 Review/Gate mit Fokus auf UX-Regression, Scope, Simulation und Product Truth.
