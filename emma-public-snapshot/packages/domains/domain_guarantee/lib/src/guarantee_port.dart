import 'package:domain_guarantee/src/guarantee_models.dart';

abstract interface class GuaranteePort {
  Future<GuaranteeDecision> evaluate(String journeyId);
}
