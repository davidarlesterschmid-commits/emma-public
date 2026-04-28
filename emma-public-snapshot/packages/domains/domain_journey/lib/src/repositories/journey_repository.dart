import 'package:domain_journey/src/entities/journey_case.dart';
import 'package:domain_journey/src/entities/journey_phase.dart';
import 'package:domain_journey/src/entities/journey_state.dart';
import 'package:domain_journey/src/entities/reaccommodation_models.dart';
import 'package:domain_journey/src/entities/travel_option.dart';

/// Domain port for the journey-engine source of truth.
///
/// The repository owns the [JourneyCase] lifecycle and the derived
/// [JourneyState] projection. Concrete implementations live in the
/// feature layer and may be backed by emma-internal services,
/// Partnerhub adapters, or hybrid replay from the Migrationsfabrik.
abstract interface class JourneyRepository {
  Future<JourneyCase> getJourneyCase(String userId);
  Future<JourneyState> getJourneyState(String userId);
  Future<JourneyCase> selectTravelOption(
    JourneyCase journeyCase,
    TravelOption option,
  );
  Future<JourneyCase> confirmMockBooking(JourneyCase journeyCase);
  Future<JourneyCase> advanceJourneyCase(JourneyCase journeyCase);
  Future<JourneyCase> simulateDisruption(JourneyCase journeyCase);
  Future<JourneyCase> acceptFallback(JourneyCase journeyCase);
  Future<JourneyCase> completeJourney(JourneyCase journeyCase);
  Future<JourneyCase> evaluatePhase4Control(JourneyCase journeyCase);
  Future<List<ReaccommodationOption>> getReaccommodationOptions(
    JourneyCase journeyCase,
  );
  Future<void> updateJourneyCase(JourneyCase journeyCase);
  Future<void> updateJourneyState(JourneyState state);
  Future<JourneyPhase> getNextStep(JourneyState state);
}
