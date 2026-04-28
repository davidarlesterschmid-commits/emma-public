class Phase1ToPhase2Handoff {
  const Phase1ToPhase2Handoff({
    required this.globalCaseId,
    required this.tripId,
    required this.userId,
    required this.traceId,
    required this.idempotencyKey,
    required this.intentDetected,
    required this.confidenceScore,
    required this.actionType,
    required this.triggerReason,
  });

  final String globalCaseId;
  final String tripId;
  final String userId;
  final String traceId;
  final String idempotencyKey;
  final bool intentDetected;
  final double confidenceScore;
  final String actionType;
  final String triggerReason;

  Map<String, dynamic> toJson() {
    return {
      'global_case_id': globalCaseId,
      'trip_id': tripId,
      'user_id': userId,
      'trace_id': traceId,
      'idempotency_key': idempotencyKey,
      'intent_detected': intentDetected,
      'confidence_score': confidenceScore,
      'action_type': actionType,
      'trigger_reason': triggerReason,
    };
  }
}

class Phase2ToPhase3Handoff {
  const Phase2ToPhase3Handoff({
    required this.globalCaseId,
    required this.tripId,
    required this.userId,
    required this.traceId,
    required this.idempotencyKey,
    required this.recommendedOptionId,
    required this.recommendationStatus,
    required this.selectionReason,
    required this.providerBundle,
  });

  final String globalCaseId;
  final String tripId;
  final String userId;
  final String traceId;
  final String idempotencyKey;
  final String recommendedOptionId;
  final String recommendationStatus;
  final String selectionReason;
  final List<String> providerBundle;

  Map<String, dynamic> toJson() {
    return {
      'global_case_id': globalCaseId,
      'trip_id': tripId,
      'user_id': userId,
      'trace_id': traceId,
      'idempotency_key': idempotencyKey,
      'recommended_option_id': recommendedOptionId,
      'recommendation_status': recommendationStatus,
      'selection_reason': selectionReason,
      'provider_bundle': providerBundle,
    };
  }
}

class Phase3ToPhase4Handoff {
  const Phase3ToPhase4Handoff({
    required this.globalCaseId,
    required this.tripId,
    required this.userId,
    required this.traceId,
    required this.idempotencyKey,
    required this.selectedOptionId,
    required this.executionStatus,
    required this.commitScope,
    required this.providerBundle,
  });

  final String globalCaseId;
  final String tripId;
  final String userId;
  final String traceId;
  final String idempotencyKey;
  final String selectedOptionId;
  final String executionStatus;
  final String commitScope;
  final List<String> providerBundle;

  Map<String, dynamic> toJson() {
    return {
      'global_case_id': globalCaseId,
      'trip_id': tripId,
      'user_id': userId,
      'trace_id': traceId,
      'idempotency_key': idempotencyKey,
      'selected_option_id': selectedOptionId,
      'execution_status': executionStatus,
      'commit_scope': commitScope,
      'provider_bundle': providerBundle,
    };
  }
}

class Phase4ToPhase5Handoff {
  const Phase4ToPhase5Handoff({
    required this.globalCaseId,
    required this.tripId,
    required this.userId,
    required this.traceId,
    required this.idempotencyKey,
    required this.controlStatus,
    required this.incidentSummary,
    required this.fulfillmentSummary,
    required this.evidenceLog,
  });

  final String globalCaseId;
  final String tripId;
  final String userId;
  final String traceId;
  final String idempotencyKey;
  final String controlStatus;
  final Map<String, dynamic> incidentSummary;
  final Map<String, dynamic> fulfillmentSummary;
  final Map<String, dynamic> evidenceLog;

  Map<String, dynamic> toJson() {
    return {
      'global_case_id': globalCaseId,
      'trip_id': tripId,
      'user_id': userId,
      'trace_id': traceId,
      'idempotency_key': idempotencyKey,
      'control_status': controlStatus,
      'incident_summary': incidentSummary,
      'fulfillment_summary': fulfillmentSummary,
      'evidence_log': evidenceLog,
    };
  }
}

class HandoffBundle {
  const HandoffBundle({
    required this.phase1ToPhase2,
    required this.phase2ToPhase3,
    required this.phase3ToPhase4,
    required this.phase4ToPhase5,
  });

  final Phase1ToPhase2Handoff phase1ToPhase2;
  final Phase2ToPhase3Handoff phase2ToPhase3;
  final Phase3ToPhase4Handoff phase3ToPhase4;
  final Phase4ToPhase5Handoff phase4ToPhase5;
}
