/// Ergebnis einer Zwei-Modi-Direktionsanfrage (Auto + OePNV) in
/// menschlich lesbarer Form.
///
/// Felder sind absichtlich Strings, weil der ursprueungliche Google-
/// Maps-Adapter mit bereits lokalisierten Labels ('12 Min.', '8,2 km')
/// arbeitet. Fakes liefern dasselbe Format, damit die UI austauschbar
/// bleibt.
///
/// Wenn ein Modus nicht verfuegbar ist, MUSS der jeweilige Wert
/// `'Nicht verfuegbar'` sein — nie `null`, nie leer.
class DirectionsSummary {
  const DirectionsSummary({
    required this.durationDriving,
    required this.distanceDriving,
    required this.durationTransit,
    required this.distanceTransit,
  });

  final String durationDriving;
  final String distanceDriving;
  final String durationTransit;
  final String distanceTransit;

  static const unavailable = 'Nicht verfuegbar';

  static const DirectionsSummary empty = DirectionsSummary(
    durationDriving: unavailable,
    distanceDriving: unavailable,
    durationTransit: unavailable,
    distanceTransit: unavailable,
  );
}

/// Port fuer Kurzzusammenfassungen von Directions (Auto + OePNV) zwischen
/// zwei frei formulierten Orten.
///
/// Wird von Chat-Antworten und UI-Hinweisen genutzt. Die Implementierung
/// kann echt sein (z.B. Google Maps Directions) oder Fake
/// (Inline-Fahrzeittabelle, GTFS-Berechnung, ...). Der MVP-Default ist
/// Fake — siehe ADR-03 und ADR-05.
abstract interface class DirectionsPort {
  Future<DirectionsSummary> summarize({
    required String origin,
    required String destination,
  });
}
