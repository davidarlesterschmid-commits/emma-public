# SPECS — Regelwerksversionierung und Produktkatalog

**Status:** gueltig fuer EMM-108  
**Stand:** 2026-04-28  
**Linear:** [EMM-108](https://example.invalid/emma-app-mdma/issue/EMM-108/r2-regelwerksversionierung-und-produktkatalog-in-domain-rules)  
**Projekt:** [emma App v1.0 – Gleichwertigkeit, Regelwerk und BMM](https://example.invalid/emma-app-mdma/project/emma-app-v10-gleichwertigkeit-regelwerk-und-bmm-a60e566c5727/overview)  
**Risikoklasse:** R2 Spezifikation / Domain-Vorbereitung; R3 bei produktiver Tarifserver- oder Partnerintegration.

---

## 1. Zweck

Diese Spezifikation schliesst die fachliche Luecke `kein Produktkatalog / keine Produktvarianten` als Grundlage fuer:

- Routing-Preisindikation,
- Ticketing- und Wallet-Anzeige,
- Subscription / Deutschlandticket,
- Arbeitgeberzuschuss / Benefit-Nutzung,
- spaetere Tarifserver-Anbindung.

Die Spezifikation erweitert die bestehende `domain_rules`-Logik konzeptionell. Sie fuehrt keine produktive Tarifserverintegration ein.

---

## 2. Bestehender Repo-Stand

Im Repo existieren bereits:

- `packages/domains/domain_rules/lib/src/tariff/tariff_engine.dart`
- `packages/domains/domain_rules/lib/src/tariff/tariff_rule_set.dart`
- `packages/domains/domain_rules/lib/src/tariff/tariff_quote_result.dart`
- `packages/fakes/fake_tariff/**`
- `packages/core/emma_contracts/lib/src/ports/tariff_types.dart`
- `docs/planning/M11_TARIFF_ARCHITECTURE_DECISION.md`

Der vorhandene Stand ist fixture-/regelbasiert und kann Preise fuer einfache Zonen-/Paarregeln liefern. Produktvarianten, Gueltigkeiten, Entitlements, Subscription-Bezug und Versionierungsregeln sind noch nicht ausreichend als v1.0-Produktkatalog modelliert.

---

## 3. Leitentscheidungen

1. `domain_rules` bleibt fachlich fuehrend fuer Produkt-, Preis-, Berechtigungs- und Regelwerkslogik.
2. Fake-/Fixture-Regelwerke bleiben im MVP erlaubt, muessen aber klar als nicht-produktiv markiert sein.
3. Produktive Tarifserver-Integration ist nicht Teil von EMM-108 und braucht separates R3-Gate.
4. Jeder Preis, jede Berechtigung und jede Produktentscheidung muss eine Regelwerksversion ausweisen.
5. Kein Ticket-/Abo-/Wallet-Flow darf produktive Gleichwertigkeit behaupten, solange nur Mock-/Fixture-Regeln genutzt werden.

---

## 4. Zielmodell Produktkatalog

### 4.1 Mindestobjekte

| Objekt | Zweck |
|---|---|
| `TariffProduct` | Fachliches Produkt, z. B. Einzelfahrschein, Deutschlandticket, Tageskarte, Gruppenprodukt, Arbeitgeberzuschuss. |
| `TariffProductVariant` | Konkrete Variante mit Preis-/Gueltigkeits-/Berechtigungslogik. |
| `TariffRuleSetVersion` | Versioniertes Regelwerk mit Gueltigkeitszeitraum und Fixture-/Produktiv-Kennzeichnung. |
| `TariffEntitlement` | Berechtigung, z. B. adult, child, employerSponsored, subscriptionHolder. |
| `TariffEligibilityRule` | Regel, wann ein Produkt oder eine Variante zulaessig ist. |
| `TariffValidityRule` | Gueltigkeitsraum: Zeit, Zone, Relation, Modus, Partner, Produktkontext. |
| `TariffPriceRule` | Preisbildung: Fixpreis, Zonenpreis, Zeitpreis, Distanzpreis oder Fake-/Fallbackpreis. |
| `TariffDecisionTrace` | Nachvollziehbarkeit der angewendeten Regeln. |

---

## 5. Mindest-Produktumfang fuer v1.0/MVP

| Produkt | Code-Vorschlag | Status | Zweck |
|---|---|---|---|
| Einzelfahrschein | `MDV_SINGLE` | MVP/Fake erlaubt | Basispreis fuer einfache Routing-/Ticketing-Flows. |
| Tageskarte | `MDV_DAY` | MVP/Fake erlaubt | Produktvariante fuer laengere Nutzung / Bestpreis-Hinweis. |
| Gruppenprodukt | `MDV_GROUP_DAY` | Spezifikation | Bestands-/Produktkatalog-Luecke sichtbar machen. |
| Deutschlandticket | `DE_D_TICKET` | Spezifikation, keine echte Vertragslogik | Grundlage fuer EMM-109 Subscription. |
| Arbeitgeberzuschuss | `BMM_EMPLOYER_SUBSIDY` | Spezifikation | Grundlage fuer BMM/Budget/Benefit. |
| Benefit-Nutzung | `BMM_BENEFIT_USAGE` | Spezifikation | Grundlage fuer Arbeitgeberbenefits. |
| Fallback-Preis | `FAKE_FALLBACK` | MVP/Fake | Fallback, wenn keine produktive Regel greift. |

---

## 6. Regelwerksversionierung

### 6.1 Pflichtfelder je Regelwerk

| Feld | Typ | Pflicht | Beschreibung |
|---|---|---|---|
| `ruleSetId` | string | ja | Stabiler Identifier des Regelwerks. |
| `version` | string | ja | Semantische oder datumsbasierte Version. |
| `validFrom` | DateTime | ja | Beginn der fachlichen Gueltigkeit. |
| `validTo` | DateTime? | nein | Ende der fachlichen Gueltigkeit. |
| `source` | enum | ja | `fixture`, `fake`, `imported`, `partner`, `productive`. |
| `operatorId` | string? | nein | Betreiber-/Verbund-/Partnerbezug. |
| `checksum` | string? | nein | Optional fuer importierte/produktive Regelwerke. |
| `createdAt` | DateTime | ja | Erstellzeitpunkt. |
| `decisionTraceEnabled` | bool | ja | Muss fuer MVP true sein. |

### 6.2 Gueltigkeitsregel

Eine Tarifentscheidung ist nur gueltig, wenn:

```text
request.departureAt >= ruleSet.validFrom
AND (ruleSet.validTo == null OR request.departureAt <= ruleSet.validTo)
AND eligibilityRules passen
AND validityRules passen
```

### 6.3 Fallback-Regel

Wenn keine passende Regel gefunden wird:

```text
→ Fallback-Produkt verwenden
→ `isFallback = true`
→ Trace muss Grund enthalten, z. B. `no_product_rule`, `no_zone_mapping`, `no_validity_rule`
```

---

## 7. Preis- und Entscheidungsmodell

### 7.1 TariffQuoteResult Erweiterung

Jede Preisentscheidung muss mindestens enthalten:

- `priceEuroCents`
- `currency`
- `productCode`
- `productVariantCode`
- `ruleSetVersion`
- `validFrom`
- `validTo`
- `isFallback`
- `decisionTrace`
- `source`

### 7.2 Entscheidungsreihenfolge

1. Produktkandidaten anhand Kontext bestimmen.
2. Eligibility pruefen.
3. Gueltigkeitsregel pruefen.
4. Preisregel anwenden.
5. Ggf. guenstigste passende Variante waehlen.
6. Deterministischer Tiebreaker: `productCode`, dann `variantCode`, dann `ruleId`.
7. Trace schreiben.

---

## 8. Anforderungen an EMM-108-Codeumsetzung

### 8.1 Scope

- Produktkatalog-Modell in `domain_rules` vorbereiten.
- Regelwerksversionierung typisieren.
- Mindestprodukte als Fixture/Fake-Katalog modellieren.
- Bestehende `TariffEngine` nicht destruktiv umbauen.
- Mock-/Fake-Quelle sichtbar machen.
- Tests fuer Produktkatalog und Versionierung ergaenzen.

### 8.2 Nicht-Scope

- Keine produktive Tarifserverintegration.
- Keine echte Preisberechnung fuer MDV-Produkte.
- Keine PSP-/Payment-Integration.
- Keine Subscription-Lifecycle-Implementierung.
- Keine UI.

---

## 9. Akzeptanzkriterien

1. `domain_rules` enthaelt ein fachliches Produktkatalog-Modell.
2. Mindestprodukte sind modellierbar: Einzelfahrschein, Tageskarte, Gruppenprodukt, Deutschlandticket, Arbeitgeberzuschuss, Benefit-Nutzung, Fallback-Preis.
3. Jede Produkt-/Preisentscheidung referenziert eine Regelwerksversion.
4. Fake-/Fixture-Regeln sind klar als nicht-produktiv markiert.
5. Deterministische Tiebreaker sind dokumentiert und testbar.
6. Fehlende Regeln fuehren zu Fallback mit Trace, nicht zu unklaren Null-Zustaenden.
7. EMM-109, EMM-99 und EMM-105 koennen auf das Modell referenzieren.

---

## 10. Testfaelle

| Test | Erwartung |
|---|---|
| Produktkatalog enthaelt Mindestprodukte | Alle Pflichtprodukte vorhanden. |
| Regelwerksversion gueltig | Anfrage im Zeitraum liefert gueltiges Ergebnis. |
| Regelwerksversion abgelaufen | Ergebnis ist Fallback oder definierter Fehlerzustand. |
| Produkt nicht berechtigt | Eligibility verhindert Auswahl. |
| Fallback bei fehlender Regel | `isFallback = true`, Trace enthaelt Ursache. |
| Deterministischer Tiebreaker | Gleiche Preise liefern reproduzierbares Ergebnis. |
| Fake-Katalog sichtbar | Source ist `fixture` oder `fake`, nicht `productive`. |

---

## 11. Folgeabhaengigkeiten

| Folgeissue | Abhaengigkeit |
|---|---|
| EMM-109 | Nutzt Produkt-/Regelwerksmodell fuer Subscription und Deutschlandticket. |
| EMM-99 | Nutzt Preis-/Produktentscheidung fuer Routing-Selektion. |
| EMM-105 | Nutzt Produkt-/Ticketkontext fuer Wallet-Credential-Anzeige. |
| EMM-101 | Testet Gleichwertigkeit und verhindert falsche `abgedeckt`-Claims. |

---

## 12. Claude-Gate fuer R2

Claude PASS oder aequivalenter Review ist erforderlich, wenn EMM-108 in Code umgesetzt wird.

Review-Fragen:

1. Ist die Modellierung kompatibel mit bestehender `TariffEngine`?
2. Wird Fake/Fixture klar von produktiv getrennt?
3. Sind Regelwerksversion und Trace in allen Entscheidungen vorhanden?
4. Gibt es keine produktive Tarifserver-Behauptung ohne Adapter?
5. Sind Folgeissues EMM-109, EMM-99 und EMM-105 ausreichend vorbereitet?

---

## 13. Agentenauftrag

**Codex**

- Produktkatalog- und Versionierungsmodelle in `domain_rules` vorbereiten.
- Tests ergaenzen.
- Keine produktiven Adapter.
- Keine UI.

**Claude**

- Architektur- und Modellreview.
- Pruefung auf Product-Truth- und Gleichwertigkeitskonformitaet.

**Cursor**

- Nur nach bestandenem R2-Gate fuer fokussierte Codeintegration verwenden.
