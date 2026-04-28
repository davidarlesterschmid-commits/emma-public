import 'package:emma_contracts/src/models/guarantee_claim.dart';

abstract interface class MobilityGuaranteePort {
  Stream<GuaranteeClaim> pendingClaims();
  Future<GuaranteeClaim> submit(GuaranteeClaimRequest request);
  Future<GuaranteeClaimStatus> statusOf(String claimId);
}
