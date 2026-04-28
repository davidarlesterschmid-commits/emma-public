# MVP — verbindliche Product- und Architekturentscheide

**Stand:** 2026-04-27 (Lückenschluss: Use-Case-IDs, Verwalter, M07, Engineering)  
**Bezug:** `DEFINITION_OF_DONE.md`, `CHECKLIST_MVP_FOLLOWON_DECISIONS.md`, `ADR-03` / `ADR-04`, `M11_TARIFF_ARCHITECTURE_DECISION.md`

---

## A. Begriff „Abnahme pro Domäne“ (Klarstellung)

Die Frage meinte: **Für jede der MVP-Domänen** laut `DEFINITION_OF_DONE.md` muss klar sein, **wann** sie als „fertig fürs MVP“ gilt (Umfang, Tests, Fake vs. echt, Nutzer sichtbar).

Das ist **kein** Widerspruch zu eurer Vorgabe **„keine harte Stub-Regel“**: Stubs, die laut Backlog unbenutzbar bleiben sollen, sollen keinen echten Verkehr lenken — **ihr** wollt wichtige Pfade real nutzbar haben; wo etwas bewusst **nur Anzeige** ist, wird das **pro Feature benannt** (z. B. **Abo = Anzeige-Stub**). Die **Abnahme** ist dann: „Diese Domäne erfüllt **ihre** definierte Umfangsgrenze + DoD, nicht: alles 18-Module-Lastenheft voll“.

---

## B. Scope-Grenzen (eure Vorgaben)

| Thema | Entscheid |
|--------|-----------|
| **Harte Stubs (Post-MVP-Block)** | **Nein** — keine allgemeine „alles unbenutzbar härten“-Regel. Stattdessen: **fachlich** pro Feature. |
| **Ticketing** | **Drei** voneinander unterscheidbare, **in der App nachvollziehbare** (End-to-End im MVP-Sinn) **Prozesse** (siehe Abschnitt **C**). |
| **Abo (M04) / D-Ticket** | Im MVP **nur Anzeige-Stub** (kein vollständiger Kauf/Vertrags-Engine). Klar in UI kennzeichnen. |
| **Gültigkeit Tarife / Auskunft** | Nur **MDV** (Mitteldeutscher Verkehrsverbund / relevantes Netz). |
| **Passagiergruppen** | **Alle** in den Tarif-Fixtures/Regelwerk genannten Gruppen müssen adressierbar sein (Berechnung/Anzeige pro Gruppe, wo MVP das vorsieht). |
| **Haftung (Produkt)** | **emma haftet immer** gegenüber dem Nutzer für die **Auskunft und die Plattform**; fachliche Trennung **Dienstleisterpreis vs. emma-Regelwerk** betrifft **Klarheit der Darstellung** und **interne Buchhaltungs-Meta**, nicht die Haftungsaussage im Sinne “wir tragen null Verantwortung” — siehe rechtlichen Schutztext unten. |

---

## C. Ticketing: drei nachvollziehbare Prozesse (MVP-Definition)

Folgende **drei** Abläufe müssen im MVP **jeweils lückenlos und unterscheidbar** sein (jeweils: klarer Einstieg, sichtbares Ergebnis, nachvollziehbarer „Abschluss“ im Fake, z. B. Eintrag in Wallet / Buchungssatz / Status):

1. **Prozess „Emma-Preis/Netz“ (Regel-M11 / `TariffPort` / `fake_tariff`)**  
   - Nutzer wählt eine im MVP unterstützte **MDV-Relation**; Preis entsteht aus **emma-seitigem** Regelwerk/Fixture.  
   - Buchung/„Kauf“ nur über **Fake-Ledger**; Rechnung/Read-Model wie in §2 der Checkliste.

2. **Prozess „Dienstleister-Publikation“ (VVU-Preisblatt, nicht die gleiche Kalkulations-Engine)**  
   - Produkt/Preis kommt aus **eingestellter** Dienstleister-Tarif-Quelle (YAML/JSON/Stub), mit Kennzeichnung **Herkunft = Verkehrsunternehmer-Publikation**.  
   - **Gleiche** Kassen-/Wallet-Mechanik, aber in UI und in Datenmodell klar getrennt (siehe **E**).  
   - emma bleibt **Auskunfts- und Plattformverantwortliche**; die **Publikation** muss in den Fixtures nachvollziehbar (Quelle, Stand) sein.

