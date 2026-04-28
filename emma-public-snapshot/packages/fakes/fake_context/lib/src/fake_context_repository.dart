import 'package:domain_context/domain_context.dart';

class FakeContextRepository implements ContextRepository {
  const FakeContextRepository();

  static final DateTime _observedAt = DateTime.utc(2026, 4, 24, 6, 30);

  @override
  Future<List<ContextSignal>> listSignals() async => <ContextSignal>[
    ContextSignal(
      id: 'sig-home-work',
      kind: ContextSignalKind.routineHint,
      label: 'Home to work shortcut',
      observedAt: _observedAt,
      confidence: 0.82,
    ),
  ];

  @override
  Future<List<RoutineCandidate>> listRoutineCandidates() async =>
      const <RoutineCandidate>[
        RoutineCandidate(
          id: 'routine-commute',
          title: 'Morning commute',
          signalIds: <String>['sig-home-work'],
          confidence: 0.82,
        ),
      ];

  @override
  Future<List<MobilityNeed>> inferMobilityNeeds() async => <MobilityNeed>[
    MobilityNeed(
      id: 'need-commute',
      summary: 'Plan commute to Leipzig Hbf',
      originLabel: 'Home',
      destinationLabel: 'Leipzig Hbf',
      neededAt: DateTime.utc(2026, 4, 24, 7, 15),
    ),
  ];
}
