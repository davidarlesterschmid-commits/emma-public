# emma — Produktanforderungen (konsolidiert)

**Stand:** 2026-04-23  
**Herkunft:** Zusammenfuehrung von docs/architecture/LASTENHEFT_v1.0.md und docs/architecture/FUNKTIONSKATALOG_v1.0.md (eine Quelle, zwei Teile).

---

## Ergaenzung: MVP-Region, Sprachen, Preistransparenz, simulierte Buchung (Stand: 2026-04-23)

**Bezuege (Split):** [MVP-Scope (Kurz)](../planning/MVP_SCOPE.md#mvp-pilot-region-dritt-services-ci-und-simulierte-buchung-stand-2026-04-23) | [ADR-06](../architecture/ADR-06_mvp_open_data_client_and_ci_matrix.md) | [ADR-07](../architecture/ADR-07_mvp_pilot_regions_provider_catalogue.md) | [Runbook: Preisdaten-Refresh](../operations/price_data_refresh_runbook.md)

Diese Ergaenzung ergaenzt fachliche Muss-Aussagen fuer den **MVP-** **Scope;** das Mitteldeutschland-Zielbild in Abschn. 2 bleibt unveraendert. **Dritt-** **Services-**Grenze: kostenpflichtige Dritt-APIs **nicht** im Default-MVP-Build; kostenlose/oeffentliche APIs (z. B. **GTFS,** oeffentliches Wetter) **duerfen** — siehe [ADR-03_mvp_without_paid_apis.md](../architecture/ADR-03_mvp_without_paid_apis.md) und [ADR-06_mvp_open_data_client_and_ci_matrix.md](../architecture/ADR-06_mvp_open_data_client_and_ci_matrix.md).

- **Region (MVP):** Im **MVP-**DoD **voll** waehlbar **nur** **Berlin** und **MDV;** weitere Regionen: **Backlog/Post-**MVP. **Kein** **Vorauswahl-**Default: Der Nutzer muss **eine** **der** **beiden** **Regionen** **aktiv waehlen,** bevor katalog- und buchungsnahe Kernfluesse sinnvoll arbeiten. **Ohne** Wahl: **weiche Sperre** (Hinweis/Overlay), App weitgehend nutzbar; unvollstaendige Kataloge **akzeptiertes** **Risiko.** **Wechsel** Berlin**↔**MDV: **Dialog** mit **„Kontext verwerfen“** bzw. **„Abbrechen“** (Warenkorb, Entwurfsfahrt, ggf. offene Suche) **—** [ADR-07](../architecture/ADR-07_mvp_pilot_regions_provider_catalogue.md).

- **Anbieterdarstellung (Hybrid, MVP):** Linien-/Takt-**OePNV,** soweit aus **oeffentlichen** **Feeds** (z. B. **GTFS**-`agency`, Fahrzeiten) fuer die jeweilige Region sinnvoll mappbar; **System-** **Sharing (GBFS),** soweit im MVP angebunden; Modes **ohne** stabilen oeffentlichen Feed (u. a. viele **Taxi-/**Sammel-/**On-Demand-**Modelle, Mietwagen, Parken) **nur** ueber **versionierte** **Registry** im **Repo** plus ggf. **Fake-**/**Snapshot-**Fahrpreise (Demo) **—** [ADR-07](../architecture/ADR-07_mvp_pilot_regions_provider_catalogue.md).

- **Preise / Tarifanzeige:** Anbieter-**Preislisten** werden **weitgehend** durch einen **automatisierten** **Aufbereitungs-**/**Refresh-**Job gepflegt (oeffentlich einsehbare **Web-**/**Preis-****Information;** Ablauf [Runbook](../operations/price_data_refresh_runbook.md)). **Kein** zwingendes manuelles **Release-**Gate **pro** **Lauf.** **UI-****Logik** **gestuft:** zuerst letzter **erfolgreicher** **Snapshot;** **Warnbanner** **bei** technisch **konfigurierter** **Alters-** **Schwelle** **(X Tage,** reine **Konfiguration,** kein fester **14-**Tage-**Zwang)** **oder** fehlgeschlagenen **Laeufen** (Details Runbook). **Haupt-** **UI:** **Preis,** **Stand-**/**Gültigkeits-**Hinweis; **keine** **pro-** **Zeilen-****URL;** rechtliche/Quellen-**Texte** nur **im** AGB-/**Impressum-**Kontext.

- **Simulierte multimodale Buchung (MVP-DoD):** Mindestens **fuenf** Szenarien, sodass **fuenf** **Bauarten** abgedeckt sind (nur Kategorien, **keine** verpflichtenden **Detail-**Strecken). *Orientierungs-Kategorien (keine verpflichtenden Strecken):* (1) rein OePNV-Ticketpfad, (2) OePNV+GBFS-Sharing, (3) Regio+urban, (4) Nacht-/Last-Mile-Platzhalter, (5) On-Demand/Registry-only. **Fehlende** Bauart: **eindeutig** **gekennzeichnete** Fake/Simulations-**Buchung** (Demo).

- **Sprache (Kern-UI):** **Kern-****Flows** (Navigation, Suche, **Region,** buchungsnahe Pfade, Preis- und Fehlerhinweise dazu) **sind** **zweisprachig: **Deutsch (DE) **und** Englisch (EN). **Rechtstexte** (Impressum, Datenschutz, AGB**/**Nutzung): **DE** **fuehrend;** **EN** **sorgfaeltig;** bei **Risiko** / **Widerspruch** **gilt** **DE;** **Hinweis** fuer **EN-**Nutzende **sichtbar** **bzw. zugaenglich.**

---
# Teil A — Fachliches Lastenheft

# Fachliches Lastenheft

**Stand:** Version 1.0 (erstellt April 2026, bestätigt 2026-04-16)
**Hinweis:** Fachlich unverändert gültig. Strukturreferenzen auf `lib/` sind durch `packages/domains/` und `apps/emma_app/lib/features/` zu ersetzen.

**emma-App v1.0**

## 1. Dokumentenstatus

Dieses Dokument beschreibt das fachliche Lastenheft für die emma-App v1.0. Es konsolidiert die von dir vorgegebenen Produktanforderungen mit der bereits festgelegten emma-Zielarchitektur. Das Zielbild einer einzigen emma-App für ganz Mitteldeutschland, die bestehende App-Welten wie LeipzigMOVE, movemix und MOOVME im tatsächlich genutzten Funktionsumfang mindestens 1:1 übernimmt oder gleichwertig ablöst, ist bereits in der emma-Produktlogik angelegt. Ebenso sind die Pflichtintegration von Mobilitätspartnern, die Tarifserver-Verantwortung sowie die Unterscheidung zwischen vermittelten, eingekauften und selbst erbrachten Leistungen dort ausdrücklich festgelegt. 

## 2. Zielbild und Produktdefinition

emma ist eine KI-gestützte Mobilitätsassistenzplattform mit einer zentralen App als künftigem einheitlichem Kundenzugang für öffentliche und ergänzende Mobilität in Mitteldeutschland. Die App soll Nutzern alle für sie verfügbaren Mobilitätsoptionen in einer Oberfläche bereitstellen, auf Basis des Nutzerverhaltens Routinen und Vorschläge ableiten und perspektivisch eine Mobilitätsgarantie über Verbünde, Verkehrsunternehmen und ergänzende Mobilitätspartner hinweg ermöglichen. Dieses Zielbild entspricht der in der Produktliste beschriebenen Zielarchitektur. 

Version 1.0 fokussiert fachlich auf die nahtlose Interaktion zwischen Mensch und Maschine, auf multimodale Auffindbarkeit, Buchbarkeit und Nutzbarkeit von Mobilitätsleistungen sowie auf die sichere Einbindung bestehender Bestandswelten. Interne Entwickler- oder Analysefunktionen sind in v1.0 nur insoweit Bestandteil, wie sie für Betrieb, Qualitätssicherung oder Pilotierung erforderlich sind.

## 3. Ausgangslage

Die emma-App entsteht nicht auf einer grünen Wiese. Sie muss sich in eine bereits bestehende Verkehrs- und Systemlandschaft einfügen. Bestehende App-Welten und Hintergrundsysteme dürfen nicht funktional verschlechtert werden. Das betrifft insbesondere Routing, Ticketing, Abo- und D-Ticket-Logik, Check-in/Check-out, On-Demand-Buchung, Sharing-Anbindungen, Taxi-Integration sowie die operativen Hintergrundfunktionen wie Tariflogik, Kundenkonto, Berechtigungen, Abrechnung, Reporting, Schnittstellen und Störungsmanagement. Tarifserver und Regelwerke sind Pflichtinfrastruktur. 

Zudem ist die Markt- und Gründungslogik von emma zweisphärig ausgelegt: gemeinwohlorientierte Bildungs-, Transfer- und Governanceprodukte auf der einen Seite sowie steuerpflichtige Betriebs-, Plattform-, Daten- und Integrationsleistungen auf der anderen. Markteintrittslogik ist vorrangig die Arbeitgebermobilität. Diese Rahmenbedingungen beeinflussen das Lastenheft der App unmittelbar. 

## 4. Projektgegenstand

Gegenstand dieses Lastenhefts ist die fachliche Beschreibung der emma-App v1.0 als Endkundenprodukt einschließlich der dafür erforderlichen Kernmodule, Schnittstellen, Betriebslogiken und Qualitätsanforderungen. Nicht Gegenstand ist die vollständige technische Detailkonstruktion im Sinne eines Pflichtenhefts oder die abschließende Festlegung des Implementierungsstacks.

## 5. Projektziele

Die emma-App v1.0 soll erstens einen zentralen, intuitiven und personalisierten Zugang zu multimodaler Mobilität schaffen. Zweitens soll sie bestehende Mobilitätsangebote nicht ersetzen, sondern orchestrieren, integrieren und kundenseitig vereinheitlichen. Drittens soll sie eine belastbare Grundlage für spätere Ausbaustufen wie Mobilitätsgarantie, Arbeitgebermobilität, erweiterte CRM-Logik und regionale Skalierung schaffen. Viertens soll sie fachlich so angelegt sein, dass Bestandswelten migrationsfähig analysiert und ohne funktionalen Verlust in das emma-Zielbild überführt werden können. 

## 6. Nicht-Ziele in v1.0

Nicht Ziel der Version 1.0 ist die vollständige Eigenproduktion bestehender Verkehrsleistungen. ÖPNV-, On-Demand-, Sharing-, Carsharing- und Taxi-Leistungen bleiben operative Leistungen der jeweiligen Partner; emma vermittelt, integriert oder orchestriert diese Leistungen. Ebenfalls nicht Ziel von v1.0 ist eine vollständige General-Purpose-Entwicklerplattform. Live-Preview von HTML/React-Anwendungen und textbasierte Datenanalyse werden, sofern umgesetzt, als interne Betriebs-, Test- oder Pilotierungsfunktionen und nicht als primäres Endkundenprodukt behandelt. Die Produktliste grenzt bestehende Verkehrsleistungen ausdrücklich als Nicht-Eigenprodukte von emma ab. 

## 7. Nutzergruppen und Stakeholder

Primäre Nutzergruppen sind Endkunden mit Mobilitätsbedarf in Mitteldeutschland sowie perspektivisch Arbeitgebernutzer im Kontext betrieblicher Mobilität. Sekundäre Nutzergruppen sind Service- und Supporteinheiten, Partnerunternehmen, Verkehrsunternehmen, Integrationspartner und Administratoren. Relevante Stakeholder sind insbesondere MDV-nahe Verkehrsunternehmen, Plattform- und Integrationspartner, Tarif- und Hintergrundsystempartner sowie bestehende und neue Mobilitätsanbieter wie nextbike, teilAuto, On-Demand-Anbieter, Taxi-Partner und perspektivisch weitere Anbieter. Diese Partnerlogik ist in der emma-Produktarchitektur ausdrücklich festgelegt. 

## 8. Fachliche Gesamtanforderungen

### 8.1 Modul A: KI-gestützte Chat- und Assistenzschicht

Die App muss eine intelligente Chat-Schnittstelle bereitstellen. Diese muss kontextuelle Konversationen ermöglichen, den bisherigen Dialogverlauf berücksichtigen und den Nutzer in einer freundlichen, professionellen und hilfsbereiten Tonalität als „emma“ ansprechen. Die Konversation muss in Deutsch und Englisch voll unterstützt werden. Weitere Sprachen sind optionale Erweiterungen.

Muss-Anforderungen sind die Verwaltung des Gesprächskontexts innerhalb einer Sitzung, die Erkennung mobilitätsbezogener Nutzerintentionen, die Ausgabe verständlicher Handlungsvorschläge und die sichere Übergabe in fachliche Module wie Routing, Ticketing oder Kundenkonto. Soll-Anforderungen sind die Erkennung von Routinen, personalisierte Vorschläge und adaptive Oberflächenlogik auf Basis des Nutzungsverhaltens. Kann-Anforderungen sind proaktive Hinweise, lernende Präferenzmodelle und vertiefte Conversational Search.

Die Betriebsverantwortung liegt fachlich bei emma; das zugrundeliegende LLM kann als eingekaufte technische Leistung angebunden werden. Die SLA-Kritikalität ist hoch, aber nicht maximal kritisch, sofern Kernfunktionen der App auch über klassische UI-Navigation erreichbar bleiben.

### 8.2 Modul B: Multimodale Mobilitätsorchestrierung

Die App muss dem Nutzer alle verfügbaren Mobilitätsoptionen in einer Oberfläche bereitstellen. Dazu gehören mindestens öffentliche Verkehrsleistungen, On-Demand-Angebote, Bikesharing, Carsharing und perspektivisch Taxi- und weitere Partnerangebote. Die emma-Produktlogik definiert diese Leistungen als vermittelte Mobilitätsleistungen, während emma selbst die Orchestrierungs- und Integrationsverantwortung trägt. 

