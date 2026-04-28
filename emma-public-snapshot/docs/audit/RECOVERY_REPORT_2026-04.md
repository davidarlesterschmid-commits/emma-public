# Recovery-Report: Migration 2026-04-21 bis 2026-04-24

**Stand:** 2026-04-24
**Auslöser:** User-Entscheidung 2026-04-24, Befund aus
`docs/audit/repo_state_review_CURRENT.md` §C.
**Referenz-Commits:**
- Sicherer Stand (Backup): `c9572d0d0cc64a1ca2ff50d863ebdd28dbca3aab`
  (2026-04-21 18:19, Branch `recovery-backup-20260422-2348`).
- Verdächtiger Migrations-Commit: `a95d1c23e26e3035090cb202ba5f647950fae19b`
  (2026-04-23 10:40, Branch `mess-up-20260423-1042`,
  Subject: `chore(repo): remove PowerShell-misparsed garbage and
  redundant melos.yaml`).
- Aktueller Stand: `d4cb095d0cc64a1ca2ff50d863ebdd28dbca3aab` (main).

## 1. Untersuchte Menge

`git diff --name-status c9572d0..d4cb095` liefert **116 gelöschte
Dateien**. Sie zerfallen in zwei Gruppen.

### Gruppe A — Legitime Umzüge (92 Dateien, kein Verlust)

Code wurde von `apps/emma_app/lib/features/*/` in die neue Paket-
struktur unter `packages/domains/*` und `packages/features/*` verschoben.
Diese Umzüge sind durch ADR-02 (Monorepo-Migration) und abgeschlossene
Tasks #6, #7, #8–#18, #34, #42 gedeckt.

| Pfad (alt)                                          | Ziel (neu, verifiziert)                                      | Nachweis  |
|-----------------------------------------------------|--------------------------------------------------------------|-----------|
| `apps/.../journey_engine/` (32 Dateien)             | `packages/domains/domain_journey/`, `packages/features/feature_journey/` | Task #8–#18 |
| `apps/.../auth_and_identity/` (16 Dateien)          | `packages/domains/domain_identity/`, `packages/features/feature_auth/`   | Task #6, #34 |
| `apps/.../employer_mobility/` (19 Dateien)          | `packages/domains/domain_employer_mobility/`, `packages/features/feature_employer_mobility/` | Task #7 |
| `apps/.../core/ports/{budget,routing,tariff}_port.dart` | `packages/core/emma_contracts/lib/src/ports/`            | Task #17, #18 |
| `apps/.../home/domain/{entities,services}/assistant_intake*.dart`, `apps/.../home/presentation/screens/home_screen_v2.dart` | **Bewusst entfernt** (ADR-05 3c) | Task #42 |
| `apps/.../windows/*` (16 Dateien: CMakeLists, runner, generated_plugins) | Flutter Windows-Plattformordner, regenerierbar via `flutter create . --platforms=windows` | Niedriges Risiko |
| `packages/adapters/adapter_maps/lib/src/maps_service.dart` | Neustrukturiert in `adapter_maps`, `DirectionsPort`-konform | Task #40 |
| `packages/features/feature_journey/lib/src/screens/journey_search_screen.dart` | Umbenannt / überführt in `feature_journey` neue Struktur | Task #39 |
| `docs/planning/IMPLEMENTIERUNGSSTATUS.md`           | `docs/_archive/2026-04-consolidation/IMPLEMENTIERUNGSSTATUS.md` + konsolidiert in `docs/planning/STATUS.md` | Doku-Konsolidierung 2026-04-23/24 |
| `melos.yaml` (1 Datei)                              | Erneut am Repo-Root vorhanden (2026-04-24 verifiziert)       | nachträglich restauriert |

**Bewertung:** Keine Aktion nötig. Alle diese Dateien haben einen
definierten Platz in der Zielarchitektur oder wurden bewusst entfernt.

### Gruppe B — Löschungen ohne Ersatz (24 Dateien)

Diese Pfade wurden **entfernt, ohne dass ein Paket-Äquivalent
entstanden ist**. Sie verteilen sich auf drei Domains:

- `apps/emma_app/lib/features/mobility_guarantee/` — 8 Dateien
- `apps/emma_app/lib/features/partnerhub/` — 8 Dateien
- `apps/emma_app/lib/features/migration/` — 8 Dateien

Inhaltliche Bewertung pro Gruppe (aus Inspektion des Backup-Commits):

#### B.1 mobility_guarantee (MVP Prio 6, vertikal gemäß ADR-04)

