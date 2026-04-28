import 'dart:developer' as developer;

/// Flutter-free logger facade.
///
/// Kept intentionally thin — feature packages depend on the interface,
/// concrete sinks (Sentry, Datadog, etc.) are wired from the app shell.
class LoggingService {
  const LoggingService();

  void log(String message) {
    developer.log(message, name: 'emma.log');
  }

  void logError(String error, {Object? cause, StackTrace? stackTrace}) {
    developer.log(
      error,
      name: 'emma.error',
      level: 1000,
      error: cause,
      stackTrace: stackTrace,
    );
  }
}
