import 'package:emma_contracts/emma_contracts.dart' show PoiResult, PoiSearchPort;

/// In-memory [PoiSearchPort] für den MVP-Default; keine Netzaufrufe.
class FakePoiSearchAdapter implements PoiSearchPort {
  const FakePoiSearchAdapter();

  @override
  Future<List<PoiResult>> search({required String query, int limit = 5}) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const <PoiResult>[];
    if (q.contains('hbf') || q.contains('bahnhof') || q.contains('leipzig')) {
      return <PoiResult>[
        PoiResult(
          id: 'fake:leipzig-hbf',
          displayName: 'Leipzig Hauptbahnhof, Leipzig, Deutschland',
          lat: 51.3450,
          lon: 12.3808,
        ),
        PoiResult(
          id: 'fake:halle-hbf',
          displayName: 'Halle (Saale) Hauptbahnhof, Deutschland',
          lat: 51.4775,
          lon: 11.9870,
        ),
      ];
    }
    return const <PoiResult>[];
  }
}