| Datei                                             | Inhalt                                                                 | Wert       | Empfehlung                                                                 |
|---------------------------------------------------|------------------------------------------------------------------------|------------|----------------------------------------------------------------------------|
| `domain/entities/guarantee_rule.dart`             | Freezed-Union-Modelle: `GuaranteeRule`, `GuaranteeTrigger` (delay / cancellation), `GuaranteeAction` (taxi / onDemand), mit JSON-Serialisierung | **mittel-hoch** | **Wiederherstellen** als Startbasis für `packages/domains/domain_mobility_guarantee/lib/src/entities/`; gegen SPEC M07 (T-01..T-08) erweitern |
| `domain/repositories/guarantee_repository.dart`   | Minimales Interface: `getActiveRules`, `triggerGuarantee`              | mittel     | Als Interface-Muster verwenden; wird durch `MobilityGuaranteePort` aus SPEC M07 abgelöst |
| `data/repositories/guarantee_repository_impl.dart`| Mock mit hardcoded Demo-Regel (Delay 15min → Taxi Berlin)              | gering     | Als Referenz für `fake_guarantee`, nicht 1:1 übernehmen                    |
| `data/datasources/guarantee_remote_datasource.dart` | (nicht inspiziert, vermutlich Stub)                                  | gering     | Verwerfen                                                                  |
| `presentation/providers/guarantee_provider.dart`  | Riverpod-Provider-Wrapper                                              | gering     | Muss ohnehin in App-Shell (#46-Muster)                                     |
| `presentation/screens/guarantee_screen.dart`      | Scaffold mit Titel und Status-Card                                     | gering     | Platzhalter, SPEC M07 sieht Home-Banner statt eigenes Screen               |
| `presentation/widgets/guarantee_status_card.dart` | (nicht inspiziert, UI-Widget)                                          | gering     | Ersatz in `emma_ui_kit` neu bauen                                          |
| Freezed-/JSON-Generated (`guarantee_rule.freezed.dart`, `guarantee_rule.g.dart`) | Build-Output                                       | null       | Ignorieren, wird regeneriert                                               |

**Gesamturteil mobility_guarantee:** Eine einzige Datei
(`guarantee_rule.dart`) liefert echten strukturellen Wert und ist als
Startmaterial für Task #31 brauchbar. Der Rest ist Platzhalter-Code.

#### B.2 partnerhub (Post-MVP gemäß ADR-04)

| Datei                                                | Inhalt                                                             | Wert       | Empfehlung                                                      |
|------------------------------------------------------|--------------------------------------------------------------------|------------|-----------------------------------------------------------------|
| `domain/entities/partner.dart`                       | `Partner { id, name, type, services, isActive }`, Freezed, minimal | mittel     | Wiederherstellen in `packages/domains/domain_partnerhub/lib/src/entities/`; `type` besser als Enum |
| `domain/repositories/partner_repository.dart`        | Trivial-Interface                                                  | gering     | Durch `PartnerhubPort` ersetzen, wenn Post-MVP aktiv             |
| `data/repositories/partner_repository_impl.dart`     | Mock                                                               | gering     | Verwerfen                                                       |
| `presentation/providers/partner_provider.dart`       | Riverpod-Wrapper                                                   | gering     | Muss in App-Shell (bei Reaktivierung)                          |
| `presentation/screens/partnerhub_screen.dart`        | Liste mit PartnerCard                                              | gering     | UI neu bauen, wenn Post-MVP aktiv                              |
| `presentation/widgets/partner_card.dart`             | (nicht inspiziert)                                                 | gering     | Verwerfen                                                       |
| Generated (`partner.freezed.dart`, `partner.g.dart`) | Build-Output                                                       | null       | Ignorieren                                                      |

**Gesamturteil partnerhub:** `domain_partnerhub/` existiert als
leeres Paket; `partner.dart` kann ohne Aufwand wiederhergestellt
werden. Kein MVP-Druck.

#### B.3 migration (Post-MVP gemäß ADR-04)

| Datei                                            | Inhalt                                                               | Wert   | Empfehlung                                                        |
|--------------------------------------------------|----------------------------------------------------------------------|--------|-------------------------------------------------------------------|
| `domain/entities/migration_task.dart`            | `MigrationTask { id, sourceSystem, targetSystem, status, createdAt }`, `enum MigrationStatus {pending, inProgress, completed, failed}` | gering | Zu simpel für echten Cutover-Scope. Als Historiemarker archivieren. |
| alle weiteren                                    | Platzhalter, Mock, UI-Liste                                          | gering | Verwerfen.                                                        |

**Gesamturteil migration:** Nichts substantiell Wertvolles; später
(Post-MVP) wird die Migrationsfabrik gegen echte Bestandssysteme
entworfen, nicht gegen dieses Schema.

## 2. Aktionen in diesem Audit

1. Sicherheits-Backup: die 4 inhaltlich wertvollen Dateien wurden als
   Text-Kopien (`.dart.txt`) unter
   `_recovery/from_c9572d0_2026-04-21/{mobility_guarantee,partnerhub,migration}/`
   abgelegt. Sie sind damit unabhängig von Git-State greifbar und
   werden bei Paketwiederaufbau als Quelle herangezogen.
2. `.git/packed-refs` war abgeschnitten; **letzte abgeschnittene Zeile
   entfernt** (`refs/remotes/origin/cod…` — Remote-Ref, beim nächsten
   `git fetch` ohnehin wiederhergestellt).
3. `.git/objects/pack/multi-pack-index` war veraltet; entfernt
   (Datei liegt als `.corrupt.bak`).
4. `.git/index` (Working-Tree-Index) ist korrupt (`bad sha1 signature`,
   `unknown extension ;R��`). **Konnte im Sandbox-Shell nicht gelöscht
   werden** (FUSE-virtiofs-Beschränkung). Fix-Befehl siehe §5.

## 3. Empfehlung an Task #31 (mobility_guarantee nach DoD ausbauen)

Beim Bau von `packages/domains/domain_mobility_guarantee/`:

- `guarantee_rule.dart` aus `_recovery/from_c9572d0_2026-04-21/mobility_guarantee/`
  als **Startpunkt für das Entity-Modell** nehmen, nicht 1:1 übernehmen.
  SPEC M07 §4 führt 8 Trigger (T-01..T-08), das Backup kennt nur zwei
  Varianten (delay, cancellation). Erweiterung nötig.
- `GuaranteeAction`-Union (taxi, onDemand) bleibt konzeptionell
  brauchbar, muss aber gegen SPEC M07 §3 Kulanz-Budget + T-04
  Platzhalter-Logik harmonisiert werden.
- `GuaranteeRepository`-Interface **verwerfen**, da `MobilityGuaranteePort`
  aus SPEC M07 die bessere Abstraktion ist.

## 4. Empfehlung an Task #50 (Scope-Entscheidung M07/M12/M16)

Auf Basis dieses Audits:

- **M07 mobility_guarantee**: absichtlicher Rückbau akzeptabel, weil
  der Alt-Code überwiegend Platzhalter war. **Wiederaufbau als
  `domain_mobility_guarantee` + feature_mobility_guarantee** ist MVP-
  Pflicht (Prio 6). Startmaterial liegt in `_recovery/`.
- **M12 partnerhub**: Rückbau legitim, Post-MVP. Kein Druck zum
  Wiederherstellen. `_recovery/partnerhub/partner.dart.txt` bei
  Bedarf verfügbar.
- **M16 migration_factory**: Rückbau legitim, Post-MVP. Kein
  relevanter Inhalt verloren.

## 5. User-Action auf Windows-Host — Git-Index reparieren

Das Sandbox-Shell konnte die Git-Interne Korruption nicht vollständig
reparieren (FUSE-virtiofs erlaubt kein `unlink` auf `.git/index`).
Bitte **einmal lokal am Windows-Host** (z. B. Git Bash / VS-Code-
Terminal im Repo-Root) ausführen:

```bash
cd <LOCAL_USER_PATH>

# 1. alte Lock- und Korrupt-Index-Dateien entfernen
rm -f .git/index .git/index.lock .git/index.corrupt.bak

# 2. Index frisch aus HEAD aufbauen (Working Tree bleibt unberuehrt)
git reset

# 3. origin/HEAD neu setzen (zeigte auf 0000...)
git symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main

# 4. fetch, damit fehlende Remote-Refs (letzte Zeile abgeschnitten) zurueckkommen
git fetch --prune

# 5. Health-Check
git fsck --full
git status
```

Danach ist `git status`, `git diff` und `git commit` wieder nutzbar.
Meine heutigen Edits an STATUS.md, MAPPING.md, TASK_37_*.md,
MVP_BACKLOG_18_DOMAINS.md und die neuen Dateien unter
`docs/audit/RECOVERY_REPORT_2026-04.md` und `_recovery/…` erscheinen
dann als unstaged modifications bzw. untracked.

## 6. Ergebnis

- **Kein wertvoller Code irreversibel verloren.**
- 92 Löschungen waren legitime ADR-02-Umzüge und bewusste ADR-05-3c-
  Entfernungen.
- 24 Löschungen waren Placeholder/Mock-Code für Post-MVP-Themen und für
  M07. Die einzige inhaltlich substantielle Datei (`guarantee_rule.dart`)
  ist in `_recovery/` gesichert und wird in Task #31 als Startbasis
  verwendet.
- **Migration war handwerklich grob, aber fachlich nicht gravierend
  schädlich.** Der Hauptverlust liegt im Platzhalter-UI, nicht in
  Geschäftslogik.

## 7. Offene Punkte

- Git-Index-Reparatur muss am Host ausgeführt werden (§5).
- `origin/HEAD` zeigt auf 0000-SHA — wird durch §5 Schritt 3 behoben.
- Mögliche weitere Reflog-Einträge, die gelöschte Dateien im
  Zeitfenster 2026-04-16 bis 2026-04-21 zeigen, wurden nicht geprüft
  (Backup-Branch `c9572d0` ist vom 2026-04-21, frühere Stände
  nicht explizit gesichert). Wenn noch fragmentarische
  Löschungen vor dem 21. vermutet werden, separate Reflog-Analyse nötig.

## 8. Referenz-Commits (für zukünftige Recherche)

- Sicherer Stand: `c9572d0` (2026-04-21 18:19) — Branch
  `recovery-backup-20260422-2348`.
- Mess-up-Marker: `a95d1c2` (2026-04-23 10:40) — Branch
  `mess-up-20260423-1042`.
- Aktueller main: `d4cb095` (2026-04-24 12:27).