Muss-Anforderungen sind die Darstellung verfügbarer Optionen, die Verknüpfung mit Routing- und Buchungslogiken, die partnerbezogene Leistungsanzeige und die konsistente Nutzerführung über verschiedene Leistungsarten hinweg. Soll-Anforderungen sind kombinierte Reiseoptionen, Fallback-Optionen und kontextabhängige Priorisierung. Kann-Anforderungen sind multimodale Routinen, automatische Re-Planung und Mobilitätsgarantie-Trigger.

Die Bestandswelt umfasst LeipzigMOVE, movemix, MOOVME und weitere regionale App-Welten. Die 1:1-Übernahmepflicht umfasst den tatsächlich genutzten Funktionsumfang dieser Welten. Die SLA-Kritikalität ist maximal kritisch.

### 8.3 Modul C: Routing, Buchung und Ticketing

Die App muss Routing-, Buchungs- und Ticketing-Funktionen mindestens in dem Umfang abbilden, in dem sie in den relevanten Bestandswelten heute tatsächlich genutzt werden. Dazu gehören insbesondere Ticketkauf, D-Ticket-/Abo-Anzeige, Check-in/Check-out, On-Demand-Buchung sowie partnerbezogene Weiterleitungen oder direkte Buchungsstrecken. Diese Pflicht ergibt sich unmittelbar aus der 1:1-Übernahmelogik der emma-Zielarchitektur. 

Muss-Anforderungen sind konsistente Reiseauskunft, produktkonforme Ticketlogik, eindeutige Preis- und Produktdarstellung, Transaktionssicherheit und nachvollziehbare Fehlermeldungen. Soll-Anforderungen sind nutzerbezogene Favoriten, wiederkehrende Wege und vereinfachte Buchungsflows. Kann-Anforderungen sind vorausschauende Angebotsvorschläge und alternative Produktoptimierung.

Die Betriebsverantwortung ist geteilt: fachlich emma, technisch je nach Modul teils Integrations- oder Plattformpartner. Die SLA-Kritikalität ist maximal kritisch.

### 8.4 Modul D: Kundenkonto, Authentifizierung und Personalisierung

Die App muss ein sicheres Kundenkonto mit moderner Authentifizierung bereitstellen. Vorgesehen ist token-basierte Authentifizierung nach modernen Standards. Die App muss persönliche Präferenzen, Spracheinstellungen, Verlauf und relevante Mobilitätsroutinen nutzerbezogen verarbeiten können.

Muss-Anforderungen sind Registrierung, Login, Sitzungsverwaltung, Rollen-/Berechtigungslogik und datenschutzkonforme Speicherung nutzerbezogener Einstellungen. Soll-Anforderungen sind Single Sign-on, geräteübergreifende Synchronisierung und Präferenzprofile. Kann-Anforderungen sind fein granular steuerbare Personalisierungsregeln und kontextabhängige Startoberflächen.

Die Bestandswelt umfasst bestehende Kundenkontologiken der angeschlossenen Systeme. Die 1:1-Übernahmepflicht betrifft insbesondere Abo-, Berechtigungs- und Kundenkontofunktionen. Die SLA-Kritikalität ist sehr hoch.

### 8.5 Modul E: Tarifserver und Regelwerksmanagement

Tarifserver und Regelwerke sind Pflichtinfrastruktur. emma muss fachlich in der Lage sein, Tarifregeln, Produktlogiken, Preislogiken, Berechtigungen, Übergänge, Versionierungen und Ausnahmen sicher zu steuern oder technisch sicher integrieren zu lassen. Diese fachliche Verantwortung ist in der Produktliste ausdrücklich als Kernbaustein festgelegt. 

Muss-Anforderungen sind Tarifkonsistenz, Regelwerksversionierung, Produkt- und Berechtigungslogik, Nachvollziehbarkeit von Preisentscheidungen und sichere Integration mit Hintergrundsystemen. Soll-Anforderungen sind Test- und Simulationsmodi für Tarifänderungen. Kann-Anforderungen sind regelbasierte Produktempfehlungen.

Die SLA-Kritikalität ist maximal kritisch.

### 8.6 Modul F: Partnerhub und Integrationsmanagement

Die emma-App benötigt eine organisatorische und technische Integrationslogik für Verkehrsunternehmen, Sharing-Partner, Carsharing, Taxi, On-Demand und technische Plattformpartner. Die Produktarchitektur definiert hierfür den emma Partnerhub als Querschnittsbaustein. 

Muss-Anforderungen sind standardisierte Partneranbindung, Verwaltung technischer und fachlicher Schnittstellen, Fehler- und Qualitätsmanagement sowie eindeutige Vertragspartnerlogik. Soll-Anforderungen sind standardisierte Onboarding-Strecken und Monitoring je Partner. Kann-Anforderungen sind Self-Service-Partnerportale.

Die SLA-Kritikalität ist sehr hoch bis maximal kritisch, abhängig vom Partner und von seiner Rolle im Mobilitätsversprechen.

### 8.7 Modul G: Migrationsfabrik und Bestandsübernahme

Die emma-App v1.0 muss migrationsfähig gedacht werden. Für jede zu übernehmende Bestandswelt muss der tatsächlich genutzte Funktionsumfang dokumentiert, gemappt, getestet und abgesichert werden. Die Produktliste beschreibt hierfür eine eigene Migrationsfabrik mit Analyse, Parallelbetrieb, Datenmigration, Test, Schulung, Cut-over und Stabilisierung. 

Muss-Anforderungen sind Bestandsanalyse, Migrationsmapping, Testkonzepte, Fallback-Szenarien und Betriebsüberführung. Soll-Anforderungen sind standardisierte Migrationswerkzeuge und wiederverwendbare Migrationsmuster. Kann-Anforderungen sind weitgehend automatisierte Mapping- und Regressionstests.

Die SLA-Kritikalität ist maximal kritisch.

### 8.8 Modul H: Datenanalyse und textbasierte Auswertung

Die Anforderung „Auswertung von textbasierten Datensätzen und Erstellung von Zusammenfassungen“ wird in diesem Lastenheft nicht als primäre Endkundenfunktion, sondern als internes Analyse- und Betriebsmodul eingeordnet. Fachlich passt sie zu den bereits beschriebenen Daten- und Analyseprodukten von emma. 

Muss-Anforderungen bestehen nur dann, wenn diese Funktion für Support, Reporting, Qualitätsmanagement oder Pilotbewertung benötigt wird. Endkundenseitig ist sie in v1.0 nicht zwingend. Soll-Anforderungen sind interne Auswertungs- und Berichtsfunktionen. Kann-Anforderungen sind explorative Analysen, Clusterung und zusammenfassende Management-Reports.

### 8.9 Modul I: Live-Preview für HTML/React

Die Anforderung „Live-Preview“ ist für eine Mobilitäts-Endkundenapp fachlich kein Kernmodul. Sie wird daher als optionales internes Entwickler- oder Betriebsmittel klassifiziert. In einem reinen Endkunden-Release ist sie kein Muss. Sollte sie Bestandteil von v1.0 werden, dann nur für interne Vorschau, Template-Testing oder White-Label-Konfiguration.

## 9. Anforderungen an Benutzeroberfläche und Design

Die App muss ein modernes, klares und reduziertes Interface mit Fokus auf Lesbarkeit, Whitespace, klarer Typografie und konsistenter Navigationslogik bereitstellen. Sie muss responsive für Smartphone, Tablet und Desktop funktionieren. Dark Mode und Light Mode müssen sich mindestens am Systemdesign orientieren; eine manuelle Umschaltmöglichkeit ist Soll-Anforderung.

Die Oberfläche muss sowohl für konversationelle Nutzung als auch für klassische Navigation geeignet sein. Kritische Kernfunktionen dürfen nicht ausschließlich im Chat verborgen sein, sondern müssen auch explizit über UI-Elemente erreichbar bleiben.

## 10. Sicherheit und Datenschutz

Die App muss persönliche Daten datensparsam und datenschutzkonforme verarbeiten. Personenbezogene Daten sind nur in dem Umfang zu verarbeiten, der für Kundenkonto, Transaktion, Personalisierung und Support erforderlich ist. KI-bezogene Verarbeitungen müssen soweit möglich anonymisiert oder pseudonymisiert erfolgen. Es müssen rollenbasierte Zugriffe, sichere Token-Verwaltung, Logging sicherheitsrelevanter Ereignisse und Schutzmechanismen gegen unbefugten Zugriff vorgesehen werden.

Muss-Anforderungen sind sichere Authentifizierung, Transportverschlüsselung, Berechtigungsprüfung, Lösch- und Auskunftsfähigkeit sowie nachvollziehbare Zuständigkeiten zwischen emma und Partnern. Soll-Anforderungen sind Privacy-by-Design, getrennte Verarbeitungsräume und feingranulare Consent-Steuerung. Kann-Anforderungen sind lokale Personalisierungslogiken auf Endgeräten.

## 11. Technische und nichtfunktionale Anforderungen

Die App muss an leistungsfähige LLMs angebunden werden können. Das Frontend muss mit modernen Frameworks entwickelt werden und eine hohe Performance auf mobilen Endgeräten bieten. Die Zielvorgabe von unter einer Sekunde für die initiale Inhaltsgenerierung ist als Zielwert für wahrgenommene Erstreaktion sinnvoll, fachlich aber nur für bestimmte Interaktionen realistisch. Für komplexe Live-Abfragen über mehrere Partner- und Bestandssysteme ist daher zwischen Sofortreaktion, Teilantwort und Endergebnis zu unterscheiden.

Muss-Anforderungen sind performanter Erstaufruf, stabile Kernnavigation, robuste Fehlertoleranz, Monitoring und Wiederanlaufbarkeit. Soll-Anforderungen sind progressive Inhaltsladung und Offline-nahe Puffermuster für unkritische Inhalte. Kann-Anforderungen sind edge-basierte Beschleunigung und lokale Cache-Logiken.

## 12. Schnittstellenanforderungen

Die App benötigt Schnittstellen zu Routingdiensten, Ticketing- und Vertriebssystemen, Tarifservern, Kundenkonten, Zahlungsdiensten, Sharing- und Carsharing-Partnern, On-Demand-Systemen, Taxi-Partnern sowie internen Analyse- und Reportingdiensten. Die Produktlogik nennt ausdrücklich technische Plattformmodule, Hintergrundsystemkomponenten, Payment-/PSP-Leistungen, Routing-, Buchungs- und Betriebsbausteine als eingekaufte oder integrierte Pflichtkomponenten. 

Für jede Schnittstelle sind fachlich mindestens Dateninhalt, Betriebsverantwortung, Fehlerverhalten, SLA, Versionierung und Migrationsrelevanz zu definieren.

## 13. Rollen und Betriebsverantwortung

emma trägt die fachliche Produktführerschaft für App, Orchestrierung, Regelwerk, Partnersteuerung und Zielarchitektur. Technische Teilkomponenten können durch Service-Sphäre, Plattformpartner oder Bestandspartner erbracht werden. Verkehrsunternehmen bleiben Betreiber ihrer originären Verkehrsleistungen. Sharing-, Carsharing-, Taxi- und On-Demand-Anbieter bleiben Betreiber ihrer jeweiligen Leistungen. Daraus folgt eine gemischte Verantwortungsstruktur aus selbst erbrachten, vermittelten und eingekauften Leistungen, wie sie in der Produktliste festgelegt ist. 

## 14. Muss-/Soll-/Kann-Verdichtung auf Gesamtproduktebene

**Muss:** KI-Chat mit Kontextbezug, Deutsch/Englisch, multimodale Angebotsanzeige, Routing/Buchung/Ticketing im relevanten Bestandsumfang, sicheres Kundenkonto, moderne Authentifizierung, responsive UI, Dark-/Light-Mode-Grundfähigkeit, Tarifserver-/Regelwerksanbindung, Partnerintegration, Migrationsfähigkeit, Datenschutz- und Sicherheitsbasis.

**Soll:** adaptive Startoberfläche, Routinen und personalisierte Vorschläge, manuelle Theme-Umschaltung, standardisierte Partner-Onboarding-Logik, Reporting- und Analysefunktionen für Betrieb, vorbereitete Arbeitgebermobilitätslogik.

**Kann:** weitere Sprachen, Mobilitätsgarantie-Automatisierung, explorative Datenanalyse, interne Live-Preview-Funktion, proaktive Re-Planung, White-Label-Ausleitungen.

## 15. Abnahmekriterien

Das System gilt fachlich als abnahmefähig, wenn die Kernnutzerreise von Information über Auswahl bis Nutzung/Buchung für die priorisierten Mobilitätsarten stabil funktioniert, wenn die relevanten Bestandsfunktionen nicht schlechter gestellt werden, wenn Authentifizierung und Datenschutz nachweisbar belastbar umgesetzt sind und wenn die Partner- und Tariflogik betrieblich beherrscht werden kann.

Abnahmeleitend sind insbesondere vier Prüffragen: Erstens, kann ein Nutzer seine relevanten Mobilitätsoptionen in einer Oberfläche verlässlich finden? Zweitens, bleiben die heute genutzten Kernfunktionen der Bestandswelten erhalten? Drittens, ist die Verantwortungslogik zwischen emma, Verkehrsunternehmen und technischen Partnern eindeutig? Viertens, ist das System migrations- und skalierungsfähig?

## 16. Risiken

Das größte fachliche Risiko ist Scope-Überdehnung durch Vermischung von Endkundenprodukt, Betriebsplattform und Entwicklerwerkzeug. Zweitens besteht ein hohes Integrationsrisiko, weil die 1:1-Übernahmepflicht von App-Welten und Hintergrundsystemen sehr anspruchsvoll ist. Drittens besteht ein Betriebsrisiko, wenn Tarifserver-, Regelwerks- und Partnerverantwortung nicht sauber getrennt sind. Viertens besteht ein Governance-Risiko, falls Vertragspartnerlogik, SLA und Eskalationswege nicht frühzeitig festgelegt werden. Fünftens besteht ein UX-Risiko, wenn Chat und klassische UI-Navigation nicht konsistent zusammenspielen.

