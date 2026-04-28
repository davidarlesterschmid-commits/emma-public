# ADR-06: Oeffentliche Dienste in der Laufzeit-App und CI-Matrix (MVP)

**Status:** Accepted  
**Datum:** 2026-04-23

**Bezug:** [ADR-03_mvp_without_paid_apis.md](ADR-03_mvp_without_paid_apis.md), [ADR-04_mvp_domain_scope.md](ADR-04_mvp_domain_scope.md), [ADR-07_mvp_pilot_regions_provider_catalogue.md](ADR-07_mvp_pilot_regions_provider_catalogue.md), [../product/PRODUKT.md](../product/PRODUKT.md) (Ergaenzung MVP-Region, …), [../planning/MVP_SCOPE.md](../planning/MVP_SCOPE.md)

## Kontext

[ADR-03](ADR-03_mvp_without_paid_apis.md) schliesst *kostenpflichtige* Dritt-APIs im Default-MVP-Build aus. Fachlich zusaetzlich vorgesehen: In der laufenden Demo-App sollen *kostenlose, oeffentlich nutzbare* Dienste (z. B. GTFS, oeffentliches Wetter) *vorrangig* genutzt werden; *Fakes* dienen *Fallback* bei Fehlern, Timeouts oder Offline. CI soll schnell und reproduzierbar bleiben, ohne *zwingende* Live-Abhaengigkeit im Merge-Gate.

## Entscheidung

1. **Laufzeit (Haupt-Demo, Client)**  
   - Oeffentliche, kostenlose HTTP-Schnittstellen duerfen *direkt* aus der Mobile-Client-App angesprochen werden, *wenn* kein geteiltes Geheimnis (API-Key, Token) noetig ist: typisch oeffentliche URL, in der Praxis haeufig GET (oder anderes rein lesbares, lizenz- und rate-freundliches Vorgehen).  
   - Bei Fehlern, Timeouts oder fehlendem Netz: Fakes/Fixtures als Fallback, Ports unveraendert. Entwickler-Doku ([ENTWICKLER.md](../technical/ENTWICKLER.md)) und Fake-First-Beschreibung werden schrittweise so gelesen, dass Fakes *primaer* Test/CI-Determinismus und *Resilience* absichern, nicht dass der Demo-Client *ausschliesslich* Fakes nutzen muss.

2. **CI / PR-Gate (schnell, mergesicher)**  
   - `melos run test:unit` und `test:flutter` (sowie empfohlen: `analyze`, `format`) laufen *ohne* zwingende Live-Aufrufe zu fremden Endpunkten: Fakes, Mocks, eingebettete Fixtures oder Fake-HTTP-Adapter. Kein planbarer Dritt-Flake im Standard-Gate.

3. **Zweite Pipeline (optional, naechtlich/woechentlich)**  
   - Integration- oder Smoke-Tests *gegen* reale, kostenlose Endpunkte sind zulaessig und duerfen dokumentiert werden; sie blockieren *nicht* den schnellen Gate. Ausfaelle: Report/Fehlermarkierung, kein fester Release-Stopper, solange fachlich nicht anders definiert (aktuell: nein).

4. **BFF**  
   - Keine Pflicht, oeffentliche Lese-Feeds zuerst ueber BFF zu fuehren, solange ADR-07 (Region/Katalog) und Sicherheits-Review (Rate-Limit, Lizenzen, TLS, PII) eingehalten werden. BFF/Cache/Key-Handling fuer spaetere, nicht-oeffentliche APIs bleibt Architektur-Option, kein MVP-Blocker.

## Konsequenzen

- **Positiv:** Staerkere Nutzung oeffentlicher Daten; Fakes absichern Tests und Offline.  
- **Aufwand:** Zwei Pipeline-Klassen; Live-Smokes koennen flaken (Netz, Rate-Limit, Dritt-Aenderungen).  
- **Doku-Pflege:** `ENTWICKLER.md` / `CLAUDE.md` — Formulierungen `USE_FAKES` / „MVP ausschliesslich Fakes\“ ggf. an ADR-06/ADR-03 angleichen, ohne ADR-03 aufzuweichen.

## Abgrenzung

- [ADR-03](ADR-03_mvp_without_paid_apis.md) — wirtschaftlich/kaufmaennisch, nicht Technik-Transportweg.  
- [ADR-05](ADR-05_chat_and_directions_behind_ports.md) — Chat/Directions hinter Ports; oeffentliche Fahrplan-Feeds betreffen andere Schichten.

## Offene Punkte

- Konkrete Feed-Allowlist (Berlin/MDV) in Katalog-Artefakten im Repo, nicht in diesem ADR.  
- Build-Flavors ggf. fuer separate `integration_test`-Profile mit Live-Smoke.
