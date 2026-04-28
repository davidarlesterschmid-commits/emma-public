import 'dart:async';

import 'package:emma_contracts/emma_contracts.dart';

class FakeMobilityGuaranteeAdapter implements MobilityGuaranteePort {
  FakeMobilityGuaranteeAdapter({
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final DateTime Function() _now;

  final _controller = StreamController<GuaranteeClaim>.broadcast();
  final Map<String, GuaranteeClaim> _claimsById = <String, GuaranteeClaim>{};
  final Map<String, String> _dedupeIndex = <String, String>{};

  @override
  Stream<GuaranteeClaim> pendingClaims() => _controller.stream;

  @override
  Future<GuaranteeClaim> submit(GuaranteeClaimRequest request) async {
    final key = _dedupeKey(request.tripId, request.triggerId);
    final existingId = _dedupeIndex[key];
    if (existingId != null) {
      return _claimsById[existingId]!;
    }

    final claim = GuaranteeClaim(
      id: 'fake:${request.tripId}:${request.triggerId}:${_now().microsecondsSinceEpoch}',
      tripId: request.tripId,
      triggerId: request.triggerId,
      reasonCode: 'submitted_via_fake',
      evaluationLog: List<String>.unmodifiable(<String>[
        'submit.tripId=${request.tripId}',
        'submit.triggerId=${request.triggerId}',
        if (request.userNote != null) 'submit.userNote=${request.userNote}',
      ]),
      createdAt: _now(),
      status: GuaranteeClaimStatus.open,
    );

    _claimsById[claim.id] = claim;
    _dedupeIndex[key] = claim.id;
    _controller.add(claim);
    return claim;
  }

  @override
  Future<GuaranteeClaimStatus> statusOf(String claimId) async {
    return _claimsById[claimId]?.status ?? GuaranteeClaimStatus.open;
  }

  static String _dedupeKey(String tripId, String triggerId) => '$tripId|$triggerId';
}
