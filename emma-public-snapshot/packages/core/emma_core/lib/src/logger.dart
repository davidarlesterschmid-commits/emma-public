import 'dart:developer' as developer;

class EmmaLogger {
  const EmmaLogger._();

  static void info(String message) {
    developer.log(message, name: 'emma.info');
  }

  static void warning(String message) {
    developer.log(message, name: 'emma.warning');
  }

  static void error(String message, [Object? error]) {
    developer.log(message, name: 'emma.error', error: error);
  }
}