## 17. Offene Entscheidungen

Offen ist, welche Funktionen in v1.0 tatsächlich als Endkundenfunktion live gehen und welche zunächst intern oder pilotseitig betrieben werden. Offen ist ferner, welche Bestandswelten in Phase 1 konkret übernommen werden und in welcher Reihenfolge. Ebenfalls offen sind das konkrete Identitätsmodell, die priorisierten Partner-APIs, die Ausgestaltung der Mobilitätsgarantie in v1.0 und die Frage, ob Arbeitgebermobilität bereits in der ersten öffentlichen App-Version sichtbar ist oder zunächst als gesonderter Servicebaustein läuft.

## 18. Annahmen

Dieses Lastenheft geht davon aus, dass emma fachlich als zentrale Orchestrierungs- und Produktinstanz auftreten soll, während operative Verkehrsleistungen bei den jeweiligen Partnern verbleiben. Es geht ferner davon aus, dass die Bestandswelten nicht vollständig ersetzt, sondern schrittweise integriert oder gleichwertig abgelöst werden. Zudem wird angenommen, dass Arbeitgebermobilität ein priorisierter Markteintrittspfad bleibt und daher die Architektur bereits in v1.0 anschlussfähig dafür vorbereitet werden soll. Diese Annahmen sind konsistent mit der vorliegenden emma-Produktliste. 

## 19. Qualitätssicherung

Zentrale Annahmen sind die Ein-App-Logik für Mitteldeutschland, die 1:1-Übernahmepflicht der genutzten Bestandsfunktionen, die Pflichtrolle von Tarifserver und Regelwerksmanagement sowie die Dreiteilung in vermittelten, eingekauften und selbst erbrachten Leistungen. Diese Punkte sind in der vorliegenden emma-Produktlogik bereits eindeutig angelegt. 

Die fachlich größte Schärfung in diesem Lastenheft ist die bewusste Umklassifizierung von „Live-Preview“ und „wissenschaftlicher Analyse“: Beides ist für eine Mobilitäts-Endkundenapp kein zwingender v1.0-Kern und sollte nur aufgenommen werden, wenn du diese Funktionen ausdrücklich als internes Betriebsmodul oder separates Admin-/Pilotmodul freigibst.

Mini-Checkliste zur Validierung:

1. Sind Endkunden-, Admin- und Entwicklerfunktionen sauber getrennt?
2. Ist je Modul klar, was Muss, Soll und Kann ist?
3. Ist die 1:1-Übernahmepflicht pro Bestandswelt konkret benannt?
4. Sind Betriebsverantwortung, Vertragspartnerlogik und SLA je Kernmodul belastbar festgelegt?
5. Ist die v1.0-Abgrenzung gegen v1.1 tatsächlich entscheidungsreif?

## 20. Statusübersicht Funktionskatalog

Die folgenden Module sind aus Sicht des aktuellen Codes und der vorhandenen Feature-Strukturen im Projekt überprüft.

| Modul | Titel | Status | Kommentar |
|------|-------|--------|-----------|
| M01 | Nutzerkonto und Identität | Implementiert | auth_and_identity vorhanden, SSO/Multi-Profil noch offen |
| M02 | Routing, Reiseauskunft | Teilweise | trips vorhanden, Routing-Logik und Echtzeit noch ausbaubar |
| M03 | Ticketing und Produktkauf | Platzhalter/teilweise | tickets Screen vorhanden, aber keine vollständige Ticketing-Architektur |
| M04 | Abo, Deutschlandticket | Placeholder vorhanden | subscriptions Feature erstellt, Domain/Usecases noch offen |
| M05 | Check-in / Check-out | Placeholder vorhanden | check_in_out Feature erstellt, Geschäftslogik fehlt |
| M06 | Partnerbuchung | Teilweise | partnerhub existiert, Buchungsfluss und Partner-UX noch nicht voll getrennt |
| M07 | Mobilitätsgarantie | Implementiert | mobility_guarantee vorhanden, Fallback-Orchestrierung noch ausstehend |
| M08 | Arbeitgebermobilität | Implementiert | employer_mobility vorhanden, Budget- und Benefit-Logik noch nicht komplett |
| M09 | Kundenservice, Support | Placeholder vorhanden | customer_service Feature erstellt, Supportprozesse noch nicht modelliert |
| M10 | Zahlungen, Transaktionen, Belege | Placeholder vorhanden | payments Feature erstellt, PSP-Integration und Beleglogik fehlen |
| M11 | Tarifserver, Regelwerk | Implementiert | tariff_rules vorhanden, Tarif-Engine und Versionierung noch in Arbeit |
| M12 | Partnerintegration | Teilweise | partnerhub vorhanden, Partneradapter- und SLA-Logik noch unvollständig |
| M13 | Benachrichtigungen | Placeholder vorhanden | notifications Feature erstellt, Nachrichtensystem noch nicht implementiert |
| M14 | Daten, Reporting | Placeholder vorhanden | data_reporting Feature erstellt, Reporting/Monitoring noch nicht umgesetzt |
| M15 | Barrierefreiheit, UX | Querschnittlich | noch kein eigener Ordner, muss design- und accessibility-gesteuert ergänzt werden |
| M16 | Migration, Cut-over | Implementiert | migration Feature vorhanden, Migrationsstrategie bleibt ausstehend |

### Ergänzbare Funktionen

Die folgenden Funktionen können jetzt weiter ergänzt werden, weil der Projektbaukasten bereits die notwendigen Feature-Strukturen oder Screens enthält:
- M04 Abo / Deutschlandticket: `lib/features/subscriptions/`
- M05 Check-in / Check-out: `lib/features/check_in_out/`
- M09 Kundenservice / Support: `lib/features/customer_service/`
- M10 Zahlungen / Transaktionen: `lib/features/payments/`
- M13 Benachrichtigungen: `lib/features/notifications/`
- M14 Daten / Reporting: `lib/features/data_reporting/`
- M03 Ticketing: `lib/features/tickets/` ist präsent, benötigt aber Domain-/Datenebene

### Fehlende oder noch als Platzhalter vorhandene Aufgaben

- M03 Ticketing: Full Ticketing-Architektur fehlt, Platzhalter-Screen nur initial vorhanden.
- M04 Abo: Platzhalter existiert, Geschäftsprozesse und Deutschlandticket-Regeln fehlen.
- M05 Check-in/Check-out: Platzhalter vorhanden, Funktionslogik fehlt komplett.
- M09 Kundenservice: Platzhalter vorhanden, Support-Fallmanagement fehlt.
- M10 Zahlungen: Platzhalter vorhanden, PSP-Integration und Belege fehlen.
- M13 Benachrichtigungen: Platzhalter vorhanden, Nachrichtenauslieferung fehlt.
- M14 Daten/Reporting: Platzhalter vorhanden, Monitoring/Reporting fehlt.
- M02 Routing: Funktionalität nur ansatzweise, Echtzeit und Alternativen müssen ergänzt werden.
- M06 Partnerbuchung: Struktur vorhanden, Buchungsabläufe und Partner-UX müssen sauber getrennt werden.
- M11 Tarifserver: Struktur vorhanden, Tarifregel-Engine mit Versionierung/Tests fehlt.

### Empfehlung für das Lastenheft

Dieses Lastenheft sollte nun als Grundlage für die nächste Entwicklungsphase genutzt werden. Die Statusübersicht macht die Lücken transparent und erlaubt einen klaren Umsetzungsplan:
- Phase 1: MVP-Kernmodule ohne externe Abhängigkeiten (selbst entwickelbar oder öffentliche APIs wie TRIAS)
- Phase 2: API-gebundene Funktionalitäten mit Mock-Daten und vollständigen Prozessen
- Querschnitt: M15 Accessibility/UX als begleitende Qualitätsaufgabe

## 21. Nächste Entwicklungsaufgaben und User Stories

Die folgenden Aufgaben sind die direkte Fortsetzung der offenen Punkte im Funktionskatalog. Sie sind so formuliert, dass sie als Entwicklungstickets oder User Stories genutzt werden können. Priorität: Zuerst MVP-Kern ohne externe Abhängigkeiten (selbst entwickelbar / öffentliche APIs), dann API-gebundene mit Mock-Daten und vollständigen Prozessen.

### 21.1 Phase 1: MVP-Kernmodule (selbst entwickelbar / öffentliche APIs)

Diese Module können ohne externe Partner oder Dritte umgesetzt werden. Sie bilden das Minimum Viable Product (MVP) für die emma-App.

#### US-101: Authentifizierung und Nutzerkonto (M01 – Erweiterung)
- Als Nutzer möchte ich mich sicher anmelden und mein Profil verwalten können, damit ich personalisierte Mobilitätsoptionen nutze.
- Akzeptanzkriterien:
  - Registrierung und Login funktionieren mit lokaler Speicherung.
  - Profil zeigt Basisdaten und Präferenzen.
  - Mock-Daten für SSO (später ersetzbar durch API).
- Technische Aufgaben:
  - Auth-Provider erweitern um Profil-Management.
  - Lokale Speicherung mit Flutter Secure Storage.
  - Mock-SSO-Logik für spätere API-Integration.

#### US-102: Routing und Reiseauskunft (M02 – Erweiterung)
- Als Nutzer möchte ich Routen suchen und Alternativen sehen, damit ich meine Reise plane.
- Akzeptanzkriterien:
  - Start-Ziel-Eingabe liefert Routenvorschläge.
  - Öffentliche TRIAS-API wird genutzt (kein Dritter nötig).
  - Mock-Daten für Störungen und Echtzeit.
- Technische Aufgaben:
  - TRIAS-Integration in `lib/features/trips/` ausbauen.
  - Routing-Engine mit Alternativen implementieren.
  - Mock-Störungsdaten für Fallbacks.

#### US-103: Tarifserver und Regelwerk (M11 – Erweiterung)
- Als Produktverantwortlicher möchte ich Tarifregeln definieren und testen, damit Preise korrekt berechnet werden.
- Akzeptanzkriterien:
  - Regelwerk kann lokal gespeichert und versioniert werden.
  - Simulation von Tarifberechnungen möglich.
  - Mock-Daten für komplexe Regeln.
- Technische Aufgaben:
  - Regelwerk-Engine mit lokaler Persistenz bauen.
  - Versionierungsmodell implementieren.
  - Testmodus mit Mock-Tarifen.

#### US-104: Mobilitätsgarantie (M07 – Erweiterung)
- Als Nutzer möchte ich bei Problemen alternative Optionen erhalten, damit meine Mobilität gesichert ist.
- Akzeptanzkriterien:
  - Garantie-Trigger erkennt Störungen.
  - Fallback-Optionen werden vorgeschlagen.
  - Mock-Daten für Partner-SLAs.
- Technische Aufgaben:
  - Garantie-Logik in `lib/features/mobility_guarantee/` erweitern.
  - Trigger-Matrix mit Mock-SLAs implementieren.
  - Kommunikations-Logik mit Mock-Benachrichtigungen.

#### US-105: Arbeitgebermobilität (M08 – Erweiterung)
- Als Arbeitnehmer möchte ich meine Benefits einsehen, damit ich Mobilitätsoptionen nutze.
- Akzeptanzkriterien:
  - Budget- und Benefit-Anzeige funktioniert.
  - Split-Payment-Logik ist modelliert.
  - Mock-Daten für Arbeitgeberprofile.
- Technische Aufgaben:
  - Budget-Engine in `lib/features/employer_mobility/` implementieren.
  - Benefit-Konfiguration mit Mock-Daten.
  - Integration mit Auth für Rollen.

#### US-106: Migration und Parallelbetrieb (M16 – Erweiterung)
- Als Betriebsverantwortlicher möchte ich Migrationsszenarien planen, damit der Übergang reibungslos verläuft.
- Akzeptanzkriterien:
  - Migrationsmapping ist dokumentiert.
  - Parallelbetrieb-Szenarien sind definiert.
  - Mock-Daten für Bestandssysteme.
- Technische Aufgaben:
  - Migrations-Logik in `lib/features/migration/` ausbauen.
  - Mapping-Tools mit Mock-Bestandsdaten.
  - Cut-over-Plan mit Fallbacks.

### 21.2 Phase 2: API-gebundene Funktionalitäten (mit Mock-Daten)

Diese Module benötigen externe APIs oder Partner. Prozesse sind vollständig definiert, warten aber auf API-Input mit Mock-Daten.

#### US-201: Ticketing und Produktkauf (M03)
- Als Nutzer möchte ich Tickets kaufen, damit ich Mobilität buchen kann.
- Akzeptanzkriterien:
  - Produktkatalog zeigt Tickets mit Mock-Daten.
  - Kaufprozess simuliert Transaktion (wartet auf Payment-API).
  - Beleg wird generiert.
- Technische Aufgaben:
  - Vollständige Ticketing-Architektur in `lib/features/ticketing/` anlegen.
  - Mock-Produkte und Kauf-Logik implementieren.
  - Platzhalter für API-Integration (z.B. Ticketing-API).

#### US-202: Abo-Verwaltung und Deutschlandticket (M04)
- Als Abonnent möchte ich meine Abos verwalten, damit ich Verträge einsehe.
- Akzeptanzkriterien:
  - Abo-Liste mit Mock-Daten funktioniert.
  - Status und Kündigung sind modelliert.
  - Wartet auf Vertrags-API.
- Technische Aufgaben:
  - Abo-Modell in `lib/features/subscriptions/` vollenden.
  - Mock-Verträge und Deutschlandticket-Logik.
  - Platzhalter für API-Adapter.

