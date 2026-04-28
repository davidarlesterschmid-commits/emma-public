import 'dart:async';

import 'package:emma_contracts/emma_contracts.dart';

class MobilityGuaranteeTriggerEngine {
  MobilityGuaranteeTriggerEngine({
    required this.realtimePort,
    required this.mobilityGuaranteePort,
    required this.notificationPort,
    required this.now,
  });

  final RealtimePort realtimePort;
  final MobilityGuaranteePort mobilityGuaranteePort;
  final NotificationPort notificationPort;

  /// Injected for deterministic tests and time-window logic (T-04).
  final DateTime Function() now;

  /// Streams newly detected, deduplicated claim candidates.
  Stream<GuaranteeClaim> watchClaimsFor({required List<String> tripIds}) async* {
    final emittedKeys = <String>{};

    await for (final event in realtimePort.eventsFor(tripIds: tripIds)) {
      final evaluation = _evaluate(event);
      if (evaluation == null) continue;

      final key = _dedupeKey(evaluation.tripId, evaluation.triggerId);
      if (emittedKeys.contains(key)) continue;
      emittedKeys.add(key);

      await notificationPort.notifyGuaranteeClaimable(evaluation);
      yield evaluation;
    }
  }

  GuaranteeClaim? _evaluate(RealtimeEvent event) {
    final log = <String>[
      'event.kind=${event.kind}',
      'event.tripId=${event.tripId}',
      if (event.delayMinutes != null) 'event.delayMinutes=${event.delayMinutes}',
      if (event.lineOutOfServiceMinutes != null)
        'event.lineOutOfServiceMinutes=${event.lineOutOfServiceMinutes}',
      if (event.isLastConnectionOfDay != null)
        'event.isLastConnectionOfDay=${event.isLastConnectionOfDay}',
      if (event.missedConnectionPlannedBufferMinutes != null)
        'event.missedConnectionPlannedBufferMinutes=${event.missedConnectionPlannedBufferMinutes}',
    ];

    switch (event.kind) {
      case RealtimeEventKind.tripCancelled:
        return _claim(
          tripId: event.tripId,
          triggerId: 'T-01',
          reasonCode: 'trip_cancelled',
          log: log..add('matched=T-01'),
        );
      case RealtimeEventKind.delayUpdated:
        final delay = event.delayMinutes ?? 0;
        if (delay > 60) {
          return _claim(
            tripId: event.tripId,
            triggerId: 'T-03',
            reasonCode: 'arrival_delay_gt_60m',
            log: log..add('matched=T-03'),
          );
        }
        if (delay > 20) {
          return _claim(
            tripId: event.tripId,
            triggerId: 'T-02',
            reasonCode: 'arrival_delay_gt_20m',
            log: log..add('matched=T-02'),
          );
        }
        return null;
      case RealtimeEventKind.lineOutOfService:
        final minutes = event.lineOutOfServiceMinutes ?? 0;
        if (minutes > 120) {
          return _claim(
            tripId: event.tripId,
            triggerId: 'T-05',
            reasonCode: 'line_out_of_service_gt_120m',
            log: log..add('matched=T-05'),
          );
        }
        return null;
      case RealtimeEventKind.missedConnection:
        final delay = event.delayMinutes ?? 0;
        final buffer = event.missedConnectionPlannedBufferMinutes ?? 0;
        if (delay > buffer) {
          final isNightWindow = _isNightWindow(now());
          final isLast = event.isLastConnectionOfDay ?? false;
          if (isLast && isNightWindow) {
            return _claim(
              tripId: event.tripId,
              triggerId: 'T-04',
              reasonCode: 'last_connection_failed_night_window',
              log: log..add('matched=T-04'),
            );
          }
          return _claim(
            tripId: event.tripId,
            triggerId: 'T-06',
            reasonCode: 'missed_connection_due_to_delay',
            log: log..add('matched=T-06'),
          );
        }
        return null;
      // M07-only kinds (see emma_contracts RealtimeEventKind) — handled by domain_mobility_guarantee.
      case RealtimeEventKind.trainCancelled:
      case RealtimeEventKind.delay:
      case RealtimeEventKind.lastConnectionOfDayFailed:
      case RealtimeEventKind.missedConnectionDueToDelay:
      case RealtimeEventKind.userSelfReport:
        return null;
    }
  }

  GuaranteeClaim _claim({
    required String tripId,
    required String triggerId,
    required String reasonCode,
    required List<String> log,
  }) {
    return GuaranteeClaim(
      id: 'candidate:$tripId:$triggerId',
      tripId: tripId,
      triggerId: triggerId,
      reasonCode: reasonCode,
      evaluationLog: List<String>.unmodifiable(log),
      createdAt: now(),
      status: GuaranteeClaimStatus.open,
    );
  }

  static bool _isNightWindow(DateTime dt) {
    final hour = dt.hour;
    // Spec: between 22:00 and 04:00 local.
    return hour >= 22 || hour < 4;
  }

  static String _dedupeKey(String tripId, String triggerId) => '$tripId|$triggerId';
}
