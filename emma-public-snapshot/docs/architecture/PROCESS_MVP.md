# MVP — Kernprozess und Architekturpaket (konsolidiert)

**Herkunft:** MVP_ARCHITEKTURPAKET_2026-04-08.md (Inhalt unveraendert folgt)


# MVP-Architekturpaket für den bestätigten Kernprozess

**Ursprünglicher Stand:** 2026-04-08  
**Aktualisiert:** 2026-04-16 (nach Workspace-Migration)  
**Strukturhinweis:** Feature-Targets wie `home`, `journey_engine`, `employer_mobility` etc. liegen in `apps/emma_app/lib/features/`. Domain-Ports und Entitäten gehören in die entsprechenden `packages/domains/domain_*/` Packages. Der Root-`lib/`-Ordner ist archiviert.

Zielprozess:

`User Intent -> Demand Recognition -> Option Selection -> Fare/Budget Check -> Booking Intent -> Payment Intent -> Journey State Update -> Support/Reporting Event`

Leitlinie:
- Fachlogik zuerst
- externe APIs erst später
- jeder Prozess ist bis zum Ende modelliert
- externe Systeme hängen nur an Ports/Adaptergrenzen

## 1. Zielbild pro vorhandenes Feature

### `home`
- Rolle im MVP: Einstiegspunkt für User Intent und Rückfragen
- Ausbau:
  - freie Chatnachricht in strukturierten Intent überführen
  - Rückfragen und Bestätigungsschritte anzeigen
  - Journey-Start an den Orchestrator übergeben

### `journey_engine`
- Rolle im MVP: zentrales Prozessmodul
- Ausbau:
  - wird fachlicher Owner des gesamten Kernprozesses
  - verwaltet Journey Case, Phasen, Ereignisse, Entscheidungen und Handoffs
  - ruft spezialisierte Engines und Fachports auf

### `tariff_rules`
- Rolle im MVP: Regel- und Entscheidungsinstanz
- Ausbau:
  - Tarifprüfung
  - Produktberechtigung
  - Garantieschwellen
  - Preis-/Kostenmodell

### `auth_and_identity`
- Rolle im MVP: Nutzerprofil, Präferenzen, Freigaben
- Ausbau:
  - Consent
  - Präferenzen
  - Mobilitätsprofile
  - Rollen/Freigaben

### `employer_mobility`
- Rolle im MVP: Budget- und Arbeitgeberlogik
- Ausbau:
  - Budgetprüfung
  - Benefit-Regeln
  - Kostenzuordnung privat vs. Arbeitgeber

### `tickets`
- Rolle im MVP: Ticket-/Buchungsprozess im UI
- Ausbau:
  - Booking Intent anzeigen
  - Reservierungs- und Aktivierungsstatus anzeigen
  - Ergebnis/Fehler transparent machen

### `payments`
- Rolle im MVP: Payment Intent und Zahlungsstatus
- Ausbau:
  - interne Zahlungslogik
  - Zahlungsfreigabe
  - Belegentwurf
  - Fehlersicht

### `mobility_guarantee`
- Rolle im MVP: Störfall- und Garantieentscheidung
- Ausbau:
  - Triggerbewertung
  - Alternativmaßnahmen
  - Kostenwirkung
  - Support-Handoff

### `customer_service`
- Rolle im MVP: Fallanlage und Eskalation
- Ausbau:
  - Cases aus Journey-/Payment-/Garantiefehlern ableiten
  - Statusmodell für Bearbeitung

### `data_reporting`
- Rolle im MVP: Audit Trail, KPI-Ereignisse, Betriebsereignisse
- Ausbau:
  - strukturierte Events statt Platzhalter-Screen

## 2. Kernobjekte für den MVP

Diese Objekte sollten als stabile Domain-Modelle eingeführt oder aus vorhandenen Modellen abgeleitet werden.

### `UserIntent`
- `intentId`
- `userId`
- `source` (`chat`, `tap`, `routine`, `system`)
- `rawText`
- `origin`
- `destination`
- `targetArrivalTime`
- `targetDepartureWindow`
- `tripPurpose`
- `preferencesSnapshot`
- `needsClarification`

