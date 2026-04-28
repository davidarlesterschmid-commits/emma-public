import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Ports exposed by `feature_employer_mobility` to its host integrator.
///
/// The feature deliberately does NOT depend on `emma_app`'s infra
/// providers. It declares `throw`-default providers here; the host app
/// overrides them at bootstrap so the same shared [Dio] and
/// [FlutterSecureStorage] instances are reused. Test harnesses override
/// with fakes.

/// HTTP client used by the employer-mobility remote data sources.
/// MUST be overridden.
final employerDioProvider = Provider<Dio>((ref) {
  throw StateError(
    'employerDioProvider was read without an override. '
    'Bind it to your app-level Dio provider in ProviderScope.overrides.',
  );
});

/// Secure storage used by the profile-mode local data source.
/// MUST be overridden.
final employerSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  throw StateError(
    'employerSecureStorageProvider was read without an override. '
    'Bind it to your app-level FlutterSecureStorage provider in '
    'ProviderScope.overrides.',
  );
});
