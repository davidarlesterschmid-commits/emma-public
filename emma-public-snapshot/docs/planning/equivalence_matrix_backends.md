# Backend-Gleichwertigkeitsmatrix — emma App v1.0

**Status:** Arbeitsfassung / EMM-107  
**Stand:** 2026-04-28  
**Linear:** [EMM-107](https://example.invalid/emma-app-mdma/issue/EMM-107/r1-backend-gleichwertigkeitsmatrix-erstellen)  
**Projekt:** [emma App v1.0 – Gleichwertigkeit, Regelwerk und BMM](https://example.invalid/emma-app-mdma/project/emma-app-v10-gleichwertigkeit-regelwerk-und-bmm-a60e566c5727/overview)  
**Risikoklasse:** R1 Doku-/Nachweismatrix; R2, sobald technische Adapter-Architektur abgeleitet oder Code geaendert wird.

---

## 1. Zweck

Diese Matrix ergaenzt die App-Gleichwertigkeitsmatrix um backend- und systemnahe Bestandswelten. Sie dokumentiert, welche genutzten Hintergrundsystem-Funktionen fuer emma v1.0 mindestens gleichwertig uebernommen, angebunden oder abgeloest werden muessen.

Die Datei ist ein Nachweis- und Steuerungsartefakt. Sie implementiert keine Adapter und trifft keine produktive Ablöseentscheidung.

---

## 2. Grundregeln

1. Keine produktive Gleichwertigkeit ohne echten Adapter-, Test- oder Dokumentationsnachweis.
2. Ports, Mocks und Fakes begruenden hoechstens den Status `vorbereitet`.
3. Fehlt Modell, Adapter oder Nachweis, gilt der Status `luecke`.
4. Bei unklarer fachlicher Reichweite gilt `Entscheidung offen`.
5. Eine Bestandsfunktion darf erst dann als abgeloest gelten, wenn der tatsaechlich genutzte Funktionsumfang 1:1 oder besser nachgewiesen ist.

---

## 3. Status-Legende

| Status | Bedeutung |
|---|---|
| `abgedeckt` | emma-Modul, Adapter/Test oder belastbarer Doku-Nachweis vorhanden. |
| `vorbereitet` | Domain/Port/Fake/Mock oder Spezifikation vorhanden, aber kein produktiver Adapter/Nachweis. |
| `luecke` | Kein ausreichendes Modell, kein Adapter oder kein Test-/Dokunachweis. |
| `Entscheidung offen` | Fachliche oder technische Zielentscheidung fehlt. |

---

## 4. Backend-Bestandswelten

| Bestandswelt | Typische Rolle im Zielbild |
|---|---|
| Patris-nahe Vertriebswelten | Ticketing, Abo, Vertragsstatus, Produkt-/Kundenzuordnung, Belege. |
| Hacon-nahe Auskunfts-/Routing-Systeme | Routing, Echtzeit, Verbindungen, Umstiege, Stoerungen. |
| Tarifserver / Verbundregelwerke | Preis, Produktregeln, Berechtigungen, Gueltigkeiten, Ausnahmen. |
| Abo-/Vertriebsbackend | D-Ticket, Monatsabo, Vertragsstatus, Sperre, Wiederfreigabe. |
| Payment / PSP | Zahlung, Transaktion, Rueckabwicklung, Zahlungsstatus. |
| CRM / Support / Ticketsystem | Servicefaelle, Beschwerden, Eskalation, Nachbearbeitung. |
| Reporting / BI / Monitoring | Nutzung, Betrieb, KPI, Partnerqualitaet, Garantiefaelle. |
| Clearing / Abrechnung | Partnerabrechnung, Zuordnung, Gutschriften, Split-Logik. |
| Arbeitgeberportal / Budget-Engine | Arbeitgeberfreischaltung, Budget, Benefit, Kostenstellen, Reporting. |
| Partner-APIs | Sharing, Carsharing, On-Demand, Taxi, Verfuegbarkeit, Buchungsstatus. |

---

## 5. Matrix nach backendkritischen Funktionen

| Backend-Funktion | Bestandswelt | emma-Zielmodul | Ziel-Domain / Paket | Adapterbedarf | 1:1-Uebernahmepflicht | Nachweis / Test | Status | Risiko / Folgeissue |
|---|---|---|---|---|---|---|---|---|
| Produktkatalog fuer Einzelfahrschein | Patris / Vertriebsbackend / Tarifserver | M03 Ticketing, M11 Regelwerk | `domain_rules`, `domain_ticketing` | Tarif-/Produktadapter spaeter | Produktanzeige, Produktregeln, Gueltigkeit | noch offen | `luecke` | EMM-108 |
| Produktvarianten Tageskarte / Gruppenprodukt | Patris / Tarifserver | M03, M11 | `domain_rules` | Tarif-/Produktadapter spaeter | Produktvarianten duerfen nicht entfallen | noch offen | `luecke` | EMM-108 |
| Deutschlandticket-Vertragsstatus | Abo-/Vertriebsbackend | M04 Abo/D-Ticket | `domain_subscription` geplant | Abo-/Subscription-Adapter spaeter | Aktiv, abgelaufen, gesperrt, unbekannt | noch offen | `luecke` | EMM-109 |
| Abo-Vertragsverwaltung Statusanzeige | Abo-/Vertriebsbackend | M04 | `domain_subscription` geplant | Abo-/Subscription-Adapter spaeter | Status, Gueltigkeit, Sperr-/Freigabelogik | noch offen | `luecke` | EMM-109 |
| Abo-Aenderung / Kuendigung | Abo-/Vertriebsbackend | M04 | spaeter `domain_subscription` | Adapter + Prozessentscheidung | Bestandsfunktion nur wenn real genutzt im Startscope | fachlich offen | `Entscheidung offen` | EMM-109 / Folgeissue |
| Ticketkauf / Transaktionsausloesung | Vertriebsbackend / Payment / Ticketing | M03, M10 | `domain_ticketing`, `domain_wallet` | Ticketing-/Payment-Adapter spaeter | Kauf, Fehlerbehandlung, Bereitstellung | Fake/Stub nur MVP | `vorbereitet` | EMM-105, spaeter Ticketing-Issue |
| Ticket-Credential / QR-/Barcode | Ticketing-/Kontrollsystem | M03, M10 | `domain_wallet`, `domain_ticketing` | Kontrollstandard spaeter | Anzeige pruefbarer Berechtigung | noch offen | `luecke` | EMM-105 |
| Beleg / Rechnung | Vertriebsbackend / Rechnungsdienst | M10 | `domain_wallet` / invoices | InvoiceListPort vorbereitet | Historie und Beleglogik | Port/Fake teilweise | `vorbereitet` | Folgeissue Belegwesen |
| Zahlung autorisieren | PSP / Payment | M10 | `domain_wallet`, PaymentsPort geplant | PSP-Adapter spaeter | Sichere Transaktion, Status, Fehler | Simulation/Fake | `vorbereitet` | spaeter PaymentsPort |
| Zahlung rueckabwickeln / Erstattung | PSP / CRM / Backoffice | M09, M10 | `domain_wallet`, Service | PSP-/CRM-Adapter spaeter | Korrektur- und Fehlerbehandlung | offen | `luecke` | Folgeissue Refunds |
| Routing-Verbindung berechnen | Hacon / Routing-Engine | M02 | `domain_journey` | RoutingAdapter / Open-Data-first | Start-Ziel, Umstieg, Dauer | Fake/Open-Data geplant | `vorbereitet` | EMM-99, EMM-101 |
| Echtzeitdaten / Abfahrten | Echtzeitfeed / Hacon-nahe Systeme | M02, M07 | `domain_journey`, realtime geplant | RealtimeAdapter spaeter | Echtzeit-/Soll-Daten, Stoerung | Fake/Fixture | `vorbereitet` | EMM-101 / Folgeissue Realtime |
| Stoerungsfeed | Echtzeit / Leitstellen / Partnerfeeds | M02, M07, M13 | realtime/guarantee/notification geplant | Feed-Adapter spaeter | Stoerung, Alternativen, Hinweise | offen | `luecke` | EMM-111 / M07-Folgeissue |
| Tarifberechnung fuer Route | Tarifserver / Verbundregelwerk | M11, M02 | `domain_rules` | Tarifadapter spaeter | Preis pro Route | fake_tariff | `vorbereitet` | EMM-108, EMM-99 |
| Berechtigungspruefung | IAM / Abo / Tarifserver | M01, M04, M11 | `domain_identity`, `domain_subscription`, `domain_rules` | Auth-/Entitlement-Adapter spaeter | Rechte, Ermaessigungen, Arbeitgeberkontext | teilweise vorbereitet | `vorbereitet` | EMM-109, EMM-110 |
| Check-in / Check-out aktiver Fahrtzustand | CiCo-/ABT-System | M05 | Domain fehlt | Port/Adapter offen | Start, Stop, laufender Status | kein Nachweis | `luecke` | Entscheidung / Folgeissue |
| Check-in / Check-out Preisnachlauf | CiCo-/Tarifserver | M05, M11 | Domain fehlt, `domain_rules` Teilbasis | Adapter offen | Preis, Plausibilitaet, Korrektur | kein Nachweis | `luecke` | Entscheidung / Folgeissue |
| Arbeitgeberbudget-Saldo | Arbeitgeberportal / Budget-Engine | M08, M10 | `domain_employer_mobility`, `domain_wallet` | BudgetAdapter spaeter | Saldo, Zeitraum, Restbetrag | Fake geplant/teilweise | `vorbereitet` | EMM-110 / BMM-Folgeissue |
| Arbeitgeberbudget-Verrechnung | Budget-Engine / Payment / Clearing | M08, M10 | `domain_wallet`, employer mobility | Adapter spaeter | private/AG-Trennung, Split | offen | `luecke` | EMM-110 / Folgeissue |
| Kostenstellenzuordnung | Arbeitgeberportal / Payroll | M08, M10 | fehlt | Adapter/Modell offen | Kostenstelle, Zuordnung, Reporting | kein Nachweis | `luecke` | Folgeissue BMM Cost Centers |
| Partnerverfuegbarkeit nextbike | Partner-API / GBFS | M06, M12 | partner/routing geplant | GBFS/PartnerAdapter spaeter | Verfuegbarkeit, Standort, Status | Fake/Fixture moeglich | `vorbereitet` | EMM-99, EMM-101 |
| Partnerverfuegbarkeit Carsharing | Partner-API | M06, M12 | partner/routing geplant | PartnerAdapter spaeter | Verfuegbarkeit, Standort, Status | offen | `luecke` | EMM-101 / Partner-Folgeissue |
| On-Demand-Verfuegbarkeit / Shuttle | Partner-API / On-Demand-System | M06, M07, M12 | partner/routing geplant | PartnerAdapter spaeter | Anfrage, Status, Bedingungen | Stub/Fake | `vorbereitet` | EMM-99, EMM-101 |
| Taxi-Verfuegbarkeit / Garantieersatz | Taxi-/Dispatch-System | M06, M07 | guarantee/partner geplant | TaxiAdapter spaeter | Ersatzleistung, Status, Kostenrahmen | Stub/Fake | `vorbereitet` | EMM-99, M07-Folgeissue |
| CRM-Fallanlage | CRM / Ticketsystem | M09 | customer service geplant/leer | CRMAdapter spaeter | Fall, Kategorie, Zuordnung | teilweise Alt-/Fake-Logik | `vorbereitet` | Folgeissue CRM |
| CRM-Fallstatus / Nachbearbeitung | CRM / Ticketsystem | M09 | customer service geplant/leer | CRMAdapter spaeter | Status, Eskalation, Partneruebergabe | offen | `luecke` | Folgeissue CRM |
| Notification Trigger Buchung | Notification-Service / App | M13, M03 | NotificationPort geplant | MessagingAdapter spaeter | Bestaetigung, Statushinweis | offen | `luecke` | EMM-111 |
| Notification Trigger Stoerung | Realtime / Notification-Service | M13, M07 | NotificationPort geplant | MessagingAdapter spaeter | Stoerung, Alternative, Eskalation | offen | `luecke` | EMM-111 |
| Reporting Nutzung / Transaktionen | BI / Reporting | M14 | `domain_reporting` leer | ReportingAdapter spaeter | KPI, Nutzung, Transaktion | offen | `luecke` | Folgeissue Reporting |
| Reporting Garantiefaelle | BI / CRM / Guarantee | M07, M14 | reporting/guarantee geplant | ReportingAdapter spaeter | Garantiefall, Kosten, Qualitaet | offen | `luecke` | M07/M14-Folgeissue |
| Clearing Partnerabrechnung | Clearing / Finance | M10, M12, M14 | fehlt | ClearingAdapter spaeter | Partnerabrechnung, Gutschrift, Split | offen | `luecke` | Folgeissue Clearing |
| Partner-SLA Monitoring | Monitoring / Partnerhub | M12, M14 | `domain_partnerhub` leer, reporting | MonitoringAdapter spaeter | API/SLA/Qualitaet je Partner | offen | `luecke` | EMM-112 / Folgeissue Partnerhub |

---

## 6. Kritische Luecken nach Prioritaet

| Rang | Luecke | Begruendung | Folgeissue |
|---|---|---|---|
| 1 | Produktkatalog / Regelwerksversionierung | Ohne Produkt-/Regelmodell keine belastbare Ticket-, Routing-Preis- oder Subscription-Logik. | EMM-108 |
| 2 | Abo-/Deutschlandticket-Vertragsmodell | D-Ticket/Abo darf nicht nur Shortcut oder Label bleiben. | EMM-109 |
| 3 | Ticket-Credential / QR-/Barcode | Gekaufte oder vorhandene Tickets muessen pruefbar darstellbar sein. | EMM-105 |
| 4 | Check-in / Check-out | Bestandsfunktion potenziell 1:1-kritisch; Scope-Entscheidung fehlt. | neues Folgeissue nach Entscheidung |
| 5 | Notification-Port / Kommunikationskanaele | Stoerung, Buchung und Fristen brauchen Mindestkommunikation. | EMM-111 |
| 6 | Arbeitgeberbudget-Verrechnung / Kostenstellen | BMM braucht saubere Privat-/AG-Trennung und Zuordnung. | EMM-110 / Folgeissue |
| 7 | Reporting / Clearing / Partner-SLA | Betriebs- und Partnersteuerung ohne Nachweislogik unvollstaendig. | Folgeissues M12/M14 |

---

## 7. Offene Entscheidungen

| Entscheidung | Bedeutung | Zugehoerige Issues |
|---|---|---|
| D-Ticket/Abo: Pass-through vs. eigener emma-Vertrag | Bestimmt Adaptertiefe und Vertragsmodell. | EMM-109 |
| CiCo Pflicht in Phase 1? | Entscheidet, ob Domain/Port sofort noetig ist. | Folgeissue erforderlich |
| Push vs. In-App vs. E-Mail | Bestimmt minimale Notification-Architektur. | EMM-111 |
| Produktiver Tarifserver vs. Mock/Fake im MVP | Bestimmt R2/R3-Gate fuer `domain_rules`. | EMM-108 |
| Partnerbuchung: Deeplink vs. In-App | Bestimmt Adaptertiefe fuer Sharing/Taxi/On-Demand. | EMM-99 / Folgeissues |
| Reporting-/Clearing-Mindestumfang | Bestimmt M14/M10-Ausbau. | Folgeissue Reporting/Clearing |

---

## 8. Ableitung fuer Execution

Die Matrix bestaetigt die bestehende Linear-Reihenfolge:

1. **EMM-107** Backend-Gleichwertigkeitsmatrix — diese Datei.
2. **EMM-108** Regelwerksversionierung und Produktkatalog.
3. **EMM-109** Subscription / D-Ticket / Vertragsstatus.
4. **EMM-99** Routing-Selektion mit Preis-/Produktgrundlage.
5. **EMM-101** Routing-Tests / Gleichwertigkeitsnachweis.
6. **EMM-100** Nutzerpraeferenzen / Lernlogik.
7. **EMM-110** Multi-Profil / Arbeitgebermodus.
8. **EMM-111** Notifications.
9. **EMM-105** Ticket-Wallet Credential.

---

## 9. Definition of Done fuer EMM-107

- Backend-Bestandswelten sind benannt.
- Backendkritische Funktionen sind tabellarisch gemappt.
- Adapterbedarf ist erkennbar.
- 1:1-Uebernahmepflicht ist je Funktion beschrieben.
- Status ist nach Legende markiert.
- Kritische Luecken und Folgeissues sind ausgewiesen.
- Keine produktive Gleichwertigkeit wird ohne Nachweis behauptet.

---

## 10. Nicht-Scope

- Keine Adapter-Implementierung.
- Keine produktive API-Anbindung.
- Keine Tarif-/Payment-/Ticketing-Liveintegration.
- Keine Ablöseentscheidung fuer Bestandssysteme.
- Keine Rechts- oder Vergabeentscheidung.
