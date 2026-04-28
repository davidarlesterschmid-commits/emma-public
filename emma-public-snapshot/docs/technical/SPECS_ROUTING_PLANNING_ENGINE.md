# SPECS — Routing-Selektion und Planungs-Engine

**Status:** gueltig fuer EMM-99  
**Stand:** 2026-04-28  
**Linear:** [EMM-99](https://example.invalid/emma-app-mdma/issue/EMM-99/r2-routing-selektion-planungs-engine-nachscharfen)  
**Projekt:** [emma App v1.0 – Gleichwertigkeit, Regelwerk und BMM](https://example.invalid/emma-app-mdma/project/emma-app-v10-gleichwertigkeit-regelwerk-und-bmm-a60e566c5727/overview)  
**Risikoklasse:** R2 Spezifikation / Domain-Vorbereitung; R3 bei produktiver Routing-, Tarif-, Realtime- oder Partnerintegration.

---

## 1. Zweck

Diese Spezifikation definiert die Routing-Selektion und Planungs-Engine fuer emma v1.0. Ziel ist eine deterministische, testbare Auswahl von Mobilitaetsoptionen aus einem validierten Journey-Kontext.

Die Planungs-Engine bewertet Optionen nicht nur nach Preis und Zeit, sondern auch nach Komfort, Zuverlaessigkeit, Umstiegsrisiko, Barrierefreiheit, Verfuegbarkeit, Garantieeignung und Nutzerpraeferenz.

---

## 2. Einordnung

EMM-99 baut auf folgenden Vorarbeiten auf:

- EMM-97: Assistant -> Journey-Handoff vor Stub-/Auswahlprozessen.
- EMM-108: Produktkatalog und Regelwerksversionierung.
- EMM-109: Subscription / Deutschlandticket / Vertragsstatus.
- EMM-101: Routing-Tests und Gleichwertigkeitsnachweis.
- `docs/technical/SPECS_ROUTING_SELECTION.md`: Grundregeln fuer 1 Route pro Option, Scoring und Open-Data-first.

---

## 3. Leitentscheidungen

1. Pro Mobilitaetsoption wird genau eine empfohlene Route ausgegeben.
2. Optionen werden nicht ausgeblendet; fehlende Daten erzeugen Fallback/Stub mit Hinweis.
3. Routing ist Fake-/Fixture-first im MVP, Open-Data/Open-Source-first bei echter Integration, Google Maps nur expliziter Fallback.
4. Keine produktive Routing-, Tarif-, Ticketing-, Realtime- oder Partnerintegration ohne separates Gate.
5. Preis muss aus EMM-108-Regelwerks-/Produktlogik oder klar markiertem Fake/Fallback stammen.
6. Berechtigungen und vorhandene Abos aus EMM-109 duerfen die effektive Preis-/Nutzungslogik beeinflussen.
7. Nutzerpraeferenzen duerfen Scoring beeinflussen, aber keine intransparenten kosten- oder vertragsrelevanten Entscheidungen ausloesen.

---

## 4. Mobilitaetsoptionen

Die Planungs-Engine muss mindestens diese Optionen abbilden:

1. OePNV
2. nextbike
3. cityflitzer
4. Shuttle
5. Taxi

Default-Reihenfolge im Auswahlbildschirm:

```text
OePNV > nextbike > cityflitzer > Shuttle > Taxi
```

---

## 5. Eingangsmodell

### 5.1 Journey-Kontext

Routing darf erst starten, wenn ein validierter Journey-Kontext vorliegt.

Mindestfelder:

| Feld | Pflicht | Beschreibung |
|---|---|---|
| `origin` | ja | Startort / Haltestelle / Koordinate / semantischer Ort. |
| `destination` | ja | Zielort / Haltestelle / Koordinate / semantischer Ort. |
| `departureAt` oder `arrivalAt` | ja | Zeitwunsch. |
| `tripPurpose` | nein | Privat, Pendeln, Dienstreise, Freizeit, Stoerfall. |
| `userPreferenceProfile` | nein | Praeferenzen, Komfort, Barrierefreiheit, Verkehrsmittel. |
| `subscriptionContext` | nein | Aktive Abos / D-Ticket / Entitlements aus EMM-109. |
| `tariffContext` | ja | Regelwerksversion / Produktkatalog aus EMM-108. |
| `automationLevel` | nein | Empfehlung, Vorbereitung, Ausfuehrung nach Freigabe. |

### 5.2 Keine Stub-Auswahl ohne Journey-Kontext

Wenn `origin`, `destination` oder Zeit fehlen:

```text
→ Follow-up / Validierung
→ kein Routing
→ keine Stub-/Buchungsoption
```

---

## 6. Routing-Kandidatenmodell

| Feld | Typ | Pflicht | Beschreibung |
|---|---|---|---|
| `candidateId` | string | ja | Stabiler Kandidaten-Identifier. |
| `mobilityOption` | enum | ja | OePNV, nextbike, cityflitzer, Shuttle, Taxi. |
| `legs` | list | ja | Teilstrecken / Modi / Umstiege. |
| `durationMinutes` | int | ja | Gesamtdauer. |
| `priceEuroCents` | int | ja | Preisindikation inkl. Fallbackkennzeichnung. |
| `comfortScore` | double | ja | 0..1, hoeher ist besser. |
| `reliabilityScore` | double | ja | 0..1, hoeher ist besser. |
| `transferRiskScore` | double | ja | 0..1, hoeher ist riskanter. |
| `accessibilityScore` | double? | nein | 0..1, wenn verfuegbar. |
| `availabilityStatus` | enum | ja | available, limited, unavailable, unknown. |
| `guaranteeEligibility` | enum | ja | eligible, maybeEligible, notEligible, unknown. |
| `isFallback` | bool | ja | Fake/Stub/Fallback markiert. |
| `source` | enum | ja | fixture, fake, openData, partner, googleFallback. |
| `decisionTrace` | list | ja | Nachvollziehbarkeit. |

---

## 7. Scoring-Modell

### 7.1 Basisscore

Default-Gewichtung:

```text
Preis:          40 %
Zeit:           40 %
Komfort:        20 %
```

Erweitertes Bewertungsmodell fuer EMM-99:

```text
score =
  priceComponent        * 0.30 +
  timeComponent         * 0.25 +
  comfortComponent      * 0.15 +
  reliabilityComponent  * 0.15 +
  guaranteeComponent    * 0.10 +
  accessibilityComponent* 0.05
  - transferRiskPenalty
  - fallbackPenalty
```

Hinweis: Die Default-Produktentscheidung aus SPECS_ROUTING_SELECTION bleibt als vereinfachtes MVP-Modell gueltig. EMM-99 erweitert diese Logik fuer v1.0-faehige Planungsentscheidung.

### 7.2 Normalisierung

- Preis: niedrigster Preis der Kandidaten = bester Wert.
- Zeit: kuerzeste Dauer = bester Wert.
- Komfort/Zuverlaessigkeit/Barrierefreiheit: bereits 0..1.
- Garantie: eligible > maybeEligible > unknown > notEligible.
- Transfer-Risiko: hoeherer Wert reduziert Score.
- Fallback: Stub/Fake darf angezeigt, aber nicht unmarkiert bevorzugt werden.

### 7.3 User-Modi

| Modus | Gewichtungswirkung |
|---|---|
| `balanced` | Default. |
| `fast` | Zeit und Zuverlaessigkeit hoeher gewichten. |
| `cheap` | Preis hoeher gewichten. |
| `comfortable` | Komfort, Barrierefreiheit und Umstiegsrisiko hoeher gewichten. |
| `robust` | Zuverlaessigkeit und Garantieeignung hoeher gewichten. |

---

## 8. Auswahlregel

Pro Mobilitaetsoption:

```text
candidate list -> filter invalid -> score -> sort deterministic -> take first
```

Deterministische Tiebreaker:

1. hoeherer Score,
2. geringerer Preis,
3. geringere Dauer,
4. niedrigere Transferanzahl,
5. `mobilityOption` Default-Reihenfolge,
6. `candidateId` lexikografisch.

---

## 9. Fallback-/Stub-Regel

Wenn keine belastbare Route fuer eine Mobilitaetsoption verfuegbar ist:

```text
→ StubCandidate erzeugen
→ `isFallback = true`
→ `availabilityStatus = unknown` oder `unavailable`
→ Hinweis: `keine Daten verfuegbar`
→ Option bleibt im Ergebnis sichtbar
```

Google Maps darf nur als expliziter Fallback genutzt werden, nie als Default.

---

## 10. Preis- und Berechtigungsintegration

### 10.1 Preis aus EMM-108

Jede Route muss einen Preis enthalten:

```text
RoutingCandidate.priceEuroCents <- TariffDecision.priceEuroCents
RoutingCandidate.decisionTrace includes TariffDecision.ruleSetVersion
```

### 10.2 Subscription aus EMM-109

Wenn eine aktive Subscription vorhanden ist, kann die effektive Preislogik angepasst werden:

| Fall | Wirkung |
|---|---|
| aktives D-Ticket fuer OePNV | effektiver OePNV-Preis kann 0 oder `included` sein, aber Trace muss Subscription enthalten. |
| abgelaufenes D-Ticket | keine Preisreduktion, Service-/Hinweis moeglich. |
| unknown Status | keine Nutzungsfreigabe als aktiv. |
| Arbeitgeber-Entitlement | nur wenn Profil-/BMM-Kontext valide ist. |

---

## 11. Output-Modell

`PlanningSelectionResult` muss enthalten:

| Feld | Zweck |
|---|---|
| `journeyContextId` | Bezug zum validierten Journey-Handoff. |
| `recommendedRoutes` | Map: MobilityOption -> exactly one SelectedRoute. |
| `globalRecommendation` | Optionale Top-Empfehlung. |
| `fallbacks` | Liste sichtbarer Fallback-/Stub-Faelle. |
| `decisionTrace` | Gesamttrace fuer Auswahl. |
| `warnings` | Hinweise wie Fake/Fallback/unknown status. |
| `ruleSetVersion` | Genutzte Tarif-/Produktversion. |

---

## 12. Nicht-Scope

- Keine produktive Routing-API.
- Keine echte Partnerbuchung.
- Keine echte Zahlung.
- Keine echte Ticketaktivierung.
- Keine Google-Maps-Default-Nutzung.
- Keine UI-Umsetzung des Auswahlbildschirms.
- Keine personenbezogene Lernlogik ohne EMM-100.

---

## 13. Akzeptanzkriterien

1. Aus validiertem Journey-Kontext entsteht ein PlanningSelectionResult.
2. Genau eine Route je Mobilitaetsoption wird ausgegeben.
3. Alle fuenf Optionen bleiben sichtbar.
4. Jede Route hat Preis, Dauer, Komfort-/Zuverlaessigkeitsindikator und Entscheidungstrace.
5. Fehlende Daten erzeugen Fallback/Stub statt Null-/Leerergebnis.
6. EMM-108-Regelwerksversion wird im Trace referenziert.
7. EMM-109-Subscriptionstatus wird nicht falsch als aktiv interpretiert.
8. Keine produktive API-Behauptung ohne Adapter/Gate.
9. Deterministische Tiebreaker sind dokumentiert und testbar.

---

## 14. Testfaelle

| Test | Erwartung |
|---|---|
| Vollstaendiger Journey-Kontext | Ergebnis enthaelt 5 Optionen. |
| Fehlender Journey-Kontext | Kein Routing, Follow-up erforderlich. |
| Mehrere OePNV-Kandidaten | Genau eine OePNV-Route nach Score. |
| Keine nextbike-Daten | nextbike Stub mit Hinweis sichtbar. |
| Aktives D-Ticket | OePNV-Preislogik beruecksichtigt Subscription im Trace. |
| Unknown Subscription | Keine aktive Berechtigung. |
| Modus `fast` | Schnellere Route wird bevorzugt. |
| Modus `cheap` | Günstigere Route wird bevorzugt. |
| Fallback vs echte Route | echte Route wird bei vergleichbarer Qualitaet bevorzugt. |
| Deterministischer Tiebreaker | Wiederholte Auswertung liefert gleiche Auswahl. |

---

## 15. Folgeabhaengigkeiten

| Folgeissue | Abhaengigkeit |
|---|---|
| EMM-101 | Routing-Tests pruefen Gleichwertigkeit und Fallbacks. |
| EMM-100 | Praeferenzen beeinflussen Scoring. |
| EMM-98 | Auswahlbildschirm zeigt Ergebnis. |
| EMM-105 | Wallet/Buchungssimulation nutzt ausgewaehlte Route. |
| EMM-111 | Notifications koennen auf Routing-/Fallback-Events reagieren. |

---

## 16. Claude-Gate fuer R2

Claude PASS oder aequivalenter Review ist erforderlich, wenn EMM-99 in Code umgesetzt wird.

Review-Fragen:

1. Startet Routing nur nach validiertem Journey-Handoff?
2. Gibt es exakt eine Route pro Mobilitaetsoption?
3. Werden Preis, Subscription und Fallbacks sauber getraced?
4. Sind Fake/Open-Data/Google-Fallback klar getrennt?
5. Sind Scoring und Tiebreaker deterministisch?
6. Gibt es keine Scope-Ausweitung in echte Buchung, Zahlung oder Live-Adapter?

---

## 17. Agentenauftrag

**Codex**

- Domain-/Service-Modelle fuer PlanningSelection vorbereiten.
- Fake-/Fixture-Kandidaten fuer alle fuenf Mobilitaetsoptionen bereitstellen.
- Scoring und Tiebreaker mit Unit Tests implementieren.
- Keine Live-API, keine UI.

**Claude**

- Review Scoring, Determinismus, Product-Truth-Konformitaet.
- Pruefung gegen EMM-108, EMM-109 und EMM-101.

**Cursor**

- Erst nach R2-Gate fuer Integration in App-/Journey-Flow verwenden.
