import 'package:domain_reporting/domain_reporting.dart';

class FakeReportingSnapshotPort implements ReportingSnapshotPort {
  const FakeReportingSnapshotPort();

  @override
  Future<ReportingSnapshot> loadSnapshot() async {
    return const ReportingSnapshot(
      id: 'reporting-demo',
      quality: <QualitySnapshot>[
        QualitySnapshot(metricId: 'module-coverage', label: 'M01-M14', value: 14),
      ],
      gateNote: 'BI-/Partnerreporting-Adapter Gate erforderlich / nicht implementiert',
    );
  }
}
