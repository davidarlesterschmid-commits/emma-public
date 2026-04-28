import 'package:flutter/foundation.dart';

class MonitoringService {
  void trackEvent(String event) {
    debugPrint('[MONITOR] $event');
  }
}
