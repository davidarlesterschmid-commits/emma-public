# SPECS — Ticket-Wallet, QR-/Barcode und DisplayCredential

**Status:** gueltig fuer EMM-105  
**Stand:** 2026-04-28  
**Linear:** [EMM-105](https://example.invalid/emma-app-mdma/issue/EMM-105/r2-qr-barcode-anzeige-flow-fur-ticket-wallet-spezifizieren)  
**Projekt:** [emma App v1.0 – Gleichwertigkeit, Regelwerk und BMM](https://example.invalid/emma-app-mdma/project/emma-app-v10-gleichwertigkeit-regelwerk-und-bmm-a60e566c5727/overview)  
**Risikoklasse:** R2 Spezifikation / Fake-Credential-Vorbereitung; R3 bei produktivem Ticketing-, Kontrollstandard-, Kryptographie- oder Partneradapter.

---

## 1. Zweck

Diese Spezifikation definiert den Ticket-Wallet- und DisplayCredential-Zuschnitt fuer emma v1.0. Ziel ist, dass Tickets, Abos und Deutschlandticket-Berechtigungen nicht nur als Text/Shortcut angezeigt werden, sondern als fachlich pruefbare Wallet-Objekte mit klar gekennzeichnetem Nachweisstatus modelliert werden koennen.

EMM-105 implementiert keine produktive Kontrolllogik und keinen echten QR-/Barcode-Standard.

---

## 2. Bestehender Repo-Stand

Eine Suche nach `wallet`, `ticket credential`, `QR`, `barcode`, `DisplayCredential`, `domain_wallet` und `ticketing` ergab keinen belastbaren bestehenden Ticket-Wallet-/Credential-Zuschnitt.

Damit gilt fuer EMM-105:

```text
Status: fachlich neu vorzubereiten
Keine produktive Ticket-/Kontrollstandard-Integration vorhanden
Keine echte Signatur-/Kryptologik im Scope
```

---

## 3. Leitentscheidungen

1. Wallet-Anzeige darf nur dann als nutzbarer Nachweis erscheinen, wenn Status, Gueltigkeit und Evidence vorhanden sind.
2. Fake-/Fixture-Credentials muessen visuell und technisch als nicht-produktiv markiert sein.
3. Fehlende Credentials duerfen nicht durch produktiv wirkende Platzhalter ersetzt werden.
4. QR-/Barcode im MVP ist nur Mock-/Fixture-Anzeige, kein echter Kontrollstandard.
5. Ticket-/Subscription-Kontext muss EMM-108 und EMM-109 referenzieren.
6. Keine echte Buchung, Zahlung, Ticketaktivierung oder Kontrollsignatur in EMM-105.

---

## 4. Zielmodell

| Objekt | Zweck |
|---|---|
| `WalletItem` | Generisches Wallet-Objekt fuer Ticket, Abo, D-Ticket, Simulation oder Beleg. |
| `TicketCredential` | Fachlicher Nachweis, dass ein Ticket/Produkt angezeigt werden kann. |
| `DisplayCredential` | Darstellbare Form, z. B. QR, Barcode, Textcode, Providerlink. |
| `CredentialStatus` | Status des Nachweises: valid, expired, missing, invalid, fake. |
| `CredentialSource` | Herkunft: fixture, fake, imported, partner, productive. |
| `WalletDisplayState` | UI-/ViewModel-faehiger Zustand. |
| `CredentialDecisionTrace` | Nachvollziehbarkeit, warum ein Nachweis angezeigt oder verweigert wird. |

---

## 5. Pflichtfelder

### 5.1 WalletItem

| Feld | Typ | Pflicht | Beschreibung |
|---|---|---|---|
| `id` | string | ja | Interne Wallet-ID. |
| `userId` | string | ja | Nutzerbezug. |
| `productCode` | string | ja | Produktreferenz aus EMM-108. |
| `subscriptionId` | string? | nein | Bezug zu EMM-109, wenn Abo/D-Ticket. |
| `routeSelectionId` | string? | nein | Bezug zu EMM-99, wenn aus Reiseauswahl erzeugt. |
| `validity` | validity | ja | Gueltigkeitsfenster. |
| `credential` | DisplayCredential? | nein | Darstellbarer Nachweis. |
| `status` | CredentialStatus | ja | Nachweisstatus. |
| `source` | CredentialSource | ja | Fake/Fixture/Produktiv-Kennzeichnung. |
| `decisionTrace` | list | ja | Nachvollziehbarkeit. |

### 5.2 DisplayCredential

| Feld | Typ | Pflicht | Beschreibung |
|---|---|---|---|
| `type` | enum | ja | `qr`, `barcode`, `textCode`, `providerLink`, `none`. |
| `payload` | string? | nein | Darstellbarer Payload, bei Fake klar markiert. |
| `displayLabel` | string | ja | Nutzerverstaendlicher Titel. |
| `expiresAt` | DateTime? | nein | Ablaufzeitpunkt des Credentials. |
| `isMachineReadable` | bool | ja | Ob der Nachweis maschinenlesbar dargestellt wird. |
| `isProductionCredential` | bool | ja | Muss false fuer Fake/Fixture sein. |
| `issuer` | string? | nein | Aussteller/Provider. |

---

## 6. Statusmodell

| Status | Bedeutung | UI-Folge |
|---|---|---|
| `valid` | Nachweis ist aktuell gueltig. | Anzeigen. |
| `expired` | Nachweis abgelaufen. | Nicht als nutzbar anzeigen; Hinweis. |
| `missing` | Kein Credential vorhanden. | Fehler-/Servicehinweis. |
| `invalid` | Credential widerspricht Status/Gueltigkeit/Quelle. | Sperrhinweis. |
| `fake` | Nur Demo-/Fixture-Credential. | Sichtbar als Simulation, nie produktiv. |

---

## 7. Anzeigeentscheidung

Ein WalletItem darf als nutzbar angezeigt werden, wenn:

```text
credential != null
AND status == valid
AND validity passt
AND source == productive oder partner/imported mit Nachweis-Gate
```

Im MVP gilt:

```text
source == fake/fixture -> Anzeige nur als Simulation
```

---

## 8. Fehlerzustaende

| Fall | Verhalten |
|---|---|
| Ticket/Subscription aktiv, aber Credential fehlt | `missing`, klarer Hinweis: Nachweis nicht verfuegbar. |
| Subscription unknown | Kein aktiver Nachweis. |
| Subscription expired | WalletItem ggf. sichtbar, aber nicht nutzbar. |
| Credential fake | Demo-/Simulation-Hinweis zwingend. |
| Credential abgelaufen | Nicht nutzbar, Service-/Refresh-Hinweis. |
| Produktcode unbekannt | Nicht nutzbar, Trace `unknown_product`. |

---

## 9. Beziehung zu EMM-108

WalletItem muss den Produktkontext aus EMM-108 referenzieren:

```text
WalletItem.productCode -> TariffProduct.productCode
WalletItem.decisionTrace includes ruleSetVersion
```

Kein Credential ohne Produktkontext.

---

## 10. Beziehung zu EMM-109

Fuer Abo/D-Ticket gilt:

```text
subscription.contractStatus == active
AND subscription.validity passt
AND subscription.evidence vorhanden oder fake/fixture klar markiert
```

`unknown` oder `suspended` duerfen keinen nutzbaren Nachweis erzeugen.

---

## 11. Beziehung zu EMM-99

Wenn ein WalletItem aus einer Route entsteht, muss die Route referenziert werden:

```text
routeSelectionId -> PlanningSelectionResult.selectedRoute
```

Dadurch bleibt nachvollziehbar, welche gewaehlte Option zu welchem Wallet-/Ticketobjekt fuehrte.

---

## 12. Nicht-Scope

- Kein produktiver QR-/Barcode-Standard.
- Keine digitale Signatur.
- Keine Verschluesselung/Kryptographie.
- Kein PSP.
- Keine echte Buchung oder Ticketaktivierung.
- Keine Kontrollgeraete-Integration.
- Keine Partner-API.
- Keine UI-Umsetzung, ausser spaetere ViewModel-Faehigkeit.

---

## 13. Akzeptanzkriterien

1. WalletItem und DisplayCredential sind fachlich modellierbar.
2. Fake-/Fixture-Credentials sind klar von produktiven Credentials getrennt.
3. Fehlende Credentials fuehren zu `missing` und klarer Fehlermeldung.
4. Abgelaufene oder gesperrte Berechtigungen erzeugen keinen nutzbaren Nachweis.
5. Produkt- und Subscription-Kontext werden referenziert.
6. QR-/Barcode-Darstellung wird nicht als produktiver Kontrollstandard behauptet.
7. DecisionTrace dokumentiert Quelle, Produkt, Gueltigkeit und Credential-Status.

---

## 14. Testfaelle

| Test | Erwartung |
|---|---|
| gueltiges Fake-Ticket | Anzeige als Simulation, nicht produktiv. |
| aktives D-Ticket mit Fake-Evidence | Simulation sichtbar, Trace enthaelt Subscription. |
| aktives D-Ticket ohne Evidence | Status `missing`, kein QR/Barcode als nutzbar. |
| abgelaufenes Ticket | Status `expired`, keine Nutzungsanzeige. |
| unknown Subscription | Kein nutzbarer Nachweis. |
| produktiver Credential ohne Gate | Fehler/invalid; nicht erlaubt. |
| unbekannter Produktcode | nicht nutzbar, Trace `unknown_product`. |

---

## 15. Folgeabhaengigkeiten

| Folgeissue | Abhaengigkeit |
|---|---|
| EMM-101 | Tests muessen Wallet-/Credential-Status in Gleichwertigkeit beruecksichtigen. |
| EMM-111 | Notifications koennen Credential-/Ablauf-/Fehlerzustaende melden. |
| EMM-98 | Auswahlbildschirm kann simulierte Buchung/Wallet-Vorbereitung anzeigen. |
| Spaeter Ticketing R3 | Produktive Ticketing-/Kontrollstandard-Integration. |

---

## 16. Claude-Gate fuer R2

Claude PASS oder aequivalenter Review ist erforderlich, wenn EMM-105 in Code umgesetzt wird.

Review-Fragen:

1. Wird Fake/Fixture visuell und technisch klar getrennt?
2. Wird `missing` nicht durch produktiv wirkende Platzhalter ueberdeckt?
3. Verhindert das Modell nutzbare Nachweise bei `unknown`, `expired` oder `suspended`?
4. Referenziert Wallet EMM-108 und EMM-109 korrekt?
5. Gibt es keine produktive Ticket-/Kontrollstandard-Behauptung ohne Gate?

---

## 17. Agentenauftrag

**Codex**

- Wallet-/Credential-Modelle vorbereiten.
- Fake-Credentials nur als Simulation kennzeichnen.
- Unit Tests fuer valid, expired, missing, fake und unknown Subscription.
- Keine produktiven Adapter.
- Keine UI, ausser minimaler ViewModel-Faehigkeit falls noetig.

**Claude**

- Review gegen Gleichwertigkeit, Compliance und Fake-vs-real-Trennung.

**Cursor**

- Erst nach R2-Gate fuer UI-/Journey-Integration verwenden.
