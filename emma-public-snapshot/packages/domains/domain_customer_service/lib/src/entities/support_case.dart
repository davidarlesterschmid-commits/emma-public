/// Snapshot of a customer-service case raised during a journey or after
/// a partner/incident handoff.
///
/// Pure domain entity: no Flutter, no transport. The CRM / service
/// backend is the source of truth; this class is the wire-compatible
/// snapshot the emma app can hand around between features.
class SupportCase {
  const SupportCase({
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
