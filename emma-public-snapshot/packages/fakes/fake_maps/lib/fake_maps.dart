/// Fake implementation of [DirectionsPort] for MVP and tests.
///
/// Default adapter under ADR-03 (MVP-without-paid-APIs). The live
/// Google-Maps adapter lives in `package:adapter_maps`.
library;

export 'src/fake_directions_adapter.dart';
export 'src/fake_journey_routing_adapter.dart';
export 'src/fake_poi_search_adapter.dart' show FakePoiSearchAdapter;
