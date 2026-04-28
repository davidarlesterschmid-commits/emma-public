import 'dart:convert';

import 'package:emma_contracts/emma_contracts.dart' show PoiResult, PoiSearchPort;
import 'package:http/http.dart' as http;

/// [PoiSearchPort] via **Nominatim** (OpenStreetMap, ODbL, Nutzung mit
/// [userAgent] pro Fair-Use-Policye).
class PoiNominatimAdapter implements PoiSearchPort {
  PoiNominatimAdapter({
    this.baseUrl = 'https://nominatim.openstreetmap.org',
    this.userAgent = 'emma/0.1 (Open-Data; local dev)',
    http.Client? httpClient,
  }) : _client = httpClient ?? http.Client();

  static const _europeBbox = '5.0,47.0,15.0,55.0';

  final String baseUrl;
  final String userAgent;
  final http.Client _client;

  @override
  Future<List<PoiResult>> search({required String query, int limit = 5}) async {
    final q = query.trim();
    if (q.isEmpty) return const <PoiResult>[];
    final cap = limit.clamp(1, 10);
    final uri = Uri.parse(baseUrl).replace(
      path: '/search',
      queryParameters: <String, String>{
        'q': q,
        'format': 'json',
        'limit': cap.toString(),
        'viewbox': _europeBbox,
        'bounded': '0',
        'addressdetails': '0',
      },
    );
    try {
      final res = await _client.get(
        uri,
        headers: <String, String>{'User-Agent': userAgent},
      );
      if (res.statusCode != 200) return const <PoiResult>[];
      final data = jsonDecode(res.body) as List<dynamic>?;
      if (data == null) return const <PoiResult>[];
      final out = <PoiResult>[];
      for (final e in data) {
        if (e is! Map<String, dynamic>) continue;
        final id = e['place_id']?.toString() ?? e['osm_id']?.toString();
        if (id == null) continue;
        final name = e['display_name']?.toString() ?? id;
        final lat = double.tryParse(e['lat']?.toString() ?? '');
        final lon = double.tryParse(e['lon']?.toString() ?? '');
        out.add(
          PoiResult(id: 'nominatim:$id', displayName: name, lat: lat, lon: lon),
        );
      }
      return out;
    } catch (_) {
      return const <PoiResult>[];
    }
  }
}
