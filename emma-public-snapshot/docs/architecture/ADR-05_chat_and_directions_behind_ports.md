# ADR-05: Chat- und Directions-Integrationen hinter Ports + Fake-First-Schalter

**Status:** Accepted
**Datum:** 2026-04-23
**Bezug:** `docs/architecture/ADR-03_mvp_without_paid_apis.md`,
`docs/architecture/ADR-04_mvp_domain_scope.md`,
`apps/emma_app/lib/features/home/presentation/screens/home_screen.dart`,
`packages/adapters/adapter_maps/lib/src/maps_service.dart`

## Kontext

Vor Inkrement 3a nutzt der emma-App-Code zwei kostenpflichtige externe APIs
direkt im `HomeScreen`-Widget:

1. **Google Maps Directions** — ueber `adapter_maps.MapsService()`, der
   mit `GOOGLE_MAPS_API_KEY` aus `dotenv` gegen
   `https://maps.googleapis.com/maps/api/directions/json` ruft.
2. **Google Gemini** — ueber `google_generative_ai.GenerativeModel` mit
   `GEMINI_API_KEY` aus `dotenv`, direkt instanziert im Widget-State.

Damit werden drei harte Projektregeln verletzt:

- **ADR-03 / CLAUDE.md** "Keine kostenpflichtige API-Calls in MVP-Code".
- **Architektur-Leitlinie** "Keine Business-Logik in Widgets".
- **Architektur-Leitlinie** "Jede kritische Integrationslogik hinter
  Interfaces kapseln" — weder Maps noch Gemini haengen hinter einem Port
  aus `package:emma_contracts`.

Zusaetzlich ist der in ADR-03 angekuendigte Build-Zeit-Schalter
`--dart-define=USE_FAKES=true` noch nicht implementiert; das MVP laeuft
faktisch gegen Echt-APIs, sobald die Keys geladen sind.

## Entscheidung

Chat- und Directions-Integrationen kommen hinter Ports in
`package:emma_contracts`. Fake-Implementierungen sind MVP-Default.
Echt-Adapter bleiben fuer Dev-Builds verfuegbar und werden per
Build-Zeit-Flag eingeschaltet.

Die Umsetzung wird in drei Teil-Inkremente geschnitten:

- **3a (erledigt)** — `DirectionsPort` + `fake_maps` + `adapter_maps`-
  Umhaengung. Dieses ADR wurde mit dem 3a-Commit eingebracht.
- **3b (erledigt)** — `ChatPort` + `adapter_gemini` + `fake_chat` +
  `chatPortProvider` + Bootstrap-Override.
- **3c (erledigt)** — `HomeScreen` auf `HomeChatNotifier` umgestellt,
  Business-Logik aus dem Widget raus, `home_screen_v2.dart` und
  Deprecation-Alias `MapsService` / `DirectionsResult` physisch geloescht,
  `google_generative_ai` nur noch transitiv ueber `adapter_gemini`,
  `FakeModeBanner` in `emma_ui_kit` eingefuehrt und im Home-Screen
  oberhalb des Headers platziert (aktiv wenn `AppConfig.useFakes`).

### Port-Vertrag (3a)

```dart
// package:emma_contracts
class DirectionsSummary {
  final String durationDriving;
  final String distanceDriving;
  final String durationTransit;
  final String distanceTransit;
}

abstract interface class DirectionsPort {
  Future<DirectionsSummary> summarize({
    required String origin,
    required String destination,
  });
}
```

### Port-Vertrag (3b)

Der 3b-Vertrag faellt bewusst minimaler aus als in der 3a-Vorschau
skizziert. Die im MVP reale Nutzung (Single-Prompt-Call, keine
Multi-Turn-History auf Aufrufer-Seite) rechtfertigt keine
Messages-Sequenz. System-Instruction und optionale History wandern
dem Adapter ins Konstruktor-Setup statt in jeden Call.

```dart
// package:emma_contracts
abstract interface class ChatPort {
  Future<String> reply(String prompt);
}

class ChatException implements Exception { … }
```

