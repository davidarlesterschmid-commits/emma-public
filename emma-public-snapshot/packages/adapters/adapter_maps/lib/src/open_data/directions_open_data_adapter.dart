import 'dart:convert';

import 'package:emma_contracts/emma_contracts.dart' show DirectionsPort, DirectionsSummary;
import 'package:http/http.dart' as http;

/// [DirectionsPort] against **Nominatim** (geocoding, ODbL) and **OSRM**
/// public demo (free as in beer, not for heavy production; host your own
/// for scale). Keine Google-Key erforderlich.
///
/// **ÖPNV-Zeile:** OSRM-Profil `foot` als grobe Distanz-/Zeit-**Annäherung**,
/// bis TRIAS/ÖPNV angebunden ist (siehe [RoutingPort] / TRIAS-Adapter).
class DirectionsOpenDataAdapter implements DirectionsPort {
  DirectionsOpenDataAdapter({
    this.nominatimBaseUrl = 'https://nominatim.openstreetmap.org',
    this.osrmBaseUrl = 'https://router.project-osrm.org',
    this.userAgent = 'emma/0.1 (Open-Data; local dev)',
    http.Client? httpClient,
  }) : _client = httpClient ?? http.Client();

  static const _europeBbox = '5.0,47.0,15.0,55.0';

  final String nominatimBaseUrl;
  final String osrmBaseUrl;
  final String userAgent;
  final http.Client _client;

  @override
  Future<DirectionsSummary> summarize({
    required String origin,
    required String destination,
  }) async {
    final o = origin.trim();
    final d = destination.trim();
    if (o.isEmpty || d.isEmpty) {
      return DirectionsSummary.empty;
    }
    final a = await _geocode(o);
    final b = await _geocode(d);
    if (a == null || b == null) {
      return DirectionsSummary.empty;
    }
    if ((a.lon - b.lon).abs() < 1e-5 && (a.lat - b.lat).abs() < 1e-5) {
      return DirectionsSummary.empty;
    }
    final car = await _osrm('driving', a.lon, a.lat, b.lon, b.lat);
    final foot = await _osrm('foot', a.lon, a.lat, b.lon, b.lat);
    return DirectionsSummary(
      durationDriving: car.durationText,
      distanceDriving: car.distanceText,
      durationTransit: foot.durationText,
      distanceTransit: foot.distanceText,
    );
  }

  Future<_Geo?> _geocode(String q) async {
    final uri = Uri.parse(nominatimBaseUrl).replace(
      path: '/search',
      queryParameters: <String, String>{
        'q': q,
        'format': 'json',
        'limit': '1',
        'viewbox': _europeBbox,
        'bounded': '1',
      },
    );
    try {
      final res = await _client.get(
        uri,
        headers: <String, String>{'User-Agent': userAgent},
      );
      if (res.statusCode != 200) return null;
      final data = jsonDecode(res.body) as List<dynamic>?;
      if (data == null || data.isEmpty) return null;
      final o = data.first as Map<String, dynamic>;
      final lat = double.tryParse(o['lat']?.toString() ?? '');
      final lon = double.tryParse(o['lon']?.toString() ?? '');
      if (lat == null || lon == null) return null;
      return _Geo(lat: lat, lon: lon);
    } catch (_) {
      return null;
    }
  }

  Future<_RouteFmt> _osrm(
    String profile,
    double fromLon,
    double fromLat,
    double toLon,
    double toLat,
  ) async {
    final path =
        '/route/v1/$profile/$fromLon,$fromLat;$toLon,$toLat'
        '?overview=false&alternatives=false&steps=false';
    final uri = Uri.parse(osrmBaseUrl).replace(path: path);
    try {
      final res = await _client.get(
        uri,
        headers: <String, String>{'User-Agent': userAgent},
      );
      if (res.statusCode != 200) {
        return const _RouteFmt('Nicht verfuegbar', 'Nicht verfuegbar');
      }
      final data = jsonDecode(res.body) as Map<String, dynamic>?;
      final routes = data?['routes'] as List<dynamic>?;
      if (routes == null || routes.isEmpty) {
        return const _RouteFmt('Nicht verfuegbar', 'Nicht verfuegbar');
      }
      final r = routes.first as Map<String, dynamic>;
      final durationSec = (r['duration'] as num?)?.toDouble() ?? 0;
      final distanceM = (r['distance'] as num?)?.toDouble() ?? 0;
      if (durationSec <= 0 || distanceM <= 0) {
        return const _RouteFmt('Nicht verfuegbar', 'Nicht verfuegbar');
      }
      return _RouteFmt(
        _formatDurationDe(durationSec),
        _formatDistanceDe(distanceM),
      );
    } catch (_) {
      return const _RouteFmt('Nicht verfuegbar', 'Nicht verfuegbar');
    }
  }

  String _formatDurationDe(double seconds) {
    final totalMin = (seconds / 60).round();
    if (totalMin < 60) {
      return '$totalMin Min.';
    }
    final h = totalMin ~/ 60;
    final m = totalMin % 60;
    return m == 0 ? '$h Std.' : '$h Std. $m Min.';
  }

  String _formatDistanceDe(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    }
    final km = meters / 1000;
    return '${km.toStringAsFixed(1).replaceAll('.', ',')} km';
  }
}

class _Geo {
  const _Geo({required this.lat, required this.lon});
  final double lat;
  final double lon;
}

class _RouteFmt {
  const _RouteFmt(this.durationText, this.distanceText);
  final String durationText;
  final String distanceText;
}
