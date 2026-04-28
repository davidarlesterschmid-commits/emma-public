import 'package:meta/meta.dart';

/// Eine Karten-/Sucheinheit aus einer Open-Data-Quelle (z. B. Nominatim).
@immutable
class PoiResult {
  const PoiResult({
    required this.id,
    required this.displayName,
    this.lat,
    this.lon,
  });

  /// Stabiler Anbieter-Key, z. B. Nominatim `place_id`.
  final String id;
  final String displayName;
  final double? lat;
  final double? lon;
}
