# SPECS — Routing & Selection (MVP)

**Status:** gueltig  
**Stand:** 2026-04-28  
**Fuehrend:** `docs/product/PRODUCT_TRUTH.md`

---

## 1. Ziel

Die App erzeugt pro Mobilitaetsoption genau eine bewertete Route und stellt diese im Auswahlbildschirm dar.

---

## 2. Auswahlregel

```text
→ genau 1 Route pro Mobilitaetsoption
→ keine Mehrfachrouten
```

---

## 3. Mobilitaetsoptionen

1. OePNV
2. nextbike
3. cityflitzer
4. Shuttle
5. Taxi

---

## 4. Bewertungslogik

Score:

```text
Preis: 40 %
Zeit: 40 %
Komfort: 20 %
```

Die Route mit dem besten Score wird je Option ausgewaehlt.

---

## 5. Tarifintegration

Jede Route muss einen Preis enthalten:

- Quelle: `TariffPort` oder `fake_tariff`
- Einheit: `priceEuroCents` (int)

---

## 6. Routing-Policy

```text
1. Fake / Fixture
2. Open Data / Open Source APIs
3. Google Maps (Fallback)
```

Google Maps darf niemals Default sein.

---

## 7. Multimodalitaet

```text
Level 0 = mono
Level 1 = max 1 Wechsel
Level 2 = frei
```

Wird durch Nutzerpraeferenzen gesteuert.

---

## 8. Fallback-Regel

Wenn keine Route verfuegbar ist:

```text
→ Stub anzeigen
→ Hinweis "keine Daten verfuegbar"
```

---

## 9. Simulation

Alle Buchungsprozesse sind Simulation:

- keine echte Zahlung
- kein PSP
- kein echtes Ticket

---

## 10. Testfaelle (verpflichtend)

Fuer jede Mobilitaetsoption:

- deterministischer Routing-Test
- reproduzierbar
- ohne Google Maps lauffaehig

---

## 11. Definition of Done

- 1 Route pro Option vorhanden
- Preis vorhanden
- Auswahl deterministisch
- Tests fuer alle 5 Modi vorhanden
- Simulation sichtbar
