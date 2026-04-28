# ADR-08 — M07 Domain-Kanonisierung: `domain_mobility_guarantee`

## 1. Titel

ADR-08 — M07 Mobilitätsgarantie: Konsolidierung auf eine kanonische Domain (`domain_mobility_guarantee`).

## 2. Status

`accepted`
Datum: 2026-04-27
Gates: EMM-218 (R3, `PASS_MIT_AUFLAGEN`), Vorentscheidung EMM-219 (R2, `PASS`)
Umsetzungs-Issue (Doku + später Code): EMM-221
Bezug: ADR-03 (Fake-First), ADR-04 (MVP-Domänen-Scope, M07 als vertikale MVP-Domäne), `docs/technical/SPECS_MVP.md` (M07 Trigger-Matrix), CLAUDE.md (Ports in `package:emma_contracts`).

## 3. Kontext

Im Repo existieren zwei konkurrierende M07-Domain-Pakete:

* `packages/domains/domain_guarantee` — eigene Modelle (`FallbackOffer`, `GuaranteeDecision`, `GuaranteeEligibility`), eigener `GuaranteePort` (außerhalb `emma_contracts`), `MobilityGuaranteeTriggerEngine` mit Trigger-Logik T-01..T-06 als Stream-API über die generischen `RealtimeEventKind`-Werte (`tripCancelled`, `delayUpdated`, `lineOutOfService`, `missedConnection`).
* `packages/domains/domain_mobility_guarantee` — nutzt ausschließlich `emma_contracts`-Ports und -Modelle, liefert M07-Trigger-IDs T-01..T-08, `GuaranteeTriggerEngine` (`evaluate(event, context)`, Engine-Version `M07-Engine/1.0.0+emm91`), `m07GuaranteeRuleCatalog` mit Compensation-Beträgen und Aktionen (Taxi, On-Demand) und arbeitet auf den M07-spezifischen `RealtimeEventKind`-Werten (`trainCancelled`, `delay`, `lastConnectionOfDayFailed`, `missedConnectionDueToDelay`, `userSelfReport`).

Belegte Drift:

