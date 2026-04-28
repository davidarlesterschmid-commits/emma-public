# SPECS — Routing-Tests und Gleichwertigkeitsnachweis

**Status:** gueltig fuer EMM-101  
**Stand:** 2026-04-28  
**Linear:** [EMM-101](https://example.invalid/emma-app-mdma/issue/EMM-101/r1-routing-tests-gleichwertigkeitsnachweis-erweitern)  
**Projekt:** [emma App v1.0 – Gleichwertigkeit, Regelwerk und BMM](https://example.invalid/emma-app-mdma/project/emma-app-v10-gleichwertigkeit-regelwerk-und-bmm-a60e566c5727/overview)  
**Risikoklasse:** R1 fuer reine Test-/Doku-Schaerfung; R2 bei Domain-Modell- oder Fixture-Anpassung.

---

## 1. Zweck

Diese Spezifikation definiert die Test- und Nachweislogik fuer Routing, Fallbacks und Gleichwertigkeit gegen bestehende App-Welten. Ziel ist, dass Bestandsfunktionen aus LeipzigMOVE, movemix und MOOVME nicht faelschlich als `abgedeckt` gelten, wenn nur Mock, Port, Stub oder Spezifikation vorhanden ist.

---

## 2. Bezug

EMM-101 baut auf folgenden Artefakten auf:

- `docs/planning/equivalence_matrix_backends.md`
- `docs/technical/SPECS_RULES_PRODUCT_CATALOG.md`
- `docs/technical/SPECS_SUBSCRIPTION_D_TICKET.md`
- `docs/technical/SPECS_ROUTING_PLANNING_ENGINE.md`
- `docs/technical/SPECS_ROUTING_SELECTION.md`
- `docs/planning/LINEAR_EXECUTION_MAP.md`

---

## 3. Gleichwertigkeitsstatus

| Status | Zulässiger Nachweis |
|---|---|
| `abgedeckt` | Produktiver Adapter, belastbarer Test oder Repo-Dokumentation, die den tatsächlich genutzten Funktionsumfang vollständig abdeckt. |
| `vorbereitet` | Domain-Modell, Port, Fake, Fixture, Stub oder Spezifikation vorhanden. |
| `luecke` | Kein belastbares Modell, kein Test, kein Adapter oder fehlende fachliche Entscheidung. |
| `Entscheidung offen` | Fachlicher Zielzustand noch nicht entschieden, z. B. Pass-through vs. eigener Vertrag. |

Wichtig:

```text
Mock/Port/Fake/Stub alleine => maximal `vorbereitet`, niemals `abgedeckt`.
```

---

## 4. Testdimensionen

Routing- und Gleichwertigkeitstests muessen mindestens diese Dimensionen abdecken:

1. Happy Path
2. fehlende oder unvollstaendige Daten
3. Fallback-/Stub-Verhalten
4. Partnerverfuegbarkeit
5. Stoerfall-/Garantiepfad
6. Preis-/Tarifkontext aus EMM-108
7. Subscription-/D-Ticket-Kontext aus EMM-109
8. Determinismus / Tiebreaker
9. keine Google-Maps-Pflicht
10. keine falsche Produktivbehauptung

---

## 5. Pflicht-Testfaelle je Mobilitaetsoption

| Mobilitaetsoption | Happy Path | Fallback | Gleichwertigkeitsrisiko |
|---|---|---|---|
| OePNV | Route mit Preis, Dauer, Trace | no_route -> Stub mit Hinweis | D-Ticket, Tarif, Echtzeit, Stoerung |
| nextbike | Route mit Bike-Segment/Fake-Verfuegbarkeit | keine GBFS-/Fake-Daten -> Stub | Partnerverfuegbarkeit, Deeplink/Buchung offen |
| cityflitzer | Route mit Carsharing-Segment/Fake-Verfuegbarkeit | keine Daten -> Stub | Partnerintegration, Verfuegbarkeit, Kostenlogik |
| Shuttle | Route/Option als On-Demand-/Stub-Fall | keine Verfuegbarkeit -> Stub | Buchungsprozess, Garantieersatz |
| Taxi | Taxi-/Fallback-Route mit Preisindikator | keine Daten -> Stub | Garantieersatz, Kostenrahmen, Partnerstatus |

---

## 6. Konkrete Testszenarien

### 6.1 Journey-Kontext

| Test | Erwartung |
|---|---|
| Vollstaendiger Journey-Kontext | PlanningSelectionResult enthaelt 5 Optionen. |
| Fehlender Start | Kein Routing, Follow-up erforderlich. |
| Fehlendes Ziel | Kein Routing, Follow-up erforderlich. |
| Fehlende Zeit | Kein Routing, Follow-up erforderlich oder Default-Entscheidung dokumentiert. |

### 6.2 Routing-Selektion

| Test | Erwartung |
|---|---|
| Mehrere OePNV-Kandidaten | Genau eine OePNV-Route wird gewaehlt. |
| Mehrere gleich gute Kandidaten | Tiebreaker liefert reproduzierbar dasselbe Ergebnis. |
| Modus `fast` | Schnellere Route wird bevorzugt, sofern nicht unplausibel teuer/unsicher. |
| Modus `cheap` | Günstigere Route wird bevorzugt, sofern nutzbar. |
| Modus `comfortable` | Weniger Umstiege / hoerer Komfort wird bevorzugt. |
| Modus `robust` | Zuverlaessigkeit / Garantieeignung wird bevorzugt. |

### 6.3 Tarif und Produkt

| Test | Erwartung |
|---|---|
| gueltige Regelwerksversion | Preisentscheidung enthaelt ruleSetVersion. |
| fehlende Tarifregel | Fallbackpreis mit Trace, kein Null-Preis ohne Begruendung. |
| Fake-Katalog | Source ist `fixture` oder `fake`, nicht `productive`. |
| Produktvariante | Produktcode und ggf. Variantencode nachvollziehbar. |

### 6.4 Subscription / D-Ticket

| Test | Erwartung |
|---|---|
| aktives D-Ticket | OePNV-Preis-/Berechtigungsentscheidung enthaelt Subscription-Trace. |
| abgelaufenes D-Ticket | Keine aktive Berechtigung; Hinweis/Servicefall moeglich. |
| gesperrtes Abo | Keine Nutzungsfreigabe. |
| unknown Status | Wird nicht als active behandelt. |
| fehlende Evidence | Kein produktiver Wallet-/Ticketnachweis. |

### 6.5 Fallbacks und Stubs

| Test | Erwartung |
|---|---|
| keine nextbike-Daten | nextbike bleibt sichtbar mit Stub + Hinweis. |
| keine Taxi-Daten | Taxi bleibt sichtbar mit Stub + Hinweis. |
| Partner-API down | Fake/Fixture oder Stub, keine App-Leere. |
| alle Partnerdaten fehlen | Alle 5 Optionen bleiben sichtbar, Fallbacks markiert. |

### 6.6 Google Maps und externe APIs

| Test | Erwartung |
|---|---|
| Testlauf ohne externe APIs | Alle Pflicht-Tests laufen deterministisch. |
| Google nicht konfiguriert | Tests bleiben gruen. |
| Open-Data-Provider fehlt | Fallback/Fixture greift. |

---

## 7. Gleichwertigkeitsmapping App-Welten

| Bestandsfunktion | Erwarteter EMM-101-Status | Begründung |
|---|---|---|
| Routing Start-Ziel | `vorbereitet` bis echte Adapter/Testnachweise vorliegen | Domain-/Spec-/Fake-Basis reicht nicht fuer `abgedeckt`. |
| Multimodales Routing | `vorbereitet` | 5 Modi spezifiziert, echte Partnerdaten offen. |
| Ticketpreis in Route | `vorbereitet` | Fake-/Fixture-Tarif bis produktive Tarifquelle. |
| D-Ticket Beruecksichtigung | `vorbereitet` | EMM-109 spezifiziert, Adapter/Evidence offen. |
| Sharing-Verfuegbarkeit | `luecke` oder `vorbereitet` je Fixture | Ohne Partneradapter nicht `abgedeckt`. |
| Taxi-/Shuttle-Fallback | `vorbereitet` | Stub-/Fallback-faehig, echte Buchung offen. |
| Stoerfall/Mobilitaetsgarantie | `luecke`/`vorbereitet` | M07/Realtime/Notification nicht voll implementiert. |
| QR-/Barcode-Ticketanzeige | `luecke` bis EMM-105 | Kein produktiver Credential-Nachweis. |

---

## 8. Testartefakte fuer Codex

Codex soll bei Umsetzung von EMM-101 mindestens folgende Artefakte anlegen oder erweitern:

```text
packages/domains/domain_journey/test/planning_selection_test.dart
packages/domains/domain_rules/test/product_catalog_test.dart
packages/domains/domain_subscription/test/subscription_status_test.dart
packages/fakes/*/test/*_fixture_test.dart
```

Falls `domain_subscription` noch nicht existiert, muss Codex EMM-109 vorher oder gemeinsam mit einem R2-Gate vorbereiten. Ohne Domain-Package darf EMM-101 fuer Subscription nur Doku-/Spec-Tests referenzieren, aber keinen Code-Test vortaeuschen.

---

## 9. Nicht-Scope

- Keine produktive Routing-API.
- Keine produktive Partnerintegration.
- Keine echte Buchung.
- Keine echte Zahlung.
- Keine produktive Ticket-/QR-Prueflogik.
- Keine Status-Hochstufung auf `abgedeckt`, wenn nur Mock/Port/Fake existiert.

---

## 10. Akzeptanzkriterien

1. Testmatrix fuer alle 5 Mobilitaetsoptionen liegt vor.
2. Happy Path, Fallback, Stoerfall und Partnerverfuegbarkeit sind als Testdimensionen definiert.
3. Gleichwertigkeitsstatus-Regeln verhindern falsche `abgedeckt`-Claims.
4. Tests duerfen ohne Google Maps und ohne externe APIs laufen.
5. EMM-108 und EMM-109 werden in Testfaellen referenziert.
6. Nicht implementierte Bereiche bleiben als `luecke` oder `Entscheidung offen` markiert.
7. Codex-Auftrag ist file-level ableitbar.

---

## 11. Claude-Gate

Claude PASS oder aequivalenter Review ist erforderlich, sobald EMM-101 von reiner Doku-/Testplanung in Domain-/Testcode uebergeht.

Review-Fragen:

1. Wird `abgedeckt` nur bei belastbarem Nachweis verwendet?
2. Laufen Pflicht-Tests ohne externe APIs?
3. Sind alle 5 Mobilitaetsoptionen abgedeckt?
4. Sind D-Ticket/Subscription- und Tarifkontext korrekt eingebunden?
5. Gibt es keine produktive Adapter- oder Gleichwertigkeitsbehauptung ohne Nachweis?

---

## 12. Agentenauftrag

**Codex**

- Testmatrix in konkrete Unit-/Fixture-Tests ueberfuehren.
- Keine produktiven Adapter.
- Fehlende Domain-Packages nicht stillschweigend vortaeuschen.
- Testnamen und Assertions muessen Linear-ID `EMM-101` im PR-Kontext referenzieren.

**Claude**

- Review der Testabdeckung, Statuslogik und Gleichwertigkeitsbehauptungen.
- Pruefung gegen EMM-107, EMM-108, EMM-109 und EMM-99.

**Cursor**

- Nur nach R1/R2-Gate fuer fokussierte Testintegration verwenden.
