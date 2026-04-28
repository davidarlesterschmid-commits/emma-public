import 'package:domain_planning/domain_planning.dart';

class FakePlanningPort implements PlanningPort {
  const FakePlanningPort();

  @override
  Future<List<PlanningResult>> plan(PlanningRequest request) async =>
      <PlanningResult>[
        PlanningResult(
          id: 'plan-${request.originLabel}-${request.destinationLabel}',
          summary: '${request.originLabel} -> ${request.destinationLabel}',
          isFallback: true,
          gateNote: 'Live-TRIAS Gate erforderlich / nicht implementiert',
        ),
      ];
}
