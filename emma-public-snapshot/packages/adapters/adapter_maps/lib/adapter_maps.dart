/// Public API of `adapter_maps`.
///
/// Primary adapter: [GoogleMapsDirectionsAdapter] implementing
/// [DirectionsPort] from `package:emma_contracts`. Paid Google-Maps-API,
/// aktiviert nur wenn `USE_FAKES=false` (ADR-03 / ADR-05).
///
/// Der frueher exportierte Deprecation-Alias `MapsService` ist mit
/// Teil-Inkrement 3c entfernt. Konsumenten muessen gegen
/// [DirectionsPort] programmieren.
library;

export 'src/google_maps_directions_adapter.dart';
export 'src/mdv_routing_adapter.dart';
export 'src/open_data/directions_open_data_adapter.dart' show
    DirectionsOpenDataAdapter;
export 'src/open_data/poi_nominatim_adapter.dart' show PoiNominatimAdapter;
