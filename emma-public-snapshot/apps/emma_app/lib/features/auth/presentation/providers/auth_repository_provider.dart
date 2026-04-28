import 'package:emma_app/core/infra_providers.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [AuthRepository] and its datasources (Dio, secure storage).
///
/// Isolated so [AuthNotifier] can depend on this file without pulling in
/// account/invoice wiring (avoids an import cycle with
/// [authAccountProviders] / [authNotifierProvider]).
final _authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(dioProvider));
});

final _authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(ref.watch(secureStorageProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remote: ref.watch(_authRemoteDataSourceProvider),
    local: ref.watch(_authLocalDataSourceProvider),
  );
});
