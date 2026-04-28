class GuaranteeClaim {
  const GuaranteeClaim({
    required this.id,
    required this.tripId,
    required this.triggerId,
    required this.reasonCode,
    required this.evaluationLog,
    required this.createdAt,
    required this.status,
    this.compensationCents,
  });

  final String id;
  final String tripId;

  /// Trigger IDs per M07: T-01..T-08
  final String triggerId;

  /// Stable machine-readable reason derived from trigger matrix / evaluation.
  final String reasonCode;

  /// Full evaluation trace for audit/debug (deterministic, ordered).
  final List<String> evaluationLog;

  final DateTime createdAt;
  final GuaranteeClaimStatus status;

  /// M07: optional; generic pipeline may leave null.
  final int? compensationCents;
}

class GuaranteeClaimRequest {
  const GuaranteeClaimRequest({
    required this.tripId,
    required this.triggerId,
    this.userNote,
  });

  final String tripId;
  final String triggerId;
  final String? userNote;
}

enum GuaranteeClaimStatus {
  /// Generic / legacy pipeline
  open,
  inReview,
  approved,
  rejected,
  /// M07 workflow
  draft,
  pending,
}
