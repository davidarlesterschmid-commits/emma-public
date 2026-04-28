# Technische SPECs — MVP (konsolidiert)

**Herkunft:** docs/technical/SPECS_MVP.md (Abschnitt M07) und docs/technical/SPECS_MVP.md (Abschnitt M11)


# Spezifikation M07 — Mobilitaetsgarantie: Trigger-Matrix

Status: Entwurf, gueltig fuer MVP
Stand: 2026-04-23
Bezug: Funktionskatalog M07, `ADR-04_mvp_domain_scope.md`
(vertikal MVP, Prio 6), `MVP_BACKLOG_18_DOMAINS.md`,
`docs/architecture/MAPPING.md`
Domaenenname (CLAUDE.md): `mobility_guarantee`

## 1. Zweck

Die Mobilitaetsgarantie ist ein zentrales Kundennutzenversprechen der
emma-App (`CLAUDE.md`, Zielbedingung 6). Sie muss maschinell erkennen,
wann ein Anspruch besteht, den Nutzer benachrichtigen und den Antrag
aufnehmen. Diese Spec definiert die Trigger-Matrix und die
Port-Vertraege fuer den MVP.

## 2. Scope — was im MVP drin ist

- Automatisierte Anspruchserkennung auf Basis von Echtzeit-Events aus
  `fake_realtime` oder einem spaeteren Echt-Adapter.
- Nutzer-Benachrichtigung bei erkanntem Anspruch.
- Antrag mit einem Tap aus der Benachrichtigung.
- Status-Tracking des Antrags (offen / in Pruefung / bewilligt /
  abgelehnt).

## 3. Nicht im MVP

- Automatische Entschaedigungs-Auszahlung (bleibt manuell, Support-
  Seite).
- Ersatz-Buchung als Direkt-Aktion (Alternativ-Routing zeigt nur Info).
- Komplexe Missbrauchserkennung (nur Basis-Deduplikation).
- Reale Taxi-Kostenuebernahme bei T-04 (siehe §5, MVP zeigt nur
  Platzhalter).

## 4. Trigger-Matrix

| Trigger-ID | Ereignis                                                            | Bedingung                                                                            | Anspruch | Kulanz-Budget (MVP)                                   |
|------------|---------------------------------------------------------------------|--------------------------------------------------------------------------------------|----------|-------------------------------------------------------|
| T-01       | Zugausfall                                                          | Nutzer-gebuchte Fahrt entfaellt                                                      | Ja       | Alternativ-Verbindung + 5 EUR Gutschein                |
| T-02       | Verspaetung > 20 Min                                                | geplante Ankunft um > 20 Min ueberschritten                                          | Ja       | 5 EUR Gutschein                                        |
| T-03       | Verspaetung > 60 Min                                                | geplante Ankunft um > 60 Min ueberschritten                                          | Ja       | 15 EUR Gutschein                                       |
| T-04       | Letzte Verbindung des Tages ausgefallen                              | gebuchte Verbindung UND keine Anschluss-Alternative UND aktuell > 22:00 lokal       | Ja       | Platzhalter "Taxi-Gutschein bis 50 EUR angekuendigt"   |
| T-05       | Linie > 2 Std. ausser Betrieb                                        | Stoerungs-Event mit `lineOutOfServiceMinutes > 120`                                   | Ja       | 10 EUR Gutschein                                       |
| T-06       | Umstieg verpasst durch Verspaetung der vorherigen Fahrt              | geplanter Umstieg mit <= 5 Min Puffer, vorige Fahrt verspaetet > Puffer              | Ja       | 5 EUR Gutschein                                        |
| T-07       | Fahrzeug nicht barrierefrei trotz gebuchter Option                   | **Post-MVP**                                                                          | nein     | —                                                      |
| T-08       | Nutzer-Selbstmeldung                                                | Nutzer meldet manuell (CRM-Pfad)                                                      | Pruefung | manuell, bis 10 EUR                                    |

Fallback: wenn kein Trigger matcht, kein automatischer Anspruch. Nutzer
kann ueber T-08 manuell einreichen.

## 5. Datenfluss

```
[fake_realtime | RealtimePort]
          v  Event-Stream
[GuaranteeTriggerEngine in domain_mobility_guarantee]
          v  (match?)
[GuaranteeClaim candidate]
          v  (Deduplizierung gegen offene Claims)
[NotificationPort] ----> Nutzer
          v  (User accept)
[MobilityGuaranteePort / ClaimRepository]
          v
[Status-Tracking in UI]
```

## 6. Port-Vertraege (geplant, in `emma_contracts`)

