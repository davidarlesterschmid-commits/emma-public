# Checkliste — MVP-Folgethemen (Product-Entscheide)

**Zweck:** Arbeits- und Abnahme-Checkliste aus Product-/Architekturvorgaben.  
**Stand:** 2026-04-27, technische Feinheit in SPECs nachziehen.  
**Bezug:** `DEFINITION_OF_DONE.md`, [MVP_PRODUCT_DECISIONS_2026-04-26.md](MVP_PRODUCT_DECISIONS_2026-04-26.md), `MVP_BACKLOG_18_DOMAINS.md`, `STATUS.md`, ADR-03/04.

---

## 0. Gemeinsames (alle Inkremente)

- [ ] Keine kostenpflichtigen APIs im MVP-Default-Build (ADR-03), Fake/Ledger wo „Zahlung“.
- [ ] Gemeinsame **Read-Modelle** und **Begrifflichkeit** (siehe §2 Payments) — keine doppelte „Wahrheit“ für Konto, Zahlung, Ticket, Budget.
- [ ] `melos` / `dart analyze` / relevante Tests grün pro betroffener Paket-Scope.
- [ ] Doku: `STATUS.md` / betroffene SPECs bei Abschluss eines Blocks aktualisieren.

---

## 1. Ticketing (M03)

**Zielbild (Entscheid):** **Wallet**; Anbindung an **beide** Tarifwelten: **Dienstleister-Tarife** (extern modelliert) **und** **eigene (emma) Tarife**; Berücksichtigung **Mobilitätsbudgets**; Abwicklung **nur über Fake-Ledger** (kein PSP). **Drei** klar trennbare, **E2E-nachvollziehbare** Prozesse: siehe [MVP_PRODUCT_DECISIONS_2026-04-26.md](MVP_PRODUCT_DECISIONS_2026-04-26.md) Abschnitt **C** (Abo/D-Ticket **nur Anzeige-Stub**). **Fachl./Code-Trennung** Dienstleister vs. emma: Abschnitt **E** derselben Datei.

### Anforderungen

- [ ] **Wallet-UX:** Anzeige gekaufter/aktiver Entitlements; klarer Leer- und Fehlerzustand.
- [ ] **Tarif-Integration (konzeptionell + Fake):**
  - [ ] Produkte/Preise, die **aus Dienstleister-Tariflogik** kommen (Fixture/Adapter-Stub, lesend).
  - [ ] Produkte/Preise **eigener (emma) Tarife** (anbinden an M11 / `TariffPort` bzw. `fake_tariff`).
  - [ ] **Mobilitätsbudget** (Employer) bei Kaufentscheid / Anzeige einbezogen (Port `BudgetPort` / bestehende Modelle).
- [ ] **Kaufabwicklung:** **nur Fake-Ledger** — Buchung als Transaktionssatz, kein echter Geldeinzug.
- [ ] **Domain + Fake** nach DoD-Struktur, wo fachlich sinnvoll: `domain_ticketing`, `fake_ticketing`, App-Wiring hinter klarer Grenze.
- [ ] **Tests:** mindestens Happy-Path (Kauf → Wallet-Eintrag) + negativer Pfad (z. B. unzureichend Budget) deterministisch.

### In SPECs/Domain nachziehen

- [ ] Enum und Felder laut [MVP_PRODUCT_DECISIONS_2026-04-26.md](MVP_PRODUCT_DECISIONS_2026-04-26.md) **E** + Use-Case-IDs **C.1** im Code (z. B. `priceSourceKind`, `publicationId`, Routen).
- [ ] **Ticket-Darstellung** (QR/Barcode) im MVP: rein Demo, Label „Demo“, wie in Backlog vorgesehen.

---

## 2. Payments (M10) — wiederverwendbar, maximale Funktionsbreite, gemeinsames Read-Modell

**Zielbild (Entscheid):** So viel **fachliche und modellseitige** Funktionalität wie sinnvoll; Code soll **später** mit PSP/Produktiv-Adapter weiterleben; **ein gemeinsames Read-Modell** für alles, was Konto, Rechnung, Ticketkauf, Budgetschnitt anzeigen.

