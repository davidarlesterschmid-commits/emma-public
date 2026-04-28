/// Canonical event emitted into the reporting / clearing pipeline.
///
/// Pure data: no transport, no Flutter. Consumers (analytics, clearing,
/// ops dashboards) attach their own delivery mechanics.
class ReportingEvent {
  const ReportingEvent({
    required this.eventId,
    required this.journeyId,
    required this.module,
    required this.eventType,
    required this.severity,
    required this.payload,
    required this.occurredAt,
  });

  final String eventId;
  final String journeyId;
  final String module;
  final String eventType;
  final String severity;
  final Map<String, dynamic> payload;
  final DateTime occurredAt;

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'journey_id': journeyId,
      'module': module,
      'event_type': eventType,
      'severity': severity,
      'payload': payload,
      'occurred_at': occurredAt.toIso8601String(),
    };
  }
}
