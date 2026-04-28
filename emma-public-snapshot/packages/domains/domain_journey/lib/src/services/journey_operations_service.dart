import 'package:domain_journey/src/entities/booking_intent.dart';
import 'package:domain_journey/src/entities/fare_decision.dart';
import 'package:domain_journey/src/entities/journey_case.dart';
import 'package:domain_journey/src/entities/payment_intent.dart';
import 'package:domain_journey/src/entities/travel_option.dart';
import 'package:domain_journey/src/entities/journey_operational_artifacts.dart';

class JourneyOperationsResult {
  const JourneyOperationsResult({
    required this.supportCases,
    required this.reportingEvents,
  });

  final List<JourneySupportCase> supportCases;
  final List<JourneyReportingEvent> reportingEvents;
}

class JourneyOperationsService {
  const JourneyOperationsService();

  JourneyOperationsResult buildOperations({
    required JourneyCase journeyCase,
    required TravelOption selectedOption,
    required FareDecision fareDecision,
    required BookingIntent bookingIntent,
    required PaymentIntent paymentIntent,
  }) {
    final reportingEvents = <JourneyReportingEvent>[
      JourneyReportingEvent(
        eventId: 'evt-${journeyCase.journeyId}-intent',
        journeyId: journeyCase.journeyId,
        module: 'journey_engine',
        eventType: 'USER_INTENT_CAPTURED',
        severity: 'info',
        payload: {
          'source': journeyCase.intent.source,
          'trip_purpose': journeyCase.intent.tripPurpose,
        },
        occurredAt: DateTime.now(),
      ),
    ];

    final supportCases = <JourneySupportCase>[
      if (bookingIntent.blockingReasons.isNotEmpty)
        JourneySupportCase(
          caseId: 'case-${journeyCase.journeyId}-booking',
          journeyId: journeyCase.journeyId,
          sourceModule: 'tickets',
          reasonCode: 'BOOKING_REVIEW_REQUIRED',
          severity: 'medium',
          payloadSnapshot: {
            'blocking_reasons': bookingIntent.blockingReasons,
            'option_id': bookingIntent.optionId,
          },
          caseStatus: 'OPEN',
        ),
    ];

    return JourneyOperationsResult(
      supportCases: supportCases,
      reportingEvents: reportingEvents,
    );
  }
}
