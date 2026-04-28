import 'package:domain_planning/src/planning_models.dart';

abstract interface class PlanningPort {
  Future<List<PlanningResult>> plan(PlanningRequest request);
}
