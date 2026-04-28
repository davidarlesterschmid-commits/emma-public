class BookingExecutionInput {
  const BookingExecutionInput({
    required this.schemaVersion,
    required this.phase2Result,
    required this.tripContext,
    required this.userContext,
    required this.selectedOption,
    required this.providerExecutionStatus,
    required this.serviceRules,
    required this.executionContext,
  });

  factory BookingExecutionInput.fromJson(Map<String, dynamic> json) {
    return BookingExecutionInput(
      schemaVersion: json['schema_version']?.toString() ?? '1.0',
      phase2Result: Map<String, dynamic>.from(
        json['phase2_result'] as Map? ?? const {},
      ),
      tripContext: Map<String, dynamic>.from(
        json['trip_context'] as Map? ?? const {},
      ),
      userContext: Map<String, dynamic>.from(
        json['user_context'] as Map? ?? const {},
      ),
      selectedOption: Map<String, dynamic>.from(
        json['selected_option'] as Map? ?? const {},
      ),
      providerExecutionStatus: Map<String, dynamic>.from(
        json['provider_execution_status'] as Map? ?? const {},
      ),
      serviceRules: Map<String, dynamic>.from(
        json['service_rules'] as Map? ?? const {},
      ),
      executionContext: Map<String, dynamic>.from(
        json['execution_context'] as Map? ?? const {},
      ),
    );
  }

  final String schemaVersion;
  final Map<String, dynamic> phase2Result;
  final Map<String, dynamic> tripContext;
  final Map<String, dynamic> userContext;
  final Map<String, dynamic> selectedOption;
  final Map<String, dynamic> providerExecutionStatus;
  final Map<String, dynamic> serviceRules;
  final Map<String, dynamic> executionContext;
}

class BookingExecutionOutput {
  const BookingExecutionOutput({
    required this.schemaVersion,
    required this.executionStatus,
    required this.displayMessage,
    required this.executionReason,
    required this.transactionPlan,
    required this.trustLayerAction,
    required this.rollbackPlan,
    required this.compensationPlan,
    required this.technicalMetadata,
  });

  final String schemaVersion;
  final String executionStatus;
  final String displayMessage;
  final String executionReason;
  final TransactionPlan transactionPlan;
  final BookingTrustLayerAction trustLayerAction;
  final RollbackPlan rollbackPlan;
  final CompensationPlan compensationPlan;
  final BookingTechnicalMetadata technicalMetadata;

  Map<String, dynamic> toJson() {
    return {
      'schema_version': schemaVersion,
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

class TransactionPlan {
  const TransactionPlan({
    required this.idempotencyKey,
    required this.commitScope,
    required this.requiresAtomicCommit,
    required this.steps,
  });

  final String idempotencyKey;
  final String commitScope;
  final bool requiresAtomicCommit;
  final List<ExecutionStep> steps;

  Map<String, dynamic> toJson() {
    return {
      'idempotency_key': idempotencyKey,
      'commit_scope': commitScope,
      'requires_atomic_commit': requiresAtomicCommit,
      'steps': steps.map((step) => step.toJson()).toList(),
    };
  }
}

class ExecutionStep {
  const ExecutionStep({
    required this.stepNo,
    required this.action,
    required this.provider,
    required this.legId,
    required this.mandatory,
  });

  final int stepNo;
  final String action;
  final String provider;
  final String legId;
  final bool mandatory;

  Map<String, dynamic> toJson() {
    return {
      'step_no': stepNo,
      'action': action,
      'provider': provider,
      'leg_id': legId,
      'mandatory': mandatory,
    };
  }
}

class BookingTrustLayerAction {
  const BookingTrustLayerAction({
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

class RollbackPlan {
  const RollbackPlan({
    required this.required,
    required this.rollbackScope,
    required this.steps,
  });

  final bool required;
  final String? rollbackScope;
  final List<ExecutionStep> steps;

  Map<String, dynamic> toJson() {
    return {
      'required': required,
      'rollback_scope': rollbackScope,
      'steps': steps.map((step) => step.toJson()).toList(),
    };
  }
}

class CompensationPlan {
  const CompensationPlan({
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

class BookingTechnicalMetadata {
  const BookingTechnicalMetadata({
    required this.checkedLegs,
    required this.blockedLegs,
    required this.providerStates,
    required this.policyResults,
    required this.dataGaps,
  });

  final List<String> checkedLegs;
  final List<String> blockedLegs;
  final Map<String, dynamic> providerStates;
  final BookingPolicyResults policyResults;
  final List<String> dataGaps;

  Map<String, dynamic> toJson() {
    return {
      'checked_legs': checkedLegs,
      'blocked_legs': blockedLegs,
      'provider_states': providerStates,
      'policy_results': policyResults.toJson(),
      'data_gaps': dataGaps,
    };
  }
}

class BookingPolicyResults {
  const BookingPolicyResults({
    required this.consentOk,
    required this.paymentOk,
    required this.budgetOk,
    required this.inventoryOk,
    required this.guaranteeOk,
    required this.partialBookingOk,
  });

  final bool consentOk;
  final bool paymentOk;
  final bool budgetOk;
  final bool inventoryOk;
  final bool guaranteeOk;
  final bool partialBookingOk;

  Map<String, dynamic> toJson() {
    return {
      'consent_ok': consentOk,
      'payment_ok': paymentOk,
      'budget_ok': budgetOk,
      'inventory_ok': inventoryOk,
      'guarantee_ok': guaranteeOk,
      'partial_booking_ok': partialBookingOk,
    };
  }
}