```dart
abstract interface class RealtimePort {
  Stream<RealtimeEvent> eventsFor({required List<String> tripIds});
}

abstract interface class MobilityGuaranteePort {
  Stream<GuaranteeClaim> pendingClaims();
  Future<GuaranteeClaim> submit(GuaranteeClaimRequest request);
  Future<GuaranteeClaimStatus> statusOf(String claimId);
}

abstract interface class NotificationPort {
  Future<void> notifyGuaranteeClaimable(GuaranteeClaim claim);
}
```

Modelle `RealtimeEvent`, `GuaranteeClaim`, `GuaranteeClaimRequest`,
`GuaranteeClaimStatus` gehoeren zu `emma_contracts`. Jeder Claim traegt
mindestens `tripId`, `triggerId`, `reasonCode`, `evaluationLog`,
`createdAt`, `status`.

## 7. Engine-Regeln (deterministisch)

1. Ein Event kann hoechstens einen Anspruch pro `tripId` ausloesen.
2. Ansprueche werden gegen bereits eingereichte Claims dedupliziert
   (Key: `tripId + triggerId`).
3. Hoehere Trigger dominieren: T-03 > T-02 (Nutzer bekommt die hoechste
   passende Entschaedigung, nicht beide).
4. T-04 gilt nur zwischen 22:00 und 04:00 lokal.
5. Alle Entscheidungen bekommen einen `reasonCode` aus der Trigger-
   Matrix und einen vollstaendigen `evaluationLog`.

## 8. Fake-Implementierung (`fake_guarantee`, geplant)

- `fake_realtime` erzeugt Event-Stream mit 3 Demo-Stoerungen
  (je ein T-02, T-03, T-04).
- `fake_guarantee` laeuft Engine, persistiert Claims in-memory.
- UI-Pfad: Home-Banner "Du hast einen Garantie-Anspruch" mit CTA
  "Antrag stellen". Banner unterscheidbar vom `FakeModeBanner`
  (andere Farbe, anderer Icon).

## 9. MVP-Deliverables

1. Trigger-Matrix in dieser Spec angenommen.
2. `domain_mobility_guarantee` (neu) mit Engine.
3. `fake_guarantee`-Paket mit 3 Demo-Triggern.
4. `MobilityGuaranteePort`, `RealtimePort`, `NotificationPort` in
   `emma_contracts`.
5. Home-Banner (unabhaengig von `FakeModeBanner`) sichtbar, wenn
   `pendingClaims` nicht leer.
6. Tests: je 1 Unit pro Trigger (T-01..T-06, T-08), 1 Integrations-
   Test Fake-Realtime -> Claim -> Nutzeraktion.

## 10. Offene Punkte

- **Kulanzbudget echt vs. Demo:** MVP zeigt Gutschein als
  UI-Placeholder. Echte Gutschein-Issue ist Post-MVP (benoetigt
  Payments + Partner-Integration).
- **Audit-Trail:** jeder Claim braucht `evaluationLog` (welcher Event,
  welcher Trigger, welche Engine-Version).
- **Partner-SLA:** T-04 Taxi-Gutschein setzt Taxi-Partner-Integration
  voraus; im MVP wird nur ein Platzhalter angezeigt.
- **Missbrauch:** im MVP nur Deduplikation gegen offene Claims. Post-
  MVP braucht Frequenz-Check und Plausibilitaet gegen Ist-Reise.
- **Realtime-Quelle echt:** heute nur `fake_realtime`. Wenn ein echter
  GTFS-RT- oder TRIAS-Stoerungsadapter kommt, wird er als Adapter
  hinter `RealtimePort` eingezogen. Kein Scope im MVP.

## 11. Risiken

- **Triggern von Ansprechen ohne gebuchte Fahrt:** wenn Nutzer keine
  Reise aktiv hatte, darf kein Anspruch erzeugt werden. Engine muss
  `tripId` gegen bestehende User-Trips pruefen.
- **Doppelansprueche:** Deduplikation-Key muss deterministisch sein.
- **Benachrichtigung ohne Netz:** `NotificationPort` muss lokale
  Queue haben; Notification wird spaeter zugestellt.
- **Missverstaendnis "Anspruch" vs. "Gewaehrung":** UI muss klarstellen,
  dass automatische Erkennung noch keine garantierte Gewaehrung bedeutet.

## 12. Definition of Done

- [ ] 7 Trigger-Regeln (T-01..T-06, T-08) deterministisch
      implementiert.
- [ ] `fake_guarantee` gruen, 3 Demo-Ansprueche durchlaufen
      End-to-End.
- [ ] Home-Banner zeigt Anspruch, Nutzer kann einreichen, Status
      wird sichtbar.
- [ ] Unit- und Integrations-Tests gruen.
- [ ] `evaluationLog` im Debug-Log sichtbar.
- [ ] `docs/architecture/MAPPING.md` Zeile "mobility_guarantee" aktualisiert.

---
# Spezifikation M11 — Tarifserver und Regelwerksmanagement (MVP-Lesepfad)

