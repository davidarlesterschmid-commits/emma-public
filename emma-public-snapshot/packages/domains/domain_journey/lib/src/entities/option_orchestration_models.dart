class OptionOrchestrationInput {
  const OptionOrchestrationInput({
    required this.schemaVersion,
    required this.phase1Result,
    required this.tripContext,
    required this.userProfile,
    required this.serviceRules,
    required this.candidateOptions,
  });

  factory OptionOrchestrationInput.fromJson(Map<String, dynamic> json) {
    return OptionOrchestrationInput(
      schemaVersion: json['schema_version']?.toString() ?? '1.0',
      phase1Result: Map<String, dynamic>.from(
        json['phase1_result'] as Map? ?? const {},
      ),
      tripContext: Map<String, dynamic>.from(
        json['trip_context'] as Map? ?? const {},
      ),
      userProfile: Map<String, dynamic>.from(
        json['user_profile'] as Map? ?? const {},
      ),
      serviceRules: Map<String, dynamic>.from(
        json['service_rules'] as Map? ?? const {},
      ),
      candidateOptions: (json['candidate_options'] as List? ?? const [])
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList(),
    );
  }

  final String schemaVersion;
  final Map<String, dynamic> phase1Result;
  final Map<String, dynamic> tripContext;
  final Map<String, dynamic> userProfile;
  final Map<String, dynamic> serviceRules;
  final List<Map<String, dynamic>> candidateOptions;
}

class OptionOrchestrationOutput {
  const OptionOrchestrationOutput({
    required this.schemaVersion,
    required this.recommendationStatus,
    required this.recommendedOptionId,
    required this.displayMessage,
    required this.selectionReason,
    required this.trustLayerAction,
    required this.alternativesSummary,
    required this.technicalMetadata,
  });

  final String schemaVersion;
  final String recommendationStatus;
  final String? recommendedOptionId;
  final String displayMessage;
  final String selectionReason;
  final OptionTrustLayerAction trustLayerAction;
  final AlternativesSummary alternativesSummary;
  final OptionTechnicalMetadata technicalMetadata;

  Map<String, dynamic> toJson() {
    return {
      'schema_version': schemaVersion,
      'recommendation_status': recommendationStatus,
      'recommended_option_id': recommendedOptionId,
      'display_message': displayMessage,
      'selection_reason': selectionReason,
      'trust_layer_action': trustLayerAction.toJson(),
      'alternatives_summary': alternativesSummary.toJson(),
      'technical_metadata': technicalMetadata.toJson(),
    };
  }
}

class OptionTrustLayerAction {
  const OptionTrustLayerAction({
    required this.type,
    required this.primaryCta,
    required this.payload,
  });

  final String type;
  final String? primaryCta;
  final Map<String, dynamic>? payload;

  Map<String, dynamic> toJson() {
    return {'type': type, 'primary_cta': primaryCta, 'payload': payload};
  }
}

class AlternativesSummary {
  const AlternativesSummary({
    required this.consideredOptionsCount,
    required this.eligibleOptionsCount,
    required this.discardedOptionIds,
    required this.discardReasons,
  });

  final int consideredOptionsCount;
  final int eligibleOptionsCount;
  final List<String> discardedOptionIds;
  final Map<String, String> discardReasons;

  Map<String, dynamic> toJson() {
    return {
      'considered_options_count': consideredOptionsCount,
      'eligible_options_count': eligibleOptionsCount,
      'discarded_option_ids': discardedOptionIds,
      'discard_reasons': discardReasons,
    };
  }
}

class OptionTechnicalMetadata {
  const OptionTechnicalMetadata({
    required this.decisionPath,
    required this.selectedBecause,
    required this.affectedProviders,
    required this.dataGaps,
  });

  final DecisionPath decisionPath;
  final SelectedBecause selectedBecause;
  final List<String> affectedProviders;
  final List<String> dataGaps;

  Map<String, dynamic> toJson() {
    return {
      'decision_path': decisionPath.toJson(),
      'selected_because': selectedBecause.toJson(),
      'affected_providers': affectedProviders,
      'data_gaps': dataGaps,
    };
  }
}

class DecisionPath {
  const DecisionPath({
    required this.hardFiltersApplied,
    required this.guaranteeRuleApplied,
    required this.budgetRuleApplied,
    required this.preferenceRuleApplied,
  });

  final bool hardFiltersApplied;
  final bool guaranteeRuleApplied;
  final bool budgetRuleApplied;
  final bool preferenceRuleApplied;

  Map<String, dynamic> toJson() {
    return {
      'hard_filters_applied': hardFiltersApplied,
      'guarantee_rule_applied': guaranteeRuleApplied,
      'budget_rule_applied': budgetRuleApplied,
      'preference_rule_applied': preferenceRuleApplied,
    };
  }
}

class SelectedBecause {
  const SelectedBecause({
    required this.bestGuaranteeLevel,
    required this.earliestViableArrival,
    required this.budgetCompliant,
    required this.lowestComplexity,
    required this.lowestCost,
  });

  final bool bestGuaranteeLevel;
  final bool earliestViableArrival;
  final bool budgetCompliant;
  final bool lowestComplexity;
  final bool lowestCost;

  Map<String, dynamic> toJson() {
    return {
      'best_guarantee_level': bestGuaranteeLevel,
      'earliest_viable_arrival': earliestViableArrival,
      'budget_compliant': budgetCompliant,
      'lowest_complexity': lowestComplexity,
      'lowest_cost': lowestCost,
    };
  }
}
