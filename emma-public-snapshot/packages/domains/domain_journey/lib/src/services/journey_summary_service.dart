import 'package:domain_journey/src/entities/journey_intent.dart';

/// Builds human-readable summaries for journey intents.
///
/// Lightweight domain service — no external dependencies, fully testable.
class JourneySummaryService {
  const JourneySummaryService();

  String buildSummary(JourneyIntent intent) {
    final guaranteeLabel = intent.requiresGuarantee
        ? 'mit Mobilitaetsgarantie'
        : 'ohne Mobilitaetsgarantie';

    return '${intent.origin} -> ${intent.destination} ($guaranteeLabel)';
  }
}