* CLAUDE.md-Verstoß durch `domain_guarantee`: Port-Definition außerhalb `emma_contracts`.
* Doku-Drift: `MAPPING.md` §4/§7/§Recovery und `SPECS_MVP.md` (M07) referenzieren `domain_mobility_guarantee` (teils „geplant"), `module_traceability.md` Z.22 und `traceability_domain_module_report.md` Z.18/19/35/63/77/85/95/104 referenzieren `domain_guarantee`.
* `RealtimeEventKind` ist Union-Enum mit zwei Welten (generic + M07), beide Engines schalten über sich gegenseitig ausschließende Cases.
* `GuaranteeClaimStatus` enthält Legacy-Werte (`open`, `inReview`, `approved`, `rejected`) und M07-Werte (`draft`, `pending`).
* Externe Konsumenten von `domain_guarantee` außerhalb des Pakets: keine. Externe Konsumenten von `domain_mobility_guarantee`: `packages/fakes/fake_guarantee/lib/src/fake_m07_in_memory.dart`.
* `packages/fakes/fake_guarantee/pubspec.yaml` listet beide Domains als Dependency, importiert im Code aber nur `domain_mobility_guarantee` — `domain_guarantee` ist toter Dependency-Ballast.

Folgen ohne Entscheidung: parallele Architektur, falsche Modul-Mapping-Zuordnung, brüchige Traceability, Onboarding-Fehler durch widersprüchliche Doku, doppelte Tests mit unterschiedlichen Engine-Verträgen.

## 4. Entscheidung

1. **Kanonische M07-Domain ist `domain_mobility_guarantee`.** Sie ist alleiniger Träger der M07-Trigger-Matrix T-01..T-08, des Regelkatalogs und der Engine.
2. **`domain_guarantee` ist Legacy.** Klassifikation: `migration_required_then_remove`. Es ist keine zweite Domain, kein Alias, kein Teilbereich — es ist Altstand.
3. **Hoheit der Ports:** Alle M07-Ports (`MobilityGuaranteePort`, `RealtimePort`, `NotificationPort`) und alle M07-Modelle (`RealtimeEvent`, `RealtimeEventKind`, `GuaranteeClaim`, `GuaranteeClaimRequest`, `GuaranteeClaimStatus`) bleiben ausschließlich in `package:emma_contracts`. Domain-eigene Ports in M07-Paketen sind nicht zulässig.
4. **Eligibility-Konzept** (`GuaranteeEligibility`/`GuaranteeDecision`) wird durch die M07-Engine nicht 1:1 ersetzt. Falls fachlich nötig, entsteht es als **neuer Port in `emma_contracts`**, nicht als eigene Domain.
5. **Naming-Lock ab Inkrafttreten dieses ADR:** keine neuen Importer auf `package:domain_guarantee`, kein neuer Code in `packages/domains/domain_guarantee/**`, keine Erweiterung der dort liegenden Modelle, Engines oder Tests.
6. **Migrations-Reihenfolge** (verbindlich, in EMM-221 abgebildet):
   1. R0/R1: dieses ADR als Kanon-Verweis aufnehmen.
   2. R0/R1: Doku-Pass — `MAPPING.md`, `module_traceability.md`, `traceability_domain_module_report.md`, `SPECS_MVP.md` auf `domain_mobility_guarantee` ausrichten.
   3. R2/R3: Code-Cleanup — `packages/domains/domain_guarantee/**` entfernen, Dependency in `packages/fakes/fake_guarantee/pubspec.yaml` streichen, ggf. Workspace-Member-Eintrag entfernen.
   4. Separat (eigenes R3-Issue, nicht Teil dieses ADR): Cleanup von `RealtimeEventKind` und `GuaranteeClaimStatus` in `emma_contracts`.

## 5. Konsequenzen

* **Single Source of Truth M07:** `domain_mobility_guarantee` + `emma_contracts`.
* **Keine neuen Imports auf `domain_guarantee`** ab Inkrafttreten dieses ADR. Review-Hinweis verbindlich, in PR-Hygiene aufzunehmen (`docs/operations/pr_hygiene.md`).
* **Alle neuen M07-Features** (Engine-Erweiterungen, Trigger, Regeln, Adapter) werden in `domain_mobility_guarantee` umgesetzt. Trigger-Erweiterungen (z. B. Post-MVP T-07) gehen ausschließlich über den Regelkatalog dieser Domain.
* **Migration erfolgt in separatem R2/R3-PR** (EMM-221). Doku-PR zwingend vor Code-PR, sonst entstehen brüchige Cross-Refs während des Mergens.
* **Traceability** wird auf den neuen Pfad ausgerichtet: jede neue M07-Arbeit referenziert `M07` + Funktionskatalog-ID + `domain_mobility_guarantee`.
* **`fake_guarantee` (Paketname)** bleibt unverändert (Verzeichnis-/Paketname ist nicht Teil der Domain-Kanonisierung). Inhaltlich nutzt es ausschließlich `domain_mobility_guarantee` und behält `FakeMobilityGuaranteeAdapter` als generischen Submission-Pfad, bis dessen Status auf den M07-Workflow angeglichen oder als Fallback abgegrenzt wird (Subtask EMM-221).
* **Tests:** Engine-Tests laufen ausschließlich gegen `GuaranteeTriggerEngine` aus `domain_mobility_guarantee`. `domain_guarantee/test/guarantee_models_test.dart` entfällt im Code-Cleanup ersatzlos.
* **DoD-Anwendung (ADR-04, M07 vertikal):** bezieht sich ab sofort auf `domain_mobility_guarantee`.

## 6. Alternativen (bewertet)

### A. `domain_guarantee` beibehalten — abgelehnt

* Verstoß gegen CLAUDE.md ("Ports in `package:emma_contracts`").
* Decken nur T-01..T-06 ab, kein T-08 (User-Selbstmeldung), kein Compensation-Katalog, keine M07-Engine-Versionierung.
* Keine externen Konsumenten — kein Migrations- oder Lock-In-Argument für Erhalt.
* Erhält die in EMM-209/219 dokumentierte Drift dauerhaft.

### B. Beide Domains parallel betreiben (z. B. „generic" vs. „M07") — abgelehnt

* Doppelte Engines auf demselben `RealtimeEvent`-Typ mit sich gegenseitig ausschließenden `RealtimeEventKind`-Cases ist eine Notbrücke, keine saubere Modellierung.
* Zwingt `RealtimeEventKind` und `GuaranteeClaimStatus` dauerhaft zu Union-Enums mit zwei Welten — verhindert späteren Cleanup in `emma_contracts`.
* Erzeugt zwei DoD-Pfade für ein Modul (M07), widerspricht ADR-04.
* Erhöht Onboarding- und Review-Aufwand ohne fachlichen Mehrwert.

### C. Komplette Neustrukturierung (neue dritte Domain, beide bestehenden ablösen) — abgelehnt

* Aktueller `domain_mobility_guarantee`-Stand ist konform zu CLAUDE.md, deckt M07 vollständig ab und ist bereits aktiver Konsumenten-Pfad (`fake_guarantee`).
* Neuaufbau ohne fachlichen Anlass; verstößt gegen "kein Refactor ohne Auftrag" und "1:1-Übernahmepflicht" für real genutzte Funktionen.
* Verzögert M07 ohne Risiko-/Nutzen-Begründung.

## 7. Nicht-Scope

* **Keine sofortige Code-Löschung** von `packages/domains/domain_guarantee/**` — passiert ausschließlich im Cleanup-PR unter EMM-221.
* **Keine automatische Migration** von Imports, Modellen oder Tests durch dieses ADR.
* **Keine Refactor-Implementierung** in M07-Engine, Regelkatalog, Trigger-IDs oder Compensation-Beträgen.
* **Keine API-Änderung** an `MobilityGuaranteePort`, `RealtimePort`, `NotificationPort`, `RealtimeEvent`, `GuaranteeClaim` o. ä.
* **Kein `emma_contracts`-Cleanup** der Legacy-Werte in `RealtimeEventKind` und `GuaranteeClaimStatus` — dafür eigenes R3-Folgeissue.
* **Kein Eingriff in `domain_journey`, `domain_realtime`, `domain_customer_service`** — Modulgrenzen bleiben unverändert.
* **Keine Tarif-Logik-Vermischung** (M11) — separat (`SPECS_MVP.md` M11, ADR-04).
* **Keine externen API-Annahmen** über Hacon/Patris/TAF — Fake-First (ADR-03/05).

## 8. Risiken

1. **Doppelreferenzen im Code** zwischen Inkrafttreten dieses ADR und Abschluss von EMM-221. Mitigation: Naming-Lock + Review-Hinweis in PR-Hygiene; CI-Grep-Check kann ergänzt werden (Subtask).
2. **Inkonsistente Imports** in offenen PRs/Branches, die `domain_guarantee` weiterführen. Mitigation: Branch-/PR-Audit (EMM-201/202/203); betroffene Branches gezielt rebasen oder schließen.
3. **Unvollständige Migration**: einzelne Doku-Stellen, Audit-/Recovery-Reports, Archiv-Verweise. Mitigation: Cleanup-Issue listet betroffene Dateien explizit (s. EMM-218-Gate); Archiv (`docs/_archive/**`) bleibt unangetastet.
4. **Testinstabilität nach Cleanup**: nach Entfernen von `domain_guarantee/test/**` entfällt ein Test ohne Funktionsabdeckung — kein echter Verlust, aber Coverage-Reports zeigen formale Abweichung. Mitigation: Coverage-Baseline im Cleanup-PR neu setzen.
5. **`emma_contracts`-Restmüll** (`RealtimeEventKind`-/`GuaranteeClaimStatus`-Doppelwerte) bleibt nach Cleanup von `domain_guarantee` redundant, bis das separate R3-Issue gezogen ist. Mitigation: Naming-Lock auch für `emma_contracts` — `RealtimeEventKind` darf nicht weiter wachsen, bis die Cleanup-Bewertung läuft.
6. **`FakeMobilityGuaranteeAdapter`-Statusinkonsistenz** (Legacy-Status `open`/`inReview` vs. M07 `draft`/`pending`). Mitigation: Subtask in EMM-221 — entweder auf M07-Status migrieren oder als generischer Submission-Fallback dokumentiert abgrenzen.
7. **Eligibility-Lücke** falls fachlich später ein Eligibility-Vorfilter gefordert wird. Mitigation: explizit als „neuer Port in `emma_contracts`" geführt, nicht als zweite Domain.

## 9. Bezug zu bestehenden Artefakten

### Linear

* Gate: EMM-218 (R3, `PASS_MIT_AUFLAGEN`).
* Vorentscheidung: EMM-219 (R2, `PASS`, Option 1: `domain_mobility_guarantee` kanonisch).
* Umsetzung Doku/Code: EMM-221.
* Verwandt/abhängig: EMM-91 (R3 M07 Recovery), EMM-185 (R2 MobilityGuarantee Engine + Fake), EMM-187 (R2 M07 Fakes, Done), EMM-194 (R2 Contracts/RealtimeEvent vereinheitlichen), EMM-209 (M07-Drift-Finding), EMM-212 (Doppelkanon-Auflage A3), EMM-49/50/51 (M07 Test/Doku/Tickets).
* Governance: EMM-200 (Repo-Review-Quiz, Public-Readiness, Auto-Merge), EMM-201 (PR-Inventar), EMM-202 (Branch-Quarantine), EMM-203 (Branch-Resolution).

### Code (Pfade, Stand der Repo-Wahrheit)

* Kanonisch: `packages/domains/domain_mobility_guarantee/**`, `packages/core/emma_contracts/lib/src/ports/{mobility_guarantee_port,realtime_port,notification_port,guarantee_ports}.dart`, `packages/core/emma_contracts/lib/src/models/{realtime_event,guarantee_claim}.dart`, `packages/fakes/fake_guarantee/lib/src/fake_m07_in_memory.dart`.
* Legacy (zu entfernen in EMM-221): `packages/domains/domain_guarantee/**`, Dependency-Eintrag `domain_guarantee:` in `packages/fakes/fake_guarantee/pubspec.yaml`, ggf. Workspace-Member-Eintrag der Root-`pubspec.yaml`.
* Berührt, aber nicht in diesem ADR aufgeräumt: `packages/fakes/fake_guarantee/lib/src/fake_mobility_guarantee_adapter.dart` (Status-Angleichung als Subtask).

### Doku

* Kanon-Quelle: `docs/technical/SPECS_MVP.md` (M07-Abschnitt), `docs/architecture/MAPPING.md`, `docs/architecture/ADR-04_mvp_domain_scope.md`.
* Anzupassen in EMM-221 Doku-Pass: `docs/architecture/MAPPING.md` (Zeilen 71/84/119/272), `docs/architecture/module_traceability.md` (Z.22), `docs/governance/traceability_domain_module_report.md` (Z.18/19/35/63/77/85/95/104), Nachträge in `docs/audit/RECOVERY_REPORT_2026-04.md` und `docs/audit/repo_state_review_2026-04-24.md`.
* ADR-Index: `docs/architecture/ADR_README.md` — Zeile für ADR-08 ergänzen.
* Archiv: `docs/_archive/2026-04-consolidation/**` bleibt unangetastet.

### Verbindliche Regelbezüge

* CLAUDE.md (global, emma): „Ports in `package:emma_contracts`. Repositories in `domain_*`."
* CLAUDE.md (Repo): Monorepo-Importregel, MVVM-Trennung, Fake-First.
* `docs/planning/DEFINITION_OF_DONE.md`: gilt für `domain_mobility_guarantee` als M07-vertikale MVP-Domain (ADR-04).
