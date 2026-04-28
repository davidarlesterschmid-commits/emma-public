import 'package:emma_contracts/src/models/poi_result.dart' show PoiResult;

/// Suche von Interessenspunkten (Open-Data, z. B. Nominatim) — ohne
/// kostenpflichtige Dritt-APIs.
abstract interface class PoiSearchPort {
  Future<List<PoiResult>> search({required String query, int limit});
}
