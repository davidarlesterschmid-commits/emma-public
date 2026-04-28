class DemandRecognitionInput {
  const DemandRecognitionInput({
    required this.userProfile,
    required this.calendarData,
    required this.realtimeStatus,
    required this.environmentalData,
    required this.currentLocation,
    required this.candidateOptions,
  });

  factory DemandRecognitionInput.fromJson(Map<String, dynamic> json) {
    return DemandRecognitionInput(
      userProfile: Map<String, dynamic>.from(
        json['user_profile'] as Map? ?? const {},
      ),
      calendarData: Map<String, dynamic>.from(
        json['calendar_data'] as Map? ?? const {},
      ),
      realtimeStatus: Map<String, dynamic>.from(
        json['realtime_status'] as Map? ?? const {},
      ),
      environmentalData: Map<String, dynamic>.from(
        json['environmental_data'] as Map? ?? const {},
      ),
      currentLocation: Map<String, dynamic>.from(
        json['current_location'] as Map? ?? const {},
      ),
      candidateOptions: (json['candidate_options'] as List? ?? const [])
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList(),
    );
  }

  final Map<String, dynamic> userProfile;
  final Map<String, dynamic> calendarData;
  final Map<String, dynamic> realtimeStatus;
  final Map<String, dynamic> environmentalData;
  final Map<String, dynamic> currentLocation;
  final List<Map<String, dynamic>> candidateOptions;
}

class DemandRecognitionOutput {
  const DemandRecognitionOutput({
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
  final TrustLayerAction trustLayerAction;
  final TechnicalMetadata technicalMetadata;

  Map<String, dynamic> toJson() {
    return {
      'intent_detected': intentDetected,
      'confidence_score': double.parse(confidenceScore.toStringAsFixed(2)),
      'trigger_reason': triggerReason,
      'action_type': actionType,
      'display_message': displayMessage,
      'trust_layer_action': trustLayerAction.toJson(),
      'technical_metadata': technicalMetadata.toJson(),
    };
  }
}

class TrustLayerAction {
  const TrustLayerAction({
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

class TechnicalMetadata {
  const TechnicalMetadata({
    required this.phases,
    required this.decisionBasis,
    required this.affectedProviders,
    required this.usedCandidateOptionId,
    required this.dataGaps,
  });

  final List<int> phases;
  final DecisionBasis decisionBasis;
  final List<String> affectedProviders;
  final String? usedCandidateOptionId;
  final List<String> dataGaps;

  Map<String, dynamic> toJson() {
    return {
      'phases': phases,
      'decision_basis': decisionBasis.toJson(),
      'affected_providers': affectedProviders,
      'used_candidate_option_id': usedCandidateOptionId,
      'data_gaps': dataGaps,
    };
  }
}

class DecisionBasis {
  const DecisionBasis({
    required this.calendarMatch,
    required this.routineMatch,
    required this.realtimeIssue,
    required this.weatherIssue,
    required this.budgetIssue,
    required this.optimizationFound,
  });

  final bool calendarMatch;
  final bool routineMatch;
  final bool realtimeIssue;
  final bool weatherIssue;
  final bool budgetIssue;
  final bool optimizationFound;

  Map<String, dynamic> toJson() {
    return {
      'calendar_match': calendarMatch,
      'routine_match': routineMatch,
      'realtime_issue': realtimeIssue,
      'weather_issue': weatherIssue,
      'budget_issue': budgetIssue,
      'optimization_found': optimizationFound,
    };
  }
}