3. **Prozess „Abo / D-Ticket o. ä.“**  
   - **Nur** **Anzeige- und Navigations-Stub** (z. B. Sicht auf „bestehende Berechtigung“ aus Fake, **kein** vollständiger Vertrags-Lebenszyklus). Fachlich und in der **Abnahme** getrennt von 1) und 2) dokumentieren.

*Technische Umsetzung der Trennung 1) vs. 2) siehe Abschnitt **E**.*

### C.1 Use-Case-IDs, Routen und Abnahme (verbindlich für QA / Specs)

| ID | Prozess (siehe C) | Einstiegs-Route (Vorschlag) | Abnahme-„Fertig“-Signal im MVP (Fake) |
|----|-------------------|-----------------------------|----------------------------------------|
| **UC-TICK-01** | Emma-Regelpreis (M11) | `…/shop` bzw. Journey-Kauf-Flow mit `priceSourceKind=emmaRuleEngine` | Kauf-Intent → `LedgerEntry` + Eintrag in **Wallet**; `TariffQuote` mit `ruleTrace` sichtbar (mind. debug) / Preis in UI |
| **UC-TICK-02** | VVU-Publikation | gleicher Shop mit `priceSourceKind=operatorPublished` + sichtbares VVU-Label | wie 01, aber UI zeigt **Herkunft VVU** + `publicationId`/`operatorId` aus Fixture |
| **UC-TICK-03** | Abo / D-Ticket-Stub | `…/subscriptions` (bestehender/ geplanter Screen) | **Nur** Anzeige „bestehende Berechtigung“ aus Fake, **kein** Vertrags- oder Zahl-Engine-Abschluss; klarer Hinweis „Auskunft / Demo“ |

Abo darf **nicht** fälschlich die gleiche „Kauf“-CTA wie 01/02 tragen, ohne extra Hinweis.

---

## D. Daten im Repo, Aktualisierung, Lizenz

- **Öffentlich generierte / Open-Data-Daten** dürfen im **Repo** gehalten werden, **wenn** die **Lizenz** (z. B. ODbL, CC, Verbund-AGB) das erlaubt.  
- **Pflicht je Fixture-Bundle:** Datei `README.md` oder `SOURCES.md` neben den Fixtures: **Quell-URL**, **Abnahmedatum / Stand**, **Kurz-Lizenzvermerk** (1–3 Sätze).  
- **Aktualisierungsfrequenz:** **zweiwöchentlich** (Release-/Refresh-Rhythmus der Tarif-Engine-Fixtures; in CI/Release-Notes verankern, nicht zwingend automatischer Crawl im MVP).

---

## E. Fachlich vs. Code: Dienstleister-Tarif vs. emma-eigener Tarif

### Fachlich (eine Karte für Product / Rechtstexte)

| Begriff | Bedeutung |
|---------|-----------|
| **Leistungsträger / Vertrag mit Nutzer (App-Ebene)** | **emma** bietet die Anwendung, die Auskunft und den (Fake-)Zahlfluss. |
| **Preis-„Motor“** | Entweder **(A) emma-Regelwerk** (M11, `fake_tariff` / `domain_rules`) **oder (B) eingespeister VVU-Publicationspreis** (Dienstleister), aus Fixtures. |
| **Rechtstext in App (Kurz)** | Einheitlicher Hinweis, z. B.: „Preise (A) werden nach dem in der App hinterlegten Regelwerk berechnet; Preise (B) entsprechen der zum Stand [Datum] veröffentlichten Preisinformation des [VVU] und werden von emma wiedergegeben. Bei Abweichungen wenden Sie sich …“ (final durch Legal prüfen). |

### Code (empfohlenes Schichtenmodell, eine „Wahrheit“ pro Angebot)

- **`TariffQuote` / Kauf-`ProductOffer` / `TicketingLineItem`** enthalten:
  - `priceSourceKind`: Enum z. B. `emmaRuleEngine` | `operatorPublished` | `employerBudgetOnly` (Letzteres nur, wenn reiner Budget-Deckel, ein Preis=0, klar bezeichnet).
  - `operatorId` (nullable) — bei `operatorPublished` Pflicht, bei `emmaRuleEngine` optional MDV-Default.
  - `ruleSetVersion` / `fixtureBundleId` (für M11) bzw. `publicationId` (für VVU-Fixture).
  - `passengerClass` bzw. Gruppen-Key aus dem Regelwerk (alle in Fixtures definierten Gruppen ansprechbar).
