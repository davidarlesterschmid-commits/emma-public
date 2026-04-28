// Canonical realtime + M07 (Mobilitaetsgarantie) union — single export surface for emma_contracts.
//
// * Trip-level stream events (journey) use: tripCancelled, delayUpdated, lineOutOfService, missedConnection.
// * M07 engine uses: trainCancelled, delay, lineOutOfService, lastConnectionOfDayFailed,
//   missedConnectionDueToDelay, userSelfReport.
class RealtimeEvent {
  const RealtimeEvent({
    this.id,
    required this.tripId,
    required this.occurredAt,
    required this.kind,
    this.delayMinutes,
    this.lineOutOfServiceMinutes,
    this.isLastConnectionOfDay,
    this.missedConnectionPlannedBufferMinutes,
    this.localClockHour,
    this.hasAlternativeConnection = true,
    this.plannedTransferBufferMinutes,
    this.previousLegDelayMinutes,
  });

  final String? id;
  final String tripId;
  final DateTime occurredAt;

  final RealtimeEventKind kind;

  /// For delay-based triggers (T-02/T-03) and [delayUpdated] / [delay] kinds.
  final int? delayMinutes;

  /// For line-out-of-service trigger (T-05).
  final int? lineOutOfServiceMinutes;

  /// For last-connection-of-day trigger in the generic [missedConnection] case.
  final bool? isLastConnectionOfDay;

  /// For missed-connection case (T-06) in the generic engine.
  final int? missedConnectionPlannedBufferMinutes;

  /// M07: optional local wall-clock hour (e.g. T-04).
  final int? localClockHour;

  /// M07: whether an alternative connection exists (T-04).
  final bool hasAlternativeConnection;

  /// M07: T-06.
  final int? plannedTransferBufferMinutes;

  /// M07: T-06.
  final int? previousLegDelayMinutes;
}

enum RealtimeEventKind {
  /// Generic trip cancellation.
  tripCancelled,
  /// Generic delay / ETA update.
  delayUpdated,
  /// Generic planned missed-connection signal.
  missedConnection,
  lineOutOfService,

  /// M07: train / trip cancelled.
  trainCancelled,
  /// M07: delay (trigger matrix).
  delay,
  lastConnectionOfDayFailed,
  missedConnectionDueToDelay,
  userSelfReport,
}
