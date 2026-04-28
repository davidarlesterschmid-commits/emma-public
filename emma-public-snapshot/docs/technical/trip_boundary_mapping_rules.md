# trip_boundary_mapping_rules

**Stand:** erstellt April 2026 | **Aktualisiert:** 2026-04-16  
**Hinweis zur Workspace-Migration:** Der Root-`lib/`-Ordner wurde nach `_recovery/` archiviert. Die hier beschriebenen Pfade sind auf die neue Mono-Repo-Struktur zu übertragen:
- `lib/features/trips/` → `packages/features/feature_journey/` + `apps/emma_app/lib/features/`  
- `lib/shared/models/` → ggf. in `packages/core/emma_contracts/` oder als Teil von `domain_journey`
- `lib/integrations/trias/` → `packages/adapters/adapter_trias/` (noch anzulegen)

---

## Verbindliche Boundary-Regel

**Fachlich führend (Domain-Aggregat):**  
`packages/domains/domain_journey/lib/src/entities/journey.dart` (Nachfolger von `lib/features/trips/domain/entities/trip.dart`)

**Nicht fachlich führend, aber weiterhin technisch relevant (DTOs):**  
Externe Transportmodelle (`EmmaTrip`, `EmmaLocation`) — bis zur Ablösung durch saubere Adapter

## Rollen

| Artefakt | Rolle | Erlaubte Verantwortung |
|---|---|---|
| `domain_journey/entities/journey.dart` | Domain-Aggregat | Fachliche Trip-/Journey-Semantik, Usecases, Repository- und Domaingrenzen |
| `shared/models/trip.dart` (DTO) | Integrationsmodell | Transportmodell für externe Daten, Realtime-/TRIAS-nahe Antwortstrukturen |
| `shared/models/location.dart` (DTO) | Integrationsmodell | Externe oder app-nahe Ortsdaten, Adapter-Input |

## Ist-Befund (nach Migration)

- `domain_journey` enthält: `journey.dart`, `journey_intent.dart`, `map_routing_port.dart`, `journey_summary_service.dart`
- Die alten `lib/features/trips/`-Dateien liegen archiviert in `_recovery/altstaende/lib_root_altstruktur/`
- `EmmaTrip`/`EmmaLocation`-Konsumenten in der App müssen auf `domain_journey`-Entitäten umgestellt werden

## Zielbild

1. Externe Integrationen dürfen weiterhin `EmmaTrip` / `EmmaLocation` erzeugen.
2. Vor dem Eintritt in Feature-/Domainlogik muss ein explizites Mapping stattfinden.
3. Präsentation im Journey-Feature soll das Domainmodell konsumieren, nicht direkt das DTO-Modell.

## Minimale Mapping-Regeln

### `EmmaTrip` → `Journey`

| DTO-Feld | Domain-Feld | Regel |
|---|---|---|
| `id` | `id` | direkt |
| `legs.first.origin.name` | `from` | aus erster Leg-Origin ableiten |
| `legs.last.destination?.name` | `to` | aus letzter Leg-Destination; Fallback auf Origin |
| `departureTime` | `departureTime` | direkt |
| `legs` | `legs` | pro `EmmaLeg` nach `JourneyLeg` mappen |
| `totalDurationSeconds` | `totalDuration` | `Duration(seconds: totalDurationSeconds)` |
| `fare` | `totalCost` | falls numerisch zu `double`; sonst `0.0` |

### `EmmaLeg` → `JourneyLeg`

| DTO-Feld | Domain-Feld | Regel |
|---|---|---|
| `legIndex` | `id` | `<journeyId>-<legIndex>` |
| `mode` | `mode` | direkt |
| `origin.name` | `from` | direkt |
| `destination?.name` | `to` | direkt, Fallback-Regel bei null |
| `departure?.timetabledTime` | `departureTime` | Fallback auf Journey-Abfahrtszeit |
| `arrival?.timetabledTime` | `arrivalTime` | Fallback auf Journey-Ankunftszeit |
| `line?.operatorName` | `provider` | direkt |
| `line?.shortName` | `line` | direkt |

## Verbotene Abkürzungen

- Keine neue Fachlogik direkt auf `EmmaTrip`.
- Keine UI-Komponenten in `feature_journey`, die direkt vom DTO-Modell abhängen.
- Kein Löschen von DTO-Modellen, solange aktive Konsumenten und Mappings nicht bereinigt sind.

## Nächste technische Schritte

1. Konsumenten von `EmmaTrip`/`EmmaLocation` in `feature_journey` und `apps/emma_app` inventarisieren.
2. Mapper-Schicht zwischen TRIAS-Adapter und `domain_journey` definieren (→ `adapter_trias` anlegen).
3. `apps/emma_app` Journey-Screens von DTO- auf `domain_journey`-Konsum umstellen.
4. Erst danach DTO-Modelle als reine Integrationsmodelle einschränken.
