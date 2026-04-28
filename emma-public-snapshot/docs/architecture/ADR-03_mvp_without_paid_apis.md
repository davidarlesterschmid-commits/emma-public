# ADR-03: MVP ohne kostenpflichtige APIs

**Status:** Accepted  
**Datum:** 2026-04-22 (Aktualisiert Verweise: 2026-04-23)  
**Bezug:** [ADR-04_mvp_domain_scope.md](ADR-04_mvp_domain_scope.md) (MVP-Scope 6+3+9), `docs/planning/MVP_BACKLOG_18_DOMAINS.md`,  
[../technical/ENTWICKLER.md](../technical/ENTWICKLER.md) (Fake-First-Abschnitt), `docs/planning/DEFINITION_OF_DONE.md`, [../product/PRODUKT.md](../product/PRODUKT.md)

## Kontext

Das **langfristige** Produktbild (eine emma-App fuer Mitteldeutschland) umfasst viele Domaenen und Schnittstellen, siehe Funktionskatalog in `PRODUKT.md`.

Fuer den **abgegrenzten MVP** nach **ADR-04** gilt: Es werden **nicht** alle 18 Domaenen vertikal produktionsnah ausgebaut, sondern **6 vertikal** plus **3** querschnittlich minimal; der Rest ist Post-MVP-Backlog. Unabhaengig davon gelten oekonomische und CI-Anforderungen: **kein** Vertrags- oder Kreditkarten-Zwang fuer kostenpflichtige Dritt-APIs im Default-MVP-Build, reproduzierbare Pipelines, deterministische Tests.

## Entscheidung

Der MVP setzt fuer die im Scope liegenden Domaenen **zuerst Fake- oder Fixture-basierte Implementierungen** gegen Ports aus `package:emma_contracts` um, soweit in DoD/Backlog vorgesehen. Echte kostenpflichtige Partner-Adapter sind **kein** MVP-Gate (Phase 2 / nach Vertraegen).

### Open-Source-Maxime (verbindlich fuer MVP-Builds)

Fuer **MVP-Abnahme, CI und der Default-Build** gilt zusaetzlich:

- **Maxime:** Soweit fuer die jeweilige Funktion sinnvoll, sind **Open-Source-Komponenten und Open-Data** (lizenzkonform im Repo) zu bevorzugen; proprietäre Cloud-APIs sind **kein** Architektur-Standard im MVP.
- **Karten / Routing / Geocoding:** Kein **Google Maps** (oder vergleichbare kostenpflichtige Kartendienste) im MVP-Pfad. Stattdessen: Fakes, Fixture-Daten, TRIAS/Open-Data wo vorgesehen, OSM-basierte Karten **wenn** eine Karten-UI gebaut wird (siehe `docs/technical/ENTWICKLER.md`).
- **Google Maps Directions** (Adapter in `adapter_maps`): **erst ab Livegang / produktivem Rollout** mit Vertrag, Keys und Release-Gate — nicht Bestandteil der MVP-Feature-Abnahme. Technische Anbindung bleibt hinter `DirectionsPort` und `USE_FAKES` (siehe ADR-05).
- **Abgrenzung:** „Open-Source-Maxime“ bedeutet nicht, dass jedes Pixel selbst geschrieben wird; sie bedeutet, dass **keine** zwingende Abhängigkeit von kostenpflichtigen SaaS-APIs fuer den MVP-Readypfad besteht.

- Fakes leben in `packages/fakes/fake_<name>/` (siehe Fake-First-Abschnitt in `ENTWICKLER.md`), soweit ein eigenes Paket sinnvoll ist; andernfalls In-Memory/Fixture im Domain-Test.
- Fakes bzw. Test-Doubles implementieren dieselbe Port-Schnittstelle wie spaetere Echte-Adapter, wo Port vorhanden.
- Fake-Daten: Open-Data (GTFS, OSM, Brightsky, GBFS) und JSON-Fixtures im Repo.
- Das globale Flag `AppConfig.useFakes` (Default `true` im MVP, Build: `--dart-define=USE_FAKES=true`) schaltet die App-Shell zwischen Fake- und Echt-Adaptern.

Details und Tabellen: `docs/technical/ENTWICKLER.md` (Abschnitt *Fake-First-Strategie*).

## Konsequenzen

**Positiv**

- Kein Vertragsrisiko, keine Kreditkarte fuer MVP-Betrieb/CI.
- Tests reproduzierbar ohne Live-APIs; weniger Flakiness.
- Ports testgetrieben und echt-Adapter-faehig.

**Negativ**

- Luecken ggue. Bestandswelten (kein echter Vollausbau ausserhalb ADR-04-Scope).
- UI muss den Fake-Modus kennzeichnen (z. B. `FakeModeBanner` in `emma_ui_kit`).

**Abstimmung mit ADR-04:** Ohne Widerspruch: ADR-03 regelt *keine* Abdeckung *aller* 18 Domaenen; vielmehr *keine bezahlten APIs* im **Default**-MVP-Build. ADR-04 entscheidet, **welche** Domaenen ueberhaupt vertikal bauen sind.

## Abgrenzung

- **ADR-02** — Monorepo-/Package-Migration (Topologie).  
- **ADR-04** — welche Domaenen im MVP vertikal vs. querschnitt vs. Post-MVP.  
- **ADR-05** — Chat + Directions hinter Ports, Fake-Default.  
- [ADR-06_mvp_open_data_client_and_ci_matrix.md](ADR-06_mvp_open_data_client_and_ci_matrix.md) — oeffentliche, kostenlose Dienste in der *laufenden* App, CI-Matrix, Fake als Fallback. Kein Widerspruch: ADR-03 bleibt auf *kostenpflichtige* Drittanbieter bezogen.  
- [ADR-07_mvp_pilot_regions_provider_catalogue.md](ADR-07_mvp_pilot_regions_provider_catalogue.md) — Berlin/MDV-Pilot, Hybrid-Katalog; Preis-Job-Runbook verlinkt dorthin bzw. nach `docs/operations/`.

## Offene Punkte

- `AppConfig.useFakes` dauerhaft an Build-Flags koppeln; optionales Runtime-Override fuer Piloten.
- Release-Gate vor echten **kommerziellen** Adaptern (Vertraege, SLAs), insbesondere **Google Maps** erst Livegang.
- UX-Abnahme Fake-Banner/Tooltip.
- OSM-basierte Karten-UI (`flutter_map` o. a.) als nachfolgendes Inkrement, falls Karten-Rendering im MVP-Scope fester wird.
