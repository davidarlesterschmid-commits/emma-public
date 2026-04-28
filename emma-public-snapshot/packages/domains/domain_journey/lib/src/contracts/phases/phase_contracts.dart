import 'package:domain_journey/src/contracts/common/contract_models.dart';

Map<String, dynamic> _map(Object? input) =>
    Map<String, dynamic>.from(input as Map? ?? const {});

class Phase1DemandRecognitionResult {
  const Phase1DemandRecognitionResult({
    required this.intentDetected,
    required this.confidenceScore,
    required this.triggerReason,
    required this.actionType,
    required this.displayMessage,
    required this.trustLayerAction,
    required this.technicalMetadata,
  });

  final bool intentDetected;
  final double confidenceScore;
  final String triggerReason;
  final String actionType;
  final String displayMessage;
  final EmmaTrustLayerAction trustLayerAction;
  final Phase1TechnicalMetadata technicalMetadata;

  Map<String, dynamic> toJson() {
    return {
      'intent_detected': intentDetected,
      'confidence_score': confidenceScore,
      'trigger_reason': triggerReason,
      'action_type': actionType,
      'display_message': displayMessage,
      'trust_layer_action': trustLayerAction.toJson(),
      'technical_metadata': technicalMetadata.toJson(),
    };
  }
}

class Phase1TechnicalMetadata {
  const Phase1TechnicalMetadata({
    required this.decisionBasis,
    required this.affectedProviders,
    required this.dataGaps,
  });

  final Map<String, dynamic> decisionBasis;
  final List<String> affectedProviders;
  final List<String> dataGaps;

  Map<String, dynamic> toJson() {
    return {
      'decision_basis': decisionBasis,
      'affected_providers': affectedProviders,
      'data_gaps': dataGaps,
    };
  }
}

class Phase2OptionOrchestrationResult {
  const Phase2OptionOrchestrationResult({
    required this.recommendationStatus,
    required this.recommendedOptionId,
    required this.displayMessage,
    required this.selectionReason,
    required this.trustLayerAction,
    required this.technicalMetadata,
  });

  final String recommendationStatus;
  final String recommendedOptionId;
  final String displayMessage;
  final String selectionReason;
  final EmmaTrustLayerAction trustLayerAction;
  final Phase2TechnicalMetadata technicalMetadata;

  Map<String, dynamic> toJson() {
    return {
      'recommendation_status': recommendationStatus,
      'recommended_option_id': recommendedOptionId,
      'display_message': displayMessage,
      'selection_reason': selectionReason,
      'trust_layer_action': trustLayerAction.toJson(),
      'technical_metadata': technicalMetadata.toJson(),
    };
  }
}

class Phase2TechnicalMetadata {
  const Phase2TechnicalMetadata({
    required this.affectedProviders,
    required this.dataGaps,
  });

  final List<String> affectedProviders;
  final List<String> dataGaps;

  Map<String, dynamic> toJson() {
    return {'affected_providers': affectedProviders, 'data_gaps': dataGaps};
  }
}

class Phase3BookingExecutionResult {
  const Phase3BookingExecutionResult({
    required this.executionStatus,
    required this.displayMessage,
    required this.executionReason,
    required this.transactionPlan,
    required this.trustLayerAction,
    required this.rollbackPlan,
    required this.compensationPlan,
    required this.technicalMetadata,
  });

  final String executionStatus;
  final String displayMessage;
  final String executionReason;
  final Phase3TransactionPlan transactionPlan;
  final EmmaTrustLayerAction trustLayerAction;
  final Phase3RollbackPlan rollbackPlan;
  final Phase3CompensationPlan compensationPlan;
  final Phase3TechnicalMetadata technicalMetadata;

  Map<String, dynamic> toJson() {
    return {
      'execution_status': executionStatus,
      'display_message': displayMessage,
      'execution_reason': executionReason,
      'transaction_plan': transactionPlan.toJson(),
      'trust_layer_action': trustLayerAction.toJson(),
      'rollback_plan': rollbackPlan.toJson(),
      'compensation_plan': compensationPlan.toJson(),
      'technical_metadata': technicalMetadata.toJson(),
    };
  }
}

