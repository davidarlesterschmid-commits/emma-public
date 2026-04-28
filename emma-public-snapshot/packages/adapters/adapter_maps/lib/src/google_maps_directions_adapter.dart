import 'dart:convert';

import 'package:emma_contracts/emma_contracts.dart';
import 'package:http/http.dart' as http;

/// Live-[DirectionsPort] gegen die Google-Maps-Directions-API.
///
/// Der API-Key wird explizit vom Composition-Root uebergeben; der
/// Adapter liest selbst kein `dotenv`. Damit bleibt das Paket
/// Test-freundlich und ohne Flutter-Abhaengigkeit.
///
/// Achtung: Kostenpflichtig. Im MVP (ADR-03 / ADR-05) ist dieser
/// Adapter ausgeschaltet — der Default ist `FakeDirectionsAdapter`
/// aus `package:fake_maps`. Dieser Adapter aktiviert sich erst, wenn
/// `USE_FAKES=false` gebaut wird UND ein gueltiger Key vorhanden ist.
class GoogleMapsDirectionsAdapter implements DirectionsPort {
  GoogleMapsDirectionsAdapter({required this.apiKey, http.Client? httpClient})
      : _client = httpClient ?? http.Client();

  final String apiKey;
  final http.Client _client;

  @override
  Future<DirectionsSummary> summarize({
    required String origin,
    required String destination,
  }) async {
    if (apiKey.isEmpty) {
      return DirectionsSummary.empty;
    }
    final driving = await _fetchRoute(origin, destination, 'driving');
    final transit = await _fetchRoute(origin, destination, 'transit');

    return DirectionsSummary(
      durationDriving:
          driving['duration'] ?? DirectionsSummary.unavailable,
      distanceDriving:
          driving['distance'] ?? DirectionsSummary.unavailable,
      durationTransit:
          transit['duration'] ?? DirectionsSummary.unavailable,
      distanceTransit:
          transit['distance'] ?? DirectionsSummary.unavailable,
    );
  }

  Future<Map<String, String>> _fetchRoute(
    String origin,
    String destination,
    String mode,
  ) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json'
      '?origin=${Uri.encodeComponent(origin)}'
      '&destination=${Uri.encodeComponent(destination)}'
      '&mode=$mode'
      '&language=de'
      '&key=$apiKey',
    );

    try {
      final response = await _client.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final routes = data['routes'];
        if (routes is List && routes.isNotEmpty) {
          final leg = routes[0]['legs'][0];
          return {
            'duration': leg['duration']['text'] as String,
            'distance': leg['distance']['text'] as String,
          };
        }
      }
    } catch (_) {
      // Netzfehler/Parse-Fehler → "Nicht verfuegbar"-Fallback via
      // leere Map; der Wrapper fuellt die Summary auf.
    }
    return const <String, String>{};
  }
}
