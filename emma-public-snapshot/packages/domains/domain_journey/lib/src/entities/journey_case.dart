import 'package:domain_journey/src/entities/booking_intent.dart';
import 'package:domain_journey/src/entities/fare_decision.dart';
import 'package:domain_journey/src/entities/journey_phase.dart';
import 'package:domain_journey/src/entities/payment_intent.dart';
import 'package:domain_journey/src/entities/reaccommodation_models.dart';
import 'package:domain_journey/src/entities/travel_option.dart';
import 'package:domain_journey/src/entities/user_intent.dart';
import 'package:domain_journey/src/entities/journey_operational_artifacts.dart';

/// Lifecycle of a [JourneyCase] across the emma 5-phase journey.
enum JourneyLifecycleStatus {
  draft,
  readyForConfirmation,
  awaitingPartnerHandoff,
  awaitingPaymentHandoff,
  booked,
  active,
  disrupted,
  supportRequired,
  completed,
}

class JourneyCase {
  const JourneyCase({
    required this.journeyId,
    required this.userId,
    required this.status,
    required this.currentStep,
    required this.intent,
    required this.phases,
    required this.events,
    required this.context,
    this.selectedOption,
    this.selectedOptionId,
    this.fareDecision,
    this.bookingIntent,
    this.paymentIntent,
    this.supportCases = const [],
    this.reportingEvents = const [],
    this.supportCaseIds = const [],
    this.phase4Fulfillment,
  });

  final String journeyId;
  final String userId;
  final JourneyLifecycleStatus status;
  final JourneyPhase currentStep;
  final UserIntent intent;
  final List<JourneyPhaseState> phases;
  final List<JourneyEvent> events;
  final Map<String, dynamic> context;
  final TravelOption? selectedOption;
  final String? selectedOptionId;
  final FareDecision? fareDecision;
  final BookingIntent? bookingIntent;
  final PaymentIntent? paymentIntent;
  final List<JourneySupportCase> supportCases;
  final List<JourneyReportingEvent> reportingEvents;
  final List<String> supportCaseIds;
  final JourneyFulfillmentControl? phase4Fulfillment;

  JourneyCase copyWith({
    String? journeyId,
    String? userId,
    JourneyLifecycleStatus? status,
    JourneyPhase? currentStep,
    UserIntent? intent,
    List<JourneyPhaseState>? phases,
    List<JourneyEvent>? events,
    Map<String, dynamic>? context,
    TravelOption? selectedOption,
    String? selectedOptionId,
    FareDecision? fareDecision,
    BookingIntent? bookingIntent,
    PaymentIntent? paymentIntent,
    List<JourneySupportCase>? supportCases,
    List<JourneyReportingEvent>? reportingEvents,
    List<String>? supportCaseIds,
    JourneyFulfillmentControl? phase4Fulfillment,
  }) {
    return JourneyCase(
      journeyId: journeyId ?? this.journeyId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      intent: intent ?? this.intent,
      phases: phases ?? this.phases,
      events: events ?? this.events,
      context: context ?? this.context,
      selectedOption: selectedOption ?? this.selectedOption,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
      fareDecision: fareDecision ?? this.fareDecision,
      bookingIntent: bookingIntent ?? this.bookingIntent,
      paymentIntent: paymentIntent ?? this.paymentIntent,
      supportCases: supportCases ?? this.supportCases,
      reportingEvents: reportingEvents ?? this.reportingEvents,
      supportCaseIds: supportCaseIds ?? this.supportCaseIds,
      phase4Fulfillment: phase4Fulfillment ?? this.phase4Fulfillment,
    );
  }
}
