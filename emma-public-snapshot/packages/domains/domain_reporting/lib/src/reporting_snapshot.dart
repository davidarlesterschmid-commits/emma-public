class QualitySnapshot {
  const QualitySnapshot({
    required this.metricId,
    required this.label,
    required this.value,
  });

  final String metricId;
  final String label;
  final num value;
}

class ReportingSnapshot {
  const ReportingSnapshot({
    required this.id,
    required this.quality,
    required this.gateNote,
  });

  final String id;
  final List<QualitySnapshot> quality;
  final String gateNote;
}

abstract interface class ReportingSnapshotPort {
  Future<ReportingSnapshot> loadSnapshot();
}
