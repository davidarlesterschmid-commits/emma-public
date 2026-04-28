# Traceability-Pruefung: Domain-Pakete und Module M01–M14

Stand: 2026-04-26 (Repo-Snapshot)  
**Linear:** [EMM-36](https://example.invalid/emma-app-mdma/issue/EMM-36/m04-repo-nachweis-prufen) — Repo-Nachweis (Parent: [EMM-13](https://example.invalid/emma-app-mdma/issue/EMM-13/m04-mobilitatsentscheidungs-und-planungs-engine) / Modul-Parent & Gap-Analyse).  
Methode: Abgleich `packages/domains/*` mit [docs/architecture/MAPPING.md](../architecture/MAPPING.md), [docs/architecture/module_traceability.md](../architecture/module_traceability.md); Testdateien per `packages/domains/**/test/**/*.dart`. M07-Kanon gemaess ADR-08/EMM-221.

---

## 0. Repo-Nachweis B01–B14 (EMM-36)

Durchstich: Alle in [module_traceability.md](../architecture/module_traceability.md) in Spalte **Package/Pfad** genannten **Haupt-Pfade** (Domain-Pakete, `emma_contracts`, `fakes/*`, `fake_maps`) sind im Repo **2026-04-26** als Verzeichnisse vorhanden — **kein** fehlendes Ziel-Package aus der Matrix.  
*Hinweis:* B01 nennt zusaetzlich **App-Home-Verweise**; fachlich aus [MAPPING.md](../architecture/MAPPING.md) / App-Shell, nicht Bestandteil dieses Verzeichnis-Checks.

| Statuslogik (Eltern-EMM-13) | Einordnung dieses Berichts |
| --- | --- |
| abgedeckt | Modulzeilen + Repo-Pfade in `module_traceability` nachweisbar; produktive End-to-End-Abdeckung ist **kein** Gegenstand von EMM-36. |
| vorbereitet | Ports/Fakes/Domains vorhanden; viele Backend-Gleichwertigkeiten weiter `vorbereitet` / `luecke` s. [equivalence_matrix_backends.md](../planning/equivalence_matrix_backends.md). |
| Lücke | u. a. `domain_identity` ohne Paket-`test/`; M04/M05/M13 sowie M07-Legacy-Pfad `domain_guarantee` migration_required_then_remove (s. u.). |
| Entscheidung offen | z. B. M04-Subscription-Paket; M07 ist durch ADR-08/EMM-221 auf `domain_mobility_guarantee` kanonisiert. |

---

## 1. Modul (M01–M14) → Domain-Paket(e)

Hauptzuordnung nach `MAPPING.md` §7 (Domain-Paket-Spalte); Querschnitts- und Quellen-Pakete in Klammern.

| Modul | Kurz | Domain-Paket(e) im Repo | Hinweis |
| --- | --- | --- | --- |
| M01 | Identitaet/Konto | `domain_identity` | MAPPING erwaehnt zusaetzlich optionales `domain_customer_account` — **kein** solches Paket. |
| M02 | Routing/Reise | `domain_journey` | + engine-artig: `domain_planning`, `domain_realtime` (B04/B08; kein 1:1-Modul) |
| M03 | Ticketing | `domain_ticketing` | |
| M04 | Abo/D-Ticket | — | MAPPING: `domain_subscription` **geplant** — **fehlt** als Paket. |
| M05 | CiCo | — | bewusst kein Paket (Post-MVP laut MAPPING). |
| M06 | Partnerbuchung (Teil) | `domain_partnerhub` | MAPPING: Paket i. d. R. leer/Stub-Charakter. |
| M07 | Mobilitaetsgarantie | `domain_mobility_guarantee` kanonisch; `domain_guarantee` migration_required_then_remove | ADR-08/EMM-221: Neue M07-Arbeit referenziert nur `domain_mobility_guarantee`. |
| M08 | Arbeitgeber | `domain_employer_mobility` | |
| M09 | Kundenservice | `domain_customer_service` | MAPPING: leer/Post-MVP-Charakter. |
| M10 | Zahlungen/Wallet | `domain_wallet` | |
| M11 | Tarif/Regelwerk | `domain_rules` | |
| M12 | Partnerintegration | `domain_partnerhub` | mit M06 geteilt. |
| M13 | Benachrichtigungen | — | MAPPING: kein Domain-Paket; technisch Ueberlappung mit `domain_realtime` (Feed/Alert, nicht 1:1 M13). |
| M14 | Reporting | `domain_reporting` | MAPPING: eher leer/Post-MVP-Charakter. |

**Zusaetzliche Domain-Pakete (nicht 1:1 M01–M14-Zeile):**

| Paket | Rolle (Kurz) | Modul-Bezug / Traceability |
| --- | --- | --- |
| `domain_context` | Kontext/Bedarf | B03; in `module_traceability.md` **kein** M0x-Mapping. |
| `domain_learning` | Lern/Optimierung | B13; kein M0x in Matrix. |
| `domain_planning` | Planungsengine | B04, nahe M02. |
| `domain_realtime` | Echtzeit/Feed | B08, nahe M02/M07/M13. |

---

## 2. Lueckenliste

### 2.1 Fehlende oder unklare **Module** (Paket- vs. Soll-Architektur)

| Luecke | Befund |
| --- | --- |
| **M04** | Kein `domain_subscription` (laut MAPPING geplant) — Abo/DTicket-Pfad nur als Planreferenz, kein Paket-Trace. |
| **M05, M13** | Kein Domain-Paket laut MAPPING — erwartet fuer Traceability-Review: Issue/ADR explizit „kein Paket im MVP". |
| **M07 Benennung** | ADR-08/EMM-221 setzt `domain_mobility_guarantee` als Kanon; `domain_guarantee` ist Legacy mit `migration_required_then_remove`. |
| **M01 Konto** | `domain_customer_account` in MAPPING optional genannt — **fehlt**; Identitaet laeuft ueber `domain_identity`. |
| **Ohne M01–M16-Zeile** | `domain_context`, `domain_learning` in `module_traceability.md` ohne M-Mapping — **Querverweis-Traceability lueckig**. |

### 2.2 Fehlende **Tests** (kein `test/` im Domain-Paket)

| Paket | Befund |
| --- | --- |
| `domain_identity` | **Kein** `test/`-Unterverzeichnis, keine `test/*.dart` (Stand 2026-04-26). |

Alle anderen Domain-Pakete unter `packages/domains/` weisen mindestens eine `test/*.dart` auf (siehe Abschnitt 3), inkl. `domain_employer_mobility` (`bmm_profile_context_test.dart`).

### 2.3 Fehlende / inkonsistente **Referenzen** (Doku vs. Repo)

- **MAPPING** §4/§7: `domain_mobility_guarantee` ist gemaess ADR-08/EMM-221 kanonisch; `domain_guarantee` bleibt nur als Legacy mit `migration_required_then_remove` referenziert.
- **MAPPING** `domain_subscription` / `domain_customer_account` — im Repo **nicht** als Pakete vorhanden; Traceability muss in Issues PRs klarstellen, ob bewusst verschoben oder Ersatz (z. B. M03-Mitfuehrung M04).
- **module_traceability (B01–B14)** — deckt 14 Kandidaten ab; B03/B13 **ohne** M-Mapping: Governance-Risiko bei Modulabnahme reiner Backlog-Referenz.

---

## 3. Test-Ueberblick (Domain-Pakete mit Tests)

Vorhandene Testdateien (Auszug): `domain_journey` (5), `domain_ticketing` (3), `domain_customer_service` (2), `domain_reporting` (2), `domain_employer_mobility` (1), `domain_rules`, `domain_wallet`, `domain_planning`, `domain_partnerhub`, `domain_learning`, Legacy `domain_guarantee` migration_required_then_remove, `domain_realtime`, `domain_context` (je mindestens 1 Datei). **14** Domain-Pakete gesamt: **13** mit lokalem `test/`, **1** ohne — `domain_identity` (s. 2.2).

---

## 4. Risiken (Kurz, Governance-Sicht)

| Risiko | Einordnung |
| --- | --- |
| M01 ohne Unit-Package-Tests | Regressions- und Aenderbarkeitsrisiko; fuer R2+ relevant bis Tests nachgezogen (`domain_employer_mobility` hat mind. einen Paket-Test). |
| M04 ohne Paket/Trace | Features mit Abo-Bezug laufen Gefahr, implizit in M03/Wallet zu koppeln — Modulgrenze unklar. |
| M07 Legacy-Pfad | `domain_guarantee` ist migration_required_then_remove; neue M07-Arbeit muss ADR-08/EMM-221-konform `domain_mobility_guarantee` nutzen. |
| B-only-Pakete (`domain_context`, `domain_learning`) | Abnahme gegen **M01–M14** allein erschwert; Backlog-IDs und Specs im Issue zwingen. |
| M13 vs. `domain_realtime` | Fachliches M13 (Benachrichtigungen) vs. technisches Echtzeit-Paket **nicht** 1:1 abgebildet — Missverstaendnisse in Traceability-Reviews. |

---

## 5. Blocker

Keine (reine Bestandsanalyse, keine verbindliche Massnahme).  
**Empfehlung naechster Schritt (optional):** ADR-08/EMM-221-Kanon fuer M07 halten und `domain_guarantee` migration_required_then_remove technisch bereinigen; M04/M01-Konto-Entscheidung in Product Truth/ADR festhalten. **Folge-Sub-Issues (EMM-13):** Testabdeckung (mind. `domain_identity`), Doku-/Traceability, Gaps in Umsetzungstickets.

---

*Aktualisiert im Rahmen EMM-36 Repo-Nachweis. Keine Laufzeit- oder Refactoring-Aenderung in diesem Schritt.*
