import 'package:dio/dio.dart';
import 'package:emma_app/core/config/app_config.dart';
import 'package:emma_app/core/network/api_client.dart';
import 'package:emma_contracts/emma_contracts.dart'
    show ChatPort, DirectionsPort, PoiSearchPort;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Shared Dio instance. Base URL and timeouts are derived from
/// [appEnvironmentProvider] so they stay in sync with the current flavor
/// (dev / integration / production) — no hard-coded hosts.
final dioProvider = Provider<Dio>((ref) {
  final env = ref.watch(appEnvironmentProvider);
  return Dio(
    BaseOptions(
      baseUrl: env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
});

/// Legacy thin wrapper around [dioProvider].
///
/// New code should depend on [dioProvider] directly.
/// Kept for feature modules that still construct `ApiClient()` by hand —
/// to be migrated in a follow-up cleanup task.
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient.fromDio(ref.watch(dioProvider));
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// App-seitiger Zugriff auf den [DirectionsPort] (ADR-05).
///
/// Wird im [bootstrap] ueberschrieben — je nach [AppConfig.useFakes] mit
/// dem `FakeDirectionsAdapter` (MVP-Default, keine kostenpflichtige API)
/// oder dem `GoogleMapsDirectionsAdapter`. Features und Widgets
/// importieren immer nur diesen Provider und kennen die konkrete
/// Implementation nicht.
final directionsPortProvider = Provider<DirectionsPort>((ref) {
  throw StateError(
    'directionsPortProvider was read without an override. '
    'Make sure ProviderScope overrides it at app start (see bootstrap.dart).',
  );
});

/// App-seitiger Zugriff auf den [ChatPort] (ADR-05).
///
/// Wird im [bootstrap] ueberschrieben — je nach [AppConfig.useFakes] mit
/// dem `FakeChatAdapter` (MVP-Default) oder dem `GeminiChatAdapter`.
final chatPortProvider = Provider<ChatPort>((ref) {
  throw StateError(
    'chatPortProvider was read without an override. '
    'Make sure ProviderScope overrides it at app start (see bootstrap.dart).',
  );
});

/// Open-Data POI- / Orts-Suche (Nominatim). Wird in [bootstrap] mit Fake
/// oder Nominatim-Adapter ueberschrieben.
final poiSearchPortProvider = Provider<PoiSearchPort>((ref) {
  throw StateError(
    'poiSearchPortProvider was read without an override. '
    'Make sure ProviderScope overrides it at app start (see bootstrap.dart).',
  );
});