Status: Entwurf, gueltig fuer MVP
Stand: 2026-04-25
Bezug: Funktionskatalog M11, `ADR-04_mvp_domain_scope.md` (Querschnitt-
minimal), `MVP_BACKLOG_18_DOMAINS.md`, `docs/architecture/MAPPING.md`,
[../planning/M11_TARIFF_ARCHITECTURE_DECISION.md](../planning/M11_TARIFF_ARCHITECTURE_DECISION.md)
Domaenenname (CLAUDE.md): `tariff_and_rules`

## 0. Architektur- und Daten-Entscheid (verbindlich, MVP)

- **Engine:** **self-built** (reine Dart-Logik in `domain_rules`, keine kostenpflichtige Tarif-API) — siehe
  [M11_TARIFF_ARCHITECTURE_DECISION.md](../planning/M11_TARIFF_ARCHITECTURE_DECISION.md).
- **Rohdaten:** oeffentlich im Internet abrufbare Quellen (z. B. GTFS/Open-Data der Verkehrsverbuende, OSM-Metadaten, veroeffentlichte
  Zonen-/Preisdokumente), in versionierte **Fixtures (YAML/JSON)** im Repo ueberfuehrt; Lizenzen und Stand-Datum pro Quelle in Fixture-Readme
  oder Commit-Beschreibung festhalten.
- **Grenze ADR-03:** kein kostenpflichtiger API-Aufruf im Default-MVP-Build; Echt-Adapter hinter `TariffPort` erst Post-MVP oder mit
  explizitem Flavor, ohne ADR-03 zu brechen.

## 1. Scope — was im MVP drin ist

Nur der **Lese-Tarif-Pfad fuer Ticketing und Routing**:

- Tarifauskunft fuer die 6 MVP-relevanten Staedtepaare (Basis wie
  ADR-05 `FakeDirectionsAdapter`).
- Einzelfahrschein-Preis (EF) in Euro-Cent.
- Zone-Ermittlung anhand Station-IDs (Lookup-Tabelle im Fake).
- Tageskarten-Preis als Bestpreis-Hinweis.
- Regel-Trace fuer Support-Debug (welche Regel hat den Preis gesetzt).

## 2. Nicht im MVP

- Regelwerks-Editor, Backoffice-Pfad.
- Tarifaenderungen zur Laufzeit, Multi-Version-Zugriff.
- Clearing-Integration.
- D-Ticket-Spezifika (separater Anzeige-Pfad in
  `subscriptions_and_d_ticket`, MVP-intern mitgefuehrt).
- Rabatt-Logik ueber statische Klassen-Reduktion hinaus (Schueler,
  Senior — spaeter).

## 3. Fachliche Pflichtfelder einer Tarifentscheidung

| Feld                  | Typ          | Beschreibung                                                 |
|-----------------------|--------------|--------------------------------------------------------------|
| `priceEuroCents`      | `int`        | Preis in Cent, nie `double`                                  |
| `currency`            | `String`     | derzeit immer `"EUR"`                                        |
| `productCode`         | `String`     | z. B. `"MDV-1-EF"`, `"MDV-TAGESKARTE"`                       |
| `zoneFrom` / `zoneTo` | `String`     | MDV-Zonen-Code                                                |
| `validFrom` / `validTo` | `DateTime` | Gueltigkeit der Preisentscheidung (nicht des Tickets)        |
| `ruleTrace`           | `List<String>` | geordnete Regel-IDs, die den Preis bestimmt haben            |
| `isFallback`          | `bool`       | `true`, wenn Fallback-Regel griff                             |

## 4. Port-Vertrag (in `emma_contracts`)

`TariffPort` existiert bereits. Signatur gegen diese Spec pruefen und
anheben auf:

```dart
// emma_contracts: TariffPort + TariffQuote/TariffProduct/PriceSourceKind
abstract class TariffPort {
  Future<TariffQuote?> quote({ ... });
  Future<List<TariffProduct>> listProducts({ required String zoneId });
  Future<List<TariffRule>> getAvailableTariffs(); // Katalog/Anzeige, domain_rules
}
// TariffQuote enthaelt u. a. priceEuroCents, ruleTrace, ruleSetVersion,
// fixtureBundleId, priceSourceKind (MVP: emmaRuleEngine).
```

## 5. Fake-Implementierung (`fake_tariff`)

- YAML-String/Fixture: `packages/fakes/fake_tariff/lib/fixtures/mdv_mvp_v1.dart` + `SOURCES.md`.
- Mindestens 3 MDV-Zonen (Leipzig, Halle, Chemnitz) mit je einem EF-
  Tarif und einem Tageskarten-Tarif.
