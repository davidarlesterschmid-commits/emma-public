import 'package:domain_customer_service/domain_customer_service.dart';
import 'package:domain_journey/contracts.dart';
import 'package:domain_journey/domain_journey.dart';
import 'package:domain_reporting/domain_reporting.dart';
import 'package:feature_journey/feature_journey.dart' show JourneyNotifier;
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'package:feature_journey/feature_journey.dart'
    show journeyRepositoryProvider;

/// App-Shell: Journey-Case, abgeleitete Selektoren, [JourneyNotifier].
/// Port-[Provider] liegen in `feature_journey` (`feature_journey_ports.dart`).

final journeyStateProvider = Provider<JourneyState?>((ref) {
  final journeyCase = ref.watch(journeyCaseProvider);
  if (journeyCase == null) return null;

  const mapper = JourneyContractMapper();
  final baseState = JourneyState(
    id: journeyCase.journeyId,
    userId: journeyCase.userId,
    currentPhase: journeyCase.currentStep,
    phases: journeyCase.phases,
    events: journeyCase.events,
    context: {
      ...journeyCase.context,
      'journey_status': journeyCase.status.name,
      'selected_option_id': journeyCase.selectedOptionId,
      if (journeyCase.selectedOption != null)
        'selected_option': journeyCase.selectedOption!.toJson(),
      'user_intent': {
        'intent_id': journeyCase.intent.intentId,
        'source': journeyCase.intent.source,
        'origin': journeyCase.intent.origin,
        'destination': journeyCase.intent.destination,
        'trip_purpose': journeyCase.intent.tripPurpose,
      },
      if (journeyCase.fareDecision != null)
        'fare_decision': journeyCase.fareDecision!.toJson(),
      if (journeyCase.bookingIntent != null)
        'booking_intent': journeyCase.bookingIntent!.toJson(),
      if (journeyCase.paymentIntent != null)
        'payment_intent': journeyCase.paymentIntent!.toJson(),
      'support_cases': journeyCase.supportCases
          .map((item) => item.toJson())
          .toList(),
      'reporting_events': journeyCase.reportingEvents
          .map((item) => item.toJson())
          .toList(),
      if (journeyCase.phase4Fulfillment != null)
        'phase4_fulfillment': journeyCase.phase4Fulfillment!.toJson(),
      if (journeyCase.phase4Fulfillment != null)
        'reaccommodation_options': journeyCase
            .phase4Fulfillment!
            .reaccommodationOptions
            .map((item) => item.toJson())
            .toList(),
      if (journeyCase.phase4Fulfillment != null)
        'selected_reaccommodation_option_id': journeyCase
            .phase4Fulfillment!
            .technicalMetadata
            .selectedReaccommodationOptionId,
    },
  );
  return baseState.copyWith(contractBundle: mapper.buildBundle(baseState));
});

final journeyCaseProvider = NotifierProvider<JourneyNotifier, JourneyCase?>(
  JourneyNotifier.new,
);

final supportCasesProvider = Provider<List<SupportCase>>((ref) {
  final journeyCase = ref.watch(journeyCaseProvider);
  if (journeyCase == null) return const <SupportCase>[];
  // Boundary-Mapping: domain_journey haelt einen lokalen
  // [JourneySupportCase], um keine harte Abhaengigkeit auf
  // domain_customer_service zu ziehen. Die App-Shell mappt am Boundary
  // feldgleich auf den kanonischen [SupportCase] um.
  return journeyCase.supportCases
      .map(
        (item) => SupportCase(
          caseId: item.caseId,
          journeyId: item.journeyId,
          sourceModule: item.sourceModule,
          reasonCode: item.reasonCode,
          severity: item.severity,
          payloadSnapshot: item.payloadSnapshot,
          caseStatus: item.caseStatus,
        ),
      )
      .toList(growable: false);
});

final reportingEventsProvider = Provider<List<ReportingEvent>>((ref) {
  final journeyCase = ref.watch(journeyCaseProvider);
  if (journeyCase == null) return const <ReportingEvent>[];
  // Analoges Boundary-Mapping: domain_journey haelt einen lokalen
  // [JourneyReportingEvent], die App-Shell mappt feldgleich auf den
  // kanonischen [ReportingEvent] um.
  return journeyCase.reportingEvents
      .map(
        (item) => ReportingEvent(
          eventId: item.eventId,
          journeyId: item.journeyId,
          module: item.module,
          eventType: item.eventType,
          severity: item.severity,
          payload: item.payload,
          occurredAt: item.occurredAt,
        ),
      )
      .toList(growable: false);
});

final phase4FulfillmentProvider = Provider<JourneyFulfillmentControl?>((ref) {
  return ref.watch(journeyCaseProvider)?.phase4Fulfillment;
});

final reaccommodationOptionsProvider = Provider<List<ReaccommodationOption>>((
  ref,
) {
  return ref.watch(phase4FulfillmentProvider)?.reaccommodationOptions ??
      const [];
});

final selectedReaccommodationOptionProvider = Provider<ReaccommodationOption?>((
  ref,
) {
  final fulfillment = ref.watch(phase4FulfillmentProvider);
  final selectedId =
      fulfillment?.technicalMetadata.selectedReaccommodationOptionId;
  if (fulfillment == null || selectedId == null) {
    return null;
  }
  for (final option in fulfillment.reaccommodationOptions) {
    if (option.optionId == selectedId) {
      return option;
    }
  }
  return null;
});

final guaranteeRequiredProvider = Provider<bool>((ref) {
  return ref.watch(phase4FulfillmentProvider)?.selectedAction.guaranteeCase ==
      true;
});

final manualOpsEscalationProvider = Provider<bool>((ref) {
  return ref
          .watch(phase4FulfillmentProvider)
          ?.selectedAction
          .manualOpsEscalation ==
      true;
});
