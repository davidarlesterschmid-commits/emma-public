import 'package:domain_identity/src/entities/user_account.dart';

/// Contract for customer-account data: roles, contracts, preferences.
///
/// Read-heavy; writes are narrow on purpose (preferences only for now).
/// Profile edits against the identity provider belong on
/// [AuthRepository] or a dedicated ProfileRepository once a real IdP
/// is wired in.
abstract interface class AccountRepository {
  /// Returns the full account view for the currently-authenticated user.
  ///
  /// Throws [NotAuthenticatedFailure] when no session is active.
  Future<UserAccount> getUserAccount();

  /// Persists a flat preference map. Schema is intentionally opaque so
  /// it can be reshaped without breaking feature code.
  Future<void> updatePreferences(Map<String, dynamic> prefs);
}