#### US-203: Zahlungen und Transaktionen (M10)
- Als Nutzer möchte ich Zahlungen ausführen, damit ich Buchungen abschließe.
- Akzeptanzkriterien:
  - Zahlungsmethoden mit Mock-Daten.
  - Transaktionstracking simuliert.
  - Wartet auf PSP-API.
- Technische Aufgaben:
  - Payment-Feature mit Mock-Transaktionen.
  - Beleg-Generierung implementieren.
  - Platzhalter für PSP-Integration.

#### US-204: Partnerbuchung und Partner-UX (M06)
- Als Nutzer möchte ich bei Partnern buchen, damit ich Sharing/Taxi nutze.
- Akzeptanzkriterien:
  - Booking-UI mit Mock-Partnern.
  - Statusanzeige funktioniert.
  - Wartet auf Partner-APIs.
- Technische Aufgaben:
  - Partnerbuchung von Partnerhub trennen.
  - Mock-Booking-Logik implementieren.
  - Platzhalter für API-Adapter.

#### US-205: Partnerintegration und Partnerhub (M12)
- Als Betriebsverantwortlicher möchte ich Partner anbinden, damit Integrationen funktionieren.
- Akzeptanzkriterien:
  - Partner-Adapter mit Mock-Daten.
  - SLA-Monitoring simuliert.
  - Wartet auf Partner-APIs.
- Technische Aufgaben:
  - Partnerhub mit Mock-Partnern erweitern.
  - Adapter-Pattern implementieren.
  - Platzhalter für reale APIs.

### 21.3 Phase 3: Ergänzende Funktionalitäten (selbst entwickelbar)

Diese sind nice-to-have und können nach MVP ergänzt werden.

#### US-301: Check-in / Check-out (M05)
- Als Nutzer möchte ich Fahrten starten/beenden, damit Preise korrekt sind.
- Akzeptanzkriterien:
  - Check-in/out mit Mock-Daten.
  - Tarifberechnung simuliert.
- Technische Aufgaben:
  - State-Management in `lib/features/check_in_out/` implementieren.
  - Mock-Tarife anbinden.

#### US-302: Kundenservice (M09)
- Als Nutzer möchte ich Support kontaktieren, damit Probleme gelöst werden.
- Akzeptanzkriterien:
  - Support-Formular mit Mock-Cases.
  - Status-Tracking simuliert.
- Technische Aufgaben:
  - Support-Feature mit Mock-Fällen.
  - Platzhalter für CRM-API.

#### US-303: Benachrichtigungen (M13)
- Als Nutzer möchte ich Notifications erhalten, damit ich informiert bleibe.
- Akzeptanzkriterien:
  - In-App-Notifications mit Mock-Daten.
  - Präferenzen einstellbar.
- Technische Aufgaben:
  - Notification-Service strukturieren.
  - Mock-Nachrichten implementieren.

#### US-304: Reporting und Monitoring (M14)
- Als Betriebsverantwortlicher möchte ich KPIs sehen, damit ich überwache.
- Akzeptanzkriterien:
  - Dashboard mit Mock-Metriken.
  - Export simuliert.
- Technische Aufgaben:
  - Reporting-Feature mit Mock-Daten.
  - Basis-Dashboard bauen.

### 21.4 Querschnittliche Qualitätsaufgaben

#### US-401: Barrierefreiheit und UX (M15)
- Als Nutzer möchte ich barrierefreie UI, damit alle zugreifen können.
- Akzeptanzkriterien:
  - Accessibility-Standards dokumentiert.
  - UI konsistent und lesbar.
- Technische Aufgaben:
  - Guidelines etablieren.
  - Review-Prozess einführen.

#### US-402: Fehler- und Eskalationslogik
- Als Nutzer möchte ich verständliche Fehler, damit ich weiß, was passiert.
- Akzeptanzkriterien:
  - Fehlermeldungen nutzerfreundlich.
  - Eskalation dokumentiert.
- Technische Aufgaben:
  - Fehlerklassen standardisieren.
  - Mock-Eskalationen implementieren.

### 21.5 Umsetzungsempfehlung

- **Phase 1 zuerst:** Baue MVP mit US-101 bis US-106 – alles selbst entwickelbar oder öffentliche APIs.
- **Phase 2 parallel:** Implementiere API-gebundene mit Mock-Daten, Prozesse vollständig definieren.
- **Phase 3 später:** Ergänzende Features nach MVP.
- **Mock-Daten:** Überall wo APIs warten, Mock-Daten hinterlegen (z.B. JSON-Files oder lokale DB).
- **API-Wartezeiten:** Prozesse enden mit Platzhaltern für API-Input, aber Logik ist vollständig.# Fachliches Lastenheft

**emma-App v1.0**

## 1. Dokumentenstatus

Dieses Dokument beschreibt das fachliche Lastenheft für die emma-App v1.0. Es konsolidiert die von dir vorgegebenen Produktanforderungen mit der bereits festgelegten emma-Zielarchitektur. Das Zielbild einer einzigen emma-App für ganz Mitteldeutschland, die bestehende App-Welten wie LeipzigMOVE, movemix und MOOVME im tatsächlich genutzten Funktionsumfang mindestens 1:1 übernimmt oder gleichwertig ablöst, ist bereits in der emma-Produktlogik angelegt. Ebenso sind die Pflichtintegration von Mobilitätspartnern, die Tarifserver-Verantwortung sowie die Unterscheidung zwischen vermittelten, eingekauften und selbst erbrachten Leistungen dort ausdrücklich festgelegt. 

## 2. Zielbild und Produktdefinition

emma ist eine KI-gestützte Mobilitätsassistenzplattform mit einer zentralen App als künftigem einheitlichem Kundenzugang für öffentliche und ergänzende Mobilität in Mitteldeutschland. Die App soll Nutzern alle für sie verfügbaren Mobilitätsoptionen in einer Oberfläche bereitstellen, auf Basis des Nutzerverhaltens Routinen und Vorschläge ableiten und perspektivisch eine Mobilitätsgarantie über Verbünde, Verkehrsunternehmen und ergänzende Mobilitätspartner hinweg ermöglichen. Dieses Zielbild entspricht der in der Produktliste beschriebenen Zielarchitektur. 

Version 1.0 fokussiert fachlich auf die nahtlose Interaktion zwischen Mensch und Maschine, auf multimodale Auffindbarkeit, Buchbarkeit und Nutzbarkeit von Mobilitätsleistungen sowie auf die sichere Einbindung bestehender Bestandswelten. Interne Entwickler- oder Analysefunktionen sind in v1.0 nur insoweit Bestandteil, wie sie für Betrieb, Qualitätssicherung oder Pilotierung erforderlich sind.

## 3. Ausgangslage

Die emma-App entsteht nicht auf einer grünen Wiese. Sie muss sich in eine bereits bestehende Verkehrs- und Systemlandschaft einfügen. Bestehende App-Welten und Hintergrundsysteme dürfen nicht funktional verschlechtert werden. Das betrifft insbesondere Routing, Ticketing, Abo- und D-Ticket-Logik, Check-in/Check-out, On-Demand-Buchung, Sharing-Anbindungen, Taxi-Integration sowie die operativen Hintergrundfunktionen wie Tariflogik, Kundenkonto, Berechtigungen, Abrechnung, Reporting, Schnittstellen und Störungsmanagement. Tarifserver und Regelwerke sind Pflichtinfrastruktur. 

Zudem ist die Markt- und Gründungslogik von emma zweisphärig ausgelegt: gemeinwohlorientierte Bildungs-, Transfer- und Governanceprodukte auf der einen Seite sowie steuerpflichtige Betriebs-, Plattform-, Daten- und Integrationsleistungen auf der anderen. Markteintrittslogik ist vorrangig die Arbeitgebermobilität. Diese Rahmenbedingungen beeinflussen das Lastenheft der App unmittelbar. 

## 4. Projektgegenstand

Gegenstand dieses Lastenhefts ist die fachliche Beschreibung der emma-App v1.0 als Endkundenprodukt einschließlich der dafür erforderlichen Kernmodule, Schnittstellen, Betriebslogiken und Qualitätsanforderungen. Nicht Gegenstand ist die vollständige technische Detailkonstruktion im Sinne eines Pflichtenhefts oder die abschließende Festlegung des Implementierungsstacks.

## 5. Projektziele

Die emma-App v1.0 soll erstens einen zentralen, intuitiven und personalisierten Zugang zu multimodaler Mobilität schaffen. Zweitens soll sie bestehende Mobilitätsangebote nicht ersetzen, sondern orchestrieren, integrieren und kundenseitig vereinheitlichen. Drittens soll sie eine belastbare Grundlage für spätere Ausbaustufen wie Mobilitätsgarantie, Arbeitgebermobilität, erweiterte CRM-Logik und regionale Skalierung schaffen. Viertens soll sie fachlich so angelegt sein, dass Bestandswelten migrationsfähig analysiert und ohne funktionalen Verlust in das emma-Zielbild überführt werden können. 

## 6. Nicht-Ziele in v1.0

Nicht Ziel der Version 1.0 ist die vollständige Eigenproduktion bestehender Verkehrsleistungen. ÖPNV-, On-Demand-, Sharing-, Carsharing- und Taxi-Leistungen bleiben operative Leistungen der jeweiligen Partner; emma vermittelt, integriert oder orchestriert diese Leistungen. Ebenfalls nicht Ziel von v1.0 ist eine vollständige General-Purpose-Entwicklerplattform. Live-Preview von HTML/React-Anwendungen und textbasierte Datenanalyse werden, sofern umgesetzt, als interne Betriebs-, Test- oder Pilotierungsfunktionen und nicht als primäres Endkundenprodukt behandelt. Die Produktliste grenzt bestehende Verkehrsleistungen ausdrücklich als Nicht-Eigenprodukte von emma ab. 

## 7. Nutzergruppen und Stakeholder

Primäre Nutzergruppen sind Endkunden mit Mobilitätsbedarf in Mitteldeutschland sowie perspektivisch Arbeitgebernutzer im Kontext betrieblicher Mobilität. Sekundäre Nutzergruppen sind Service- und Supporteinheiten, Partnerunternehmen, Verkehrsunternehmen, Integrationspartner und Administratoren. Relevante Stakeholder sind insbesondere MDV-nahe Verkehrsunternehmen, Plattform- und Integrationspartner, Tarif- und Hintergrundsystempartner sowie bestehende und neue Mobilitätsanbieter wie nextbike, teilAuto, On-Demand-Anbieter, Taxi-Partner und perspektivisch weitere Anbieter. Diese Partnerlogik ist in der emma-Produktarchitektur ausdrücklich festgelegt. 

## 8. Fachliche Gesamtanforderungen

### 8.1 Modul A: KI-gestützte Chat- und Assistenzschicht

Die App muss eine intelligente Chat-Schnittstelle bereitstellen. Diese muss kontextuelle Konversationen ermöglichen, den bisherigen Dialogverlauf berücksichtigen und den Nutzer in einer freundlichen, professionellen und hilfsbereiten Tonalität als „emma“ ansprechen. Die Konversation muss in Deutsch und Englisch voll unterstützt werden. Weitere Sprachen sind optionale Erweiterungen.

Muss-Anforderungen sind die Verwaltung des Gesprächskontexts innerhalb einer Sitzung, die Erkennung mobilitätsbezogener Nutzerintentionen, die Ausgabe verständlicher Handlungsvorschläge und die sichere Übergabe in fachliche Module wie Routing, Ticketing oder Kundenkonto. Soll-Anforderungen sind die Erkennung von Routinen, personalisierte Vorschläge und adaptive Oberflächenlogik auf Basis des Nutzungsverhaltens. Kann-Anforderungen sind proaktive Hinweise, lernende Präferenzmodelle und vertiefte Conversational Search.

Die Betriebsverantwortung liegt fachlich bei emma; das zugrundeliegende LLM kann als eingekaufte technische Leistung angebunden werden. Die SLA-Kritikalität ist hoch, aber nicht maximal kritisch, sofern Kernfunktionen der App auch über klassische UI-Navigation erreichbar bleiben.

### 8.2 Modul B: Multimodale Mobilitätsorchestrierung

Die App muss dem Nutzer alle verfügbaren Mobilitätsoptionen in einer Oberfläche bereitstellen. Dazu gehören mindestens öffentliche Verkehrsleistungen, On-Demand-Angebote, Bikesharing, Carsharing und perspektivisch Taxi- und weitere Partnerangebote. Die emma-Produktlogik definiert diese Leistungen als vermittelte Mobilitätsleistungen, während emma selbst die Orchestrierungs- und Integrationsverantwortung trägt. 

Muss-Anforderungen sind die Darstellung verfügbarer Optionen, die Verknüpfung mit Routing- und Buchungslogiken, die partnerbezogene Leistungsanzeige und die konsistente Nutzerführung über verschiedene Leistungsarten hinweg. Soll-Anforderungen sind kombinierte Reiseoptionen, Fallback-Optionen und kontextabhängige Priorisierung. Kann-Anforderungen sind multimodale Routinen, automatische Re-Planung und Mobilitätsgarantie-Trigger.

Die Bestandswelt umfasst LeipzigMOVE, movemix, MOOVME und weitere regionale App-Welten. Die 1:1-Übernahmepflicht umfasst den tatsächlich genutzten Funktionsumfang dieser Welten. Die SLA-Kritikalität ist maximal kritisch.

### 8.3 Modul C: Routing, Buchung und Ticketing

Die App muss Routing-, Buchungs- und Ticketing-Funktionen mindestens in dem Umfang abbilden, in dem sie in den relevanten Bestandswelten heute tatsächlich genutzt werden. Dazu gehören insbesondere Ticketkauf, D-Ticket-/Abo-Anzeige, Check-in/Check-out, On-Demand-Buchung sowie partnerbezogene Weiterleitungen oder direkte Buchungsstrecken. Diese Pflicht ergibt sich unmittelbar aus der 1:1-Übernahmelogik der emma-Zielarchitektur. 

