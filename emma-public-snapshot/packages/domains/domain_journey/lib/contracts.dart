/// Secondary entrypoint for the 5-phase canonical contract surface.
///
/// Consumers that project, evaluate or transport journey cases should
/// import this barrel. The primary `domain_journey.dart` barrel stays
/// focused on entities and repositories.
library;

export 'src/contracts/case/canonical_case.dart';
export 'src/contracts/case/emma_case_contract.dart';
export 'src/contracts/common/contract_enums.dart';
export 'src/contracts/common/contract_models.dart';
export 'src/contracts/handoff/handoffs.dart';
export 'src/contracts/mapping/journey_contract_mapper.dart';
export 'src/contracts/messages/phase_envelope.dart';
export 'src/contracts/orchestrator/master_orchestrator.dart';
export 'src/contracts/orchestrator/master_orchestrator_result.dart';
export 'src/contracts/phases/phase_contracts.dart';
