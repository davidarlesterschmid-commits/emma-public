import 'package:domain_journey/domain_journey.dart';
import 'package:emma_core/emma_core.dart';

/// Implements [MapRoutingPort] by calling the TRIAS/VDV Trip endpoint.
///
/// Replace [_baseUrl] with the actual MDV TRIAS endpoint in app configuration.
class TriasRoutingAdapter implements MapRoutingPort {
  const TriasRoutingAdapter({required String baseUrl}) : _baseUrl = baseUrl;

  // ignore: unused_field
  final String _baseUrl;

  @override
  Future<Result<List<Journey>>> calculateRoute(
    String originId,
    String destinationId,
  ) async {
    // TODO(adapter_trias): implement HTTP call + XML parsing
    // 1. Build OJP/TRIAS TripRequest from JourneyIntent
    // 2. POST to _baseUrl/trias
    // 3. Parse TripResponse XML
    // 4. Map each TripResult via TriasJourneyMapper.fromTripResult()
    throw UnimplementedError(
      'TriasRoutingAdapter.calculateRoute not yet implemented',
    );
  }
}