Muss-Anforderungen sind konsistente Reiseauskunft, produktkonforme Ticketlogik, eindeutige Preis- und Produktdarstellung, Transaktionssicherheit und nachvollziehbare Fehlermeldungen. Soll-Anforderungen sind nutzerbezogene Favoriten, wiederkehrende Wege und vereinfachte Buchungsflows. Kann-Anforderungen sind vorausschauende Angebotsvorschläge und alternative Produktoptimierung.

Die Betriebsverantwortung ist geteilt: fachlich emma, technisch je nach Modul teils Integrations- oder Plattformpartner. Die SLA-Kritikalität ist maximal kritisch.

### 8.4 Modul D: Kundenkonto, Authentifizierung und Personalisierung

Die App muss ein sicheres Kundenkonto mit moderner Authentifizierung bereitstellen. Vorgesehen ist token-basierte Authentifizierung nach modernen Standards. Die App muss persönliche Präferenzen, Spracheinstellungen, Verlauf und relevante Mobilitätsroutinen nutzerbezogen verarbeiten können.

Muss-Anforderungen sind Registrierung, Login, Sitzungsverwaltung, Rollen-/Berechtigungslogik und datenschutzkonforme Speicherung nutzerbezogener Einstellungen. Soll-Anforderungen sind Single Sign-on, geräteübergreifende Synchronisierung und Präferenzprofile. Kann-Anforderungen sind fein granular steuerbare Personalisierungsregeln und kontextabhängige Startoberflächen.

Die Bestandswelt umfasst bestehende Kundenkontologiken der angeschlossenen Systeme. Die 1:1-Übernahmepflicht betrifft insbesondere Abo-, Berechtigungs- und Kundenkontofunktionen. Die SLA-Kritikalität ist sehr hoch.

### 8.5 Modul E: Tarifserver und Regelwerksmanagement

Tarifserver und Regelwerke sind Pflichtinfrastruktur. emma muss fachlich in der Lage sein, Tarifregeln, Produktlogiken, Preislogiken, Berechtigungen, Übergänge, Versionierungen und Ausnahmen sicher zu steuern oder technisch sicher integrieren zu lassen. Diese fachliche Verantwortung ist in der Produktliste ausdrücklich als Kernbaustein festgelegt. 

Muss-Anforderungen sind Tarifkonsistenz, Regelwerksversionierung, Produkt- und Berechtigungslogik, Nachvollziehbarkeit von Preisentscheidungen und sichere Integration mit Hintergrundsystemen. Soll-Anforderungen sind Test- und Simulationsmodi für Tarifänderungen. Kann-Anforderungen sind regelbasierte Produktempfehlungen.

Die SLA-Kritikalität ist maximal kritisch.

### 8.6 Modul F: Partnerhub und Integrationsmanagement

Die emma-App benötigt eine organisatorische und technische Integrationslogik für Verkehrsunternehmen, Sharing-Partner, Carsharing, Taxi, On-Demand und technische Plattformpartner. Die Produktarchitektur definiert hierfür den emma Partnerhub als Querschnittsbaustein. 

Muss-Anforderungen sind standardisierte Partneranbindung, Verwaltung technischer und fachlicher Schnittstellen, Fehler- und Qualitätsmanagement sowie eindeutige Vertragspartnerlogik. Soll-Anforderungen sind standardisierte Onboarding-Strecken und Monitoring je Partner. Kann-Anforderungen sind Self-Service-Partnerportale.

Die SLA-Kritikalität ist sehr hoch bis maximal kritisch, abhängig vom Partner und von seiner Rolle im Mobilitätsversprechen.

### 8.7 Modul G: Migrationsfabrik und Bestandsübernahme

Die emma-App v1.0 muss migrationsfähig gedacht werden. Für jede zu übernehmende Bestandswelt muss der tatsächlich genutzte Funktionsumfang dokumentiert, gemappt, getestet und abgesichert werden. Die Produktliste beschreibt hierfür eine eigene Migrationsfabrik mit Analyse, Parallelbetrieb, Datenmigration, Test, Schulung, Cut-over und Stabilisierung. 

Muss-Anforderungen sind Bestandsanalyse, Migrationsmapping, Testkonzepte, Fallback-Szenarien und Betriebsüberführung. Soll-Anforderungen sind standardisierte Migrationswerkzeuge und wiederverwendbare Migrationsmuster. Kann-Anforderungen sind weitgehend automatisierte Mapping- und Regressionstests.

Die SLA-Kritikalität ist maximal kritisch.

### 8.8 Modul H: Datenanalyse und textbasierte Auswertung

Die Anforderung „Auswertung von textbasierten Datensätzen und Erstellung von Zusammenfassungen“ wird in diesem Lastenheft nicht als primäre Endkundenfunktion, sondern als internes Analyse- und Betriebsmodul eingeordnet. Fachlich passt sie zu den bereits beschriebenen Daten- und Analyseprodukten von emma. 

Muss-Anforderungen bestehen nur dann, wenn diese Funktion für Support, Reporting, Qualitätsmanagement oder Pilotbewertung benötigt wird. Endkundenseitig ist sie in v1.0 nicht zwingend. Soll-Anforderungen sind interne Auswertungs- und Berichtsfunktionen. Kann-Anforderungen sind explorative Analysen, Clusterung und zusammenfassende Management-Reports.

### 8.9 Modul I: Live-Preview für HTML/React

Die Anforderung „Live-Preview“ ist für eine Mobilitäts-Endkundenapp fachlich kein Kernmodul. Sie wird daher als optionales internes Entwickler- oder Betriebsmittel klassifiziert. In einem reinen Endkunden-Release ist sie kein Muss. Sollte sie Bestandteil von v1.0 werden, dann nur für interne Vorschau, Template-Testing oder White-Label-Konfiguration.

## 9. Anforderungen an Benutzeroberfläche und Design

Die App muss ein modernes, klares und reduziertes Interface mit Fokus auf Lesbarkeit, Whitespace, klarer Typografie und konsistenter Navigationslogik bereitstellen. Sie muss responsive für Smartphone, Tablet und Desktop funktionieren. Dark Mode und Light Mode müssen sich mindestens am Systemdesign orientieren; eine manuelle Umschaltmöglichkeit ist Soll-Anforderung.

Die Oberfläche muss sowohl für konversationelle Nutzung als auch für klassische Navigation geeignet sein. Kritische Kernfunktionen dürfen nicht ausschließlich im Chat verborgen sein, sondern müssen auch explizit über UI-Elemente erreichbar bleiben.

## 10. Sicherheit und Datenschutz

Die App muss persönliche Daten datensparsam und datenschutzkonforme verarbeiten. Personenbezogene Daten sind nur in dem Umfang zu verarbeiten, der für Kundenkonto, Transaktion, Personalisierung und Support erforderlich ist. KI-bezogene Verarbeitungen müssen soweit möglich anonymisiert oder pseudonymisiert erfolgen. Es müssen rollenbasierte Zugriffe, sichere Token-Verwaltung, Logging sicherheitsrelevanter Ereignisse und Schutzmechanismen gegen unbefugten Zugriff vorgesehen werden.

Muss-Anforderungen sind sichere Authentifizierung, Transportverschlüsselung, Berechtigungsprüfung, Lösch- und Auskunftsfähigkeit sowie nachvollziehbare Zuständigkeiten zwischen emma und Partnern. Soll-Anforderungen sind Privacy-by-Design, getrennte Verarbeitungsräume und feingranulare Consent-Steuerung. Kann-Anforderungen sind lokale Personalisierungslogiken auf Endgeräten.

## 11. Technische und nichtfunktionale Anforderungen

Die App muss an leistungsfähige LLMs angebunden werden können. Das Frontend muss mit modernen Frameworks entwickelt werden und eine hohe Performance auf mobilen Endgeräten bieten. Die Zielvorgabe von unter einer Sekunde für die initiale Inhaltsgenerierung ist als Zielwert für wahrgenommene Erstreaktion sinnvoll, fachlich aber nur für bestimmte Interaktionen realistisch. Für komplexe Live-Abfragen über mehrere Partner- und Bestandssysteme ist daher zwischen Sofortreaktion, Teilantwort und Endergebnis zu unterscheiden.

Muss-Anforderungen sind performanter Erstaufruf, stabile Kernnavigation, robuste Fehlertoleranz, Monitoring und Wiederanlaufbarkeit. Soll-Anforderungen sind progressive Inhaltsladung und Offline-nahe Puffermuster für unkritische Inhalte. Kann-Anforderungen sind edge-basierte Beschleunigung und lokale Cache-Logiken.

## 12. Schnittstellenanforderungen

Die App benötigt Schnittstellen zu Routingdiensten, Ticketing- und Vertriebssystemen, Tarifservern, Kundenkonten, Zahlungsdiensten, Sharing- und Carsharing-Partnern, On-Demand-Systemen, Taxi-Partnern sowie internen Analyse- und Reportingdiensten. Die Produktlogik nennt ausdrücklich technische Plattformmodule, Hintergrundsystemkomponenten, Payment-/PSP-Leistungen, Routing-, Buchungs- und Betriebsbausteine als eingekaufte oder integrierte Pflichtkomponenten. 

Für jede Schnittstelle sind fachlich mindestens Dateninhalt, Betriebsverantwortung, Fehlerverhalten, SLA, Versionierung und Migrationsrelevanz zu definieren.

## 13. Rollen und Betriebsverantwortung

emma trägt die fachliche Produktführerschaft für App, Orchestrierung, Regelwerk, Partnersteuerung und Zielarchitektur. Technische Teilkomponenten können durch Service-Sphäre, Plattformpartner oder Bestandspartner erbracht werden. Verkehrsunternehmen bleiben Betreiber ihrer originären Verkehrsleistungen. Sharing-, Carsharing-, Taxi- und On-Demand-Anbieter bleiben Betreiber ihrer jeweiligen Leistungen. Daraus folgt eine gemischte Verantwortungsstruktur aus selbst erbrachten, vermittelten und eingekauften Leistungen, wie sie in der Produktliste festgelegt ist. 

## 14. Muss-/Soll-/Kann-Verdichtung auf Gesamtproduktebene

**Muss:** KI-Chat mit Kontextbezug, Deutsch/Englisch, multimodale Angebotsanzeige, Routing/Buchung/Ticketing im relevanten Bestandsumfang, sicheres Kundenkonto, moderne Authentifizierung, responsive UI, Dark-/Light-Mode-Grundfähigkeit, Tarifserver-/Regelwerksanbindung, Partnerintegration, Migrationsfähigkeit, Datenschutz- und Sicherheitsbasis.

**Soll:** adaptive Startoberfläche, Routinen und personalisierte Vorschläge, manuelle Theme-Umschaltung, standardisierte Partner-Onboarding-Logik, Reporting- und Analysefunktionen für Betrieb, vorbereitete Arbeitgebermobilitätslogik.

**Kann:** weitere Sprachen, Mobilitätsgarantie-Automatisierung, explorative Datenanalyse, interne Live-Preview-Funktion, proaktive Re-Planung, White-Label-Ausleitungen.

## 15. Abnahmekriterien

Das System gilt fachlich als abnahmefähig, wenn die Kernnutzerreise von Information über Auswahl bis Nutzung/Buchung für die priorisierten Mobilitätsarten stabil funktioniert, wenn die relevanten Bestandsfunktionen nicht schlechter gestellt werden, wenn Authentifizierung und Datenschutz nachweisbar belastbar umgesetzt sind und wenn die Partner- und Tariflogik betrieblich beherrscht werden kann.

Abnahmeleitend sind insbesondere vier Prüffragen: Erstens, kann ein Nutzer seine relevanten Mobilitätsoptionen in einer Oberfläche verlässlich finden? Zweitens, bleiben die heute genutzten Kernfunktionen der Bestandswelten erhalten? Drittens, ist die Verantwortungslogik zwischen emma, Verkehrsunternehmen und technischen Partnern eindeutig? Viertens, ist das System migrations- und skalierungsfähig?

## 16. Risiken

Das größte fachliche Risiko ist Scope-Überdehnung durch Vermischung von Endkundenprodukt, Betriebsplattform und Entwicklerwerkzeug. Zweitens besteht ein hohes Integrationsrisiko, weil die 1:1-Übernahmepflicht von App-Welten und Hintergrundsystemen sehr anspruchsvoll ist. Drittens besteht ein Betriebsrisiko, wenn Tarifserver-, Regelwerks- und Partnerverantwortung nicht sauber getrennt sind. Viertens besteht ein Governance-Risiko, falls Vertragspartnerlogik, SLA und Eskalationswege nicht frühzeitig festgelegt werden. Fünftens besteht ein UX-Risiko, wenn Chat und klassische UI-Navigation nicht konsistent zusammenspielen.

## 17. Offene Entscheidungen

Offen ist, welche Funktionen in v1.0 tatsächlich als Endkundenfunktion live gehen und welche zunächst intern oder pilotseitig betrieben werden. Offen ist ferner, welche Bestandswelten in Phase 1 konkret übernommen werden und in welcher Reihenfolge. Ebenfalls offen sind das konkrete Identitätsmodell, die priorisierten Partner-APIs, die Ausgestaltung der Mobilitätsgarantie in v1.0 und die Frage, ob Arbeitgebermobilität bereits in der ersten öffentlichen App-Version sichtbar ist oder zunächst als gesonderter Servicebaustein läuft.

## 18. Annahmen

Dieses Lastenheft geht davon aus, dass emma fachlich als zentrale Orchestrierungs- und Produktinstanz auftreten soll, während operative Verkehrsleistungen bei den jeweiligen Partnern verbleiben. Es geht ferner davon aus, dass die Bestandswelten nicht vollständig ersetzt, sondern schrittweise integriert oder gleichwertig abgelöst werden. Zudem wird angenommen, dass Arbeitgebermobilität ein priorisierter Markteintrittspfad bleibt und daher die Architektur bereits in v1.0 anschlussfähig dafür vorbereitet werden soll. Diese Annahmen sind konsistent mit der vorliegenden emma-Produktliste. 

