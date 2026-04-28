# SPECS — Subscription, Deutschlandticket und Vertragsstatus

**Status:** gueltig fuer EMM-109  
**Stand:** 2026-04-28  
**Linear:** [EMM-109](https://example.invalid/emma-app-mdma/issue/EMM-109/r2-domain-subscription-fur-abo-deutschlandticket-und-vertragsstatus)  
**Projekt:** [emma App v1.0 – Gleichwertigkeit, Regelwerk und BMM](https://example.invalid/emma-app-mdma/project/emma-app-v10-gleichwertigkeit-regelwerk-und-bmm-a60e566c5727/overview)  
**Risikoklasse:** R2 Spezifikation / Domain-Vorbereitung; R3 bei produktiver Abo-Backend-, Ticketing- oder Vertragsintegration.

---

## 1. Zweck

Diese Spezifikation definiert das fachliche Zielmodell fuer `domain_subscription` als Grundlage fuer Abo, Deutschlandticket, Vertragsstatus und Berechtigungsnachweise in der emma App v1.0.

Sie schliesst die kritische Gleichwertigkeitsluecke, dass Deutschlandticket und Abos nicht nur als Shortcut, Label oder UI-Hinweis existieren duerfen, sondern als fachliche Vertrags-/Berechtigungsobjekte modelliert werden muessen.

---

## 2. Bestehender Repo-Stand

Eine Suche nach `domain_subscription`, `Subscription`, `Deutschlandticket`, `D-Ticket`, `ContractStatus`, `Entitlement` und `ProviderReference` ergab keinen belastbaren bestehenden Domain-Zuschnitt.

Damit gilt fuer EMM-109:

```text
Status: Domain fachlich neu vorzubereiten
Keine produktive Abo-Backend-Integration vorhanden
Keine echte Vertragsverwaltung im Scope
```

---

## 3. Leitentscheidungen

1. `domain_subscription` modelliert Vertrags- und Berechtigungsstatus, fuehrt aber keine rechtsverbindlichen Vertragsaenderungen aus.
2. Deutschlandticket ist ein fachliches `SubscriptionProduct`, nicht nur ein Shortcut oder Label.
3. Abo-Status muss mindestens `active`, `expired`, `suspended`, `unknown` abbilden.
4. Pass-through vs. eigener emma-Vertrag bleibt eine offene fachliche Entscheidung und wird explizit modelliert.
5. Produktive Abo-Backend-Adapter, Kuendigung, Pausierung, Zahlung und Vertragsaenderung sind nicht Teil von EMM-109.
6. Jede Subscription referenziert einen Produkt-/Regelwerkskontext aus EMM-108.

---

## 4. Zielmodell

### 4.1 Kernobjekte

| Objekt | Zweck |
|---|---|
| `Subscription` | Konkrete nutzerbezogene Vertrags-/Berechtigungsinstanz. |
| `SubscriptionProduct` | Fachliches Abo-Produkt, z. B. Deutschlandticket, Jobticket, Monatsabo. |
| `ContractStatus` | Aktueller Status der Vertrags-/Berechtigungsinstanz. |
| `SubscriptionValidity` | Gueltigkeitszeitraum und zeitliche Nachweislogik. |
| `SubscriptionEntitlement` | Berechtigungen, die aus dem Vertrag folgen. |
| `ProviderReference` | Referenz auf externes Abo-/Vertriebsbackend oder Partnervertrag. |
| `SubscriptionEvidence` | Nachweisdaten fuer Wallet/Ticketing/Service. |
| `SubscriptionDecisionTrace` | Nachvollziehbarkeit der Status-/Berechtigungsentscheidung. |

---

## 5. Pflichtfelder

### 5.1 Subscription

| Feld | Typ | Pflicht | Beschreibung |
|---|---|---|---|
| `id` | string | ja | Interne stabile Subscription-ID. |
| `userId` | string | ja | Nutzerbezug. |
| `productCode` | string | ja | Referenz auf Produktkatalog aus EMM-108, z. B. `DE_D_TICKET`. |
| `contractStatus` | enum | ja | Status gemaess Abschnitt 6. |
| `validity` | SubscriptionValidity | ja | Gueltigkeitsfenster. |
| `entitlements` | list | ja | Aus dem Vertrag folgende Berechtigungen. |
| `providerReference` | ProviderReference? | nein | Externe Vertrags-/Backendreferenz. |
| `contractModel` | enum | ja | `passThrough`, `emmaContract`, `unknown`. |
| `source` | enum | ja | `fixture`, `fake`, `imported`, `partner`, `productive`. |
| `ruleSetVersion` | string | ja | Referenz auf EMM-108-Regelwerksversion. |
| `evidence` | SubscriptionEvidence? | nein | Wallet-/Nachweisdaten. |
| `decisionTrace` | list | ja | Status- und Berechtigungsherkunft. |

### 5.2 ProviderReference

| Feld | Typ | Pflicht | Beschreibung |
|---|---|---|---|
| `providerId` | string | ja | Externer Provider, z. B. MDV, Patris, Partnerbackend. |
| `externalContractId` | string? | nein | Externe Vertrags-ID, falls vorhanden. |
| `externalCustomerId` | string? | nein | Externe Kunden-ID, falls vorhanden. |
| `lastSyncedAt` | DateTime? | nein | Letzter Sync mit Backend. |
| `systemOfRecord` | string | ja | Fuehrendes System: `emma`, `partner`, `unknown`. |

---

## 6. Statusmodell

| Status | Bedeutung | Nutzungsfolge |
|---|---|---|
| `active` | Vertrag/Berechtigung ist aktuell gueltig. | Anzeige und Nutzung erlaubt. |
| `expired` | Gueltigkeit abgelaufen. | Anzeige moeglich, Nutzung nicht erlaubt. |
| `suspended` | Vertrag gesperrt/pausiert/gesperrt gemeldet. | Nutzung nicht erlaubt, Servicehinweis erforderlich. |
| `unknown` | Status kann nicht belastbar bestimmt werden. | Keine produktive Nutzungsfreigabe; Fallback/Servicehinweis. |

### 6.1 Keine stillen Defaults

Wenn ein Status nicht bestimmt werden kann, darf nicht automatisch `active` angenommen werden.

```text
unknown != active
```

---

## 7. Deutschlandticket als Mindestprodukt

Das Deutschlandticket muss im MVP/Startmodell mindestens wie folgt modellierbar sein:

| Feld | Wert / Regel |
|---|---|
| `productCode` | `DE_D_TICKET` |
| `productType` | `subscription` |
| `contractModel` | `passThrough`, `emmaContract` oder `unknown` |
| `validity` | Monatlich oder providerdefiniert |
| `entitlements` | `publicTransportAccess`, ggf. regionale Zusatzregeln |
| `evidence` | Wallet-/Nachweisobjekt, produktiv spaeter mit Kontrollstandard |
| `source` | im MVP `fixture` oder `fake`, nie `productive` ohne Adapter |

---

## 8. Pass-through vs. eigener emma-Vertrag

Die fachliche Entscheidung bleibt offen, muss aber im Modell abbildbar sein.

| Modell | Bedeutung | Konsequenz |
|---|---|---|
| `passThrough` | Vertrag liegt beim Partner-/Bestandssystem, emma zeigt/validiert. | ProviderReference zwingend. |
| `emmaContract` | emma fuehrt Vertrag fachlich selbst oder ueber eigene Service-Sphaere. | Vertrags-/Payment-/Backoffice-Gate erforderlich. |
| `unknown` | Herkunft nicht belastbar bestimmt. | Keine produktive Vertragsbehauptung. |

---

## 9. Beziehung zu EMM-108

Jede Subscription muss auf einen Produkt-/Regelwerkskontext verweisen:

```text
Subscription.productCode -> TariffProduct.productCode
Subscription.ruleSetVersion -> TariffRuleSetVersion.version
```

EMM-109 darf keine Produktcodes frei erfinden, die nicht in EMM-108 dokumentiert oder vorbereitet sind.

---

## 10. Beziehung zu Wallet / EMM-105

Wallet darf ein Abo/Ticket nur als nutzbaren Nachweis anzeigen, wenn:

1. `contractStatus == active`
2. `validity` zum aktuellen Zeitpunkt passt
3. `evidence` vorhanden oder als Fake/Fixture klar markiert ist
4. `source != productive` nicht als produktiver Nachweis dargestellt wird

Bei fehlendem Evidence:

```text
→ klare Fehlermeldung
→ kein stilles QR-/Barcode-Placeholder als produktiver Nachweis
```

---

## 11. Beziehung zu BMM / Arbeitgebermobilitaet

Subscription muss spaeter arbeitgeberbezogene Berechtigungen abbilden koennen:

- Jobticket,
- Arbeitgeberzuschuss,
- Mobilitaetsbudget-Berechtigung,
- getrennte Privat-/Arbeitgeber-Nutzung.

Die eigentliche Profiltrennung wird in EMM-110 umgesetzt; EMM-109 muss aber Entitlements und ProviderReference kompatibel halten.

---

## 12. Anforderungen an EMM-109-Codeumsetzung

### 12.1 Scope

- `domain_subscription` als Domain-Package oder klar abgegrenzten Domain-Bereich vorbereiten.
- Kernmodelle definieren: Subscription, Product, Status, Validity, Entitlement, ProviderReference, Evidence, DecisionTrace.
- Fake-/Fixture-Repository fuer D-Ticket und Beispielabo vorbereiten.
- Keine produktiven Adapter.
- Tests fuer Status und Gueltigkeit ergaenzen.

### 12.2 Nicht-Scope

- Keine Kuendigung/Pausierung.
- Keine Zahlungsabwicklung.
- Kein produktiver Abo-Backend-Adapter.
- Keine rechtsverbindliche Vertragsaenderung.
- Keine echte QR-/Barcode- oder Kontrollstandard-Implementierung.
- Keine UI.

---

## 13. Akzeptanzkriterien

1. Deutschlandticket ist fachlich als SubscriptionProduct/Subscription modellierbar.
2. Status `active`, `expired`, `suspended`, `unknown` ist abbildbar.
3. Gueltigkeitszeitraum beeinflusst Nutzbarkeit.
4. Pass-through vs. eigener emma-Vertrag ist als `contractModel` abbildbar.
5. ProviderReference kann externe System-of-Record-Informationen aufnehmen.
6. Fake-/Fixture-Status ist klar als nicht-produktiv markiert.
7. EMM-105 kann Wallet-/Evidence-Anzeige darauf aufbauen.
8. EMM-108 Produkt-/Regelwerkskontext wird referenziert.

---

## 14. Testfaelle

| Test | Erwartung |
|---|---|
| Aktives D-Ticket | `active` + gueltiger Zeitraum -> nutzbar. |
| Abgelaufenes D-Ticket | `expired` oder Gueltigkeit vorbei -> nicht nutzbar. |
| Gesperrtes Abo | `suspended` -> nicht nutzbar, Servicehinweis. |
| Unbekannter Status | `unknown` -> nicht als aktiv behandeln. |
| Pass-through Subscription | ProviderReference vorhanden, systemOfRecord `partner`. |
| Fake Subscription | Source `fixture`/`fake`, keine produktive Behauptung. |
| Fehlende Evidence | Kein produktiver Wallet-Nachweis moeglich. |

---

## 15. Folgeabhaengigkeiten

| Folgeissue | Abhaengigkeit |
|---|---|
| EMM-105 | QR-/Barcode-/Wallet-Anzeige braucht Subscription/Evidence-Kontext. |
| EMM-110 | BMM-Profil und Arbeitgeberkontext muessen Entitlements sauber trennen. |
| EMM-111 | Status- und Fristenhinweise koennen auf Subscription-Ereignisse reagieren. |
| EMM-101 | Gleichwertigkeitsnachweis muss D-Ticket/Abo-Status testen. |

---

## 16. Claude-Gate fuer R2

Claude PASS oder aequivalenter Review ist erforderlich, wenn EMM-109 in Code umgesetzt wird.

Review-Fragen:

1. Wird `unknown` strikt von `active` getrennt?
2. Wird Deutschlandticket als fachliches Objekt modelliert und nicht nur als Label?
3. Ist Pass-through vs. eigener Vertrag explizit abbildbar?
4. Gibt es keine produktive Abo-/Ticketing-Behauptung ohne Adapter?
5. Ist das Modell kompatibel mit EMM-108 und EMM-105?

---

## 17. Agentenauftrag

**Codex**

- `domain_subscription`-Modelle und Fake-Repository vorbereiten.
- Unit-Tests fuer Status, Gueltigkeit, ContractModel und Evidence ergaenzen.
- Keine produktiven Adapter.
- Keine UI.

**Claude**

- Architektur- und Compliance-Review.
- Pruefung gegen Gleichwertigkeitsmatrix und Product Truth.

**Cursor**

- Nur nach bestandenem R2-Gate fuer fokussierte Integration verwenden.
