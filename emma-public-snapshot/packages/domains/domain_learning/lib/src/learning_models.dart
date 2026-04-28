class LearningSignal {
  const LearningSignal({
    required this.id,
    required this.kind,
    required this.weight,
    required this.recordedAt,
  });

  final String id;
  final String kind;
  final double weight;
  final DateTime recordedAt;
}

class PreferenceUpdate {
  const PreferenceUpdate({
    required this.id,
    required this.preferenceKey,
    required this.value,
    required this.isAutomated,
  });

  final String id;
  final String preferenceKey;
  final String value;
  final bool isAutomated;
}