## 19. Qualitätssicherung

Zentrale Annahmen sind die Ein-App-Logik für Mitteldeutschland, die 1:1-Übernahmepflicht der genutzten Bestandsfunktionen, die Pflichtrolle von Tarifserver und Regelwerksmanagement sowie die Dreiteilung in vermittelten, eingekauften und selbst erbrachten Leistungen. Diese Punkte sind in der vorliegenden emma-Produktlogik bereits eindeutig angelegt. 

Die fachlich größte Schärfung in diesem Lastenheft ist die bewusste Umklassifizierung von „Live-Preview“ und „wissenschaftlicher Analyse“: Beides ist für eine Mobilitäts-Endkundenapp kein zwingender v1.0-Kern und sollte nur aufgenommen werden, wenn du diese Funktionen ausdrücklich als internes Betriebsmodul oder separates Admin-/Pilotmodul freigibst.

Mini-Checkliste zur Validierung:

1. Sind Endkunden-, Admin- und Entwicklerfunktionen sauber getrennt?
2. Ist je Modul klar, was Muss, Soll und Kann ist?
3. Ist die 1:1-Übernahmepflicht pro Bestandswelt konkret benannt?
4. Sind Betriebsverantwortung, Vertragspartnerlogik und SLA je Kernmodul belastbar festgelegt?
5. Ist die v1.0-Abgrenzung gegen v1.1 tatsächlich entscheidungsreif?

## 20. Statusübersicht Funktionskatalog

Die folgenden Module sind aus Sicht des aktuellen Codes und der vorhandenen Feature-Strukturen im Projekt überprüft.

| Modul | Titel | Status | Kommentar |
|------|-------|--------|-----------|
| M01 | Nutzerkonto und Identität | Implementiert | auth_and_identity vorhanden, SSO/Multi-Profil noch offen |
| M02 | Routing, Reiseauskunft | Teilweise | trips vorhanden, Routing-Logik und Echtzeit noch ausbaubar |
| M03 | Ticketing und Produktkauf | Platzhalter/teilweise | tickets Screen vorhanden, aber keine vollständige Ticketing-Architektur |
| M04 | Abo, Deutschlandticket | Placeholder vorhanden | subscriptions Feature erstellt, Domain/Usecases noch offen |
| M05 | Check-in / Check-out | Placeholder vorhanden | check_in_out Feature erstellt, Geschäftslogik fehlt |
| M06 | Partnerbuchung | Teilweise | partnerhub existiert, Buchungsfluss und Partner-UX noch nicht voll getrennt |
| M07 | Mobilitätsgarantie | Implementiert | mobility_guarantee vorhanden, Fallback-Orchestrierung noch ausstehend |
| M08 | Arbeitgebermobilität | Implementiert | employer_mobility vorhanden, Budget- und Benefit-Logik noch nicht komplett |
| M09 | Kundenservice, Support | Placeholder vorhanden | customer_service Feature erstellt, Supportprozesse noch nicht modelliert |
| M10 | Zahlungen, Transaktionen, Belege | Placeholder vorhanden | payments Feature erstellt, PSP-Integration und Beleglogik fehlen |
| M11 | Tarifserver, Regelwerk | Implementiert | tariff_rules vorhanden, Tarif-Engine und Versionierung noch in Arbeit |
| M12 | Partnerintegration | Teilweise | partnerhub vorhanden, Partneradapter- und SLA-Logik noch unvollständig |
| M13 | Benachrichtigungen | Placeholder vorhanden | notifications Feature erstellt, Nachrichtensystem noch nicht implementiert |
| M14 | Daten, Reporting | Placeholder vorhanden | data_reporting Feature erstellt, Reporting/Monitoring noch nicht umgesetzt |
| M15 | Barrierefreiheit, UX | Querschnittlich | noch kein eigener Ordner, muss design- und accessibility-gesteuert ergänzt werden |
| M16 | Migration, Cut-over | Implementiert | migration Feature vorhanden, Migrationsstrategie bleibt ausstehend |

### Ergänzbare Funktionen

Die folgenden Funktionen können jetzt weiter ergänzt werden, weil der Projektbaukasten bereits die notwendigen Feature-Strukturen oder Screens enthält:
- M04 Abo / Deutschlandticket: `lib/features/subscriptions/`
- M05 Check-in / Check-out: `lib/features/check_in_out/`
- M09 Kundenservice / Support: `lib/features/customer_service/`
- M10 Zahlungen / Transaktionen: `lib/features/payments/`
- M13 Benachrichtigungen: `lib/features/notifications/`
- M14 Daten / Reporting: `lib/features/data_reporting/`
- M03 Ticketing: `lib/features/tickets/` ist präsent, benötigt aber Domain-/Datenebene

### Fehlende oder noch als Platzhalter vorhandene Aufgaben

- M03 Ticketing: Full Ticketing-Architektur fehlt, Platzhalter-Screen nur initial vorhanden.
- M04 Abo: Platzhalter existiert, Geschäftsprozesse und Deutschlandticket-Regeln fehlen.
- M05 Check-in/Check-out: Platzhalter vorhanden, Funktionslogik fehlt komplett.
- M09 Kundenservice: Platzhalter vorhanden, Support-Fallmanagement fehlt.
- M10 Zahlungen: Platzhalter vorhanden, PSP-Integration und Belege fehlen.
- M13 Benachrichtigungen: Platzhalter vorhanden, Nachrichtenauslieferung fehlt.
- M14 Daten/Reporting: Platzhalter vorhanden, Monitoring/Reporting fehlt.
- M02 Routing: Funktionalität nur ansatzweise, Echtzeit und Alternativen müssen ergänzt werden.
- M06 Partnerbuchung: Struktur vorhanden, Buchungsabläufe und Partner-UX müssen sauber getrennt werden.
- M11 Tarifserver: Struktur vorhanden, Tarifregel-Engine mit Versionierung/Tests fehlt.

### Empfehlung für das Lastenheft

Dieses Lastenheft sollte nun als Grundlage für die nächste Entwicklungsphase genutzt werden. Die Statusübersicht macht die Lücken transparent und erlaubt einen klaren Umsetzungsplan:
- Phase 1: MVP-Kernmodule ohne externe Abhängigkeiten (selbst entwickelbar oder öffentliche APIs wie TRIAS)
- Phase 2: API-gebundene Funktionalitäten mit Mock-Daten und vollständigen Prozessen
- Querschnitt: M15 Accessibility/UX als begleitende Qualitätsaufgabe

## 21. Nächste Entwicklungsaufgaben und User Stories

Die folgenden Aufgaben sind die direkte Fortsetzung der offenen Punkte im Funktionskatalog. Sie sind so formuliert, dass sie als Entwicklungstickets oder User Stories genutzt werden können.

### 21.1 Priorität 1: Kritische Produktkernfunktionen

#### US-101: Ticketkauf und Ticket-Produktlogik (M03)
- Als Nutzer möchte ich verfügbare Tickets sehen, ein Ticket auswählen und sicher kaufen können, damit ich eine echte Mobilitätsbuchung durchführen kann.
- Akzeptanzkriterien:
  - Produktkatalog zeigt Tickettyp, Preis, Gültigkeit und Bedingungen.
  - Kaufprozess startet Zahlungstransaktion und liefert Beleg oder Fehlermeldung.
  - Ticketstatus wird im Nutzerkonto angezeigt.
- Technische Aufgaben:
  - Feature-Ordner `lib/features/ticketing/` anlegen.
  - Ticket-Entity, Repository, Remote-DataSource und Domain-Usecases implementieren.
  - Integration mit `payments` und `tariff_rules` sicherstellen.

#### US-102: Abo-Verwaltung und Deutschlandticket (M04)
- Als Abonnent möchte ich meine laufenden Abos und Deutschlandticket-Informationen einsehen und verwalten können, damit ich den Status meiner Verträge kenne.
- Akzeptanzkriterien:
  - Abo-Liste zeigt aktiven Status, Laufzeit, Preis und Produktdetails.
  - Kündigung/Erneuerung kann angestoßen werden.
  - Deutschlandticket-Spezifika (Gültigkeit, Nutzerrechte) sind abgebildet.
- Technische Aufgaben:
  - Domain-Model für Subscription/Contract implementieren.
  - Abo-Statusverwaltung und API-Adapter für Vertragsdaten entwickeln.
  - Anzeige im Kundenkonto integrieren.

#### US-103: Zahlungsabwicklung und Belege (M10)
- Als Nutzer möchte ich Zahlungen sicher ausführen und Belege erhalten, damit ich meine Buchungen vertrauenswürdig abschließen kann.
- Akzeptanzkriterien:
  - Zahlungsmethoden können ausgewählt werden.
  - Transaktionen werden eindeutig getrackt und bei Fehlern verständlich erklärt.
  - Belegdaten werden erzeugt und sind im Konto verfügbar.
- Technische Aufgaben:
  - `payments` Feature mit PSP-Adapterstruktur anlegen.
  - Transaktionsmodell und Fehlerbehandlung implementieren.
  - Beleg-Generierung als Dokumentenknoten modellieren.

### 21.2 Priorität 2: Essentielle Service- und Regelwerksthemen

#### US-201: Routing mit Echtzeit und Alternativen (M02)
- Als Nutzer möchte ich zuverlässige Routenvorschläge inklusive Alternativen erhalten, damit ich bei Störungen schnell umplanen kann.
- Akzeptanzkriterien:
  - Routing-Suche liefert mehrere Optionen mit Verkehrsarten.
  - Störungsbezogene Alternativen werden vorgeschlagen.
  - Echtzeitdaten werden bei Verfügbarkeit genutzt.
- Technische Aufgaben:
  - Routing-Logik in `lib/features/trips/` erweitern.
  - Echtzeitdaten-Adapter einbinden.
  - Performance- und Fallback-Mechanismen absichern.

#### US-202: Partnerbuchung und Partner-UX (M06)
- Als Nutzer möchte ich Buchungen bei Partnern wie Sharing, Taxi oder On-Demand ohne Brüche durchführen können.
- Akzeptanzkriterien:
  - Einheitliches Booking-UI für alle Partner-Typen.
  - Statusanzeige und Abschluss-Feedback vorhanden.
  - Fehler und Stornierungen werden konsistent behandelt.
- Technische Aufgaben:
  - Partnerbuchung logisch vom Partnerhub trennen.
  - Gemeinsames Booking-Interface definieren.
  - Partner-spezifische Adapter einführen.

#### US-203: Tarifserver-Regelwerk mit Versionierung (M11)
- Als Produktverantwortlicher möchte ich Tarifregeln versionieren und simulieren können, damit Änderungen kontrolliert ausgerollt werden.
- Akzeptanzkriterien:
  - Regelwerk kann in Versionen gespeichert werden.
  - Gültigkeit und Ausnahmen sind nachvollziehbar.
  - Testmodus erlaubt Simulation ohne Live-Schaltung.
- Technische Aufgaben:
  - Regelwerk-Engine mit Persistenz- und Versionierungsmodell bauen.
  - Test- / Simulationsmodus implementieren.
  - Integration mit Ticketing und Abo sicherstellen.

### 21.3 Priorität 3: Ergänzende Betriebs- und Kundenfunktionen

#### US-301: Check-in / Check-out für nutzungsbasierte Produkte (M05)
- Als Nutzer möchte ich meine Fahrt starten und beenden können, damit nutzungsbasierte Preise korrekt berechnet werden.
- Akzeptanzkriterien:
  - Check-in und Check-out lassen sich starten und stoppen.
  - Tarifberechnung erfolgt am Ende der Nutzung.
  - Fehler beim Abbruch werden dokumentiert.
- Technische Aufgaben:
  - Check-in/out-State-Management implementieren.
  - Tarifberechnung an M11 anbinden.
  - Integration mit Ticketing und Support sicherstellen.

#### US-302: Kundenservice-Formular und Case-Tracking (M09)
- Als Nutzer möchte ich Supportfälle einreichen und ihren Status einsehen können.
- Akzeptanzkriterien:
  - Ein Formular für Supportanfragen existiert.
  - Supportfälle werden eindeutig referenziert.
  - Fälle können im Nutzerkonto eingesehen werden.
- Technische Aufgaben:
  - Support-Feature mit Fallmanagement anlegen.
  - Schnittstelle zu CRM/Service-Backend spezifizieren.
  - FAQ/Status-Tracking ergänzen.

#### US-303: In-App-Benachrichtigungen (M13)
- Als Nutzer möchte ich Benachrichtigungen über Buchungsstatus, Änderungen und Störungen erhalten.
- Akzeptanzkriterien:
  - Nachrichten erscheinen in der App.
  - Nutzerpräferenzen für Notifications sind vorhanden.
  - Push-/In-App-Logik ist strukturiert.
- Technische Aufgaben:
  - Notification-Service strukturieren.
  - Kanäle (Push, In-App) definieren.
  - Präferenzen und Opt-in implementieren.

#### US-304: Reporting und Monitoring (M14)
- Als Betriebsverantwortlicher möchte ich Kennzahlen und Systemzustände sehen, damit ich Betrieb und Qualität steuern kann.
- Akzeptanzkriterien:
  - KPI-Dashboard zeigt Basismetriken.
  - Monitoring informiert über kritische Fehler.
  - Reporting-Daten können exportiert werden.
- Technische Aufgaben:
  - Reporting-Feature anlegen.
  - Datenquelle für Betriebsmetriken definieren.
  - Basis-Dashboard implementieren.

### 21.4 Querschnittliche Qualitätsaufgaben

