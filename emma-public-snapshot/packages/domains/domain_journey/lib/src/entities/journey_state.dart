import 'package:domain_journey/src/contracts/mapping/journey_contract_mapper.dart';
import 'package:domain_journey/src/entities/journey_phase.dart';

/// Snapshot of the journey orchestration state as presented to the UI.
///
/// Carries an optional [JourneyContractBundle] for callers that project
/// the 5-phase canonical contract surface (Phase 1..5, handoffs,
/// orchestrator result). UI layers can consume the bundle directly.
class JourneyState {
  const JourneyState({
    required this.id,
    required this.userId,
    required this.currentPhase,
    required this.phases,
    required this.events,
    required this.context,
    this.contractBundle,
  });

  final String id;
  final String userId;
  final JourneyPhase currentPhase;
  final List<JourneyPhaseState> phases;
  final List<JourneyEvent> events;
  final Map<String, dynamic> context;
  final JourneyContractBundle? contractBundle;

  JourneyPhaseState get currentPhaseState =>
      phases.firstWhere((phase) => phase.phase == currentPhase);

  JourneyState copyWith({
    String? id,
    String? userId,
    JourneyPhase? currentPhase,
    List<JourneyPhaseState>? phases,
    List<JourneyEvent>? events,
    Map<String, dynamic>? context,
    JourneyContractBundle? contractBundle,
  }) {
    return JourneyState(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      currentPhase: currentPhase ?? this.currentPhase,
      phases: phases ?? this.phases,
      events: events ?? this.events,
      context: context ?? this.context,
      contractBundle: contractBundle ?? this.contractBundle,
    );
  }
}
