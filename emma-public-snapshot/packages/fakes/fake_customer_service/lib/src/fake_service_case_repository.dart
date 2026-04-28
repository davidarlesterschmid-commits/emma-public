import 'package:domain_customer_service/domain_customer_service.dart';

class FakeServiceCaseRepository implements ServiceCaseRepository {
  const FakeServiceCaseRepository();

  @override
  Future<ServiceCaseSnapshot> createCase(SupportCase supportCase) async {
    return ServiceCaseSnapshot(
      caseData: supportCase,
      escalationStatus: EscalationStatus.crmGateRequired,
      gateNote: 'CRM-Adapter Gate erforderlich / nicht implementiert',
    );
  }
}
