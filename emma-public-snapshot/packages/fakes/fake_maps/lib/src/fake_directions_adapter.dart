import 'package:emma_contracts/emma_contracts.dart';

/// Fake [DirectionsPort] mit Inline-Fahrzeittabelle fuer MDV-Staedte.
///
/// Deckt die sechs haeufigsten Mitteldeutschland-Kombinationen ab. Unbekannte
/// Origin/Destination-Paare liefern eine "Nicht verfuegbar"-Summary —
/// die UI (bzw. der Chat-Notifier) muss damit umgehen koennen.
///
/// Matching ist case-insensitive auf Substring-Ebene, damit freie
/// Nutzereingaben wie "Leipzig" oder "Leipzig Hbf" auf den Knoten
/// "Leipzig" matchen. Ein genauer Stop-Ref wird nicht benoetigt — das
/// waere Aufgabe eines echten Adapters.
class FakeDirectionsAdapter implements DirectionsPort {
  const FakeDirectionsAdapter();

  /// Fahrzeiten wurden grob nach oeffentlich bekannten Werten angesetzt.
  /// Bewusst kein Netzabruf, kein GTFS-Parsing — siehe ADR-05.
  ///
  /// Keys sind in Normalform `from|to` mit Kleinschreibung, damit die
  /// Map als `const` bleiben kann (Map-Keys duerfen `==` nicht
  /// ueberschreiben — deshalb keine Tupel-/Record-Keys).
  static const Map<String, DirectionsSummary> _table = {
    'leipzig|halle': DirectionsSummary(
      durationDriving: '35 Min.',
      distanceDriving: '42 km',
      durationTransit: '25 Min.',
      distanceTransit: '40 km',
    ),
    'leipzig|dresden': DirectionsSummary(
      durationDriving: '1 Std. 20 Min.',
      distanceDriving: '115 km',
      durationTransit: '1 Std. 10 Min.',
      distanceTransit: '112 km',
    ),
    'leipzig|chemnitz': DirectionsSummary(
      durationDriving: '1 Std.',
      distanceDriving: '85 km',
      durationTransit: '55 Min.',
      distanceTransit: '82 km',
    ),
    'halle|magdeburg': DirectionsSummary(
      durationDriving: '1 Std.',
      distanceDriving: '95 km',
      durationTransit: '1 Std. 15 Min.',
      distanceTransit: '90 km',
    ),
    'halle|dresden': DirectionsSummary(
      durationDriving: '1 Std. 50 Min.',
      distanceDriving: '155 km',
      durationTransit: '2 Std.',
      distanceTransit: '150 km',
    ),
    'chemnitz|dresden': DirectionsSummary(
      durationDriving: '1 Std.',
      distanceDriving: '70 km',
      durationTransit: '1 Std. 5 Min.',
      distanceTransit: '68 km',
    ),
  };

  /// Bekannte Knoten als Normalform. Erster Treffer per substring
  /// gewinnt — Reihenfolge entspricht grob der Relevanz.
  static const List<String> _knownCities = [
    'leipzig',
    'halle',
    'dresden',
    'magdeburg',
    'chemnitz',
  ];

  @override
  Future<DirectionsSummary> summarize({
    required String origin,
    required String destination,
  }) async {
    final from = _resolve(origin);
    final to = _resolve(destination);
    if (from == null || to == null || from == to) {
      return DirectionsSummary.empty;
    }
    return _table['$from|$to'] ??
        _table['$to|$from'] ??
        DirectionsSummary.empty;
  }

  String? _resolve(String raw) {
    final needle = raw.trim().toLowerCase();
    if (needle.isEmpty) return null;
    for (final city in _knownCities) {
      if (needle.contains(city)) return city;
    }
    return null;
  }
}