class Phase3TransactionPlan {
  const Phase3TransactionPlan({
    required this.idempotencyKey,
    required this.commitScope,
    required this.requiresAtomicCommit,
    required this.steps,
  });

  final String idempotencyKey;
  final String commitScope;
  final bool requiresAtomicCommit;
  final List<Map<String, dynamic>> steps;

  Map<String, dynamic> toJson() {
    return {
      'idempotency_key': idempotencyKey,
      'commit_scope': commitScope,
      'requires_atomic_commit': requiresAtomicCommit,
      'steps': steps,
    };
  }
}

class Phase3RollbackPlan {
  const Phase3RollbackPlan({
    required this.required,
    required this.rollbackScope,
    required this.steps,
  });

  final bool required;
  final String? rollbackScope;
  final List<Map<String, dynamic>> steps;

  Map<String, dynamic> toJson() {
    return {
      'required': required,
      'rollback_scope': rollbackScope,
      'steps': steps,
    };
  }
}

class Phase3CompensationPlan {
  const Phase3CompensationPlan({
    required this.required,
    required this.reason,
    required this.suggestedAction,
  });

  final bool required;
  final String? reason;
  final String? suggestedAction;

  Map<String, dynamic> toJson() {
    return {
      'required': required,
      'reason': reason,
      'suggested_action': suggestedAction,
    };
  }
}

class Phase3TechnicalMetadata {
  const Phase3TechnicalMetadata({
    required this.checkedLegs,
    required this.blockedLegs,
    required this.dataGaps,
  });

  final List<String> checkedLegs;
  final List<String> blockedLegs;
  final List<String> dataGaps;

  Map<String, dynamic> toJson() {
    return {
      'checked_legs': checkedLegs,
      'blocked_legs': blockedLegs,
      'data_gaps': dataGaps,
    };
  }
}

