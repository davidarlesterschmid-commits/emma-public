/// Support artifact raised by the journey domain for downstream
/// CRM/service handling.
///
/// This type intentionally lives in `domain_journey` so the journey aggregate
/// can stay independent from `domain_customer_service`. Downstream adapters or
/// feature layers may map it into their own canonical CRM/support contracts.
class JourneySupportCase {
  const JourneySupportCase({
    required this.caseId,
    required this.journeyId,
    required this.sourceModule,
    required this.reasonCode,
    required this.severity,
    required this.payloadSnapshot,
    required this.caseStatus,
  });

  final String caseId;
  final String journeyId;
  final String sourceModule;
  final String reasonCode;
  final String severity;
  final Map<String, dynamic> payloadSnapshot;
  final String caseStatus;

  Map<String, dynamic> toJson() {
    return {
      'case_id': caseId,
      'journey_id': journeyId,
      'source_module': sourceModule,
      'reason_code': reasonCode,
      'severity': severity,
      'payload_snapshot': payloadSnapshot,
      'case_status': caseStatus,
    };
  }
}

/// Reporting artifact emitted by journey orchestration.
///
/// Kept local to `domain_journey` to avoid a direct dependency from the
/// journey domain into `domain_reporting`. Reporting pipelines can map this
/// shape into their canonical event model at the boundary.
class JourneyReportingEvent {
  const JourneyReportingEvent({
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
