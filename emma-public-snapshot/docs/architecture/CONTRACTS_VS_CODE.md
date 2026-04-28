# JSON-Schema-Paket vs. Anwendungscode (Kurzfassung)

**Stand:** 2026-04-23  
**Herkunft:** Verdichtung aus `docs/_archive/2026-04-consolidation/GAP_REPORT_JSON_SCHEMA_V1.md` (Voll-Report, archiviert).

## Problem

Backend-Vertrags- und Schemawelt (`emma-json-schema-v1` u. a.) und der Flutter-Code im Monorepo sind **nicht 1:1 deckungsgleich**: Es fehlt ein kanonisches Case- und Phase-Envelope-Modell, formale Handoffs zwischen Phasen und vollstaendige Phase-4/5-Result-Modelle, wie das ZIP-Schema sie definiert.

## Ist-Zustand (praezise)

- Fachlich bestehen Ueberlappungen in Demand Recognition, Option Orchestration, Booking Execution sowie Teilen von Trust-, Garantie- und Budgetlogik.
- **Strukturell** nutzt die App i. d. R. **lose Dart-Modelle** und — je nach Zustand des Repos — ein **8-Phasen-App-Modell** statt des im ZIP beschriebenen **5-Phasen-Vertragsmodells**.

## Bewertung (Matrix, gekuerzt)

| ZIP-Bausteil | Ueberblick |
|-------------|------------|
| Kanonischer Case, Phase-Envelope, Master-Orchestrator-Result | im Code weitgehend **nicht** in Schema-Treue umgesetzt |
| Phase 1–3 Result-Strukturen | teilweise **PARTIAL** (aehnlich, nicht identisch) |
| Handoffs Phase n→m | **fehlen** in formaler Form |
| Phase 4/5 | **fehlen** in formaler Form |

Detaillierte Spaltenvergleiche und alte `lib/`-Pfade: siehe **archiviertem** Gap-Report im Repo-Archivordner (gleicher Inhalt wie frueher `GAP_REPORT_JSON_SCHEMA_V1.md`).

## Zielbild (nicht-MVP-Pflicht)

- Explizite Abbild- oder Migrationsstrategie: entweder **Schema im Repo** (contracts/jsonschema) als Single Source of Truth **oder** dokumentierte Mapping-Pipeline ZIP ↔ Domain-Modelle.
- Fuer MVP-Releases gilt weiterhin: **Port-basierte** Integration, Fake-First, sichtbarer Demo-Modus (siehe ADR-03/05).

## Verweis

- Archivierte Vollanalyse (identisch zum frueheren `GAP_REPORT_JSON_SCHEMA_V1.md`): [../_archive/2026-04-consolidation/GAP_REPORT_JSON_SCHEMA_V1.md](../_archive/2026-04-consolidation/GAP_REPORT_JSON_SCHEMA_V1.md)