### `JourneyCase`
- `journeyId`
- `userId`
- `status`
- `currentStep`
- `intent`
- `selectedOptionId`
- `fareDecision`
- `bookingIntent`
- `paymentIntent`
- `activeAlerts`
- `supportCaseIds`
- `eventLog`

### `TravelOption`
- `optionId`
- `legs`
- `providerCandidates`
- `estimatedArrival`
- `estimatedDuration`
- `estimatedCost`
- `reliabilityScore`
- `guaranteeScore`
- `budgetCompatibility`
- `requiresPartnerBooking`

### `FareDecision`
- `decisionId`
- `journeyId`
- `applicableProducts`
- `entitlementsUsed`
- `priceBreakdown`
- `budgetImpact`
- `ruleVersion`
- `decisionStatus`

### `BookingIntent`
- `bookingIntentId`
- `journeyId`
- `optionId`
- `requiredActions`
- `partnerActions`
- `bookingStatus`
- `blockingReasons`
- `handoffRequired`

### `PaymentIntent`
- `paymentIntentId`
- `journeyId`
- `bookingIntentId`
- `amountTotal`
- `amountPrivate`
- `amountEmployer`
- `paymentMethodRef`
- `receiptDraft`
- `paymentStatus`
- `handoffRequired`

### `SupportCase`
- `caseId`
- `journeyId`
- `sourceModule`
- `reasonCode`
- `severity`
- `payloadSnapshot`
- `caseStatus`

### `ReportingEvent`
- `eventId`
- `journeyId`
- `module`
- `eventType`
- `severity`
- `payload`
- `occurredAt`

## 3. Fachports für spätere API-Handoffs

Diese Ports sollen in Phase 1 schon existieren, auch wenn die erste Implementierung lokal/mock/in-memory ist.

### Identität und Präferenzen
- `IdentityPort`
  - `loadUserProfile(userId)`
  - `savePreferences(userId, preferences)`
  - `recordConsent(userId, consent)`

### Routing und Kontext
- `ContextPort`
  - `loadContext(userId, now)`
  - `loadRoutines(userId)`
  - `loadEnvironmentalSignals(location, time)`

- `RoutingPort`
  - `searchOptions(origin, destination, constraints)`
  - `loadRealtimeState(optionIds)`

### Regelwerk und Budget
- `TariffRulePort`
  - `evaluateFare(option, userContext)`
  - `checkEntitlements(option, userContext)`
  - `checkGuaranteeEligibility(journeyContext)`

- `BudgetPort`
  - `loadBudget(userId)`
  - `reserveBudget(journeyId, amount)`
  - `releaseBudget(journeyId, amount)`

### Ticketing und Payment
- `BookingPort`
  - `prepareBooking(bookingIntent)`
  - `commitBooking(bookingIntent)`
  - `rollbackBooking(bookingIntent)`

- `PaymentPort`
  - `preparePayment(paymentIntent)`
  - `capturePayment(paymentIntent)`
  - `refundPayment(paymentIntent)`

### Support und Reporting
- `SupportPort`
  - `openCase(supportCase)`
  - `appendCaseNote(caseId, note)`

- `ReportingPort`
  - `recordEvent(reportingEvent)`
  - `recordAuditTrail(journeyId, event)`

## 4. Orchestrierungsfluss im MVP

### Schritt 1: Intent erfassen
- `home` sammelt Nutzereingabe
- Ausgabe ist `UserIntent`
- bei Unschärfe erzeugt der Prozess Rückfragen statt sofortiger Planung

### Schritt 2: Bedarf erkennen
- `journey_engine` kombiniert Intent, Routinen, Zeit, Standort und Umweltsignale
- Ergebnis:
  - `no_demand`
  - `demand_confirmed`
  - `clarification_required`

### Schritt 3: Optionen auswählen
- `journey_engine` ruft Routing-/Kontext-Port auf
- `option_orchestration_engine` priorisiert Optionen
- Ausgabe ist Liste fachlich validierter `TravelOption`

