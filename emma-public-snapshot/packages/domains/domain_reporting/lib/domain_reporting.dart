/// Reporting domain.
///
/// Owns the canonical reporting-event contract emitted by journey
/// modules, partner adapters, and CRM/service flows, consumed by the
/// analytics/clearing pipelines.
library;

export 'src/entities/reporting_event.dart';
export 'src/reporting_snapshot.dart'
    show QualitySnapshot, ReportingSnapshot, ReportingSnapshotPort;
