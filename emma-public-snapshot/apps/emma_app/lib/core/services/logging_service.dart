import 'package:flutter/foundation.dart';

class LoggingService {
  void log(String message) {
    debugPrint('[LOG] $message');
  }

  void logError(String error) {
    debugPrint('[ERROR] $error');
  }
}
