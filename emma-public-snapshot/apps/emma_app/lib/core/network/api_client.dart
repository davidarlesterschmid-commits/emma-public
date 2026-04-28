import 'package:dio/dio.dart';

/// Thin wrapper around a [Dio] instance.
///
/// Preferred construction path: resolve via `apiClientProvider`
/// (in `emma_app/core/infra_providers.dart`), which wires the Dio
/// instance from [appEnvironmentProvider]. Legacy call sites that
/// still instantiate `ApiClient()` directly are supported via a
/// detached Dio with a clearly marked placeholder base URL — these
/// must be migrated in the API-client consolidation follow-up.
class ApiClient {
  ApiClient.fromDio(this._dio);

  /// Legacy no-arg constructor. Creates a detached Dio with a
  /// placeholder base URL. This bypasses [appEnvironmentProvider]
  /// and is only kept so existing feature modules keep compiling.
  ///
  /// Deprecated: migrate to `apiClientProvider` / `dioProvider`.
  @Deprecated(
    'Use ref.watch(apiClientProvider) instead. '
    'This constructor ignores the active AppEnvironment and should be '
    'removed once the employer_mobility and journey_engine modules are '
    'migrated to provider-based DI.',
  )
  ApiClient()
    : _dio = Dio(
        BaseOptions(
          // Intentionally invalid — forces a 4xx/connect-error so that
          // misuse surfaces loudly instead of hitting a random host.
          baseUrl: 'https://api.invalid.emma.local',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      ) {
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  final Dio _dio;

  Dio get dio => _dio;
}
