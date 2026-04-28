/// Customer-service / support domain.
///
/// Owns support-case contracts that are produced by any emma journey
/// or partner adapter and consumed by the CRM/service stack.
library;

export 'src/entities/support_case.dart';
export 'src/service_case_repository.dart'
    show EscalationStatus, ServiceCaseRepository, ServiceCaseSnapshot;