### Schritt 4: Tarif- und Budgetprüfung
- `tariff_rules` und `employer_mobility` erzeugen `FareDecision`
- Ergebnis enthält:
  - zulässige Produkte
  - Preis
  - Budgetwirkung
  - Garantie-/Berechtigungsrelevanz

### Schritt 5: Booking Intent erzeugen
- `journey_engine` baut aus `TravelOption` + `FareDecision` ein `BookingIntent`
- Wenn Partneraktion nötig ist, wird das im Intent markiert, aber der Prozess bleibt vollständig beschrieben

### Schritt 6: Payment Intent erzeugen
- `payments` baut `PaymentIntent`
- enthält:
  - Zahlbetrag
  - Kostensplit
  - Belegentwurf
  - Handoff an spätere PSP-Schnittstelle

### Schritt 7: Journey aktualisieren
- `JourneyCase` wird auf Basis von Booking-/Payment-Zustand fortgeschrieben
- wichtige Zustände:
  - `draft`
  - `ready_for_confirmation`
  - `awaiting_partner_handoff`
  - `awaiting_payment_handoff`
  - `booked`
  - `active`
  - `disrupted`
  - `support_required`
  - `completed`

### Schritt 8: Support- und Reporting-Ereignisse auslösen
- Jeder kritische Schritt erzeugt `ReportingEvent`
- Fehler oder ungeklärte Zustände erzeugen optional `SupportCase`

## 5. Implementierungspakete

### Paket A: Journey Case als zentrales Persistenzmodell
- `journey_engine` von statischem Demo-Repository auf persistierbares Case-Modell umbauen
- Phasenmodell mit echten Statuswerten statt nur Story-Blueprints

### Paket B: Intent- und Entscheidungsobjekte einführen
- `UserIntent`, `TravelOption`, `FareDecision`, `BookingIntent`, `PaymentIntent` anlegen
- Provider- und Screen-Schicht auf diese Objekte ausrichten

### Paket C: Regelwerk + Budget integrieren
- `tariff_rules` und `employer_mobility` an den Journey-Flow hängen
- erster deterministischer Fare/Budget-Check im Produkt

### Paket D: Ticketing- und Payment-Handoff fachlich schließen
- `tickets` und `payments` mit echten Prozesszuständen statt Platzhalter-Screens versehen
- Booking-/Payment-Ports zunächst lokal oder in-memory implementieren

### Paket E: Support- und Reporting-Grundlage
- `customer_service` und `data_reporting` mit echten Domänenobjekten verbinden
- strukturierte Events und Fallanlage aus Fehlerzuständen erzeugen

### Paket F: App-nahe Tests
- bestehende Journey-Tests beibehalten und erweitern
- veralteten `widget_test.dart` ersetzen
- Smoke-Tests für Kernprozess hinzufügen

## 6. Empfohlene Dateiausrichtung

Neue oder zu stärkende Bereiche:
- `lib/features/journey_engine/domain/entities/`
  - zentrale Prozessobjekte
- `lib/features/journey_engine/domain/services/`
  - Orchestrierungs-Use-Cases
- `lib/features/journey_engine/domain/repositories/`
  - Journey Case Repository
- `lib/features/payments/domain/`
  - Payment Intent, Receipt Draft, Payment Method
- `lib/features/tickets/domain/`
  - Booking Intent, Ticket Product, Booking Result
- `lib/features/customer_service/domain/`
  - Support Case, Escalation Rule
- `lib/features/data_reporting/domain/`
  - Reporting Event, KPI Snapshot
- `lib/core/ports/`
  - externe Handoff-Schnittstellen

## 7. Direkt umsetzbare Reihenfolge

1. `JourneyCase` und `UserIntent` als stabile Domain einführen
2. vorhandene `journey_engine`-Services auf diese Objekte umstellen
3. `FareDecision` mit `tariff_rules` und `employer_mobility` verbinden
4. `BookingIntent` und `PaymentIntent` in `tickets` und `payments` einziehen
5. Reporting- und Support-Events bei jedem Statuswechsel erzeugen
6. danach erst echte Adapter gegen externe APIs austauschen
