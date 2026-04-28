enum ContextSignalKind { locationHint, calendarHint, routineHint, manualIntent }

class ContextSignal {
  const ContextSignal({
    required this.id,
    required this.kind,
    required this.label,
    required this.observedAt,
    this.confidence = 1.0,
  });

  final String id;
  final ContextSignalKind kind;
  final String label;
  final DateTime observedAt;
  final double confidence;
}

class RoutineCandidate {
  const RoutineCandidate({
    required this.id,
    required this.title,
    required this.signalIds,
    required this.confidence,
  });

  final String id;
  final String title;
  final List<String> signalIds;
  final double confidence;
}

class MobilityNeed {
  const MobilityNeed({
    required this.id,
    required this.summary,
    required this.originLabel,
    required this.destinationLabel,
    required this.neededAt,
  });

  final String id;
  final String summary;
  final String originLabel;
  final String destinationLabel;
  final DateTime neededAt;
}
