library;

// Moved to package:domain_reporting (ADR-02 Schritt 3.a).
// ReportingEvent is referenced by JourneyCase and therefore needs to
// live in a cross-feature domain package. The feature-layer
// data_reporting package will pick this up in Schritt 3.c / 10.
export 'package:domain_reporting/domain_reporting.dart' show ReportingEvent;