- **Eine** Preisberechnung pro Kauf-Request:  
  - Entweder Aufruf **`TariffPort` (M11)** **oder** Lookup **VVU-Product-Repository** (lesend), **niemals** vermischen ohne sichtbares `priceSourceKind`.
- **Wallet / Ledger** referenziert **dieselben** fachlichen IDs und trägt `priceSourceKind` in den Metadaten der Buchung, damit **Konto-Read-Model** (Rechnung = Projektion) konsistent bleibt.

Diese Definition ersetzt die offene Frage **„Wie trennen wir fachlich und im Code?“**; Feinheiten in `domain_ticketing` / SPECS nachziehen.

---

## F. Konto, Löschung, Export, Ledger

- **Read-Model:** **sowohl** Rechnung/Anzeige **als auch** Ledger-Einträge — **beide** sichtbar; fachlich **eine** Kette (Buchung → Ledger-Events → ggf. Rechnungs-Projektion). Keine widersprüchlichen Salden.  
- **Kontolöschung (DSGVO):** vollständiger **fachlicher Ablauf** inkl. **Umgang mit Fake-Daten** (Demo-Accounts, Demo-Zahlungen): klare Trennung „Demo-Reset“ vs. „Kontolöschung beantragt“ in Specs.  
- **Datenexport:** **minimaler** Umfang (nur in der App vorhandene strukturierte Daten, JSON, ein Download-Pfad im Fake-Modus sinnvoll simulierbar).

---

## G. Arbeitgebermobilität (UX, Rollen, Farben)

- **Farben in der Kunden-App** für Arbeitgeber-Bereich: **automatische Anpassung** an **Unternehmensmarkenfarben** (vom Profil/Backend-Stub/Fixture: Primär- und Akzentfarben) — im Rahmen des **M3/Theme-Systems**; Fallback: **Landesfarben-App-Theme** wenn keine Firmenfarben.  
- **Rollen (MVP-Minimum):**  
  - **Nutzer (Arbeitnehmersicht)** in der App.  
  - **Firmenkundenverwalter** mit **Hintergrundfunktionen** (nach Login): separater Einstieg/Route, nur mit Rolle/Fixture erreichbar.

**MVP-Mindestumfang Verwalter (verbindlich, kein vollwertiges HR/ERP):**

| ID | Funktion | Verhalten (Fake) |
|----|----------|------------------|
| **UC-ER-01** | **Login** als Verwalter-User (eigener Fixture-Account / Rollen-Claim) | Zugang nur mit Rolle; normale Kunden-Accounts sehen keinen Einstieg |
| **UC-ER-02** | **Unternehmens-Dashboard (Lesen)** | Aggregierte Anzeige: Budget-Rest / Zeitraum / Anzahl Nutzer (Stub-Zahlen) |
| **UC-ER-03** | **Mitarbeiter-Liste (Lesen)** | Tabelle/Liste aus Fixture (Name/Pseudonym, Status); **keine** vollständige Stammdaten-Pflege |
| **UC-ER-04** | **Ein-Klick-„Antrag“** (z. B. Budget-Erhöhung / Kontakt) | erzeugt nur **Support-/Workflow-Stub** (in-app Status „gesendet“ / Eintrag in Fake-Log), **kein** externes ERP |
| *optional* | Weitere Aktionen | nur nach Rückmeldung Product; default **nein** im MVP-Abnahmestreifen |

Detaillierung **über** dieses Mindest-Set: nur Backlog, nicht MVP-Blocker.

---

## H. Einstellungen & Einwilligungen

- **Texte:** **Kurztexte** in der App.  
- **Sprache:** **nur Deutsch** im genannten MVP-Strang.  
- **Zustimmung:** alles, was **zwingend** bestätigt werden muss, muss **explizit** vom Nutzer bestätigt werden (kein reines Vorkreuzen; klare CTA, nachvollziehbarer Nachweis im Fake, z. B. `consentLog`-Stub).

---

## I. Mobilitätsgarantie (M07) — eure Verfeinerung

- **Re-Routing / Alternative:** **System** wählt die Alternative (Nutzers präferiert, falls mehrere: Policy in Engine).  
- **Gutschein / finanzielle Entschädigung:** im MVP-Teil, den ihr umsetzt: **außen vor** (keine Buchung in Ledger für Gutschein im ersten Scope).

**M07 MVP-Teil-Scope (verbindlich, „klein“):**

