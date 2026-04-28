# M11 — Tarif-Architektur: Entscheid und Datengrundlage

**Status:** verbindlich fuer MVP  
**Stand:** 2026-04-25  
**Bezug:** [ADR-03](../architecture/ADR-03_mvp_without_paid_apis.md), [SPECS_MVP M11](../technical/SPECS_MVP.md), `docs/planning/STATUS.md`

## Entscheidung (Product / Architektur)

| Option | Entscheidung |
|--------|----------------|
| **Tarif-Engine** | **self-built** in `domain_rules` + Fixture-/Adapter-Schicht, exponiert nach aussen über `TariffPort` (`emma_contracts`). |
| **Kommerzieller Tarifserver (SaaS)** | **nicht** im MVP; spaeterer Adapter hinter `TariffPort` denkbar, solange der Port stabil bleibt. |

## Datenquellen (MVP, ohne kostenpflichtige APIs)

Die Preis- und Zonenlogik stützt sich auf **oeffentlich im Internet abrufbare** Roh- und Strukturdaten, z. B.:

- **Statische Fahrplandaten (GTFS / GTFS-Flex)**, die Verkehrsverbuende oeffentlich bereitstellen, sowie **GTFS-Regionalkataloge** (Open-Data-Portale, Mobilitaets-Open-Data-Deutschland, Verbund-Webseiten).
- **Oeffentliche Geodaten** (z. B. **OpenStreetMap** / Nominatim nur im Rahmen der jeweiligen Nutzungsbedingungen und Rate-Limits; fuer Station-/Koordinaten-Mapping, nicht als kostenpflichtiger Routing-Dienst im MVP).
- **Vom Verbund veroeffentlichte Preis- und Zonen-Meta** (als PDF/CSV/Web — manuell oder per Build-Skript in **YAML/JSON-Fixtures** im Repo ueberfuehren, versioniert, deterministische Tests).

**Nicht** zulaessig im MVP-Build: kostenpflichtige kommerzielle Auskunfts- oder Tarif-APIs (siehe ADR-03). Werden oeffentliche Quellen eingebunden, bleibt die **Aktualisierungs**- und **Lizenzhinweis**-Verantwortung in Doku/Readme pro Fixture nachvollziehbar (Quelle, Stand-Datum, Lizenz).

## Abgleich Code ↔ Doku (Pflegepflicht)

Bei jeder wesentlichen Aenderung am Tarifpfad:

1. [../technical/SPECS_MVP.md](../technical/SPECS_MVP.md) (Abschnitt M11) — Port, Deliverables, DoD-Checkboxen.  
2. [STATUS.md](STATUS.md) — Zeile `tariff_and_rules` / Reifegrad / Blocker.  
3. [../architecture/MAPPING.md](../architecture/MAPPING.md) — Matrix-Zeile M11, Fake/Adapter-Status.  
4. Dieses Dokument — Kurz **„Letzte inhaltliche Aenderung“** (Datum + Satz).

## Letzte inhaltliche Aenderung

- **2026-04-25:** Entscheid **self-built**; Daten: frei im Netz; Dokumentation verankert; Umsetzung (`fake_tariff`, Engine) wie zuvor in SPECS M11 und STATUS als **offen** gefuehrt.
