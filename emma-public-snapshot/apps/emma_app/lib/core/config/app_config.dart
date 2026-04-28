import 'package:emma_app/bootstrap/app_environment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Root provider for the resolved [AppEnvironment].
///
/// Must be overridden at the [ProviderScope] root by [bootstrap].
/// Every feature, repository or datasource that needs environment-scoped
/// configuration (API base URL, flavor, feature flags, ...) must read it
/// via this provider — never hard-code URLs or flavors.
final appEnvironmentProvider = Provider<AppEnvironment>((ref) {
  throw StateError(
    'appEnvironmentProvider was read without an override. '
    'Make sure ProviderScope overrides it at app start (see bootstrap.dart).',
  );
});

/// Statische Build-Time-Konfiguration.
///
/// Wird ueber `--dart-define=KEY=VALUE` beim Build gesetzt. Fuer den MVP
/// (ADR-03 / ADR-05) ist [useFakes] standardmaessig `true` — MVP-Maxime:
/// Open-Source/Fake-First; kostenpflichtige Cloud-APIs (Google Maps, Gemini)
/// erst ab Livegang, nicht fuer MVP-Abnahme. Nur Builds mit
/// `--dart-define=USE_FAKES=false` und definierten Keys sprechen Echt-Adapter an.
class AppConfig {
  const AppConfig._();

  /// MVP-Default `true` — siehe ADR-03 ("Keine kostenpflichtigen APIs
  /// im MVP") und ADR-05 ("Chat- und Directions-Adapter hinter Ports").
  static const bool useFakes = bool.fromEnvironment(
    'USE_FAKES',
    defaultValue: true,
  );

  /// Nur Livegang: wenn [useFakes] `false`. Google Maps ist kein MVP-Standard
  /// (ADR-03 Open-Source-Maxime). Key per
  /// `--dart-define=GOOGLE_MAPS_API_KEY=...` (kein `.env` im App-Bundle).
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  /// Nur wenn [useFakes] `false` ist. Set per
  /// `--dart-define=GEMINI_API_KEY=...`.
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  /// Nominatim (ODbL) — Geocoding & POI-Suche, ohne kostenpflichtige API.
  /// Fuer produktive Last: eigener Tile-/Proxy- oder Dienst-Host, siehe
  /// [docs/technical/ENTWICKLER.md].
  static const String nominatimBaseUrl = String.fromEnvironment(
    'NOMINATIM_BASE_URL',
    defaultValue: 'https://nominatim.openstreetmap.org',
  );

  /// OSRM-Demo-Instanz (BSD-2-Clause) — Fahrzeiten/Strasse; kein
  /// Dauerbetrieb in Produktionsqualitaet, bis selbst gehostet.
  static const String osrmBaseUrl = String.fromEnvironment(
    'OSRM_BASE_URL',
    defaultValue: 'https://router.project-osrm.org',
  );

  /// Muss laut Nominatim-Policy pro Installation gesetzt werden.
  static const String nominatimUserAgent = String.fromEnvironment(
    'NOMINATIM_USER_AGENT',
    defaultValue: 'emma/0.1 (Open-Data routing+poi; dev)',
  );
}