- **EIN** Störungsmuster, das den Flow auslöst: z. B. **Verspätung > 20 Minuten** (entspricht fachlich **T-02** aus `SPECS_MVP` M07, andere Trigger **nicht** im selben Abnahmestreifen, außer nach explizit neuem Product-Beschluss).
- **Ablauf:** Ereignis (Fake-Realtime) → Engine wählt **eine** Alternative über **`RoutingPort` / Journey** → Nutzer sieht **konkrete** Ersatzverbindung (mindestens ein **anderes** Ergebnis als vorher; deterministisch im Fake) → **kein** Gutschein, **kein** Ledger-Posting.
- **UI:** CTA z. B. **„Ersatzverbindung ansehen“** führt in den **bestehenden** Journey-Detail- / Suchkontext (kein neuer, separater Karten-Stack, wenn vermeidbar).
- **Abnahme-Test:** Integrations- oder Widget-Test: Ereignis einspeisen → **eine** Alternative sichtbar → Tap öffnet Route mit erwartbaren **Segmenten/Abfahrtstext** (nicht nur Snackbar).

---

## J. Nächste Schritte in der Doku/Technik

- [x] Prozesse 1–3 (Abschnitt C) als **Use-Case-IDs** — **C.1** (Rest: Screens in `domain_ticketing`-SPEC / Router nachziehen).  
- [ ] `SPECS_MVP` M11: `priceSourceKind` und VVU-Fixture-Kapitel ergänzen.  
- [x] `CHECKLIST` verlinkt; widersprüchliche Sätze bereinigen laufend.  
- [x] `STATUS`: Verweis Product Decisions.

---

## K. Ingenieurs- und Betriebsentscheidungen (Rest-Lücken aus STATUS / ADR-Überhang)

Diese Einträge **ersetzen** offene Debatten durch **MVP-scharfe** Defaults. Post-MVP bleibt ausdrücklich markiert.

| Thema | Entscheid (MVP) | Post-MVP / nicht MVP |
|--------|------------------|------------------------|
| **#32 Fake-First für 6 Vertikalen** | **Ja:** Alle sechs ADR-04-**Vertikalen** nutzen **Fakes** für alles, was sonst kostenpflichtige Partner-APIs braucht. Abweichung nur mit Eintrag in `STATUS.md` + Begründung. `CLAUDE.md`-Regel **beibehalten** bis vollständig erfüllt. | Echte Adapter in Phase-2-Release-Checkliste. |
| **PSP (M10)** | **Kein** PSP im MVP-Build. `domain_wallet` + `fake_payments` + gemeinsames Read-Modell. **Produktiver** Karteneinzug = **Entscheidung nach MVP**, spätestens vor Go-Live mit echtem Geld. | Anbieter-Kurzliste, PCI, Vertrag. |
| **OIDC/SSO** | MVP: **E-Mail/Passwort/Demo-Accounts** inkl. `fake_identity` wo vorgesehen. **SSO** = Entry-Point **vor öffentlichem** Beta/Prod-Launch mit IdP, **nicht** MVP-Blocker für Feature-Abnahme der 6 Domänen. | Enterprise-IdP, Mandanten, … |
| **Secrets (Maps, Gemini, …)** | **Nie** im Repo. Release/CI: `--dart-define` + Secret-Store; Staging-Keys getrennt. Vorgehen wie ADR-05 „Offene Punkte“. | — |
| **Domain `domain_journey` → `emma_ui_kit` / `domain_customer_service`** | **Technische Schuld** akzeptiert im MVP, solange `dart analyze` grün; **Folgetask** explizit: Entkopplung UI aus Domain, Ports für Support-Fälle. **Kein** MVP-Stopper für Product-Abnahme. | Gezielter Refactor-Sprint. |

**Hinweis Recht (Haftung):** endgültige **Impressum-/AGB-Texte** final durch **Legal** prüfen; technische Trennmöglichkeit `priceSourceKind` **bleibt** (Abschnitt E).

---

## Historie

- 2026-04-27: Abschnitt **C.1** (Use-Case-IDs), **G** Verwalter-Minimum (UC-ER-\*), **I** M07-Mindestscope, **K** Ingenieurs-Defaults. Offene-Fragen-Liste fachlich geschlossen, soweit nicht Legal/PSP-Prod.
- 2026-04-26: Erstfassung aus Stakeholder-Antworten; Trennmodell Dienstleister / emma in **E** verbindlich für Engineering.
