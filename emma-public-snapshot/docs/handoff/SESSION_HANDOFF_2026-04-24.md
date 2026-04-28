# Session-Handoff 2026-04-24

**Zweck:** Ermoeglicht neuen Claude-Instanzen (Cowork, Claude Code,
Cursor, Codex) den konfliktfreien Einstieg in die offenen emma-Tasks.
Jede neue Instanz liest zuerst dieses Dokument und claimt dann einen
Task via `TaskUpdate owner=<instance-name>`.

**Stand:** 2026-04-24 (Nachmittag).
**Git-HEAD:** `main` (3 Commits vor `origin/main`, Push-ready).

---

## 1. Session-Kontext (2-Min-Brief)

Was in der Session 2026-04-24 passiert ist:

- **Recovery-Audit** nach grober Monorepo-Migration: 116 geloeschte
  Dateien verifiziert. 92 waren legitime Umzuege, 24 echte Loeschungen.
  Davon sind 4 inhaltlich substantiell, jetzt gesichert in
  `_recovery/from_c9572d0_2026-04-21/`. Report:
  [docs/audit/RECOVERY_REPORT_2026-04.md](../audit/RECOVERY_REPORT_2026-04.md).
- **Cross-Agent-Konsolidierung** nach 22 parallel gepushten Commits:
  alle Audit-/Review-Dokumente konsistent gezogen. Ghost-Feature-
  Eintraege in `MAPPING.md` (M06/M07/M12/M16) korrigiert. Externes
  Audit historisiert:
  [docs/audit/repo_state_review_2026-04-24.md](../audit/repo_state_review_2026-04-24.md).
- **Sicherheits-Befund**: Alter Gemini-Key in Commit `af6b442` ist in
  der Remote-History. Aktueller Key im lokalen `.env` ist neu und
  nicht im Repo (User-Verifikation via `diff -q`). User deaktiviert
  den alten Key in Google AI Studio separat.
