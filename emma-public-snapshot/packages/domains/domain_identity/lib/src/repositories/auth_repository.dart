import 'package:domain_identity/src/entities/user.dart';

/// Contract between the Identity domain and any identity provider
/// implementation (mock, OIDC/OAuth adapter, TAF-backed, ...).
///
/// Implementations MUST translate transport errors to
/// [IdentityFailure] subclasses — no raw Dio/HTTP exceptions must
/// reach the UI.
abstract interface class AuthRepository {
  /// Returns the active user if a session exists, or `null` when the
  /// caller is logged out. MUST NOT throw [NotAuthenticatedFailure].
  Future<User?> getCurrentUser();

  /// Performs a password-based login.
  ///
  /// Throws [InvalidCredentialsFailure], [IdentityRejectedFailure] or
  /// [IdentityUnavailableFailure] on failure.
  Future<User> login(String email, String password);

  /// Performs an OAuth/OIDC login via a named provider
  /// (e.g. `'google'`, `'apple'`, `'taf'`).
  Future<User> loginWithOAuth(String provider);

  /// Clears the active session. Idempotent.
  Future<void> logout();
}