#### US-401: Barrierefreie UI und UX-Standards (M15)
- Als Nutzer möchte ich die App barrierefrei und intuitiv nutzen können.
- Akzeptanzkriterien:
  - Accessibility-Standards sind dokumentiert.
  - Navigation ist konsistent und gut lesbar.
  - Farbkontrast und Steuerbarkeit sind geprüft.
- Technische Aufgaben:
  - UX- und Accessibility-Guidelines etablieren.
  - Review-Prozess für UI-Änderungen einführen.
  - Querschnittstests für Barrierefreiheit ergänzen.

#### US-402: Konsistente Fehler- und Eskalationslogik
- Als Nutzer möchte ich bei Problemen verständliche Fehlerhinweise erhalten.
- Akzeptanzkriterien:
  - Fehlermeldungen sind nutzerfreundlich.
  - Eskalationswege sind dokumentiert.
  - Support- und Partnerfehler werden unterschieden.
- Technische Aufgaben:
  - Fehlerklassen und Messages standardisieren.
  - Eskalationsmatrix für Partner- und Systemfehler definieren.
  - Logging- und Monitoring-Tickets anlegen.

### 21.5 Umsetzungsempfehlung

- Starte mit den Priorität-1-Us auf Ticketing, Abo und Payments.
- Lege bei M02/M06/M11 parallel die technischen APIs und Adapterstrukturen fest.
- Halte M05/M09/M13/M14 als Folgephase bereit, um den Go-Live-Kern nicht zu blockieren.
- Pflege M15 als kontinuierliche Qualitätsaufgabe während der gesamten Phase.
---

# Teil B — Funktionskatalog emma-App v1.0


# Funktionskatalog emma-App v1.0

**Dokument:** Fachliches Lastenheft mit priorisiertem Muss-Umfang  
**Zweck:** Fachliche Zieldefinition, Gründungs- und Partnerfähigkeit, Architekturvorbereitung, Ausschreibungsvorbereitung  
**Stand:** Version 1.0 (erstellt April 2026, bestätigt 2026-04-16)  
**Gültigkeit:** Fachlich unverändert gültig. Strukturelle Code-Referenzen → `docs/architecture/MAPPING.md`.

---

## 1. Zweck des Dokuments

Dieser Funktionskatalog beschreibt den fachlichen und betrieblichen Sollumfang der emma-App in Version 1.0 als fachliches Lastenheft. Ziel ist ein entscheidungsreifer Arbeitsstand für Gründung, Produktsteuerung, Architekturvorbereitung, Partnerverhandlungen, Ausschreibungsvorbereitung, Migrationsplanung und die spätere Überführung in Pflichtenheft, Epics, User Stories und Akzeptanzkriterien.

Die emma-App ist das perspektivische gemeinsame Frontend für die öffentliche Mobilität in Mitteldeutschland. Sie darf bestehende regionale App-Welten und Hintergrundsysteme im tatsächlich genutzten Funktionsumfang nicht verschlechtern, sondern muss diese mindestens gleichwertig übernehmen oder geordnet ablösen.

---

## 2. Zielbild der emma-App

Die emma-App ist der zentrale digitale Kundenzugang für multimodale Mobilität in Mitteldeutschland. Sie bündelt Routing, Information, Buchung, Ticketing, Kundenkonto, Arbeitgebermobilität, Mobilitätsgarantie sowie die Integration bestehender und neuer Mobilitätspartner in einer gemeinsamen Produkt- und Betriebslogik.

Die emma-App ist **kein ergänzender Marketing-Kanal** neben bestehenden regionalen Apps, sondern das **perspektivische Zielsystem** für eine gemeinsame nutzerseitige Mobilitätswelt.

---

## 3. Leitprinzipien

1. **Mitteldeutschland-Zielbild:** Verbund- und unternehmensübergreifende Mobilitätswelt
2. **1:1-Übernahmepflicht:** Kein heute real genutzter Kernfunktionsumfang darf verloren gehen
3. **Mobilitätsgarantie als Produktkern:** App muss verlässliche Mobilitätsoptionen absichern
4. **Partnerfähigkeit:** Standardisierte Integrations- und Vertragslogik
5. **Betriebsfähigkeit vor Design:** Kritische Betriebs- und Vertriebskomponente
6. **Tarif- und Regelwerksstabilität:** Fachlich abgesichert, versioniert, auditierbar
7. **Migrationsfähigkeit:** Jede Kernfunktion für Bestandsübernahme, Parallelbetrieb, Cut-over nutzbar

---

## 4. Priorisierungslogik

- **Muss-Funktion:** Ohne diese ist die App nicht gründungsreif, migrationsreif oder marktfähig
- **Soll-Funktion:** Hoher fachlicher Nutzen; kann in früher Ausbaustufe nachgezogen werden
- **Kann-Funktion:** Ergänzender Mehrwert; nicht Voraussetzung für Betriebsstart

---

## 5. Module im Überblick

| Modul | Titel | Status |
|-------|-------|--------|
| M01 | Nutzerkonto und Identität | Muss |
| M02 | Routing, Reiseauskunft und Angebotsdarstellung | Muss |
| M03 | Ticketing und Produktkauf | Muss |
| M04 | Abo, Deutschlandticket und laufende Vertragsprodukte | Muss |
| M05 | Check-in / Check-out und nutzungsbasierte Produktlogik | Muss* |
| M06 | Buchung von On-Demand-, Sharing- und ergänzenden Mobilitätsleistungen | Muss |
| M07 | Mobilitätsgarantie und Fallback-Logik | Muss |
| M08 | Arbeitgebermobilität, Mobilitätsbudget und Benefits | Muss |
| M09 | Kundenservice, Support und Self-Service | Muss |
| M10 | Zahlungen, Transaktionen und Belege | Muss |
| M11 | Tarifserver und Regelwerksmanagement | Muss |
| M12 | Partnerintegration und Partnerhub-Funktionen | Muss |
| M13 | Benachrichtigungen und Kommunikation | Querschnitt |
| M14 | Daten, Reporting und Monitoring | Muss |
| M15 | Barrierefreiheit, Usability und Vertrauen | Querschnitt |
| M16 | Migration, Parallelbetrieb und Cut-over | Muss |

*M05 ist Muss, soweit in Zielregionen oder Kernprodukten erforderlich

---

## 6. Moduldetails

### M01: Nutzerkonto und Identität

**Ziel:** Registrierung, Anmeldung, Profil, Rechte, Einwilligungen und Grundlage aller kundenbezogenen Berechtigungen

**Muss-Funktionen:**
- M01-F01 Registrierung und Login
- M01-F02 Passwort- und Zugangsverwaltung
- M01-F03 Profilverwaltung
- M01-F04 Rechte- und Berechtigungslogik
- M01-F05 Datenschutz- und Einwilligungsmanagement

**Soll-Funktionen:**
- M01-F06 Single-Sign-On für Partnerwelten
- M01-F07 Mehrprofilfähigkeit für private und arbeitgeberbezogene Nutzung

**Kann-Funktionen:**
- M01-F08 Familien- oder Gruppenprofile

**Externe Rollen:** Fahrgast, Abokunde, Arbeitnehmer  
**Interne Rollen:** Produktverantwortung, Customer Service, Partner- und Integrationsmanagement

**Fachliche Betriebsverantwortung:** emma Produktverantwortung und Rechte-/Datenschutzverantwortung  
**Technische Betriebsverantwortung:** App-Plattformbetrieb; ggf. externes IAM-Partner

**Leistungsart:** Selbst erbracht (Kern); Teilkomponenten können eingekauft werden

**Bestandswelt:** Kundenkonto-, Abo- und Identitätslogiken regionaler Apps

**1:1-Übernahmepflicht:** Alle today real genutzten Login-, Profil-, Zustimmungs- und Berechtigungsfunktionen

**Schnittstellen:** CRM, Abo-/Vertriebshintergrundsysteme, Arbeitgeberportal, Consent-Management, Support, Partner-SSO

**SLA-Kritikalität:** Sehr hoch

**Hauptrisiken:**
- Inkonsistente Berechtigungen
- Doppelte Identitäten
- Datenschutzverstöße
- Medienbrüche zwischen privaten und arbeitgeberbezogenen Rollen

**Offene Entscheidungen:**
- Zentraler externer IAM-Baustein oder partnernahes Identitätsmodell?
- SSO bereits im Kernrelease enthalten?

**Annahmen:**
- Ein zentrales emma-Konto wird aufgebaut
- Arbeitgeberspezifische Freischaltungen im zentralen Konto abgebildet, nicht in separaten Silos

---

### M02: Routing, Reiseauskunft und Angebotsdarstellung

**Ziel:** Intermodale Reiseplanung und Angebotsdarstellung über ÖPNV, On-Demand, Sharing, Taxi und weitere integrierte Angebote

**Muss-Funktionen:**
- M02-F01 Start-Ziel-Suche
- M02-F02 Intermodales Routing
- M02-F03 Anzeige von Echtzeit- und Soll-Daten
- M02-F04 Angebotsfilter
- M02-F05 Störungsbezogene Alternativvorschläge
- M02-F06 Darstellung partnerbezogener Angebotsdetails

**Soll-Funktionen:**
- M02-F07 Personalisierte Präferenzen
- M02-F08 Pendel- und Routinenlogik

**Kann-Funktionen:**
- M02-F09 Kontextbasierte Empfehlungen

**SLA-Kritikalität:** Maximal kritisch

**Hauptrisiken:**
- Schwankende Datenqualität der Partner
- Fehlerhafte Intermodalität
- Unzureichende Echtzeitqualität
- Verschlechterung gegenüber Bestandswelten

**1:1-Übernahmepflicht:** Mindestens gleichwertige Übernahme aller heute real genutzten Routing-, Abfahrts-, Echtzeit-, Karten-, Störungs- und Umstiegsinformationen

---

### M03: Ticketing und Produktkauf

**Ziel:** Anzeige, Auswahl, Kauf, Bereitstellung und Nachweis digitaler Fahrprodukte

**Muss-Funktionen:**
- M03-F01 Produktanzeige und Produktauswahl
- M03-F02 Ticketkauf
- M03-F03 Digitale Bereitstellung des Tickets
- M03-F04 Historie und Beleglogik
- M03-F05 Produktabhängige Nutzungsregeln
- M03-F06 Störungs- und Fehlerbehandlung

**Soll-Funktionen:**
- M03-F07 Rückgabe- und Erstattungsanstoß
- M03-F08 Partnerübergreifende Bündelprodukte

**Kann-Funktionen:**
- M03-F09 Geschenk- oder Mehrpersonentickets

**SLA-Kritikalität:** Maximal kritisch

**Hauptrisiken:**
- Tarif- oder Preisfehler
- Nicht zustande kommende Transaktionen
- Nicht prüfbare Tickets
- Unklare Fehlerzustände
- Fehlende Belegfähigkeit

**1:1-Übernahmepflicht:** Alle heute real genutzten Kauf-, Bereitstellungs-, Ticketanzeige-, Prüfbarkeits- und Historienfunktionen

---

### M04: Abo, Deutschlandticket und laufende Vertragsprodukte

**Ziel:** Abbildung laufender Mobilitätsverträge, Abos und berechtigungsgebundener Produkte einschließlich Deutschlandticket

**Muss-Funktionen:**
- M04-F01 Anzeige aktiver Abos und Vertragsprodukte
- M04-F02 Deutschlandticket-Anzeige
- M04-F03 Abo-Statuslogik
- M04-F04 Berechtigungsprüfung
- M04-F05 Kundenservice-Anbindung

**Soll-Funktionen:**
- M04-F06 Digitale Abo-Änderung
- M04-F07 Vertragsbezogene Benachrichtigungen

**Kann-Funktionen:**
- M04-F08 Mehrere Vertragsprodukte in einem Wallet

**SLA-Kritikalität:** Maximal kritisch

**Hauptrisiken:**
- Fehlerhafte Statuslogik
- Unscharfe Kündigungs- oder Sperrprozesse
- Medienbrüche zwischen App und Backend
- Hohe Supportlast bei Deutschlandticket-Störungen

**Annahmen:**
- Deutschlandticket und Kernabos sind im Startumfang zwingend enthalten
- Komplexe Sonderprodukte können phasenweise folgen

---

### M05: Check-in / Check-out und nutzungsbasierte Produktlogik

**Ziel:** Unterstützung nutzungs- oder streckenbezogener Produkte mit Start-/Ende-Logik, Statusverfolgung und tariflogischer Verarbeitung

**Muss-Funktionen:**
- M05-F01 Check-in-Auslösung
- M05-F02 Check-out-Auslösung
- M05-F03 Statusanzeige laufender Nutzung
- M05-F04 Fehler- und Fallback-Logik
- M05-F05 Tariflogische Verarbeitung

**Soll-Funktionen:**
- M05-F06 Plausibilitätsprüfung und Nutzerhinweise

**SLA-Kritikalität:** Maximal kritisch

**Hauptrisiken:**
- Unbeendete Fahrten
- Fehlbepreisung
- Geringe Nutzertransparenz
- Hohe Kulanz- und Supportkosten

**Annahmen:**
- Check-in/Check-out ist nur dort Muss, wo heute bereits real genutzte Kernlogik vorhanden ist

---

### M06: Buchung von On-Demand-, Sharing- und ergänzenden Mobilitätsleistungen

**Ziel:** Auffindbarkeit, Auswahl, Buchungsanstoß, Statusrückmeldung und nutzerseitige Verwaltung angebundener Partnerleistungen

**Muss-Funktionen:**
- M06-F01 Angebotsanzeige je Partnerleistung
- M06-F02 Übergang in den Buchungsprozess
- M06-F03 Anzeige relevanter Nutzungsbedingungen
- M06-F04 Buchungsstatus und Rückmeldung
- M06-F05 Partnerbezogene Störungsbehandlung

**Soll-Funktionen:**
- M06-F06 Buchungsänderung oder Stornierungsanstoß
- M06-F07 Durchgehende Nutzerführung über mehrere Module