- **6 neue Tasks** angelegt (#51–#57), davon 3 direkt umgesetzt (#54
  Recovery, #57 Konsolidierung) und 1 abgeschlossen nach Remote-
  Umsetzung (#25, #36, #37, #46, #47, #53).

Wichtige neue Dateien:

- `docs/audit/RECOVERY_REPORT_2026-04.md`
- `docs/audit/repo_state_review_2026-04-24.md` (historisch markiert)
- `docs/audit/uncommitted-20260424-pre-consolidation.patch` (Backup)
- `_recovery/from_c9572d0_2026-04-21/` (Startmaterial fuer Task #31)

---

## 2. Aktueller Task-Stand (Kurz)

Zaehlung nach Status:

- **pending**: 17 Tasks.
- **in_progress**: 1 (#26 auth_and_identity DoD — ruhend, solange keine
  Unter-Tasks laufen).
- **completed heute**: #25, #36, #37, #46, #47, #53, #54, #57.
- **DRINGEND User-Action**: #52 (alter Gemini-Key in Google-Konsole
  deaktivieren — nicht Codearbeit).

---

## 3. User-Action-Items (nur der User)

| # | Aktion | Blocker fuer |
|---|---|---|
| U1 | `git push` (3 Commits vor origin/main) | alle parallelen Instanzen — sonst sehen sie den Konsolidierungs-Stand nicht |
| U2 | **#52**: alten Gemini-Key aus `af6b442` in Google AI Studio deaktivieren | nichts, aber Security-Prio |
| U3 | Fake-First-Regel (#32) final entscheiden: verbindlich oder streichen | #48-Folge, Task-Beschreibungen |
| U4 | Datumsanomalie in `STATUS.md` (2026-04-28 vs. heute 2026-04-24) entscheiden: korrigieren oder bewusst so lassen | #49 Doku-Sync |
| U5 | Bei Parallel-Instanzen: Jeder bekommt einen eigenen Feature-Branch + Owner-Name zum Claim | parallel-sicher arbeiten |

---

## 4. Parallel-Arbeits-Regeln fuer neue Instanzen

**Vor Start jeder Instanz:**

1. `git fetch --all && git checkout main && git pull --ff-only`
2. `TaskList` lesen, `TaskGet <id>` fuer Detail.
3. Pruefen dass `blockedBy` leer ist.
4. `TaskUpdate taskId=<id> status=in_progress owner=<instance-name>`.
5. Eigenen Feature-Branch anlegen:
   `git checkout -b task-<id>-<slug>`.

**Nach Fertigstellung:**

1. Tests lokal gruen: `dart analyze`, `melos run test:unit`,
   `melos run test:flutter`.
2. Commit mit Referenz auf Task-ID.
3. Push als Feature-Branch, PR gegen `main`.
4. `TaskUpdate status=completed`.
5. STATUS.md Historie-Eintrag ergaenzen (eine Zeile).

**Konflikt-Vermeidung:** Dokumente mit hoher Konflikt-Wahrscheinlichkeit
duerfen nur von einer Instanz gleichzeitig editiert werden. Siehe §5.

---

## 5. File-Lock-Matrix (zentrale Dokumente, Single-Writer)

Wer diese Dateien beruehrt, muss sicherstellen, dass keine andere
parallele Instanz sie gleichzeitig aendert. Koordination via Task-
Owner-Feld und Rebase vor Commit.

| Datei | Typische Aenderer | Koordinations-Weg |
|---|---|---|
| `docs/planning/STATUS.md` | fast jeder Task | Owner-Instanz schreibt; andere fuegen nur Historie-Zeile an | 
| `docs/architecture/MAPPING.md` | Tasks mit Port-/Domain-Aenderungen | rebase vor commit |
| `docs/planning/MVP_BACKLOG_18_DOMAINS.md` | Tasks mit Scope-Aenderung | rebase vor commit |
| `docs/architecture/ADR-*.md` | neue ADRs | neue ADR-Nummer per nächstem freiem Index, keine Re-Vergabe |
| `packages/core/emma_contracts/lib/**` | Port-Aenderungen | Port-Aenderungen nie parallel, immer eine Instanz |
| `apps/emma_app/lib/bootstrap/**` | Bootstrap-Override | eine Instanz zur Zeit |
| `apps/emma_app/lib/core/*_providers.dart` | Provider-Anlagen | Paket-spezifisch, kann parallel wenn pro Paket getrennt |

---

## 6. Offene Tasks — Parallel-Plan

Gruppiert nach **Gruppe A/B/C** — Tasks innerhalb einer Gruppe
duerfen parallel laufen, zwischen Gruppen existieren
Reihenfolge-Beziehungen.

### Gruppe A — kann jetzt parallel starten (keine Konflikte)

| Task | Subject | Files-Touched (Haupt) | Akzeptanz-Kurz |
|---|---|---|---|
| **#48** | TariffPort Cent-Migration | `domain_journey/entities/fare_decision.dart`, `domain_journey/services/booking_execution_engine.dart`, `domain_journey/entities/payment_intent.dart`, `domain_rules/entities/tariff_rule.dart`, `domain_rules/tariff/tariff_rule_set.dart` | `grep -n 'double\s\+\(price\|amount\|budget\)' packages/domains/**/lib/src/` 0 Treffer ausser `.freezed.dart` |
| **#50** | ADR-Nachtrag M07/M12/M16 Scope-Entscheidung | `docs/architecture/ADR-04_mvp_domain_scope.md` (Nachtrag) oder neue `ADR-09_*.md` | ADR committed, in `ADR_README.md` gelistet |
| **#56** | ADR-08 Parity-Replacement + Skeletons | neu: `docs/architecture/ADR-08_parity_replacement.md`, `docs/product/PARITY.md`, `docs/technical/PILOT_FLOWS.md`; Edit: `docs/planning/DEFINITION_OF_DONE.md` | drei neue Dateien + DoD-Erweiterung |
| **#51** | Mock-Klassen Namens-Hygiene | `packages/adapters/adapter_trias/**`, `apps/emma_app/lib/features/trips/**`, umbenennen/verschieben in `fake_*` | Grep `Future\.delayed` in `packages/adapters/**` 0 Treffer, `UnimplementedError` nur mit Task-Ref |
| **#49** | Doku-Sync apps/README, trip_boundary | `apps/emma_app/README.md`, `docs/technical/trip_boundary_mapping_rules.md`, `docs/migration/migration_checklist_v2.md`, `packages/domains/domain_journey/lib/src/**` (Dartdoc) | Grep `noch anzulegen|before flutter create|5-phase journey` 0 Treffer |

Diese 5 Tasks koennen **komplett parallel** laufen — ihre Haupt-Files
ueberlappen nicht.

### Gruppe B — nach Gruppe A, weil STATUS/MAPPING-Updates noetig

| Task | Subject | Abhaengigkeit |
|---|---|---|
| **#26** | auth_and_identity nach DoD | wartet auf #35 (Barrel show-Filter) |
| **#35** | `domain_identity` Barrel auf show-Filter | eigenstaendig, kann in Gruppe A mitschwimmen |
| **#28** | employer_mobility DoD ausbauen | wartet auf #48 Abschluss (Cent-Preise auch hier) |
| **#29** | ticketing DoD ausbauen | wartet auf #48, teilweise User-Entscheidung PSP |
| **#30** | routing DoD ausbauen | wartet auf #48 indirekt |
| **#31** | mobility_guarantee Wiederaufbau | wartet auf #50 (Scope-ADR) |

### Gruppe C — Infrastruktur, nicht dringend

| Task | Subject |
|---|---|
| #23 | `SecureStorage`-Port trennen |
| #32 | Fake-First-Regel entscheiden (User-Input #U3) |
| #33 | Pre-Commit-Hook `melos run analyze` |
| #43 | Secret-Handling Release-Build (nach U2) |
| #44 | GTFS-Fake-Fahrzeiten (teils obsolet durch OSRM) |
| #45 | AssistantIntakePort bei Revival |
| #55 | Tarifdaten-Ingest-Automatisierung |

### Dringend / User-Action

| Task | Subject |
|---|---|
| #52 | Alter Gemini-Key in Google-Konsole deaktivieren |

---

## 7. Bekannte Risiken / Pitfalls

- **Datumsanomalie** `STATUS.md` Stand 2026-04-28: von paralleler
  Session gesetzt, heute ist 2026-04-24. Bis User-Entscheidung (U4):
  nicht blind korrigieren, sonst entsteht erneut Konflikt.
- **`melos run <script>` interaktiv**: Das User-Terminal fragt beim
  Melos-Run manchmal nach Paket-Auswahl. Workaround aus Audit:
  `dart run melos run <script> --no-select` oder direkt
  `dart run melos exec -- flutter test`.
- **Sandbox-FUSE-Lag**: Claude-Instanzen, die im Sandbox-Shell
  arbeiten, sehen `.git/index`-Aenderungen manchmal verzoegert.
  Fuer Git-Operationen im Zweifelsfall direkt auf dem Host arbeiten
  lassen.
- **`_recovery/`**: der Ordner enthaelt `.dart.txt`-Dateien
  (Dart-Quelltexte mit `.txt`-Suffix, damit Analyzer sie ignoriert).
  **Nicht** zu `.dart` umbenennen ausserhalb des #31-Wiederaufbaus.
- **`docs/audit/recovered_candidates/`**: leerer Restordner aus
  fruehem Session-Moment. Kann beim naechsten Commit mit aufgeraeumt
  werden.

---

## 8. Referenzen

- Task-Liste: Cowork TaskList
- Aktueller Repo-Status: [STATUS.md](../planning/STATUS.md)
- Port-/Paket-Matrix: [MAPPING.md](../architecture/MAPPING.md)
- Architektur-ADRs: [ADR_README.md](../architecture/ADR_README.md)
- SPECs M07/M11: [SPECS_MVP.md](../technical/SPECS_MVP.md)
- Recovery-Report: [RECOVERY_REPORT_2026-04.md](../audit/RECOVERY_REPORT_2026-04.md)
- Historisierter Audit: [repo_state_review_2026-04-24.md](../audit/repo_state_review_2026-04-24.md)
- Agent-Regeln: [AGENTS.md](../../AGENTS.md)
- Session-Coding-Kontext: [CLAUDE.md](../../CLAUDE.md)
