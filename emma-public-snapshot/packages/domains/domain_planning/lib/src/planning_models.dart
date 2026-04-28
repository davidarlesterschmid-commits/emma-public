class PlanningRequest {
  const PlanningRequest({
    required this.originLabel,
    required this.destinationLabel,
    required this.departureAt,
  });

  final String originLabel;
  final String destinationLabel;
  final DateTime departureAt;
}

class PlanningResult {
  const PlanningResult({
    required this.id,
    required this.summary,
    required this.isFallback,
    required this.gateNote,
  });

  final String id;
  final String summary;
  final bool isFallback;
  final String gateNote;
}
