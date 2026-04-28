import 'package:domain_customer_service/src/entities/support_case.dart';

enum EscalationStatus { simulationOnly, crmGateRequired }

class ServiceCaseSnapshot {
  const ServiceCaseSnapshot({
    required this.caseData,
    required this.escalationStatus,
    required this.gateNote,
  });

  final SupportCase caseData;
  final EscalationStatus escalationStatus;
  final String gateNote;
}

abstract interface class ServiceCaseRepository {
  Future<ServiceCaseSnapshot> createCase(SupportCase supportCase);
}
