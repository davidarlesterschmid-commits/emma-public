/// Employer-mobility domain — contracts and entities for
/// benefit wallets, job tickets, profile-mode switching and the
/// employer-side budget repository contract.
///
/// Flutter-free by design. Pure Dart tests may exercise this package
/// without a Flutter host.
///
/// `BudgetRepository` extends [package:emma_contracts/emma_contracts.dart]'s
/// `BudgetPort`; `MobilityBudget` remains canonical in
/// [package:domain_wallet/domain_wallet.dart].
library;

export 'src/entities/benefit.dart';
export 'src/entities/bmm_profile_context.dart';
export 'src/entities/job_ticket.dart';
export 'src/entities/profile_mode.dart';
export 'src/repositories/benefit_repository.dart';
export 'src/repositories/budget_repository.dart';
export 'src/repositories/job_ticket_repository.dart';
export 'src/repositories/profile_mode_repository.dart';
