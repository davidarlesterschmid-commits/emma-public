import 'dart:developer' as developer;

/// Flutter-free event-tracking facade.
///
/// Replace with a real sink (Firebase, Segment) from the app shell.
class MonitoringService {
  const MonitoringService();

  void trackEvent(String event, {Map<String, Object?>? attributes}) {
    developer.log(event, name: 'emma.monitor', error: attributes);
  }
}