class Phase4FulfillmentResult {
  const Phase4FulfillmentResult({
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

  factory Phase4FulfillmentResult.fromJson(Map<String, dynamic> json) {
    return Phase4FulfillmentResult(
      controlStatus: json['control_status']?.toString() ?? '',
      displayMessage: json['display_message']?.toString() ?? '',
      controlReason: json['control_reason']?.toString() ?? '',
      selectedAction: Phase4SelectedAction.fromJson(
        _map(json['selected_action']),
      ),
      incidentSummary: Phase4IncidentSummary.fromJson(
        _map(json['incident_summary']),
      ),
      fulfillmentSummary: Phase4FulfillmentSummary.fromJson(
        _map(json['fulfillment_summary']),
      ),
      reaccommodationOptions:
          (json['reaccommodation_options'] as List? ?? const [])
              .map(
                (item) => Phase4ReaccommodationOption.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(),
      guaranteePolicy: _map(json['guarantee_policy']),
      evidenceLog: EmmaEvidenceLog.fromJson(_map(json['evidence_log'])),
      technicalMetadata: Phase4TechnicalMetadata.fromJson(
        _map(json['technical_metadata']),
      ),
    );
  }

  final String controlStatus;
  final String displayMessage;
  final String controlReason;
  final Phase4SelectedAction selectedAction;
  final Phase4IncidentSummary incidentSummary;
  final Phase4FulfillmentSummary fulfillmentSummary;
  final List<Phase4ReaccommodationOption> reaccommodationOptions;
  final Map<String, dynamic> guaranteePolicy;
  final EmmaEvidenceLog evidenceLog;
  final Phase4TechnicalMetadata technicalMetadata;

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
      'evidence_log': evidenceLog.toJson(),
      'technical_metadata': technicalMetadata.toJson(),
    };
  }
}

class Phase4ReaccommodationOption {
  const Phase4ReaccommodationOption({
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

  factory Phase4ReaccommodationOption.fromJson(Map<String, dynamic> json) {
    return Phase4ReaccommodationOption(
      optionId: json['option_id']?.toString() ?? '',
      providerBundle: (json['provider_bundle'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
      departureTime: DateTime.parse(json['departure_time'].toString()),
      arrivalTime: DateTime.parse(json['arrival_time'].toString()),
      estimatedCostEur: (json['estimated_cost_eur'] as num?)?.toDouble() ?? 0,
      guaranteeLevel: json['guarantee_level']?.toString() ?? 'NONE',
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
  final String guaranteeLevel;
  final bool bookable;
  final bool bookableWithOneTap;
  final bool requiresUserInput;
  final List<String> policyFlags;
  final List<String> exclusionFlags;

  Map<String, dynamic> toJson() {
    return {
      'option_id': optionId,
      'provider_bundle': providerBundle,
      'departure_time': departureTime.toIso8601String(),
      'arrival_time': arrivalTime.toIso8601String(),
      'estimated_cost_eur': estimatedCostEur,
      'guarantee_level': guaranteeLevel,
      'bookable': bookable,
      'bookable_with_one_tap': bookableWithOneTap,
      'requires_user_input': requiresUserInput,
      'policy_flags': policyFlags,
      'exclusion_flags': exclusionFlags,
    };
  }
}

class Phase4SelectedAction {
  const Phase4SelectedAction({
    required this.actionType,
    required this.targetOptionId,
    required this.guaranteeCase,
    required this.manualOpsEscalation,
  });

  factory Phase4SelectedAction.fromJson(Map<String, dynamic> json) {
    return Phase4SelectedAction(
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

class Phase4IncidentSummary {
  const Phase4IncidentSummary({
    required this.activeIncident,
    required this.incidentIds,
    required this.highestSeverity,
    required this.affectedLegIds,
  });

  factory Phase4IncidentSummary.fromJson(Map<String, dynamic> json) {
    return Phase4IncidentSummary(
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

class Phase4FulfillmentSummary {
  const Phase4FulfillmentSummary({
    required this.bookingState,
    required this.paymentState,
    required this.entitlementState,
    required this.missingArtifacts,
    required this.providerConfirmationGaps,
  });

  factory Phase4FulfillmentSummary.fromJson(Map<String, dynamic> json) {
    return Phase4FulfillmentSummary(
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

class Phase4TechnicalMetadata {
  const Phase4TechnicalMetadata({
    required this.journeyStatusEvaluated,
    required this.guaranteeRiskDetected,
    required this.reaccommodationEvaluated,
    required this.selectedReaccommodationOptionId,
    required this.affectedProviders,
    required this.dataGaps,
  });

  factory Phase4TechnicalMetadata.fromJson(Map<String, dynamic> json) {
    return Phase4TechnicalMetadata(
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

class Phase5SettlementResult {
  const Phase5SettlementResult({
    required this.settlementStatus,
    required this.caseClosureStatus,
    required this.displayMessage,
    required this.settlementReason,
    required this.refundDecision,
    required this.compensationDecision,
    required this.responsibilitySummary,
    required this.settlementPlan,
    required this.technicalMetadata,
  });

  factory Phase5SettlementResult.fromJson(Map<String, dynamic> json) {
    return Phase5SettlementResult(
      settlementStatus: json['settlement_status']?.toString() ?? '',
      caseClosureStatus: json['case_closure_status']?.toString() ?? '',
      displayMessage: json['display_message']?.toString() ?? '',
      settlementReason: json['settlement_reason']?.toString() ?? '',
      refundDecision: Phase5FinancialDecision.fromJson(
        _map(json['refund_decision']),
      ),
      compensationDecision: Phase5FinancialDecision.fromJson(
        _map(json['compensation_decision']),
      ),
      responsibilitySummary: Phase5ResponsibilitySummary.fromJson(
        _map(json['responsibility_summary']),
      ),
      settlementPlan: Phase5SettlementPlan.fromJson(
        _map(json['settlement_plan']),
      ),
      technicalMetadata: Phase5TechnicalMetadata.fromJson(
        _map(json['technical_metadata']),
      ),
    );
  }

  final String settlementStatus;
  final String caseClosureStatus;
  final String displayMessage;
  final String settlementReason;
  final Phase5FinancialDecision refundDecision;
  final Phase5FinancialDecision compensationDecision;
  final Phase5ResponsibilitySummary responsibilitySummary;
  final Phase5SettlementPlan settlementPlan;
  final Phase5TechnicalMetadata technicalMetadata;

  Map<String, dynamic> toJson() {
    return {
      'settlement_status': settlementStatus,
      'case_closure_status': caseClosureStatus,
      'display_message': displayMessage,
      'settlement_reason': settlementReason,
      'refund_decision': refundDecision.toJson(),
      'compensation_decision': compensationDecision.toJson(),
      'responsibility_summary': responsibilitySummary.toJson(),
      'settlement_plan': settlementPlan.toJson(),
      'technical_metadata': technicalMetadata.toJson(),
    };
  }
}

class Phase5FinancialDecision {
  const Phase5FinancialDecision({
    required this.eligible,
    required this.scope,
    required this.amountEur,
    required this.target,
    required this.basis,
  });

  factory Phase5FinancialDecision.fromJson(Map<String, dynamic> json) {
    return Phase5FinancialDecision(
      eligible:
          json['refund_eligible'] == true ||
          json['compensation_eligible'] == true,
      scope:
          json['refund_scope']?.toString() ??
          json['compensation_scope']?.toString() ??
          'NONE',
      amountEur:
          (json['refund_amount_eur'] as num?)?.toDouble() ??
          (json['compensation_amount_eur'] as num?)?.toDouble() ??
          0,
      target:
          json['refund_target']?.toString() ??
          json['compensation_form']?.toString(),
      basis:
          ((json['refund_basis'] ?? json['compensation_basis']) as List? ??
                  const [])
              .map((item) => item.toString())
              .toList(),
    );
  }

  final bool eligible;
  final String scope;
  final double amountEur;
  final String? target;
  final List<String> basis;

  Map<String, dynamic> toJson() {
    return {
      'eligible': eligible,
      'scope': scope,
      'amount_eur': amountEur,
      'target': target,
      'basis': basis,
    };
  }
}

class Phase5ResponsibilitySummary {
  const Phase5ResponsibilitySummary({
    required this.operationalResponsibilityHint,
    required this.financialResponsibilityHint,
  });

  factory Phase5ResponsibilitySummary.fromJson(Map<String, dynamic> json) {
    return Phase5ResponsibilitySummary(
      operationalResponsibilityHint: json['operational_responsibility_hint']
          ?.toString(),
      financialResponsibilityHint: json['financial_responsibility_hint']
          ?.toString(),
    );
  }

  final String? operationalResponsibilityHint;
  final String? financialResponsibilityHint;

  Map<String, dynamic> toJson() {
    return {
      'operational_responsibility_hint': operationalResponsibilityHint,
      'financial_responsibility_hint': financialResponsibilityHint,
    };
  }
}

class Phase5SettlementPlan {
  const Phase5SettlementPlan({required this.caseOwner, required this.actions});

  factory Phase5SettlementPlan.fromJson(Map<String, dynamic> json) {
    return Phase5SettlementPlan(
      caseOwner: json['case_owner']?.toString() ?? '',
      actions: (json['actions'] as List? ?? const [])
          .map((item) => _map(item))
          .toList(),
    );
  }

  final String caseOwner;
  final List<Map<String, dynamic>> actions;

  Map<String, dynamic> toJson() {
    return {'case_owner': caseOwner, 'actions': actions};
  }
}

class Phase5TechnicalMetadata {
  const Phase5TechnicalMetadata({
    required this.financialReconciliationComplete,
    required this.evidenceSufficient,
    required this.providerAssignmentComplete,
    required this.dataGaps,
  });

  factory Phase5TechnicalMetadata.fromJson(Map<String, dynamic> json) {
    return Phase5TechnicalMetadata(
      financialReconciliationComplete:
          json['financial_reconciliation_complete'] == true,
      evidenceSufficient: json['evidence_sufficient'] == true,
      providerAssignmentComplete: json['provider_assignment_complete'] == true,
      dataGaps: (json['data_gaps'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
    );
  }

  final bool financialReconciliationComplete;
  final bool evidenceSufficient;
  final bool providerAssignmentComplete;
  final List<String> dataGaps;

  Map<String, dynamic> toJson() {
    return {
      'financial_reconciliation_complete': financialReconciliationComplete,
      'evidence_sufficient': evidenceSufficient,
      'provider_assignment_complete': providerAssignmentComplete,
      'data_gaps': dataGaps,
    };
  }
}