**SLA-Kritikalität:** Sehr hoch bis maximal kritisch

**Hauptrisiken:**
- Abhängigkeit von Partner-API-Qualität
- Inkonsistente Nutzungsbedingungen
- Unklare Verantwortungsgrenzen
- Schlechter Buchungsfluss bei Medienbrüchen

**Annahmen:**
- Nicht jede Partnerleistung muss zum Start voll transaktional integriert sein
- Für priorisierte Partner darf aber kein relevanter Nutzungsverlust eintreten

---

### M07: Mobilitätsgarantie und Fallback-Logik

**Ziel:** Zentrales Nutzenversprechen: Bei Störungen, Ausfällen oder Angebotslücken verlässliche alternative Mobilitätsoptionen anbieten oder auslösen

**Muss-Funktionen:**
- M07-F01 Erkennung garantierrelevanter Situationen
- M07-F02 Anzeige verfügbarer Alternativen
- M07-F03 Auslöse- und Entscheidungslogik
- M07-F04 Nachweis- und Dokumentationslogik
- M07-F05 Serviceeskalation

**Soll-Funktionen:**
- M07-F06 Teilautomatisierte Fallbearbeitung
- M07-F07 Nutzerkommunikation in Echtzeit

**Kann-Funktionen:**
- M07-F08 Proaktive Prävention

**SLA-Kritikalität:** Maximal kritisch

**Hauptrisiken:**
- Unklare Trigger
- Nicht verfügbare Ersatzangebote
- Hohe Kosten im Störungsfall
- Unklare Freigaben
- Reputationsschäden bei nicht eingelöster Garantie

**Annahmen:**
- Mobilitätsgarantie ist Kernproduktversprechen, nicht reine Information
- Existierende verlässliche Fallback-Versprechen dürfen nicht verschlechtert werden

---

### M08: Arbeitgebermobilität, Mobilitätsbudget und Benefits

**Ziel:** Verbindung mit arbeitgeberbasierten Mobilitätsangeboten; zentral für priorisierten Markteintritt

**Muss-Funktionen:**
- M08-F01 Arbeitgeberbezogene Produktfreischaltung
- M08-F02 Mobilitätsbudget-Anzeige
- M08-F03 Regelkonforme Budgetnutzung
- M08-F04 Benefit-Anzeige und Benefit-Verrechnung
- M08-F05 Trennung privater und arbeitgeberbezogener Nutzung

**Soll-Funktionen:**
- M08-F06 Arbeitgeberbezogene Kommunikation
- M08-F07 Kombination mit Jobticket- oder Zuschusslogiken

**Kann-Funktionen:**
- M08-F08 Erweiterte Benefit-Konfigurationen

**SLA-Kritikalität:** Sehr hoch

**Hauptrisiken:**
- Fehlerhafte Budgetverrechnung
- Unsaubere Kostentrennung
- Steuerlich/arbeitsrechtlich problematische Konfigurationen
- Hoher Abstimmungsaufwand mit Arbeitgebern

**Annahmen:**
- Arbeitgebermobilität ist priorisierter Markteintritt, nicht nachgelagertes Zusatzmodul
- Daher Kernbestandteil von Version 1.0

---

### M09: Kundenservice, Support und Self-Service

**Ziel:** Kundennahe Bearbeitung von Fragen, Problemen, Störungen, Nachweisen und Eskalationen

**Muss-Funktionen:**
- M09-F01 Kontakt- und Hilfebereich
- M09-F02 Fallbezogene Supportanfrage
- M09-F03 Einsicht in relevante Vorgänge
- M09-F04 Verknüpfung mit Buchungen und Produkten

**Soll-Funktionen:**
- M09-F05 Self-Service für Standardfälle
- M09-F06 Digitale Dokumentenübermittlung

**SLA-Kritikalität:** Sehr hoch

**Hauptrisiken:**
- Hohe manuelle Last
- Fehlende Fallzuordnung
- Schlechte Eskalation zu Partnern
- Friktionskosten bei Reklamationen

---

### M10: Zahlungen, Transaktionen und Belege

**Ziel:** Korrekte finanzielle Verarbeitung nutzerseitiger Zahlungen, Belastungen, Gutschriften und Nachweise

**Muss-Funktionen:**
- M10-F01 Auswahl zulässiger Zahlarten
- M10-F02 Sichere Transaktionsauslösung
- M10-F03 Beleg- und Rechnungslogik
- M10-F04 Fehler- und Korrekturbehandlung
- M10-F05 Trennlogik für privat, Arbeitgeber und Sonderfälle

**Soll-Funktionen:**
- M10-F06 Split-Logiken

**SLA-Kritikalität:** Maximal kritisch

**Hauptrisiken:**
- Zahlungsabbrüche
- Doppelte Belastungen
- Fehlerhafte Trennung zwischen privat und arbeitgeberfinanziert
- Unklare Beleglage

---

### M11: Tarifserver und Regelwerksmanagement

**Ziel:** Fachlich korrekte Abbildung von Tarifregeln, Produktregeln, Berechtigungen, Preislogik, Versionierung und Auditierbarkeit

**Muss-Funktionen:**
- M11-F01 Tarif- und Produktregelverwaltung
- M11-F02 Rechte- und Berechtigungslogik
- M11-F03 Versionierung und Gültigkeiten
- M11-F04 Ausnahme- und Sonderfalllogik
- M11-F05 Auditierbarkeit

**Soll-Funktionen:**
- M11-F06 Simulation und Testbarkeit

**SLA-Kritikalität:** Maximal kritisch

**Hauptrisiken:**
- Tariffehler
- Regelkonflikte
- Nicht nachvollziehbare Preisbildung
- Mangelnde Testbarkeit
- Hohe Folgekosten durch Kulanz und Support

**Annahmen:**
- emma übernimmt zwingend fachliche Regelwerksverantwortung
- Auch wenn technische Komponenten nicht vollständig selbst betrieben werden

---

### M12: Partnerintegration und Partnerhub-Funktionen

**Ziel:** Technische und organisatorische Anbindung externer Verkehrs- und Mobilitätspartner

**Muss-Funktionen:**
- M12-F01 Standardisierte Partneranbindung
- M12-F02 Partnerfähige Produkt- und Leistungsdarstellung
- M12-F03 SLA- und Qualitätsmonitoring pro Partner
- M12-F04 Störungs- und Eskalationslogik je Partner
- M12-F05 Partnerbezogene Vertrags- und Betriebsparameter

**Soll-Funktionen:**
- M12-F06 Self-Service-Onboarding für standardisierte Partnerfälle

**SLA-Kritikalität:** Sehr hoch bis maximal kritisch

**Hauptrisiken:**
- Heterogene APIs
- Unklare Datenverantwortung
- Langsames Onboarding
- Schwankende Servicequalität
- Fehlende Eskalationsfähigkeit

**Annahmen:**
- Pflichtpartner im Kernzielbild: MDV-Verkehrsunternehmen + priorisierte Sharing-, Carsharing-, On-Demand-, Taxi-Partner

---

### M13: Benachrichtigungen und Kommunikation

**Ziel:** Relevante transaktionsbezogene, vertragsbezogene und störungsbezogene Kommunikation an Nutzer

**Muss-Funktionen:**
- M13-F01 Transaktionsbezogene Bestätigungen
- M13-F02 Störungsbezogene Hinweise
- M13-F03 Fristen- und Statushinweise

**Soll-Funktionen:**
- M13-F04 Personalisierte Kommunikationslogik

**SLA-Kritikalität:** Hoch

**Annahmen:**
- Push-, In-App- und transaktionsbezogene Bestätigungskommunikation reichen für initialen Kernumfang
- Komplexe Kampagnenlogik ist nicht startkritisch

---

### M14: Daten, Reporting und Monitoring

**Ziel:** Fachlich und betrieblich erforderliche Datenbasis für Steuerung, Reporting, Qualitätssicherung, Partnersteuerung und Weiterentwicklung

**Muss-Funktionen:**
- M14-F01 Betriebsmonitoring
- M14-F02 Nutzungs- und Transaktionsdatenbereitstellung
- M14-F03 Störungs- und Fehlerdaten
- M14-F04 Regelkonforme Datenweitergabe
- M14-F05 KPI-Grundlogik

**Soll-Funktionen:**
- M14-F06 Wirkungslogik und Angebotsanalyse

**SLA-Kritikalität:** Sehr hoch

**Annahmen:**
- Mindestens Daten für Betrieb, Support, Garantiefälle und Arbeitgebermobilität verpflichtend ab erstem produktiven Release

---

### M15: Barrierefreiheit, Usability und Vertrauen

**Ziel:** Nutzerseitige Zugänglichkeit, Verständlichkeit und Vertrauenswürdigkeit

**Muss-Funktionen:**
- M15-F01 Barrierearme Nutzung zentraler Kernprozesse
- M15-F02 Klare Fehlerkommunikation
- M15-F03 Vertrauensstiftende Statusanzeigen

**SLA-Kritikalität:** Hoch

**1:1-Übernahmepflicht:**
- Kein Rückschritt bei Verständlichkeit, Statusklarheit und Bedienbarkeit der Kernprozesse

---

### M16: Migration, Parallelbetrieb und Cut-over

**Ziel:** Kontrollierte Überführung von Bestandswelten in die emma-App

**Muss-Funktionen:**
- M16-F01 Dokumentation des übernommenen Funktionsumfangs
- M16-F02 Mapping Alt zu Neu
- M16-F03 Parallelbetriebsfähigkeit
- M16-F04 Migrations- und Cut-over-Planung
- M16-F05 Stabilisierung nach Go-live

**SLA-Kritikalität:** Maximal kritisch

**Hauptrisiken:**
- Unvollständige Bestandsanalyse
- Zu früher Cut-over
- Fehlende Parallelbetriebsfähigkeit
- Datenverluste
- Funktionsbrüche bei Partnern

**Annahmen:**
- Migration erfolgt phasenweise
- Big-Bang-Ansatz für alle Partner gleichzeitig nicht die Startannahme

---

## 7. Minimal-Release für einen gründungsreifen Kernstart

Der minimal gründungsreife Kernstart umfasst folgende Module:

- **M01** Nutzerkonto und Identität
- **M02** Routing, Reiseauskunft und Angebotsdarstellung
- **M03** Ticketing und Produktkauf
- **M04** Abo und Deutschlandticket
- **M05** Check-in / Check-out (soweit erforderlich)
- **M06** Partnerbuchung für priorisierte Mobilitätsmodule
- **M07** Mobilitätsgarantie
- **M08** Arbeitgebermobilität und Mobilitätsbudget
- **M09** Kundenservice
- **M10** Zahlungen und Belege
- **M11** Tarifserver und Regelwerksmanagement
- **M12** Partnerintegration
- **M14** Daten, Reporting und Monitoring
- **M16** Migration, Parallelbetrieb und Cut-over

**Querschnittlich (in allen Kernfunktionen verankert):**
- **M13** Benachrichtigungen und Kommunikation
- **M15** Barrierefreiheit, Usability und Vertrauen

---

## 8. Modulübergreifende Risiken

### Top 5 Funktionale Risiken:
1. **Funktionale Verschlechterung** gegenüber Bestandswelten
2. **Mangelnde Tarif- und Regelwerksstabilität**
3. **Nicht belastbare Partner- und Integrationsqualität**
4. **Unzureichende Migrationssteuerung**
5. **Zu schwache operative Mobilitätsgarantie** im Störungsfall

### Strukturelle Risiken:
1. Unklare Make-or-Buy-Entscheidungen
2. Unzureichende Abgrenzung fachlicher und technischer Betriebsverantwortung
3. Zu breiter Release-Umfang ohne priorisierte Partner- und Produktreihenfolge

---

## 9. Modulübergreifende offene Entscheidungen

1. Welche Bestandssysteme in Phase 1 nur integriert und welche perspektivisch ersetzt?
2. Welcher technische Anteil selbst aufgebaut und welcher eingekauft/white-label/modular?
3. Welche Partner in Phase 1 zwingend live integriert, wo sind Übergangslogiken zulässig?
4. Wie weit Mobilitätsgarantie automatisiert ausgelöst und welche Servicefreigaben nötig?
5. Welche Arbeitgeberfunktionen bereits im ersten Release produktiv?
6. Welches SLA-Niveau für kritische Kernmodule und Partnerverfügbarkeiten verbindlich?

---

## 10. Dokumentweite Annahmen

1. Emma perspektivisch als gemeinsamer Kundenzugang, nicht nur als Zusatz-App
2. 1:1-Übernahmepflicht für bestehende reale Kernfunktionen bleibt verbindlich
3. Arbeitgebermobilität ist priorisierter Markteintritt und Kernmodul von v1.0
4. Mobilitätsgarantie ist zentrales Produktversprechen, nicht optionaler Marketingbaustein
5. Zielarchitektur modular aufgebaut: eigene + eingekaufte + vermittelte Leistungen
6. Erster Release nicht als Finalarchitektur, sondern als gründungsreifer Kernstart mit geordnetem Migrationspfad

---

## 11. Qualitätssicherung vor Freigabe

Vor jeder Freigabe ist zu prüfen:

- [ ] Jede Muss-Funktion einer Bestandswelt ist einer fachlichen und technischen Betriebsverantwortung zugeordnet
- [ ] Jede Muss-Funktion hat eine definierte Datenlogik
- [ ] Jede Muss-Funktion hat eine Partnerlogik (falls relevant)
- [ ] Jede Muss-Funktion hat eine Migrationslogik
- [ ] Jede maximal kritische Funktion besitzt ein Incident-, Fallback- und Supportmodell
- [ ] Die 1:1-Übernahmepflicht ist konkret auf reale Bestandsfunktionen heruntergebrochen
- [ ] Offene Entscheidungen sind explizit einer Entscheidungsinstanz zugeordnet
