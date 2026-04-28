import 'package:domain_context/src/context_models.dart';

abstract interface class ContextRepository {
  Future<List<ContextSignal>> listSignals();

  Future<List<RoutineCandidate>> listRoutineCandidates();

  Future<List<MobilityNeed>> inferMobilityNeeds();
}
