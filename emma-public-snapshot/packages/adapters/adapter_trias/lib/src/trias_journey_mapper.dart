import 'package:domain_journey/domain_journey.dart';

/// Maps TRIAS TripResult DTOs to [Journey] domain entities.
///
/// Mapping rules are canonically defined in docs/technical/trip_boundary_mapping_rules.md.
class TriasJourneyMapper {
  const TriasJourneyMapper._();

  /// Convert a parsed TRIAS TripResult map to a [Journey].
  static Journey fromTripResult(Map<String, dynamic> tripResult) {
    // TODO(adapter_trias): parse tripResult fields per mapping rules
    // Fields: legs, departureTime, totalDurationSeconds, fare
    throw UnimplementedError(
      'TriasJourneyMapper.fromTripResult not yet implemented',
    );
  }
}
