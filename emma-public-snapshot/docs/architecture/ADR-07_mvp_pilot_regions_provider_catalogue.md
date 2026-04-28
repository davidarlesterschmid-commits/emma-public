# ADR-07: MVP-Pilot-Regionen (Berlin, MDV) und Provider-Katalog (Hybrid)

**Status:** Accepted  
**Datum:** 2026-04-23

**Bezug:** [ADR-04_mvp_domain_scope.md](ADR-04_mvp_domain_scope.md), [ADR-06_mvp_open_data_client_and_ci_matrix.md](ADR-06_mvp_open_data_client_and_ci_matrix.md), [../product/PRODUKT.md](../product/PRODUKT.md) (Ergaenzung MVP-Region, …), [../planning/MVP_SCOPE.md](../planning/MVP_SCOPE.md), [../operations/price_data_refresh_runbook.md](../operations/price_data_refresh_runbook.md)

## Kontext

Das langfristige Zielbild (emma fuer Mitteldeutschland) steht in [../product/PRODUKT.md](../product/PRODUKT.md) unveraendert. Fuer den abgegrenzten MVP-Entwicklungs- und Pilot-Scope sind zwei Regionen (Berlin, MDV) fachlich vorgegeben, inkl. weicher Region-Gates, Hybrid-Logik (Feeds vs. Registry), Wechsel-Dialog und Anbindung an versionierte Preis-Snapshots (siehe Runbook).

## Entscheidung

1. **Regionen-Modell (MVP-DoD)**  
   - Voll in Katalog, Tests und Fluss-DoD adressiert: *nur* die beiden Pilot-Regionen **berlin** und **mdv** (MDV-Raum, Anzeigename laut Katalog-Strings, nicht in diesem ADR fixiert). Weitere Regionen: ausserhalb MVP-DoD.  
   - Erster Start: *keine* Vorauswahl; der Nutzer muss aktiv **Berlin** oder **MDV** waehlen, bevor katalog- und buchungsnahe Kernfluesse sinnvoll arbeiten. Ohne Wahl: weiche Sperre (Hinweis/Overlay), siehe PRODUKT.  
   - Wechsel **Berlin** ↔ **MDV**: sichtbarer Dialog **Kontext verwerfen** / **Abbrechen**; bei Verwerfen: Warenkorb, offene Suche, Entwurfsfahrt- und verwandter State werden zurueckgesetzt (Detail in Implementierung).

2. **Hybrid-Provider-Logik**  
   - **Linien-/Takt-OePNV** und **Regionalbahn**, soweit aus oeffentlichen Feeds (z. B. GTFS inkl. `agency.txt` und Fahrten) fuer die jeweilige Region stabil mappbar: aus Feed-basierter Discovery abgeleitet, kein hartes manuelles Listenpflegen pro Halt, wo der Feed ausreicht.  
   - **Mietrad-/Scooter-Sharing (GBFS-artig):** soweit im MVP an oeffentlich dokumentierte Feeds anbindbar: feed-basiert.  
   - **Taxi,** Sammel-/**On-Demand,** Mietwagen, Parken und alles ohne brauchbaren oeffentlichen Feed im MVP: ausschliesslich versionierte **Provider-Registry** im Repo (JSON/YAML) plus Fahr-/Preis-Fixtures (Fake/Snapshot); in der App klar erkennbar, wo kein Live-Feed vorgesehen ist.  
   - Fehlt fuer eine der fuenf Buchungs-*Bauarten* (siehe PRODUKT) die reale Datenlage in einer Region, darf die Luecke durch *eindeutig gekennzeichnete* Fake-/Simulations-Buchung (Demo-Hinweis) gefuellt werden.

3. **Preis-/Tarifanzeige (technische Anbindung)**  
   - Die App liest versionierte **Preis-Snapshots**; UI-Logik zu Stand, gestuftem Warnbanner, Fehlversuch — siehe [Runbook: Preisdaten-Refresh](../operations/price_data_refresh_runbook.md), nicht ersetzbar durch diesen ADR.

4. **Session-Scope**  
   - Pro Nutzungssession ist genau *eine* Region aktiv; Cross-Region-Multimodal-Fahrten sind MVP-out (spaeterer Epic, nicht hier).

5. **Architektur**  
   - Region = Konfiguration/Parameter des Katalog- bzw. Repository-Resolvers, keine Business-Logik in Widgets (siehe Monorepo-Regeln in [AGENTS.md](../../AGENTS.md)). Ports in `package:emma_contracts` bzw. Domains, unveraendert.

## Konsequenzen

- **Positiv:** Klarer MVP-Rahmen; Feed- vs. Registry-Split reduziert „magische\“ Autodiscovery ausserhalb oeffentlicher Feeds.  
- **Aufwand:** Zwei voll getrennte Katalog-Pfade/Fixtures, getrennte Testfokus (optional CI-Matrix [ADR-06](ADR-06_mvp_open_data_client_and_ci_matrix.md)).

## Abgrenzung

- [ADR-04](ADR-04_mvp_domain_scope.md) — welche Domaenen vertikal; dieser ADR nur regionaler Katalog- und UX-Rahmen.  
- Migrationsfabrik / 1:1-Bestandswelten = Gesamtbild PRODUKT, nicht voll in diesem MVP-Teilkatalog abgebildet.

## Offene Punkte

- UI-Copy: Kurzname „MDV\“ vs. Verbund- oder Marketing-Label.  
- Spaeter: BFF-Caching, siehe [ADR-06](ADR-06_mvp_open_data_client_and_ci_matrix.md) Offene Punkte.
