enum RealtimeAlertSeverity { info, warning, disruption }

class RealtimeAlert {
  const RealtimeAlert({
    required this.id,
    required this.journeyId,
    required this.message,
    required this.severity,
    required this.observedAt,
  });

  final String id;
  final String journeyId;
  final String message;
  final RealtimeAlertSeverity severity;
  final DateTime observedAt;
}

abstract interface class RealtimeFeedPort {
  Future<List<RealtimeAlert>> alertsForJourney(String journeyId);
}
