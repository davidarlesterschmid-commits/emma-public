import 'dart:async';

import 'package:domain_mobility_guarantee/domain_mobility_guarantee.dart';
import 'package:emma_contracts/emma_contracts.dart';

const String kM07DemoTripId = 'm07-fake-trip';

DateTime get _kDemoTime => DateTime(2026, 4, 26, 7, 15);

/// In-Memory M07: [MobilityGuaranteePort] + [RealtimePort] + [NotificationPort].
final class FakeM07InMemory
    implements MobilityGuaranteePort, RealtimePort, NotificationPort {
  FakeM07InMemory({Set<String>? bookedTripIds})
    : _booked = Set<String>.from(
        bookedTripIds ?? const <String>{kM07DemoTripId},
      );

  static const _engine = GuaranteeTriggerEngine();

  final Set<String> _booked;
  final Map<String, GuaranteeClaim> _claims = {};
  final Set<String> _dedupe = {};
  final _notifyLog = <GuaranteeClaim>[];
  final _claimAdds = StreamController<GuaranteeClaim>.broadcast();

  List<GuaranteeClaim> get notifiedClaims =>
      List<GuaranteeClaim>.unmodifiable(_notifyLog);

  void ingestDelayDemoT02() {
    unawaited(
      ingest(
        RealtimeEvent(
          id: 'm07-fake-evt-t02',
          tripId: kM07DemoTripId,
          occurredAt: _kDemoTime,
          kind: RealtimeEventKind.delay,
          delayMinutes: 28,
        ),
      ),
    );
  }

  Future<void> ingest(RealtimeEvent event) async {
    final ctx = GuaranteeEvaluationContext(
      now: event.occurredAt,
      isBookedTrip: _booked.contains,
      existingClaimKeys: Set<String>.from(_dedupe),
      localClockHour: event.localClockHour,
    );
    final c = _engine.evaluate(event: event, context: ctx);
    if (c == null) {
      return;
    }
    _dedupe.add(claimDedupeKey(c.tripId, c.triggerId));
    _claims[c.id] = c;
    if (_isOpen(c.status)) {
      _claimAdds.add(c);
    }
    await notifyGuaranteeClaimable(c);
  }

  bool _isOpen(GuaranteeClaimStatus s) =>
      s == GuaranteeClaimStatus.draft || s == GuaranteeClaimStatus.pending;

  List<GuaranteeClaim> _pendingSnapshot() =>
      _claims.values.where((c) => _isOpen(c.status)).toList();

  // --- RealtimePort

  @override
  Stream<RealtimeEvent> eventsFor({required List<String> tripIds}) {
    if (tripIds.isEmpty) {
      return const Stream.empty();
    }
    final tid = tripIds.contains(kM07DemoTripId) ? kM07DemoTripId : tripIds.first;
    return Stream<RealtimeEvent>.fromIterable(
      <RealtimeEvent>[
        RealtimeEvent(
          id: 'demo-t02',
          tripId: tid,
          occurredAt: _kDemoTime,
          kind: RealtimeEventKind.delay,
          delayMinutes: 25,
        ),
        RealtimeEvent(
          id: 'demo-t03',
          tripId: tid,
          occurredAt: _kDemoTime,
          kind: RealtimeEventKind.delay,
          delayMinutes: 70,
        ),
        RealtimeEvent(
          id: 'demo-t04',
          tripId: tid,
          occurredAt: _kDemoTime,
          kind: RealtimeEventKind.lastConnectionOfDayFailed,
          hasAlternativeConnection: false,
          localClockHour: 23,
        ),
      ],
    );
  }

  // --- MobilityGuaranteePort

  @override
  Stream<GuaranteeClaim> pendingClaims() {
    return Stream<GuaranteeClaim>.multi((mc) {
      for (final c in _pendingSnapshot()) {
        mc.add(c);
      }
      final sub = _claimAdds.stream.listen(
        (c) {
          if (_isOpen(c.status)) {
            mc.add(c);
          }
        },
        onError: mc.addError,
        onDone: mc.close,
      );
      mc.onCancel = sub.cancel;
    });
  }

  @override
  Future<GuaranteeClaim> submit(GuaranteeClaimRequest request) async {
    final id = 'claim-${request.tripId}-${request.triggerId}';
    final x = _claims[id];
    if (x == null) {
      throw StateError('Unbekannter Anspruch: $id');
    }
    final u = GuaranteeClaim(
      id: x.id,
      tripId: x.tripId,
      triggerId: x.triggerId,
      reasonCode: x.reasonCode,
      evaluationLog: x.evaluationLog,
      createdAt: x.createdAt,
      status: x.status == GuaranteeClaimStatus.draft
          ? GuaranteeClaimStatus.pending
          : x.status,
      compensationCents: x.compensationCents,
    );
    _claims[id] = u;
    return u;
  }

  @override
  Future<GuaranteeClaimStatus> statusOf(String claimId) async {
    return _claims[claimId]?.status ?? GuaranteeClaimStatus.rejected;
  }

  // --- NotificationPort

  @override
  Future<void> notifyGuaranteeClaimable(GuaranteeClaim claim) async {
    _notifyLog.add(claim);
  }
}
