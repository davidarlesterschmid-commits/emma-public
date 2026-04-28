/// Base type for recoverable identity failures.
///
/// Thrown by [AuthRepository] and [AccountRepository] implementations.
/// Presentation layers translate these to UI messages; they MUST NOT
/// leak transport-level exceptions (Dio errors, socket exceptions) into
/// ViewModels.
sealed class IdentityFailure implements Exception {
  const IdentityFailure(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Credentials could not be verified by the identity provider.
class InvalidCredentialsFailure extends IdentityFailure {
  const InvalidCredentialsFailure([super.message = 'Invalid credentials']);
}

/// The identity provider was reachable but refused the request
/// (e.g. locked account, expired consent).
class IdentityRejectedFailure extends IdentityFailure {
  const IdentityRejectedFailure(super.message);
}

/// Network or upstream outage while contacting the identity provider.
class IdentityUnavailableFailure extends IdentityFailure {
  const IdentityUnavailableFailure([
    super.message = 'Identity provider unreachable',
  ]);
}

/// No active session. Caller should route to login.
class NotAuthenticatedFailure extends IdentityFailure {
  const NotAuthenticatedFailure([super.message = 'Not authenticated']);
}
