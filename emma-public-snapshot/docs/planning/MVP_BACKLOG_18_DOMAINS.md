# MVP-Backlog — 18 emma-Domaenen

Jede Domaene erfuellt die Definition of Done aus `DEFINITION_OF_DONE.md`.
Fake-Strategie je Partner siehe [../technical/ENTWICKLER.md](../technical/ENTWICKLER.md) (Abschnitt *Fake-First*).
Grundsatzentscheidung Fake-first siehe `ADR-03_mvp_without_paid_apis.md`.
MVP-Scope-Entscheidung siehe `ADR-04_mvp_domain_scope.md`.

Dieses Dokument ist der **Domaenen-Referenzkatalog**. Fuer den aktuellen
MVP-Arbeitsplan ist `ADR-04_mvp_domain_scope.md` massgeblich. Die
Fortschritts-Tabelle am Ende bleibt als Gesamt-Inventar.

**Pflichtfeld-Standard:**

- Fuer die 6 vertikal ausgebauten MVP-Domaenen gilt der **12-Feld-
  Standard** aus `CLAUDE.md`: Zweck, Nutzerwert, Leistungsart,
  Bestandswelt, 1:1-Uebernahmepflicht, Betriebsverantwortung,
  Vertragspartnerlogik, Pflichtpartner, SLA/Kritikalitaet,
  Datenobjekte, Use Cases, Risiken/Annahmen.
- Fuer Querschnitt-minimal und Post-MVP genuegen die 10 Felder der
  Kurzfassung.

## Prioritaeten-Reihenfolge (MVP-Spur)

| Prio | Domaene                          | ADR-04 Kategorie         | Abhaengig von     |
|------|----------------------------------|--------------------------|-------------------|
| 1    | auth_and_identity                | vertikal MVP             | —                 |
| 2    | settings_and_consent             | Querschnitt-minimal      | 1                 |
| 3    | customer_account                 | vertikal MVP             | 1, 2              |
| 4    | tariff_and_rules                 | Querschnitt-minimal      | —                 |
| 5    | subscriptions_and_d_ticket       | in 7 mitgefuehrt          | 3, 4              |
| 6    | employer_mobility                | vertikal MVP             | 3, 4              |
| 7    | ticketing                        | vertikal MVP             | 3, 4              |
| 8    | routing                          | vertikal MVP             | 4                 |
| 9    | ci_co                            | Post-MVP                 | 1, 7, 8           |
| 10   | sharing_integrations             | Post-MVP                 | 4, 8              |
| 11   | on_demand                        | Post-MVP                 | 4, 8              |
| 12   | taxi_integrations                | Post-MVP                 | 4, 8              |
| 13   | partnerhub                       | Post-MVP                 | 10, 11, 12        |
| 14   | payments                         | Querschnitt-minimal      | 5, 7              |
| 15   | mobility_guarantee               | vertikal MVP             | 7, 8, 9           |
| 16   | crm_and_service                  | Post-MVP                 | 3, 15             |
| 17   | support_and_incident_handling    | Post-MVP                 | 15, 16            |
| 18   | analytics_and_reporting          | Post-MVP                 | alle              |
| Q    | migration_factory                | Post-MVP-Querschnitt     | —                 |

---

## MVP-vertikal (6) — 12-Feld-Standard

### 1. auth_and_identity (Prio 1, M01-Teil)

- **Zweck:** Login, Session, Rollen, Token-/Credential-Verwaltung.
- **Nutzerwert:** Zugriff auf personalisierte Funktionen, sicheres
  Login, persistierte Sessions zwischen App-Starts.
- **Leistungsart:** selbst erbracht; perspektivisch OIDC vermittelt.
- **Bestandswelt:** Patris-User-DB, LeipzigMOVE-Login, movemix-Account.
- **1:1-Uebernahmepflicht:** E-Mail/Passwort-Login, Passwort-Reset,
  Auto-Login, Session-Persistenz, Logout, Profil anzeigen/bearbeiten.
- **Betriebsverantwortung:** emma (selbst). Audit-Log bei
  Authentifizierungs-Events ist Pflicht.
- **Vertragspartnerlogik:** im MVP keiner. Bei spaeterem OIDC pro IdP
  ein Trust-Vertrag.