### Anforderungen

- [ ] **Kern-Read-Modelle** (Vorschlag zur Namensbildung, in `domain_wallet` bzw. Contract-Layer festziehen):
  - [ ] `LedgerEntry` (Belastung, Gutschrift, Währung, Referenz inhaltlich z. B. ticketId/invoiceId/employerTopUp).
  - [ ] `AccountBalance` / Salden pro „Sparschicht“ (wenn nötig: getrennt Demo-Guthaben / Arbeitgeberpuffer).
  - [ ] `PaymentIntent` / Autorisations-Stub (MVP: immer „bestätigt“ im Fake) — **Schnittstelle** so wählen, dass später `authorize/capture` nachgerüstet werden kann, ohne UI neu zu bauen.
  - [ ] `Invoice` / `InvoiceLine` kompatibel mit Kundenkonto- und Rechnungsliste (siehe §4).
- [ ] **Fake-Implementierung:** In-Memory-Ledger + idempotente Operationen, wo sinnvoll; Export für Tests/Integration.
- [ ] **Kein PSP** im MVP-Default; klare Stelle für späteren `PaymentsAdapter` / `PaymentsPort` (Dokumentieren in `CONTRACTS` / ADR, wenn Port eingeführt wird).
- [ ] **Tests:** Pure-Dart für Buchungslogik, klare Szenen (Split-Hintergrund, Storno-Stub, falls im Scope).

### Abgleich

- [ ] `fake_customer_account` / Rechnungsobjekte lesen **dieselbe** fachliche Repräsentation wie Ledger (nur unterschiedliche Projektion/View, keine zweite Quelle).
- [ ] Journey/Ticketing: bei „Kauf“ **eine** Buchung im Ledger, **eine** verknüpfte Sicht in Wallet.

---

## 3. Employer mobility (M08)

**Zielbild (Entscheid):** Rollen **Nutzer** vs. **Firmenkundenverwalter** (Hintergrund nach Login); **Firmenfarben** in der Arbeitgeber-Ansicht; Details: [MVP_PRODUCT_DECISIONS_2026-04-26.md](MVP_PRODUCT_DECISIONS_2026-04-26.md) **G**.

### Checkliste

- [ ] **Firmenfarb-Adaptation** und Verwalter-Routen gemäß Product-Datei; **Umfang** der Verwalter-Funktionen im MVP **namentlich** im Ticket/Spec.
- [ ] Konsistenz **Ticketing** (§1), **BudgetPort**, **Ledger**; keine widersprüchliche Anzeige Budget vs. Buchung.

---

## 4. Settings & Consent + Konto (M01) — **ein Inkrement**

**Zielbild (Entscheid):** **Alle** Consent- und Einstellungskategorien, die die **Servicedimensionen** abdecken; im **selben** Lieferinkrement wie **Konto**-Erweiterung (Rechnungen, ggf. Lösch/Export-Stub).

### Servicedimensionen — Kategorien (abzudecken, UI + Persistenz-Stub)

**Mindest-Check (an euren Funktionskatalog anpassen, aber vollständig abhaken):**

- [ ] **Kern / Notwendig** (App-Betrieb, kein Opt-out, wo rechtlich zulässig nur informativ).
- [ ] **Nutzung / Produkt** (z. B. Reise-Assistenz, Personalisierung, Empfehlungen, soweit nicht DSGVO-eigenes Opt-in).
- [ ] **Marketing / Kommunikation** (E-Mail, Push, Partnerhinweise, falls vorgesehen).
- [ ] **Standort & Kontext** (wenn relevant: Routing, Naherholung, „smart“ Features).
- [ ] **Analytik & Qualität** (Nutzungsmessung, Crashes, Performance — getrennt von Marketing, je nach eurem Modell).
- [ ] **Dritte / Weitergabe** (sofern im MVP sichtbar: z. B. Verbundpartner, Abrechnung).
- [ ] **Barrierefreiheit / Anzeige** (Schrift, Kontrast, ggf. reduzierte Animation — als Settings, nicht Consent, falls sinnvoll trotzdem im gleichen Inkrement sichtbar).