Wenn spaeter Multi-Turn-Kontext gebraucht wird, wird der Port erweitert —
aber nicht spekulativ in 3b.

### Feature-Flag

`AppConfig.useFakes` wird per
`bool.fromEnvironment('USE_FAKES', defaultValue: true)` aufgeloest. Der
Default im MVP ist `true`. `bootstrap.dart` liest das Flag und
ueberschreibt die Port-Provider entsprechend:

**Hinweis (ADR-03 Open-Source-Maxime):** `GoogleMapsDirectionsAdapter` ist
für **Livegang** mit API-Key reserviert, nicht für die MVP-Abnahme. Im MVP
bleibt der Pfad **Fake** (und perspektivisch OSM/Open-Data, eigenes
Inkrement); siehe `FakeDirectionsAdapter` und
`docs/technical/ENTWICKLER.md`.

```dart
directionsPortProvider.overrideWith((ref) =>
    AppConfig.useFakes
        ? FakeDirectionsAdapter()
        : GoogleMapsDirectionsAdapter(
            apiKey: AppConfig.googleMapsApiKey, // String.fromEnvironment('GOOGLE_MAPS_API_KEY')
          ));
```

Analog fuer `chatPortProvider` in 3b.

### Fake-Datenbasis

`FakeDirectionsAdapter` nutzt eine Inline-Fahrzeittabelle fuer die
sechs relevantesten MDV-Staedtepaare (Leipzig↔Halle, Leipzig↔Chemnitz,
Leipzig↔Dresden, Halle↔Magdeburg, Halle↔Dresden, Chemnitz↔Dresden).
Unbekannte Origin/Destination-Kombinationen liefern `Nicht verfuegbar`.

Bewusster Trade-off: ADR-03 nennt GTFS-basierte Berechnung als
Idealzustand. 3a bleibt mit Inline-Tabelle bewusst einfach — eine
GTFS-Integration ist eigenes Inkrement und blockiert den Port-Umbau
unnoetig.

## Konsequenzen

**Positiv**

- ADR-03 wird erstmals real erfuellt: MVP-Default ist Fake-only, keine
  bezahlten API-Calls.
- Chat- und Directions-Logik sind austauschbar, mockbar und testbar.
- `HomeScreen`-Refactor in 3c bekommt einen sauberen Provider-Pfad.
- Muster fuer weitere Port-Einziehungen (Ticketing, Payments) ist
  etabliert.

**Negativ**

- Zwei neue Ports, zwei neue Fake-Pakete, ein neuer Adapter — temporaer
  mehr Pakete zu warten.
- Fake-UX ist ab 3c explizit als Demo-Modus kenntlich gemacht —
  `FakeModeBanner` aus `emma_ui_kit`, aktiv wenn `AppConfig.useFakes`.
- `adapter_maps.MapsService`-Altname und `DirectionsResult` sind mit 3c
  physisch entfernt; einziger Konsument war `HomeScreen`, der ueber
  Ports laeuft.

## Abgrenzung

- ADR-03 bleibt uebergeordnet; ADR-05 ist die konkrete Umsetzung des
  dort angekuendigten `USE_FAKES`-Flags fuer zwei Integrationen.
- ADR-05 vergroessert den Scope nicht — weitere Ports (Payments,
  Ticketing) folgen eigenen ADRs, wenn sie drankommen.

## Offene Punkte

- GTFS-basierte Fake-Fahrzeiten als Nachfolge-Inkrement, sobald die
  MVP-UX steht.
- Secret-Handling im Release-Build: `GOOGLE_MAPS_API_KEY` und
  `GEMINI_API_KEY` muessen perspektivisch aus einem sichereren Store
  kommen, nicht aus einem in die App gebundelten `.env`.
- Strukturierte Intake-Logik (frueher in `assistant_intake_service.dart`
  an `HomeScreenV2` gekoppelt) ist mit 3c aus dem Baum entfernt und
  steht nur noch im Git-Log; wenn sie wiederbelebt wird, gehoert sie
  hinter einen eigenen Port (z. B. `AssistantIntakePort`) statt direkt
  im HomeScreen-Feature.
