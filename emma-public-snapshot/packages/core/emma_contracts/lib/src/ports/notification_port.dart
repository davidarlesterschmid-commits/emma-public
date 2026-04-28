import 'package:emma_contracts/src/models/guarantee_claim.dart';

abstract interface class NotificationPort {
  Future<void> notifyGuaranteeClaimable(GuaranteeClaim claim);
}
