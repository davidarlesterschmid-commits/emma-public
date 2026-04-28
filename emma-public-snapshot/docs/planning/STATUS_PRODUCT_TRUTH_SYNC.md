# Status-Sync — Assistant, Journey, Routing

**Status:** gueltig  
**Stand:** 2026-04-28  
**Fuehrend:** `docs/product/PRODUCT_TRUTH.md`  
**Bezug:** EMM-96 bis EMM-101

---

## Zweck

Diese Datei synchronisiert den laufenden Status mit der Product Truth fuer Home Assistant, Journey-Handoff, Auswahlbildschirm, Routing-Selektion, Praeferenzen und Open-Data-Testfaelle.

Sie ergaenzt `docs/planning/STATUS.md`, ohne dessen historischen Audit-/Snapshot-Teil zu ueberschreiben.

---

## Systemstatus

| Bereich | Status |
|---|---|
| Assistant Intake | vorhanden |
| Strukturierte Anfrage | vorhanden |
| Validierung + Follow-ups | vorhanden |
| JourneyReadyInput | vorhanden |
| Journey-Handoff | in Umsetzung, EMM-97 |
| Auswahlbildschirm | in Umsetzung, EMM-98 |
| Routing-/Tarif-Selektion | in Umsetzung, EMM-99 |
| Praeferenzen / lernende Auswahl | in Umsetzung, EMM-100 |
| Routing-Testfaelle | in Umsetzung, EMM-101 |

---

## Verbindlicher Produktfluss

```text
User -> Assistant
     -> strukturierte Anfrage
     -> Validierung + Follow-ups
     -> JourneyReady
     -> Journey-Handoff vor Stub-Auswahl
     -> automatische Weiterleitung
     -> Auswahlbildschirm
     -> genau 1 Route pro Mobilitaetsoption
     -> Preis + Zeit + Komfort
     -> simulierte Buchung / simuliertes Wallet
```

---

## Mobilitaetsoptionen

1. OePNV
2. nextbike
3. cityflitzer
4. Shuttle
5. Taxi

Default-Priorisierung:

```text
OePNV > nextbike > cityflitzer > Shuttle > Taxi
```

---

## Systemregeln

- Kein Stub ohne Journey-Kontext.
- Genau eine Route pro Mobilitaetsoption.
- Preis ist Pflichtbestandteil jeder Route.
- Routing/Mapping ist Open-Data/Open-Source-first.
- Google Maps ist nur expliziter Fallback.
- Booking, Wallet, Zahlung, Reservierung und Aktivierung sind Simulation.
- Produktive PSP-, Ticketing-, Partner- oder Wallet-Adapter brauchen separates Gate.

---

## Testpflicht

Fuer alle fuenf Mobilitaetsoptionen muessen deterministische Routing-Testfaelle bestehen:

- OePNV
- nextbike
- cityflitzer
- Shuttle
- Taxi

Tests muessen ohne Google Maps laufen. Wenn Open-Data nicht stabil verfuegbar ist, sind Fake-/Fixture-Daten zu verwenden.

---

## Naechste Umsetzungsschritte

1. EMM-97: Assistant -> Journey-Handoff vor Stub-Auswahl.
2. EMM-99: Routing-/Tarif-Selektion je Mobilitaetsoption.
3. EMM-98: Auswahlbildschirm mit automatischer Weiterleitung.
4. EMM-101: Open-Data Routing-Testfaelle.
5. EMM-100: Persistierte Praeferenzen und lernende Auswahl.

---

## Konsistenzregel

Wenn diese Datei und `STATUS.md` abweichen, gilt fuer Assistant/Routing/Selection der Stand aus `PRODUCT_TRUTH.md` und dieser Sync-Datei. `STATUS.md` ist beim naechsten planbaren Doku-Refactor entsprechend zu kuerzen oder zu referenzieren.
