import 'package:domain_journey/src/entities/journey_case.dart';
import 'package:domain_journey/src/entities/reaccommodation_models.dart';

class ReaccommodationService {
  const ReaccommodationService();

  JourneyFulfillmentControl evaluateReaccommodation({
    required JourneyCase journeyCase,
    required List<ReaccommodationOption> options,
  }) {
    final monitoring = Map<String, dynamic>.from(
      journeyCase.context['phase4_monitoring'] as Map? ?? const {},
    );
    final incidentSummary = FulfillmentIncidentSummary(
      activeIncident:
          monitoring['active_incident'] == true ||
          monitoring['journey_at_risk'] == true,
      incidentIds: (monitoring['incident_ids'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
      highestSeverity: monitoring['highest_severity']?.toString(),
      affectedLegIds: (monitoring['affected_leg_ids'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
    );
    final guaranteePolicy = Map<String, dynamic>.from(
      monitoring['guarantee_policy'] as Map? ??
          const {
            'policy_code': 'MOBILITY_GUARANTEE_STANDARD',
            'automatic_action_allowed': true,
          },
    );
    final fulfillmentSummary = FulfillmentSummary(
      bookingState: journeyCase.bookingIntent?.bookingStatus ?? 'UNKNOWN',
      paymentState: journeyCase.paymentIntent?.paymentStatus ?? 'UNKNOWN',
      entitlementState: guaranteePolicy.isNotEmpty ? 'VALID' : 'UNKNOWN',
      missingArtifacts: const [],
      providerConfirmationGaps: const [],
    );

    final riskDetected =
        monitoring['journey_at_risk'] == true ||
        monitoring['guarantee_at_risk'] == true ||
        incidentSummary.activeIncident;
    final affectedProviders = <String>{
      ...?journeyCase.selectedOption?.providerCandidates,
      ...options.expand((option) => option.providerBundle),
    }.toList();
    final allowedOptions = options.where((option) => option.isAllowed).toList();

    if (!riskDetected) {
      return JourneyFulfillmentControl(
        controlStatus: 'MONITORING_ONLY',
        displayMessage: 'Die Reise ist stabil. emma bleibt im Monitoring.',
        controlReason:
            'Keine Gefaehrdung fuer Reise oder Zielerreichung erkannt.',
        selectedAction: const FulfillmentSelectedAction(
          actionType: 'SEND_INFO',
          guaranteeCase: false,
          manualOpsEscalation: false,
        ),
        incidentSummary: incidentSummary,
        fulfillmentSummary: fulfillmentSummary,
        reaccommodationOptions: allowedOptions,
        guaranteePolicy: guaranteePolicy,
        evidenceLog: const {'required': true, 'entries': []},
        technicalMetadata: FulfillmentTechnicalMetadata(
          journeyStatusEvaluated: 'TRIP_SAFE',
          guaranteeRiskDetected: false,
          reaccommodationEvaluated: true,
          selectedReaccommodationOptionId: null,
          affectedProviders: affectedProviders,
          dataGaps: const [],
        ),
      );
    }

    if (allowedOptions.isNotEmpty) {
      final selectedOption = _selectBestOption(
        options: allowedOptions,
        targetArrivalTime: journeyCase.intent.targetArrivalTime,
      );
      return JourneyFulfillmentControl(
        controlStatus: 'REACCOMMODATION_REQUIRED',
        displayMessage:
            'emma hat eine belastbare Ersatzoption ausgewaehlt und kann direkt umsteuern.',
        controlReason:
            'Die bestehende Reise ist gefaehrdet; eine zulaessige Ersatzoption wurde deterministisch priorisiert.',
        selectedAction: FulfillmentSelectedAction(
          actionType: 'REACCOMMODATE',
          targetOptionId: selectedOption.optionId,
          guaranteeCase: false,
          manualOpsEscalation: false,
        ),
        incidentSummary: incidentSummary,
        fulfillmentSummary: fulfillmentSummary,
        reaccommodationOptions: allowedOptions,
        guaranteePolicy: guaranteePolicy,
        evidenceLog: {
          'required': true,
          'entries': [
            {
              'summary': 'Best option ${selectedOption.optionId} selected',
              'event_type': 'REACCOMMODATION_EVALUATED',
            },
          ],
        },
        technicalMetadata: FulfillmentTechnicalMetadata(
          journeyStatusEvaluated: 'TRIP_AT_RISK',
          guaranteeRiskDetected: true,
          reaccommodationEvaluated: true,
          selectedReaccommodationOptionId: selectedOption.optionId,
          affectedProviders: affectedProviders,
          dataGaps: const [],
        ),
      );
    }

    final automaticGuaranteeAllowed =
        guaranteePolicy['automatic_action_allowed'] == true;
    if (automaticGuaranteeAllowed) {
      return JourneyFulfillmentControl(
        controlStatus: 'GUARANTEE_REQUIRED',
        displayMessage:
            'Keine buchbare Ersatzoption verfuegbar. emma aktiviert die Mobilitaetsgarantie.',
        controlReason:
            'Gefaehrdung erkannt, aber kein zulaessiger Reaccommodation-Pfad verfuegbar.',
        selectedAction: const FulfillmentSelectedAction(
          actionType: 'TRIGGER_GUARANTEE',
          guaranteeCase: true,
          manualOpsEscalation: false,
        ),
        incidentSummary: incidentSummary,
        fulfillmentSummary: fulfillmentSummary,
        reaccommodationOptions: const [],
        guaranteePolicy: guaranteePolicy,
        evidenceLog: const {'required': true, 'entries': []},
        technicalMetadata: FulfillmentTechnicalMetadata(
          journeyStatusEvaluated: 'TRIP_AT_RISK',
          guaranteeRiskDetected: true,
          reaccommodationEvaluated: true,
          selectedReaccommodationOptionId: null,
          affectedProviders: affectedProviders,
          dataGaps: const [],
        ),
      );
    }

    return JourneyFulfillmentControl(
      controlStatus: 'MANUAL_OPS_REQUIRED',
      displayMessage:
          'Weder Ersatzoption noch automatischer Garantiepfad sind verfuegbar. emma eskaliert an Manual Ops.',
      controlReason:
          'Gefaehrdung erkannt, aber weder automatische Reaccommodation noch Garantie konnten ausgefuehrt werden.',
      selectedAction: const FulfillmentSelectedAction(
        actionType: 'ESCALATE_TO_MANUAL_OPS',
        guaranteeCase: false,
        manualOpsEscalation: true,
      ),
      incidentSummary: incidentSummary,
      fulfillmentSummary: fulfillmentSummary,
      reaccommodationOptions: const [],
      guaranteePolicy: guaranteePolicy,
      evidenceLog: const {'required': true, 'entries': []},
      technicalMetadata: FulfillmentTechnicalMetadata(
        journeyStatusEvaluated: 'TRIP_AT_RISK',
        guaranteeRiskDetected: true,
        reaccommodationEvaluated: true,
        selectedReaccommodationOptionId: null,
        affectedProviders: affectedProviders,
        dataGaps: const [],
      ),
    );
  }

  ReaccommodationOption _selectBestOption({
    required List<ReaccommodationOption> options,
    required DateTime? targetArrivalTime,
  }) {
    final sorted = [...options]
      ..sort((a, b) {
        final guarantee = b.guaranteeLevel.priority.compareTo(
          a.guaranteeLevel.priority,
        );
        if (guarantee != 0) return guarantee;

        final aDelay = _latenessMinutes(a.arrivalTime, targetArrivalTime);
        final bDelay = _latenessMinutes(b.arrivalTime, targetArrivalTime);
        final arrival = aDelay.compareTo(bDelay);
        if (arrival != 0) return arrival;

        final aBudgetPenalty = a.policyFlags.contains('OUT_OF_BUDGET') ? 1 : 0;
        final bBudgetPenalty = b.policyFlags.contains('OUT_OF_BUDGET') ? 1 : 0;
        final budgetPenalty = aBudgetPenalty.compareTo(bBudgetPenalty);
        if (budgetPenalty != 0) return budgetPenalty;

        final cost = a.estimatedCostEur.compareTo(b.estimatedCostEur);
        if (cost != 0) return cost;

        final userInput = (a.requiresUserInput ? 1 : 0).compareTo(
          b.requiresUserInput ? 1 : 0,
        );
        if (userInput != 0) return userInput;

        final oneTap = (b.bookableWithOneTap ? 1 : 0).compareTo(
          a.bookableWithOneTap ? 1 : 0,
        );
        if (oneTap != 0) return oneTap;

        final complexity = a.complexityScore.compareTo(b.complexityScore);
        if (complexity != 0) return complexity;

        return a.optionId.compareTo(b.optionId);
      });

    return sorted.first;
  }

  int _latenessMinutes(DateTime arrivalTime, DateTime? targetArrivalTime) {
    if (targetArrivalTime == null) {
      return arrivalTime.millisecondsSinceEpoch;
    }
    final difference = arrivalTime.difference(targetArrivalTime).inMinutes;
    return difference < 0 ? 0 : difference;
  }
}
