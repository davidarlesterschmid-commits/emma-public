# SPECS — BMM Profilkontext: Privat / Arbeitgeber

**Status:** gueltig fuer EMM-110  
**Stand:** 2026-04-28  
**Linear:** [EMM-110](https://example.invalid/emma-app-mdma/issue/EMM-110/r2-multi-profil-privat-arbeitgeber-rollenmodell-fur-bmm)  
**Projekt:** [emma App v1.0 – Gleichwertigkeit, Regelwerk und BMM](https://example.invalid/emma-app-mdma/project/emma-app-v10-gleichwertigkeit-regelwerk-und-bmm-a60e566c5727/overview)  
**Risikoklasse:** R2 Spezifikation / lokale Profil- und Kontextlogik; R3 bei produktiver Arbeitgeber-, Payroll-, Budget-, Steuer- oder personenbezogener Backendintegration.

---

## 1. Zweck

Diese Spezifikation definiert den BMM-Profilkontext der emma App v1.0. Ziel ist eine saubere Trennung privater und arbeitgeberbezogener Nutzung, damit Arbeitgebermobilitaet, Budget-/Benefit-Logik und Compliance-Hinweise spaeter belastbar auf Routing, Subscription, Wallet und Reporting wirken koennen.

EMM-110 implementiert keine produktive Budget-Engine, keine Payroll-Integration und keine echten Arbeitgeberdaten.

---

## 2. Bestehender Repo-Stand

Eine Suche nach BMM, Arbeitgeber, employer, profile, budget und mobility employer zeigt keine belastbare bestehende Umsetzung eines Multi-Profil-/BMM-Kontexts. Es existieren jedoch Planungsartefakte zum MVP-Domain-Backlog.

Damit gilt fuer EMM-110:

```text
Status: fachlich neu vorzubereiten
Keine produktive Arbeitgeber-/Budget-/Payroll-Integration
Keine Verarbeitung echter Arbeitgeberdaten ohne separates Gate
```

---

## 3. Leitentscheidungen

1. Private und arbeitgeberbezogene Nutzung muessen getrennt modelliert werden.
2. Arbeitgebermodus darf nur nach expliziter Nutzeraktion und Compliance-Hinweis aktiv sein.
3. Budget-/Benefit-Kontext darf private Nutzung nicht stillschweigend beeinflussen.
4. Arbeitgeberdaten werden im MVP nur als Fake-/Fixture-/lokaler Kontext modelliert.
5. Kein Arbeitgeberreporting, keine Payroll-/Steuerlogik und keine echte Budgetbelastung ohne separates Gate.
6. BMM-Kontext darf Routing, Subscription und Wallet nur ueber nachvollziehbare Entitlements und DecisionTrace beeinflussen.

---

## 4. Zielmodell

| Objekt | Zweck |
|---|---|
| `MobilityProfileContext` | Aktiver Kontext: privat oder arbeitgeberbezogen. |
| `ProfileMode` | Enum: `private`, `employer`. |
| `EmployerMobilityProfile` | Arbeitgeberbezogene Konfiguration, z. B. Arbeitgeber-ID, Programm, Budget. |
| `EmployerEntitlement` | Berechtigung, z. B. Jobticket-Zuschuss, Mobilitaetsbudget, Benefit. |
| `MobilityBudgetState` | Fake-/Fixture-Budgetstand fuer MVP. |
| `ComplianceAcknowledgement` | Nachweis, dass Nutzer Arbeitgebermodus-Hinweis gesehen/bestaetigt hat. |
| `ProfileDecisionTrace` | Nachvollziehbarkeit, wie Profilkontext Entscheidungen beeinflusst. |

---

## 5. Profilmodi

| Modus | Bedeutung | Wirkung |
|---|---|---|
| `private` | Private Nutzung ohne Arbeitgeberkontext. | Keine Budget-/Benefit-Anwendung. |
| `employer` | Arbeitgeberbezogene Nutzung nach Hinweis/Freigabe. | BMM-Entitlements koennen Routing/Wallet beeinflussen. |

Default:

```text
ProfileMode.private
```

Kein Start im Arbeitgebermodus ohne explizite Auswahl.

---

## 6. Compliance-Hinweis

Beim Wechsel in den Arbeitgebermodus muss ein Hinweis angezeigt bzw. im Modell unterstuetzt werden:

```text
Du wechselst in den Arbeitgebermodus. Arbeitgeberbezogene Budgets, Zuschuesse oder Benefits duerfen nur fuer zugelassene Mobilitaetszwecke genutzt werden. Private und berufliche Nutzung werden getrennt behandelt.
```

Pflichtfelder:

| Feld | Zweck |
|---|---|
| `acknowledgedAt` | Zeitpunkt der Bestaetigung. |
| `profileMode` | Arbeitgebermodus. |
| `textVersion` | Version des Compliance-Hinweises. |
| `source` | fixture, fake, local, productive. |

---

## 7. BMM-Entitlements

Mindest-Entitlements:

| Entitlement | Bedeutung |
|---|---|
| `jobTicketSubsidy` | Arbeitgeberzuschuss fuer OePNV/Abo. |
| `mobilityBudget` | Budget fuer definierte Mobilitaetsleistungen. |
| `bikeBenefit` | Bike-/Sharing-bezogener Benefit. |
| `taxiFallbackAllowance` | Erlaubnis fuer Taxi im definierten Ersatz-/Garantiefall. |
| `receiptRequired` | Beleg-/Nachweispflicht. |

---

## 8. Budgetmodell MVP

EMM-110 darf nur Fake-/Fixture-Budgetlogik spezifizieren.

| Feld | Pflicht | Beschreibung |
|---|---|---|
| `budgetId` | ja | Interner Budget-Identifier. |
| `employerId` | ja | Fake-/Fixture-Arbeitgeber-ID. |
| `period` | ja | Monat/Quartal/Jahr. |
| `availableEuroCents` | ja | Verfuegbarer Betrag. |
| `reservedEuroCents` | ja | Simuliert reservierter Betrag. |
| `spentEuroCents` | ja | Simuliert verbrauchter Betrag. |
| `currency` | ja | EUR. |
| `source` | ja | fixture/fake/local/productive. |

Keine echte Belastung oder Abrechnung.

---

## 9. Einfluss auf EMM-99 Routing

BMM-Kontext darf Routing nur beeinflussen, wenn:

```text
profileMode == employer
AND ComplianceAcknowledgement vorhanden
AND employerContext consent/freigegeben
AND Entitlement passt
```

Beispiele:

| Fall | Wirkung |
|---|---|
| JobTicketSubsidy aktiv | OePNV kann effektiven Preisvorteil erhalten. |
| MobilityBudget aktiv | Optionen innerhalb Budget koennen bevorzugt werden. |
| TaxiFallbackAllowance aktiv | Taxi nur im Fallback-/Garantiepfad besser bewerten. |
| ReceiptRequired | Wallet/Beleg-Hinweis erzeugen. |

---

## 10. Einfluss auf EMM-109 Subscription

Arbeitgeberbezogene Subscription darf private Subscription nicht ueberschreiben.

```text
private subscription != employer subscription
```

ProviderReference muss erkennbar machen, ob eine Subscription privat, arbeitgeberbezogen oder unknown ist.

---

## 11. Einfluss auf EMM-105 Wallet

WalletItem muss erkennen koennen:

- privat,
- arbeitgeberbezogen,
- budgetrelevant,
- belegpflichtig,
- nur Simulation.

Bei Arbeitgebermodus:

```text
WalletItem.decisionTrace includes profileMode/employerEntitlement
```

---

## 12. Lokalisierung

MVP-Texte muessen mindestens de/en-faehig sein:

| Key | DE | EN |
|---|---|---|
| `profile.private` | Privat | Private |
| `profile.employer` | Arbeitgeber | Employer |
| `profile.employer.complianceTitle` | Arbeitgebermodus | Employer mode |
| `profile.employer.complianceBody` | Arbeitgeberbezogene Budgets und Benefits duerfen nur regelkonform genutzt werden. | Employer mobility budgets and benefits may only be used according to policy. |

---

## 13. Nicht-Scope

- Keine produktive Arbeitgeberdatenintegration.
- Keine Payroll-/Steuerlogik.
- Keine echte Budgetbelastung.
- Kein Arbeitgeberportal.
- Kein produktives Reporting an Arbeitgeber.
- Keine Verarbeitung echter personenbezogener Arbeitgeberdaten.
- Keine automatische Weitergabe von Reisedaten an Arbeitgeber.

---

## 14. Akzeptanzkriterien

1. Profilmodus `private` und `employer` ist modellierbar.
2. Default ist `private`.
3. Wechsel in Arbeitgebermodus erfordert ComplianceAcknowledgement.
4. BMM-Entitlements sind modellierbar.
5. Fake-/Fixture-Budget ist klar als nicht-produktiv markiert.
6. Arbeitgeberkontext beeinflusst Routing nur bei aktiver Freigabe.
7. Private und arbeitgeberbezogene Subscription/Wallet-Kontexte werden nicht vermischt.
8. de/en-Texte fuer Profilmodus und Compliance-Hinweis sind vorgesehen.
9. DecisionTrace dokumentiert Profil- und Entitlement-Wirkung.

---

## 15. Testfaelle

| Test | Erwartung |
|---|---|
| Default-Profil | private aktiv. |
| Wechsel Arbeitgeber ohne Hinweis | nicht erlaubt / acknowledgement fehlt. |
| Wechsel Arbeitgeber mit Hinweis | employer aktiv, trace vorhanden. |
| EmployerContext ohne Consent | keine Wirkung auf Routing. |
| MobilityBudget fake | Budget sichtbar, aber nicht produktiv. |
| Private Route | keine Arbeitgeber-Budgetwirkung. |
| Arbeitgeberroute mit Jobticket | OePNV-Preisvorteil nur im Arbeitgeberkontext. |
| WalletItem Arbeitgebermodus | Trace enthaelt employerEntitlement. |

---

## 16. Folgeabhaengigkeiten

| Folgeissue | Abhaengigkeit |
|---|---|
| EMM-99 | Routing kann BMM-Entitlements beruecksichtigen. |
| EMM-100 | Praeferenz-/Consent-Modell steuert Arbeitgeberkontext. |
| EMM-105 | Wallet zeigt budget-/belegrelevanten Kontext. |
| EMM-111 | Notifications koennen Budget-/Beleg-/Profilhinweise nutzen. |
| Spaeter BMM Budget Engine | Produktive Budget-/Benefit-Integration nach R3-Gate. |

---

## 17. Claude-Gate fuer R2

Claude PASS oder aequivalenter Review ist erforderlich, wenn EMM-110 in Code umgesetzt wird.

Review-Fragen:

1. Ist private Nutzung strikt vom Arbeitgeberkontext getrennt?
2. Gibt es keinen Arbeitgebermodus ohne Compliance-Hinweis?
3. Werden keine echten Arbeitgeberdaten verarbeitet?
4. Wirkt Budget/Benefit nur bei Freigabe?
5. Ist die Logik kompatibel mit EMM-99, EMM-100, EMM-105 und EMM-109?

---

## 18. Agentenauftrag

**Codex**

- Profil-/BMM-Kontextmodelle vorbereiten.
- Fake-/Fixture-Budgetlogik nur lokal und klar markiert.
- Unit Tests fuer Profilwechsel, Compliance, Entitlements, Trace.
- Keine produktiven Arbeitgeber-, Payroll- oder Budgetadapter.
- Keine UI ausser minimaler ViewModel-Faehigkeit.

**Claude**

- Compliance-/Architekturreview.
- Pruefung auf strikte Trennung privat/arbeitgeberbezogen.

**Cursor**

- Erst nach R2-Gate fuer UI-/Profilwechsel-Integration verwenden.