- **Pflichtpartner:** keiner (MVP). Perspektivisch: ein zentraler IdP
  je teilnehmendem Verkehrsunternehmen.
- **SLA/Kritikalitaet:** **kritisch.** Ausfall blockiert alle
  angemeldeten Funktionen. Ziel-Verfuegbarkeit 99.9 % nach Launch.
- **Datenobjekte:** `User` (id, email, displayName), `UserAccount`
  (profile, rollen, permissions), `AuthSession` (accessToken,
  refreshToken, expiresAt), Audit-Events.
- **Use Cases:** Login, Logout, Registrierung, Passwort-Reset,
  Profil anzeigen/bearbeiten, Role-Switch fuer Demo, Token-Refresh.
- **Risiken/Annahmen:**
  - Annahme: kein Port im MVP (siehe Task #37-Analyse).
  - Risiko: Secure-Storage-Kompatibilitaet iOS-Transfer (Keychain vs.
    Android Keystore) — durch `SecureStorage`-Port entschaerft
    (Task #23).
  - Risiko: DSGVO-Konformitaet der Demo-Daten (Fixture duerfen keine
    realen Namen/Adressen enthalten).
  - Risiko: Token-Rotation bei abgelaufener Session — Flow definiert,
    aber Edge-Cases (Offline) zu testen.
- **Status:** 80 %. `domain_identity` + `feature_auth` vorhanden.
  Offen: Provider-Hoist (#37), `fake_identity` (#36), Barrel-Fix (#35).

---

### 2. customer_account (Prio 3, M01-Teil)

- **Zweck:** Stammdaten, Kontaktdaten, Zahlungsprofile (Verknuepfung),
  Rechnungshistorie, Abo-Uebersicht.
- **Nutzerwert:** Selbstverwaltung des Kundenkontos, Transparenz zu
  Rechnungen und Zahlungen, Vertrauen durch Datenhoheit.
- **Leistungsart:** selbst erbracht.
- **Bestandswelt:** Patris-Kundenkonto, LeipzigMOVE-Account-Seite.
- **1:1-Uebernahmepflicht:** Profil anzeigen/bearbeiten, Adresse,
  IBAN-Referenz (maskiert), Rechnungsliste, Konto-Loeschung, Daten-
  export (DSGVO).
- **Betriebsverantwortung:** emma. Rechnungs-Archivierung mindestens
  10 Jahre (GoBD) — Abhaengigkeit zu `payments` und `analytics`.
- **Vertragspartnerlogik:** keiner (MVP). Rechnungsausgabe im Namen
  von emma, Unterauftragsverhaeltnis zu angebundenen Verkehrs-
  unternehmen muss vertraglich abgebildet sein.
- **Pflichtpartner:** keiner (MVP).
- **SLA/Kritikalitaet:** hoch. Ausfall blockiert Account-Pflege und
  Rechnungs-Einsicht, aber nicht Ticket-Nutzung.
- **Datenobjekte:** `UserProfile` (Name, Adresse), `PaymentMethodRef`
  (maskiert), `Invoice` (nummer, datum, betrag, PDF-URL),
  `SubscriptionRef`, `DataExportRequest`.
- **Use Cases:** Stammdaten bearbeiten, Rechnungs-PDF oeffnen (Fake-
  PDF), Kontoloeschung anstossen (Confirm-Dialog, 30-Tage-Frist),
  DSGVO-Datenexport als JSON, Abo-Uebersicht.
- **Risiken/Annahmen:**
  - Risiko: DSGVO-Loeschung muss korrekt kaskadieren (payments,
    analytics, ticketing-Historie) — im MVP nur anstossen, nicht
    durchfuehren.
  - Annahme: IBAN-Daten liegen nicht in emma, nur maskierte Referenz
    auf PSP-Token (Post-MVP).
- **Status:** 30 %. Account-Screen vorhanden, Rechnungsliste und
  Konto-Loesch-Pfad fehlen. Task #27.

---

### 3. employer_mobility (Prio 6, M08)

- **Zweck:** Arbeitgebermobilitaet, Budget-Verwaltung, Benefit-Katalog,
  Jobticket-Anzeige, Profil-Modus-Umschaltung privat/dienstlich.
- **Nutzerwert:** Mitarbeiter sieht sein Budget, nutzt Benefits ohne
  separate Login-Wege, trennt privat/dienstlich in einer App.
- **Leistungsart:** selbst erbracht (emma-Hoheit), vermittelt
  (Arbeitgeber-Portal).
- **Bestandswelt:** heute punktuell in Arbeitgeber-Portalen, BMM-nahe
  Produkte, Mobility-as-a-Benefit-Loesungen.
- **1:1-Uebernahmepflicht:** Jobticket-Ausweis, Budget-Saldo, Benefit-
  Katalog, Budget-Verwendung, Monatsabrechnung.
- **Betriebsverantwortung:** emma fuer die App-Oberflaeche und Budget-
  Engine; Arbeitgeber fuer das Budget-Seed und die Abrechnungs-
  Freigabe.
- **Vertragspartnerlogik:** Vertrag emma <-> Arbeitgeber mit Budget-
  Definition, Benefit-Katalog, Abrechnungs-Rhythmus. Vertrag emma <->
  Arbeitnehmer ueber die App-AGB.
- **Pflichtpartner:** mindestens ein Pilot-Arbeitgeber; Payment-
  Dienstleister fuer Abrechnungs-Clearing (Post-MVP).
- **SLA/Kritikalitaet:** hoch. Ausfall blockiert Benefit-Nutzung,
  Arbeitgeber-Reporting. Prioritaerer Markteintritt lebt daran.
- **Datenobjekte:** `EmployerProfile`, `Budget` (periodStart, periodEnd,
  amountCents, consumedCents), `Benefit` (id, titel, kategorie,
  eligibility), `JobTicket` (ausweis, gueltigkeit), `BudgetUsage`
  (tx, betrag, beleg), `ProfileMode` (private|business).
- **Use Cases:** Budget einsehen, Benefit abrufen, Jobticket anzeigen,
  Profil-Mode switchen, Monats-Reporting fuer Arbeitgeber (Post-MVP),
  Benefit-Kauf anstossen (emma Ticketing).
- **Risiken/Annahmen:**
  - Risiko: Abgrenzung privat/dienstlich in der Abrechnung — Feld
    `ProfileMode` muss vor Ticketing-Kauf verbindlich gesetzt sein.
  - Risiko: Arbeitgeber-Audit erfordert Replay-Log der Budget-
    Bewegungen.
  - Annahme: im MVP eine einzige Budget-Periode pro Monat, kein Carry-
    Over.
  - Annahme: Split-Payment (privat-Anteil + Arbeitgeber-Anteil) nicht
    im MVP; wird als UI-Hinweis simuliert.
- **Status:** 75 %. `domain_employer_mobility` + `feature_employer_
  mobility` vorhanden. Offen: Budget-Engine, `fake_employer_mobility`,
  Split-Payment-Abstraktion. Task #28.

---

### 4. ticketing (Prio 7, M03)

- **Zweck:** Ticketkauf, -anzeige, -entwertung im Kontrollfall.
- **Nutzerwert:** Digitaler Ticketkauf ohne Automat, Wallet-Zugriff,
  Kontrolle durch Pruefgeraet.
- **Leistungsart:** selbst erbracht (Issuer der emma-Produkte),
  eingekauft (Payment), vermittelt (externe Produkte eines Verkehrs-
  unternehmens).
- **Bestandswelt:** LeipzigMOVE-Ticketkauf, movemix-Ticketshop, MOOVME-
  Ticketing, VDV-KA-basierte Systeme.
- **1:1-Uebernahmepflicht:** Tarif waehlen, Kauf abschliessen, Ticket
  im Wallet, Kontroll-Modus, Stornierung innerhalb Frist, Beleg.
- **Betriebsverantwortung:** emma fuer Issuer-Logik und Kontroll-UI;
  Clearing- und Erloese-Verteilung durch emma-Backoffice in
  Zusammenarbeit mit Verkehrsunternehmen.
- **Vertragspartnerlogik:** Clearing-Vertrag je Verkehrsunternehmen.
  Emma haftet fuer ordnungsgemaesse Ausgabe und Pruefbarkeit.
- **Pflichtpartner:** mindestens ein Verkehrsunternehmen im MDV-Raum
  fuer reale Produkte; PSP (eingekauft) fuer Zahlungsabwicklung
  (Post-MVP).
- **SLA/Kritikalitaet:** **kritisch.** Go-Live-Blocker. Kontrolleur-
  Acceptance muss gegeben sein.
- **Datenobjekte:** `TariffProduct` (productCode, zoneFrom/To, preis),
  `TicketInstance` (id, productCode, validFrom, validTo, qrPayload,
  purchaser, purchasedAt), `PaymentRef`, `Invoice`.
- **Use Cases:** Tarif-Auswahl, Kauf, Wallet-Anzeige, Kontrolle mit
  QR/Barcode, Storno innerhalb Frist, Erneuerung (spaeter).
- **Risiken/Annahmen:**
  - Risiko: Pseudo-QR in MVP nicht VDV-KA-kompatibel — UI muss
    "Demo-Ticket" kennzeichnen. `FakeModeBanner` signalisiert
    Umgebung.
  - Risiko: Ticket-Erstattung bei Storno ausserhalb Frist — Policy
    nicht im MVP.
  - Annahme: PSP-Integration post-MVP; MVP zeigt Kauf ohne
    Autorisierung (reine Fake-Kette).
- **Status:** 0 %. `domain_ticketing` und `fake_ticketing` noch nicht
  angelegt. Task #29.

---

### 5. routing (Prio 8, M02)

- **Zweck:** Multimodale Routen-Berechnung: Fuss, Rad, OePNV,
  Carsharing, Taxi, On-Demand-Segmente.
- **Nutzerwert:** schnellste/preiswerteste/kompfortabelste Verbindung,
  inkl. Tarifanzeige.
- **Leistungsart:** eingekauft (TRIAS/HAFAS spaeter), selbst erbracht
  (Multimodal-Kombi, Tarif-Integration, Praesentation).
- **Bestandswelt:** LeipzigMOVE-Routing, movemix-Routing, MOOVME-Routing,
  VBB-/VRR-aehnliche Auskunftssysteme.
- **1:1-Uebernahmepflicht:** Verbindungsauskunft, Fuss-, Rad-, OePNV-,
  Carsharing-, Taxi-, On-Demand-Segmente, Alternativen-Vorschlag,
  Echtzeit-Anzeige, Tarifpreis.
- **Betriebsverantwortung:** emma fuer Darstellung und Port-Anbindung;
  Datenquellen (TRIAS, GTFS-RT, GBFS) durch Partner.
- **Vertragspartnerlogik:** TRIAS-Rahmen mit MDV-Verkehrsunternehmen
  (Post-MVP); OSRM-Public als Fallback.
- **Pflichtpartner:** MDV-Verkehrsunternehmen (Daten), nextbike (GBFS),
  teilAuto, Taxi- und On-Demand-Partner perspektivisch.
- **SLA/Kritikalitaet:** **kritisch.** Ein-App-Kernversprechen. Ziel
  Antwortzeit < 2 s fuer 95 % der Anfragen.
- **Datenobjekte:** `JourneyIntent` (origin, destination, departureAt),
  `JourneyOption` (Segmente, Dauer, Preis), `TripSegment` (mode, vom,
  bis, dauer, preis), `RealtimeEvent` (delay, outage).
- **Use Cases:** Route berechnen, Alternativen, Details, Zwischenhalte,
  Walking-Directions, Echtzeit-Alternativen bei Stoerung.
- **Risiken/Annahmen:**
  - Risiko: Rate-Limits OSRM-Public fuer Fuss-/Rad-Segmente.
  - Risiko: Fahrplan-Aktualitaet der Fakes.
  - Annahme: im MVP nur OePNV + Fuss + Rad (Sharing-Integration post-
    MVP, aber Segment-Modell bereits vorbereitet).
- **Status:** 65 %. `domain_journey` + `feature_journey` vorhanden,
  `adapter_trias` und `fake_maps`/`fake_realtime` angebunden. Offen:
  `fake_tariff` produktionsnah, Stoerungs-Fallbacks. Task #30.

---

### 6. mobility_guarantee (Prio 15, M07)

- **Zweck:** Fahrgastgarantie bei Verspaetung/Ausfall automatisch
  erkennen, anbieten, abwickeln.
- **Nutzerwert:** Vertrauen in emma, Ersatzbefoerderung/Entschaedigung
  ohne manuellen Support-Aufwand.
- **Leistungsart:** selbst erbracht.
- **Bestandswelt:** MDV-Fahrgastgarantie-Regelwerk, VDV-Fahrgastrechte.
- **1:1-Uebernahmepflicht:** Anspruch detektieren, Antrag stellen,
  Entschaedigung bereitstellen (Gutschein/Ersatzfahrt).
- **Betriebsverantwortung:** emma fuer Erkennung, Antrag und Tracking;
  Auszahlung und Partner-SLA (Taxi-Gutschein bei T-04) durch emma-
  Backoffice in Zusammenarbeit mit Partnern.
- **Vertragspartnerlogik:** Vertrag emma <-> MDV-Verkehrsunternehmen
  fuer Regelwerk und Kulanz-Budget; Vertrag emma <-> Taxi-Partner fuer
  T-04-Gutschein-Akzeptanz (Post-MVP).
- **Pflichtpartner:** MDV-Verkehrsunternehmen fuer Datenlage; Taxi-
  Partner fuer T-04 (Post-MVP).
- **SLA/Kritikalitaet:** hoch (Reputation). Fehltrigger fuehren zu
  Vertrauensverlust.
- **Datenobjekte:** `RealtimeEvent`, `GuaranteeClaim` (tripId,
  triggerId, reasonCode, evaluationLog, createdAt, status),
  `GuaranteeClaimRequest`, `GuaranteeClaimStatus`.
- **Use Cases:** Anspruch automatisch erkennen, Nutzer
  benachrichtigen, Antrag einreichen, Status nachverfolgen, manuelle
  Meldung (T-08).
- **Risiken/Annahmen:**
  - Risiko: Anspruch ohne gebuchte Fahrt — Engine prueft `tripId`
    gegen User-Trips.
  - Risiko: Missbrauch / Doppelansprueche — Deduplikation `tripId +
    triggerId`.
  - Annahme: MVP erzeugt nur Claim-Kandidaten, keine automatische
    Auszahlung.
  - Annahme: echte Realtime-Quelle post-MVP; MVP laeuft auf
    `fake_realtime`.
- **Status:** 15 %. SPEC angenommen ([../technical/SPECS_MVP.md](../technical/SPECS_MVP.md) — M07). Engine, Ports, Fake und UI ausstehend. Task #31.

---

## Querschnitt-minimal (3) — 10-Feld-Kurzfassung

### settings_and_consent (Prio 2)

- **Zweck:** Einwilligungsverwaltung, App-Einstellungen, Sprache, Theme.
- **Nutzerwert:** Kontrolle ueber Datenverarbeitung, Personalisierung.
- **Leistungsart:** selbst erbracht.
- **Bestandswelt:** Consent-Layer in LeipzigMOVE, Android-System-
  Settings.
- **1:1-Umfang:** Marketing-Opt-In/Out, Analytics-Opt-In/Out, Sprache
  de/en, Light/Dark-Theme, Benachrichtigungen.
- **Fake-Quelle:** `fake_consent` mit Initialzustand "alles optional".
- **Use-Cases:** Consent-Dialog beim ersten Start, Settings-Screen
  fuer Aenderungen, DSGVO-Datenexport als JSON.
- **Risiken:** Consent-Versionierung (Policy-Updates bedingen Re-
  Prompt), Konsistenz mit `analytics_and_reporting`.
- **Status:** offen.

### tariff_and_rules (Prio 4)

- **Zweck:** Tarifserver-Logik, Regelwerk-Auswertung, Preisberechnung,
  Fare-Decision.
- **Nutzerwert:** korrekte Preise, Tarifempfehlungen, Bestpreis.
- **Leistungsart:** selbst erbracht (Pflichtinfrastruktur).
- **Bestandswelt:** Patris-Tarifserver, MDV-Regelwerk.
- **1:1-Umfang:** Einzelfahrten, Tageskarten, Anschlusstickets,
  Bestpreis, Rabatt-Regeln, Zone-Modelle.
- **Fake-Quelle:** `fake_tariff` (YAML-Regelwerk), Engine in
  `domain_rules`.
- **Use-Cases:** Preis berechnen, Tarifoption vergleichen, Regel-Trace
  fuer Support.
- **Risiken:** Regel-Konflikte, Tarifaenderungen, Clearing-Relevanz.
- **Architektur (M11, 2026-04-25):** Engine **self-built**; Eingangsdaten aus **frei verfuegbaren
  Open-Data-/Netz-Quellen** in Repo-Fixtures; verbindlich: [M11_TARIFF_ARCHITECTURE_DECISION.md](M11_TARIFF_ARCHITECTURE_DECISION.md).
- **Status:** 40 %. `domain_rules` teilweise, `TariffPort` vorhanden.
  Fake offen. Spec: [../technical/SPECS_MVP.md](../technical/SPECS_MVP.md) (M11). **Priorisierung Product:** Tarif (M11) zuerst.

### payments (Prio 14)

- **Zweck:** Zahlungsabwicklung, Ledger, Refunds. Im MVP nur
  Abstraktion.
- **Nutzerwert:** komfortable Bezahlung, Transparenz.
- **Leistungsart:** eingekauft (PSP im Produktivbetrieb).
- **Bestandswelt:** Stripe/Adyen-aehnliche PSP in Bestandsapps.
- **1:1-Umfang:** Zahlungsmethode waehlen (SEPA, Kreditkarte maskiert,
  PayPal-Link), Autorisierung, Refund, Beleg.
- **Fake-Quelle:** `fake_payments` als In-Memory-Ledger + Pseudo-
  Autorisierung, kein echter PSP.
- **Use-Cases:** Zahlung starten, Bestaetigung, Storno, Beleg anzeigen,
  Zahlungsmethoden verwalten.
- **Risiken:** PCI-Scope-Abgrenzung, Beleg-Audit-Trail.
- **Status:** 0 %. `domain_wallet` leer.

---

## Post-MVP-Backlog (9)

### subscriptions_and_d_ticket (Prio 5)

- **Zweck:** Abo-Verwaltung, D-Ticket-Anzeige, Pruefbarkeit.
- **Nutzerwert:** Abo-Uebersicht, D-Ticket-Darstellung in App.
- **Leistungsart:** eingekauft (Abo-Engine), vermittelt (D-Ticket-
  Issuer).
- **Bestandswelt:** LeipzigMOVE D-Ticket, MOOVME-Abos.
- **1:1-Umfang:** Aktives Abo anzeigen, Kuendigen (Antrag), D-Ticket
  Barcode/QR Darstellung, Gueltigkeit, Statuswechsel.
- **Fake-Quelle:** `fake_subscriptions` mit 2 Abo-Typen (D-Ticket-Full,
  Jobticket) + Pseudo-QR.
- **Use-Cases:** Abo-Liste, Abo-Detail, Kuendigung vorbereiten,
  D-Ticket vollformatig anzeigen, Kontrolleur-Modus.
- **Risiken:** Pseudo-QR in Feldtests nicht von Kontrolleuren
  akzeptiert — UI-Banner "Demo-Ticket" Pflicht.
- **Status:** offen.

### ci_co (Prio 9)

- **Zweck:** Check-In/Check-Out fuer automatische Fahrpreisermittlung.
- **Nutzerwert:** Preis ohne vorherige Tarif-Auswahl.
- **Leistungsart:** selbst erbracht (Kontrolle), eingekauft
  (Positioning).
- **Bestandswelt:** movemix CI/CO, externe BeIn-BeOut-Loesungen.
- **1:1-Umfang:** Check-In an Station, Check-Out, Tagesdeckel,
  automatische Abrechnung.
- **Fake-Quelle:** `fake_cico` mit simulierten Positionen ueber
  `fake_realtime`, Tagesdeckel-Rule aus `tariff_and_rules`.
- **Use-Cases:** Ein-/Auschecken, Fahrt-Verlauf, Monatsrechnung.
- **Risiken:** Tagesdeckel-Edge-Cases, Positions-Genauigkeit,
  Konfliktaufloesung bei vergessenem Check-Out.
- **Status:** offen.

### sharing_integrations (Prio 10)

- **Zweck:** Fahrrad-, Scooter-, Carsharing-Anbindung.
- **Nutzerwert:** gemeinsame Sicht auf alle Sharing-Angebote.
- **Leistungsart:** vermittelt (Partner).
- **Bestandswelt:** nextbike, teilAuto-Anbindung in Bestandsapps.
- **1:1-Umfang:** Verfuegbarkeit anzeigen, Reservieren, Oeffnen/
  Schliessen (Deep-Link), Preis vorab.
- **Fake-Quelle:** GBFS-Public wo moeglich (nextbike), sonst
  `fake_sharing` mit JSON-Fixture.
- **Use-Cases:** Karte mit Verfuegbarkeit, Reservierung, Rueckgabe,
  Preisrechner.
- **Risiken:** GBFS-Rate-Limits, Partner-SLA, Deep-Link-Handling.
- **Status:** offen.

### on_demand (Prio 11)

- **Zweck:** Ridepooling-/Flex-Angebote.
- **Nutzerwert:** Tuer-zu-Tuer-Service in Randzeiten.
- **Leistungsart:** vermittelt (On-Demand-Partner).
- **Bestandswelt:** MOOVME On-Demand, regionale Flex-Angebote.
- **1:1-Umfang:** Buchen, Fahrer-Tracking, Stornierung, Preis vorab.
- **Fake-Quelle:** `fake_on_demand` mit statischer Angebotsliste +
  Timer-basiertem Zusage-Simulator.
- **Use-Cases:** Buchungsanfrage, Zusagemeldung, Fahrt verfolgen,
  Stornierung.
- **Risiken:** Zusagedauer-Erwartung, Fahrer-Kommunikation.
- **Status:** offen.

### taxi_integrations (Prio 12)

- **Zweck:** Taxi-Bestellung via App.
- **Nutzerwert:** klassische Taxi-Dienste im emma-Kundenzugang.
- **Leistungsart:** vermittelt (Taxi-Partner).
- **Bestandswelt:** MOOVME Taxi, externe Taxi-Apps.
- **1:1-Umfang:** Bestellung, Fahrzeug-Auswahl, Festpreis/Taxameter,
  Bewertung.
- **Fake-Quelle:** `fake_taxi` mit Pseudo-Dispatch-Logik.
- **Use-Cases:** Bestellung, Taxi-Tracking, Zahlung, Bewertung.
- **Risiken:** Taxi-Tarife regional verschieden, Festpreis-Logik.
- **Status:** offen.

### partnerhub (Prio 13)

- **Zweck:** einheitliche Adapter-Schnittstelle fuer alle Partner-
  typen.
- **Nutzerwert:** indirekt — Grundlage fuer konsistente Partner-UX.
- **Leistungsart:** selbst erbracht (Querschnittsbaustein).
- **Bestandswelt:** keine direkte Entsprechung.
- **1:1-Umfang:** Adapter-Registry, Lifecycle-Events, Feature-Flags
  pro Partner, Fehler-Eskalation.
- **Fake-Quelle:** interne Registry, keine Partner-API direkt.
- **Use-Cases:** Partner-Adapter registrieren, Status abfragen,
  Fehler-Telemetrie.
- **Risiken:** Ueberkomplexitaet, verfruehte Abstraktion.
- **Status:** `domain_partnerhub` vorhanden, Scope ist zu
  praezisieren.

### crm_and_service (Prio 16)

- **Zweck:** Anliegen, Feedback, Ticketing-System (Support-Tickets,
  nicht Verkehrs-Tickets).
- **Nutzerwert:** Kommunikationskanal zum Kundenservice.
- **Leistungsart:** selbst erbracht (CRM), eingekauft (Service-Desk
  perspektivisch).
- **Bestandswelt:** Zendesk/Salesforce-aehnliche Systeme in
  Bestandsapps.
- **1:1-Umfang:** Anliegen anlegen, Status einsehen, Nachrichten,
  Anhaenge.
- **Fake-Quelle:** `fake_crm` mit In-Memory-Store + Auto-Responder-
  Bot.
- **Use-Cases:** Ticket anlegen, Verlauf, Anhaenge, Schliessen.
- **Risiken:** Datenschutz Anhaenge, Eskalations-SLA.
- **Status:** offen.

### support_and_incident_handling (Prio 17)

- **Zweck:** Stoerungsmanagement, Nutzer-Hinweise bei Events.
- **Nutzerwert:** transparente Info bei Problemen.
- **Leistungsart:** selbst erbracht.
- **Bestandswelt:** Stoerungsanzeigen in Bestandsapps.
- **1:1-Umfang:** Push-Banner bei Stoerung, FAQ, Kontakt-Optionen,
  Eskalation.
- **Fake-Quelle:** `fake_incident` mit getriggerten Events aus
  `fake_realtime`.
- **Use-Cases:** Stoerung anzeigen, Details, Kontaktieren.
- **Risiken:** Fehlalarme, Content-Updates.
- **Status:** offen.

### analytics_and_reporting (Prio 18)

- **Zweck:** Nutzungsdaten, Betriebsreporting.
- **Nutzerwert:** indirekt — Produkt-Verbesserung.
- **Leistungsart:** selbst erbracht (Reporter), vermittelt (Export).
- **Bestandswelt:** Firebase/Datadog-aehnliche Systeme in Bestands-
  apps.
- **1:1-Umfang:** Consent-gesteuerte Event-Erfassung, Report-Export.
- **Fake-Quelle:** lokaler Logger + JSON-File-Sink, kein Netzwerk.
- **Use-Cases:** Event loggen, Report exportieren, Admin-Dashboard
  (Fake).
- **Risiken:** Consent-Kopplung, DSGVO.
- **Status:** offen.

### Q. migration_factory (Querschnitt, Post-MVP)

- **Zweck:** Werkzeug- und Prozessbaukasten fuer die Abloese-
  Migration der Bestandswelten (LeipzigMOVE, movemix, MOOVME ->
  emma).
- **Nutzerwert:** indirekt — sauberer Parallelbetrieb ohne Funktions-
  verlust.
- **Leistungsart:** selbst erbracht.
- **Bestandswelt:** keine direkte Entsprechung; bestehende Patris-
  Migrationen.
- **1:1-Umfang:** Daten-Migrations-Mapper, Parallelbetriebsschalter,
  Fallback-Routen, Cutover-Plaene pro Region.
- **Fake-Quelle:** `fake_migration` mit Demonstrations-Mappern.
- **Use-Cases:** Datenabgleich, Cutover-Test, Rollback-Probe.
- **Risiken:** Daten-Verlust, Identitaetsueberlappung.
- **Status:** Konzeptphase.

---

## Fortschritts-Tabelle

Detail-Status in [STATUS.md](STATUS.md).

| #  | Domaene                          | Entities | Fake | Feature | App-Wiring | Integration-Test | Status |
|----|----------------------------------|----------|------|---------|------------|------------------|--------|
| 1  | auth_and_identity                | ✔        | —    | ✔       | ✔          | —                | WIP    |
| 2  | settings_and_consent             | —        | —    | —       | —          | —                | offen  |
| 3  | customer_account                 | (✔)      | —    | (✔)     | (✔)        | —                | WIP    |
| 4  | tariff_and_rules                 | (✔)      | —    | —       | (✔)        | —                | WIP    |
| 5  | subscriptions_and_d_ticket       | —        | —    | —       | —          | —                | offen  |
| 6  | employer_mobility                | ✔        | —    | ✔       | ✔          | —                | WIP    |
| 7  | ticketing                        | —        | —    | —       | —          | —                | offen  |
| 8  | routing                          | ✔        | (✔)  | (✔)     | ✔          | —                | WIP    |
| 9  | ci_co                            | —        | —    | —       | —          | —                | offen  |
| 10 | sharing_integrations             | —        | —    | —       | —          | —                | offen  |
| 11 | on_demand                        | —        | —    | —       | —          | —                | offen  |
| 12 | taxi_integrations                | —        | —    | —       | —          | —                | offen  |
| 13 | partnerhub                       | (✔)      | —    | —       | —          | —                | WIP    |
| 14 | payments                         | —        | —    | —       | —          | —                | offen  |
| 15 | mobility_guarantee               | —        | —    | (stub)  | —          | —                | offen  |
| 16 | crm_and_service                  | —        | —    | —       | —          | —                | offen  |
| 17 | support_and_incident_handling    | —        | —    | —       | —          | —                | offen  |
| 18 | analytics_and_reporting          | —        | —    | —       | —          | —                | offen  |
| Q  | migration_factory                | —        | —    | —       | —          | —                | offen  |

Legende: ✔ vollstaendig · (✔) teilweise · — fehlt
