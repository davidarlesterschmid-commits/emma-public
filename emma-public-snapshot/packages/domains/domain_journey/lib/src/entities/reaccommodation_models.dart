/// Mobility-guarantee tier a re-accommodation option carries.
enum ReaccommodationGuaranteeLevel {
  none('NONE', 0),
  low('LOW', 1),
  medium('MEDIUM', 2),
  high('HIGH', 3);

  const ReaccommodationGuaranteeLevel(this.value, this.priority);

  final String value;
  final int priority;

  static ReaccommodationGuaranteeLevel fromValue(String? value) {
    return ReaccommodationGuaranteeLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => ReaccommodationGuaranteeLevel.none,
    );
  }
}

Map<String, dynamic> _map(Object? input) =>
    Map<String, dynamic>.from(input as Map? ?? const {});

class ReaccommodationOption {
  const ReaccommodationOption({
    required this.optionId,
    required this.providerBundle,
    required this.departureTime,
    required this.arrivalTime,
    required this.estimatedCostEur,
    required this.guaranteeLevel,
    required this.bookable,
    required this.bookableWithOneTap,
    required this.requiresUserInput,
    required this.policyFlags,
    required this.exclusionFlags,
  });

  factory ReaccommodationOption.fromJson(Map<String, dynamic> json) {
    return ReaccommodationOption(
      optionId: json['option_id']?.toString() ?? '',
      providerBundle: (json['provider_bundle'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
      departureTime: DateTime.parse(json['departure_time'].toString()),
      arrivalTime: DateTime.parse(json['arrival_time'].toString()),
      estimatedCostEur: (json['estimated_cost_eur'] as num?)?.toDouble() ?? 0,
      guaranteeLevel: ReaccommodationGuaranteeLevel.fromValue(
        json['guarantee_level']?.toString(),
      ),
      bookable: json['bookable'] == true,
      bookableWithOneTap: json['bookable_with_one_tap'] == true,
      requiresUserInput: json['requires_user_input'] == true,
      policyFlags: (json['policy_flags'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
      exclusionFlags: (json['exclusion_flags'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
    );
  }

  final String optionId;
  final List<String> providerBundle;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double estimatedCostEur;
  final ReaccommodationGuaranteeLevel guaranteeLevel;
  final bool bookable;
  final bool bookableWithOneTap;
  final bool requiresUserInput;
  final List<String> policyFlags;
  final List<String> exclusionFlags;

  bool get isAllowed =>
      bookable &&
      exclusionFlags.isEmpty &&
      !policyFlags.contains('POLICY_BLOCKED');

  int get complexityScore {
    final transfers = providerBundle.length > 1 ? providerBundle.length - 1 : 0;
    return transfers +
        (requiresUserInput ? 1 : 0) +
        (bookableWithOneTap ? 0 : 1);
  }

  Map<String, dynamic> toJson() {
    return {
      'option_id': optionId,
      'provider_bundle': providerBundle,
      'departure_time': departureTime.toIso8601String(),
      'arrival_time': arrivalTime.toIso8601String(),
      'estimated_cost_eur': estimatedCostEur,
      'guarantee_level': guaranteeLevel.value,
      'bookable': bookable,
      'bookable_with_one_tap': bookableWithOneTap,
      'requires_user_input': requiresUserInput,
      'policy_flags': policyFlags,
      'exclusion_flags': exclusionFlags,
    };
  }
}

class FulfillmentSelectedAction {
  const FulfillmentSelectedAction({
    required this.actionType,
    required this.guaranteeCase,
    required this.manualOpsEscalation,
    this.targetOptionId,
  });

  factory FulfillmentSelectedAction.fromJson(Map<String, dynamic> json) {
    return FulfillmentSelectedAction(
      actionType: json['action_type']?.toString() ?? '',
      targetOptionId: json['target_option_id']?.toString(),
      guaranteeCase: json['guarantee_case'] == true,
      manualOpsEscalation: json['manual_ops_escalation'] == true,
    );
  }

  final String actionType;
  final String? targetOptionId;
  final bool guaranteeCase;
  final bool manualOpsEscalation;

  Map<String, dynamic> toJson() {
    return {
      'action_type': actionType,
      'target_option_id': targetOptionId,
      'guarantee_case': guaranteeCase,
      'manual_ops_escalation': manualOpsEscalation,
    };
  }
}

class FulfillmentIncidentSummary {
  const FulfillmentIncidentSummary({
    required this.activeIncident,
    required this.incidentIds,
    required this.affectedLegIds,
    this.highestSeverity,
  });

  factory FulfillmentIncidentSummary.fromJson(Map<String, dynamic> json) {
    return FulfillmentIncidentSummary(
      activeIncident: json['active_incident'] == true,
      incidentIds: (json['incident_ids'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
      highestSeverity: json['highest_severity']?.toString(),
      affectedLegIds: (json['affected_leg_ids'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
    );
  }

  final bool activeIncident;
  final List<String> incidentIds;
  final String? highestSeverity;
  final List<String> affectedLegIds;

  Map<String, dynamic> toJson() {
    return {
      'active_incident': activeIncident,
      'incident_ids': incidentIds,
      'highest_severity': highestSeverity,
      'affected_leg_ids': affectedLegIds,
    };
  }
}

class FulfillmentSummary {
  const FulfillmentSummary({
    required this.bookingState,
    required this.paymentState,
    required this.entitlementState,
    required this.missingArtifacts,
    required this.providerConfirmationGaps,
  });

  factory FulfillmentSummary.fromJson(Map<String, dynamic> json) {
    return FulfillmentSummary(
      bookingState: json['booking_state']?.toString() ?? '',
      paymentState: json['payment_state']?.toString() ?? '',
      entitlementState: json['entitlement_state']?.toString() ?? '',
      missingArtifacts: (json['missing_artifacts'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
      providerConfirmationGaps:
          (json['provider_confirmation_gaps'] as List? ?? const [])
              .map((item) => item.toString())
              .toList(),
    );
  }

  final String bookingState;
  final String paymentState;
  final String entitlementState;
  final List<String> missingArtifacts;
  final List<String> providerConfirmationGaps;

  Map<String, dynamic> toJson() {
    return {
      'booking_state': bookingState,
      'payment_state': paymentState,
      'entitlement_state': entitlementState,
      'missing_artifacts': missingArtifacts,
      'provider_confirmation_gaps': providerConfirmationGaps,
    };
  }
}

class FulfillmentTechnicalMetadata {
  const FulfillmentTechnicalMetadata({
    required this.journeyStatusEvaluated,
    required this.guaranteeRiskDetected,
    required this.reaccommodationEvaluated,
    required this.affectedProviders,
    required this.dataGaps,
    this.selectedReaccommodationOptionId,
  });

  factory FulfillmentTechnicalMetadata.fromJson(Map<String, dynamic> json) {
    return FulfillmentTechnicalMetadata(
      journeyStatusEvaluated:
          json['journey_status_evaluated']?.toString() ?? '',
      guaranteeRiskDetected: json['guarantee_risk_detected'] == true,
      reaccommodationEvaluated: json['reaccommodation_evaluated'] == true,
      selectedReaccommodationOptionId:
          json['selected_reaccommodation_option_id']?.toString(),
      affectedProviders: (json['affected_providers'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
      dataGaps: (json['data_gaps'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
    );
  }

  final String journeyStatusEvaluated;
  final bool guaranteeRiskDetected;
  final bool reaccommodationEvaluated;
  final String? selectedReaccommodationOptionId;
  final List<String> affectedProviders;
  final List<String> dataGaps;

  Map<String, dynamic> toJson() {
    return {
      'journey_status_evaluated': journeyStatusEvaluated,
      'guarantee_risk_detected': guaranteeRiskDetected,
      'reaccommodation_evaluated': reaccommodationEvaluated,
      'selected_reaccommodation_option_id': selectedReaccommodationOptionId,
      'affected_providers': affectedProviders,
      'data_gaps': dataGaps,
    };
  }
}

class JourneyFulfillmentControl {
  const JourneyFulfillmentControl({
    required this.controlStatus,
    required this.displayMessage,
    required this.controlReason,
    required this.selectedAction,
    required this.incidentSummary,
    required this.fulfillmentSummary,
    required this.reaccommodationOptions,
    required this.guaranteePolicy,
    required this.evidenceLog,
    required this.technicalMetadata,
  });

  factory JourneyFulfillmentControl.fromJson(Map<String, dynamic> json) {
    return JourneyFulfillmentControl(
      controlStatus: json['control_status']?.toString() ?? '',
      displayMessage: json['display_message']?.toString() ?? '',
      controlReason: json['control_reason']?.toString() ?? '',
      selectedAction: FulfillmentSelectedAction.fromJson(
        _map(json['selected_action']),
      ),
      incidentSummary: FulfillmentIncidentSummary.fromJson(
        _map(json['incident_summary']),
      ),
      fulfillmentSummary: FulfillmentSummary.fromJson(
        _map(json['fulfillment_summary']),
      ),
      reaccommodationOptions:
          (json['reaccommodation_options'] as List? ?? const [])
              .map(
                (item) => ReaccommodationOption.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(),
      guaranteePolicy: _map(json['guarantee_policy']),
      evidenceLog: _map(json['evidence_log']),
      technicalMetadata: FulfillmentTechnicalMetadata.fromJson(
        _map(json['technical_metadata']),
      ),
    );
  }

  final String controlStatus;
  final String displayMessage;
  final String controlReason;
  final FulfillmentSelectedAction selectedAction;
  final FulfillmentIncidentSummary incidentSummary;
  final FulfillmentSummary fulfillmentSummary;
  final List<ReaccommodationOption> reaccommodationOptions;
  final Map<String, dynamic> guaranteePolicy;
  final Map<String, dynamic> evidenceLog;
  final FulfillmentTechnicalMetadata technicalMetadata;

  Map<String, dynamic> toJson() {
    return {
      'control_status': controlStatus,
      'display_message': displayMessage,
      'control_reason': controlReason,
      'selected_action': selectedAction.toJson(),
      'incident_summary': incidentSummary.toJson(),
      'fulfillment_summary': fulfillmentSummary.toJson(),
      'reaccommodation_options': reaccommodationOptions
          .map((item) => item.toJson())
          .toList(),
      'guarantee_policy': guaranteePolicy,
      'evidence_log': evidenceLog,
      'technical_metadata': technicalMetadata.toJson(),
    };
  }
}