**Konto im gleichen Inkrement**

- [ ] Rechnungsliste (Daten aus gemeinsamem Read-Modell, §2).
- [ ] Kontolösch- **Anstoß** (DSGVO) + ggf. Datenexport-Stub, konsistent mit Payments/Ledger-Referenzen.
- [ ] Einstellungen: Eintritt von Profil/Account, konsistente Navigation.

### Abnahme

- [ ] jede Kategorie: **Sicht in UI** + **Speicher-Stub** (lokal/Fake) + **Wiedergabe** nach App-Neustart im Fake, wo gefordert; **nur de**; **Zwangsbestätigungen** explizit; Kurztexte laut [MVP_PRODUCT_DECISIONS_2026-04-26.md](MVP_PRODUCT_DECISIONS_2026-04-26.md) **H**.
- [ ] **Kein** Widerspruch zu späterem Analytics-Post-MVP: Flags nur lesen/schreiben laut eurem Modell (siehe `STATUS` / Post-MVP-Hinweis).

---

## 5. Mobilitätsgarantie (M07) — **reduzierter Scope**

**Zielbild (Entscheid):** **Kleiner** Scope; **System** wählt Alternative; **Gutschein** in diesem Teilstück **außen vor** — [MVP_PRODUCT_DECISIONS_2026-04-26.md](MVP_PRODUCT_DECISIONS_2026-04-26.md) **I**. **Umleitung** muss im MVP-Teil **live funktionieren** (E2E: Störung → Vorschlag/Route → sichtbares Ergebnis in Journey/Routing).

### Checkliste (Scope reduzieren)

- [ ] **Nicht** in einem Zug die komplette Trigger-Matrix aus `SPECS_MVP` M07 — **Teilmenge wählen** (z. B. 1–2 Störungsarten + manuelle Anspruchsmeldung deaktivieren oder minimal halten). In SPECS/STATUS festhalten: „M07-MVP-Subset“.
- [ ] **Re-Routing / Alternative:** Vom Garantie-Kontext aus **konkrete** Auswahl oder Deep-Link in **Journey/ Routing** (bestehender `RoutingPort` / Journey-Flow), mit **sichtbarem** Ergebnis (z. B. mindestens eine Ersatzverbindung oder Buchungs-Intent in Demo).
- [ ] Gutschein/Entschädigung: kann **hinter** Fake-Ledger oder nur als UI-Nachweis, **wenn** nicht im subset — explizit markieren.
- [ ] **Tests:** ein Integrations- oder Widget-Pfad, der **Alternative wählt** und Ergebnis prüft.

### Abnahme „live funktioniert“

- [ ] Ablauf: Störung simulieren (`fake_realtime` / Engine) → Nutzer bekommt Option „Alternative suchen“ → **Routing-Dialog** bzw. Journey-Schritt liefert **mindestens eine** Option, die sich von der ersten unterscheidet (deterministisch in Fake).

---

## 6. Reihenfolge & Abhängigkeiten (empfohlen)

1. [ ] **Read-Model Payments** (§2) — Grundlage für Wallet, Konto, Ticketing.
2. [ ] **Ticketing + Fake-Ledger** (§1) an Tarif (M11) + Budget.
3. [ ] **Konto + Settings/Consent** (§4) an gleiches Read-Model.
4. [ ] **Employer-UX-Regel** (§3) feinjustieren, wenn 1–2 stehen.
5. [ ] **Garantie-Subset** (§5) mit funktionierender Umleitung.

---

## Historie

- 2026-04-26: Verknüpfung mit [MVP_PRODUCT_DECISIONS_2026-04-26.md](MVP_PRODUCT_DECISIONS_2026-04-26.md) (3 Ticketing-Prozesse, Trennmodell, Rollen, Garantie-Teil).
- 2026-04-25: Checkliste aus Product-Entscheidungen erstellt; technische Durchführung in `domain_*` / SPECs pro Inkrement konkretisieren.