- Regel-Engine in `domain_rules`, reine Dart-Logik, kein Flutter-Import.
- Aktivierung ueber `USE_FAKES=true` analog ADR-05. Provider:
  `tariffPortProvider` in App-Shell, Bootstrap-Override waehlt
  `FakeTariffAdapter` vs. zukuenftigen Real-Adapter.

## 6. Engine-Verantwortlichkeiten

- Eingang: `originStationId`, `destinationStationId`, `departureAt`.
- Mapping Station -> Zone (Lookup-Tabelle im Fixture).
- Regel-Auswahl: deterministisch "cheapest winning rule" bei
  Konflikten. Tiebreaker: lexikographische Regel-ID.
- Ausgabe: `TariffQuote` mit `ruleTrace`.
- Fallback: wenn keine Regel greift, Fallback-Flat-Preis +
  `isFallback = true`.

## 7. Audit-Anforderungen

- Jeder `TariffQuote` enthaelt `ruleTrace`. Die App zeigt `ruleTrace`
  nicht als UI, aber loggt ihn bei `LogLevel.debug`.
- Im Support-Modus (Feature-Flag, spaeter) ist `ruleTrace` als
  Copy-fertiger String darstellbar.
- Jeder `FakeTariffAdapter`-Call ist stabil reproduzierbar: gleiche
  Eingabe -> gleicher Preis + gleicher Trace (wichtig fuer Tests).

## 8. MVP-Deliverables

1. Port `TariffPort` in `emma_contracts` gegen diese Spec pruefen und
   ggf. erweitern (z. B. `quote` ergaenzen falls Signatur abweicht).
2. Fake-Paket `fake_tariff` anlegen (bloquiert M03 Ticketing und
   M04 D-Ticket-Anzeige).
3. `tariffPortProvider` in App-Shell (existiert bereits als
   `journeyTariffPortProvider`, ggf. umbenennen fuer Generalisierung).
4. Unit-Tests in `domain_rules`: mindestens 3 positive (EF Leipzig-Halle,
   EF Leipzig-Chemnitz, Tageskarte Halle-Magdeburg), 2 negative
   (Unbekannte Zone, keine Regel greift -> Fallback).
5. Integrations-Test in `feature_journey`: Routing-UI zeigt
   Tarifpreis fuer mindestens 1 Staedtepaar.

## 9. Offene Punkte

- **~~Entscheidung self-built vs. eingekauft~~** — **erledigt (2026-04-25):** **self-built**, Daten oeffentlich; siehe
  [M11_TARIFF_ARCHITECTURE_DECISION.md](../planning/M11_TARIFF_ARCHITECTURE_DECISION.md). Eine spaetere **eingekaufte** Auskunft bleibt
  moeglich hinter `TariffPort`, solange der Vertrag stabil bleibt.
- **Versionierung:** MVP rechnet mit genau einer Regelwerks-Version.
  Post-MVP: `ruleTrace` wird um `ruleSetVersion` ergaenzt.
- **Clearing:** nicht im MVP-Scope, ADR notwendig bei Aktivierung.
- **Station-ID-Mapping:** Routing liefert HAFAS-/TRIAS-IDs, Fake-Tarif
  kennt Zonen-Strings. Mapping-Tabelle muss mit
  `domain_journey`-StationDirectory synchron sein.

## 10. Risiken

- **Regel-Konflikte mit stillem Fallback:** wenn zwei Regeln denselben
  Preis liefern koennten, muss die Engine deterministisch auswaehlen
  (Tiebreaker nach Regel-ID). Sonst nicht-reproduzierbare Preise im
  Test.
- **YAML-Fixture als Truth-Source:** bevor Real-Regelwerk kommt, darf
  die Fixture nicht ausserhalb des MVP-Scopes mutieren (sonst
  ploetzliche Preisdrift in Tests).
- **Cent vs. Euro-Float:** Preis immer in `int priceEuroCents`, niemals
  `double`. Verstoss bricht Payments-Integration spaeter.

## 11. Definition of Done

- [x] `TariffPort` Signatur inkl. `quote` / `listProducts` / `getAvailableTariffs`; `MAPPING` tariff_and_rules aktualisiert.
- [x] `fake_tariff` mit YAML-Fixture + Engine-Tests gruen.
- [ ] 5+ Unit-Tests (Engine) — **OK**; Integrations-Test Journey/Routing-UI + optionales Debug-`ruleTrace` — **teilweise offen**.
- [ ] Routing-UI zeigt Tarifpreis fuer mindestens 1 MVP-Staedtepaar (explizit).
- [ ] `ruleTrace` im Debug-Log sichtbar (derzeit: `EmmaLogger.info` in `feature_journey` — ggf. auf Debug-Level anheben).
- [x] Kein `double` fuer Geldwerte in `TariffQuote` (Journey-UI: Euro Darstellung aus Cent/Ansatzwerten; Watchlist: FareDecision-Line-Items).
