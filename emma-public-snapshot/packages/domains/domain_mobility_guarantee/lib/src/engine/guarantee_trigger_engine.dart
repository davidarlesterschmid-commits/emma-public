import 'package:domain_mobility_guarantee/src/engine/guarantee_evaluation_context.dart';
import 'package:domain_mobility_guarantee/src/m07/guarantee_trigger_id.dart';
import 'package:emma_contracts/emma_contracts.dart';

const String m07EngineVersion = 'M07-Engine/1.0.0+emm91';

class GuaranteeTriggerEngine {
  const GuaranteeTriggerEngine();

  GuaranteeClaim? evaluate({
    required RealtimeEvent event,
    required GuaranteeEvaluationContext context,
  }) {
    if (!context.isBookedTrip(event.tripId)) {
      return null;
    }

    final hour = context.localClockHour ?? event.localClockHour;
    final candidates = <GuaranteeTriggerId, String>{};

    switch (event.kind) {
      case RealtimeEventKind.trainCancelled:
        _add(
          candidates,
          GuaranteeTriggerId.t01,
          'Ereignis: trainCancelled; trip=${event.tripId}; T-01',
        );
      case RealtimeEventKind.delay:
        _evaluateDelay(event, candidates);
      case RealtimeEventKind.lineOutOfService:
        final minutes = event.lineOutOfServiceMinutes;
        if (minutes != null && minutes > 120) {
          _add(
            candidates,
            GuaranteeTriggerId.t05,
            'Ereignis: lineOutOfService; outOfServiceMinutes=$minutes; T-05',
          );
        }
      case RealtimeEventKind.lastConnectionOfDayFailed:
        if (_isNightWindow(hour) && !event.hasAlternativeConnection) {
          _add(
            candidates,
            GuaranteeTriggerId.t04,
            'Ereignis: lastConnectionOfDayFailed; nacht; keine Alt.; T-04',
          );
        }
      case RealtimeEventKind.missedConnectionDueToDelay:
        _evaluateT06(event, candidates);
      case RealtimeEventKind.userSelfReport:
        _add(
          candidates,
          GuaranteeTriggerId.t08,
          'Ereignis: userSelfReport; T-08',
        );
      // Generic journey stream (domain_guarantee) — not part of the M07 matrix.
      case RealtimeEventKind.tripCancelled:
      case RealtimeEventKind.delayUpdated:
      case RealtimeEventKind.missedConnection:
        break;
    }

    if (candidates.isEmpty) {
      return null;
    }

    final winner = _pickDominant(candidates.keys.toList());
    if (winner == null) {
      return null;
    }
    final log = candidates[winner]!;
    final specId = winner.specId;
    if (context.existingClaimKeys
        .contains(claimDedupeKey(event.tripId, specId))) {
      return null;
    }

    return _toClaim(
      event: event,
      trigger: winner,
      reasonCode: 'M07-${winner.specId}',
      evaluationLog: [
        m07EngineVersion,
        if (event.id != null) 'eventId=${event.id}',
        'selected=${winner.specId}: ${winner.label}',
        log,
      ],
    );
  }

  void _evaluateDelay(RealtimeEvent event, Map<GuaranteeTriggerId, String> out) {
    final d = event.delayMinutes;
    if (d == null) {
      return;
    }
    if (d > 60) {
      _add(out, GuaranteeTriggerId.t03, 'delay; delayMinutes=$d; T-03');
    } else if (d > 20) {
      _add(out, GuaranteeTriggerId.t02, 'delay; delayMinutes=$d; T-02');
    }
  }

  void _evaluateT06(
    RealtimeEvent event,
    Map<GuaranteeTriggerId, String> out,
  ) {
    final buffer = event.plannedTransferBufferMinutes;
    final prev = event.previousLegDelayMinutes;
    if (buffer == null || prev == null) {
      return;
    }
    if (buffer <= 5 && prev > buffer) {
      _add(
        out,
        GuaranteeTriggerId.t06,
        'missedConnection; puffer=$buffer; vorfahrt=$prev; T-06',
      );
    }
  }

  void _add(
    Map<GuaranteeTriggerId, String> m,
    GuaranteeTriggerId id,
    String line,
  ) {
    m[id] = line;
  }

  GuaranteeTriggerId? _pickDominant(List<GuaranteeTriggerId> ids) {
    if (ids.isEmpty) {
      return null;
    }
    if (ids.contains(GuaranteeTriggerId.t03) &&
        ids.contains(GuaranteeTriggerId.t02)) {
      return GuaranteeTriggerId.t03;
    }
    ids.sort((a, b) => b.specId.compareTo(a.specId));
    return ids.first;
  }

  bool _isNightWindow(int? localHour) {
    if (localHour == null) {
      return false;
    }
    return localHour >= 22 || localHour < 4;
  }

  GuaranteeClaim _toClaim({
    required RealtimeEvent event,
    required GuaranteeTriggerId trigger,
    required String reasonCode,
    required List<String> evaluationLog,
  }) {
    final spec = trigger.specId;
    final id = 'claim-${event.tripId}-$spec';
    return GuaranteeClaim(
      id: id,
      tripId: event.tripId,
      triggerId: spec,
      reasonCode: reasonCode,
      evaluationLog: List<String>.unmodifiable(evaluationLog),
      createdAt: event.occurredAt,
      status: trigger == GuaranteeTriggerId.t08
          ? GuaranteeClaimStatus.inReview
          : GuaranteeClaimStatus.draft,
      compensationCents: _compensationCents(trigger),
    );
  }

  int? _compensationCents(GuaranteeTriggerId t) {
    return switch (t) {
      GuaranteeTriggerId.t01 => 500,
      GuaranteeTriggerId.t02 => 500,
      GuaranteeTriggerId.t03 => 1500,
      GuaranteeTriggerId.t04 => null,
      GuaranteeTriggerId.t05 => 1000,
      GuaranteeTriggerId.t06 => 500,
      GuaranteeTriggerId.t08 => null,
    };
  }
}
