class GuaranteeEvaluationContext {
  const GuaranteeEvaluationContext({
    required this.now,
    required this.isBookedTrip,
    required this.existingClaimKeys,
    this.localClockHour,
  });

  final DateTime now;
  final bool Function(String tripId) isBookedTrip;
  final Set<String> existingClaimKeys;
  final int? localClockHour;
}

String claimDedupeKey(String tripId, String triggerSpecId) =>
    '$tripId|$triggerSpecId';
