import 'package:domain_journey/src/contracts/case/emma_case_contract.dart';
import 'package:domain_journey/src/contracts/common/contract_enums.dart';
import 'package:domain_journey/src/contracts/common/contract_models.dart';

Map<String, dynamic> _map(Object? input) =>
    Map<String, dynamic>.from(input as Map? ?? const {});

class EmmaPhaseGate {
  const EmmaPhaseGate({
    required this.gatePassed,
    required this.sourcePhase,
    required this.targetPhase,
    required this.requiredHandoffFields,
    required this.missingHandoffFields,
  });

  final bool gatePassed;
  final EmmaPhase sourcePhase;
  final EmmaPhase targetPhase;
  final List<String> requiredHandoffFields;
  final List<String> missingHandoffFields;

  Map<String, dynamic> toJson() {
    return {
      'gate_passed': gatePassed,
      'source_phase': sourcePhase.value,
      'target_phase': targetPhase.value,
      'required_handoff_fields': requiredHandoffFields,
      'missing_handoff_fields': missingHandoffFields,
    };
  }
}

class EmmaOrchestratorCaseKeys {
  const EmmaOrchestratorCaseKeys({
    required this.globalCaseId,
    required this.tripId,
    required this.optionId,
    required this.idempotencyKey,
  });

  final String globalCaseId;
  final String tripId;
  final String? optionId;
  final String idempotencyKey;

  Map<String, dynamic> toJson() {
    return {
      'global_case_id': globalCaseId,
      'trip_id': tripId,
      'option_id': optionId,
      'idempotency_key': idempotencyKey,
    };
  }
}

class MasterOrchestratorResult {
  const MasterOrchestratorResult({
    required this.orchestratorStatus,
    required this.orchestrationAction,
    required this.displayMessage,
    required this.decisionReason,
    required this.currentPhase,
    required this.currentState,
    required this.nextPhase,
    required this.nextState,
    required this.nextActor,
    required this.phaseGate,
    required this.caseKeys,
    required this.error,
    required this.auditTraceDelta,
  });

  final String orchestratorStatus;
  final EmmaOrchestrationAction orchestrationAction;
  final String displayMessage;
  final String decisionReason;
  final EmmaPhase currentPhase;
  final String currentState;
  final EmmaPhase? nextPhase;
  final String? nextState;
  final EmmaNextActor nextActor;
  final EmmaPhaseGate phaseGate;
  final EmmaOrchestratorCaseKeys caseKeys;
  final EmmaErrorBlock error;
  final List<EmmaAuditEntry> auditTraceDelta;

  Map<String, dynamic> toJson() {
    return {
      'orchestrator_status': orchestratorStatus,
      'orchestration_action': orchestrationAction.value,
      'display_message': displayMessage,
      'decision_reason': decisionReason,
      'current_phase': currentPhase.value,
      'current_state': currentState,
      'next_phase': nextPhase?.value,
      'next_state': nextState,
      'next_actor': nextActor.value,
      'phase_gate': phaseGate.toJson(),
      'case_keys': caseKeys.toJson(),
      'error': error.toJson(),
      'audit_trace_delta': auditTraceDelta
          .map((entry) => entry.toJson())
          .toList(),
    };
  }
}

class MasterOrchestrator {
  const MasterOrchestrator();

  static const Map<EmmaPhase, EmmaPhase> _nextPhases = {
    EmmaPhase.phase1: EmmaPhase.phase2,
    EmmaPhase.phase2: EmmaPhase.phase3,
    EmmaPhase.phase3: EmmaPhase.phase4,
    EmmaPhase.phase4: EmmaPhase.phase5,
  };

  static const Map<EmmaPhase, String> _nextStates = {
    EmmaPhase.phase1: 'OPTION_SELECTION_PENDING',
    EmmaPhase.phase2: 'BOOKING_PENDING',
    EmmaPhase.phase3: 'JOURNEY_ACTIVE',
    EmmaPhase.phase4: 'SETTLEMENT_PENDING',
  };

  static const Map<EmmaPhase, List<String>> _requiredFields = {
    EmmaPhase.phase1: [
      'intent_detected',
      'confidence_score',
      'action_type',
      'trigger_reason',
    ],
    EmmaPhase.phase2: [
      'recommended_option_id',
      'recommendation_status',
      'selection_reason',
      'trust_layer_action.payload.provider_bundle',
    ],
    EmmaPhase.phase3: [
      'execution_status',
      'transaction_plan.idempotency_key',
      'transaction_plan.commit_scope',
      'trust_layer_action.payload.option_id',
      'trust_layer_action.payload.provider_bundle',
    ],
    EmmaPhase.phase4: [
      'control_status',
      'incident_summary',
      'fulfillment_summary',
      'evidence_log',
    ],
  };

  MasterOrchestratorResult evaluate(EmmaCaseContract emmaCase) {
    final currentPhase = emmaCase.caseHeader.currentPhase;
    final currentState = emmaCase.caseHeader.currentState;
    final currentResult = emmaCase.phaseState.byPhase(currentPhase).result;
    final nextPhase = _nextPhases[currentPhase];
    final optionId = emmaCase.sharedEntities.selectedOptionId;

    if (!_hasRequiredBaseIds(emmaCase)) {
      return _blocked(
        emmaCase: emmaCase,
        currentPhase: currentPhase,
        currentState: currentState,
        nextPhase: nextPhase,
        optionId: optionId,
        reason:
            'Required case identity fields are missing in case_header or identity',
        error: const EmmaErrorBlock(
          errorClass: EmmaErrorClass.missingRequiredInput,
          errorMessage: 'Missing required identity fields',
          blocking: true,
          sourcePhase: null,
          sourceField: 'case_header/identity',
          retryable: false,
        ),
        missingFields: const [
          'global_case_id',
          'trip_id',
          'user_id',
          'trace_id',
          'idempotency_key',
        ],
      );
    }

    if (nextPhase == null) {
      return MasterOrchestratorResult(
        orchestratorStatus: 'READY',
        orchestrationAction: EmmaOrchestrationAction.closeCase,
        displayMessage: '',
        decisionReason: 'Phase 5 has completed the terminal contract path',
        currentPhase: currentPhase,
        currentState: currentState,
        nextPhase: null,
        nextState: 'CASE_CLOSED',
        nextActor: EmmaNextActor.system,
        phaseGate: EmmaPhaseGate(
          gatePassed: true,
          sourcePhase: currentPhase,
          targetPhase: currentPhase,
          requiredHandoffFields: const [],
          missingHandoffFields: const [],
        ),
        caseKeys: EmmaOrchestratorCaseKeys(
          globalCaseId: emmaCase.caseHeader.globalCaseId,
          tripId: emmaCase.caseHeader.tripId,
          optionId: optionId,
          idempotencyKey: emmaCase.identity.idempotencyKey,
        ),
        error: EmmaErrorBlock.none(),
        auditTraceDelta: const [],
      );
    }

    if (currentResult == null) {
      return _blocked(
        emmaCase: emmaCase,
        currentPhase: currentPhase,
        currentState: currentState,
        nextPhase: nextPhase,
        optionId: optionId,
        reason: 'Current phase has no result payload to hand off',
        error: EmmaErrorBlock(
          errorClass: EmmaErrorClass.upstreamPhaseMissing,
          errorMessage: 'Current phase result is missing',
          blocking: true,
          sourcePhase: currentPhase,
          sourceField: 'phase_state.result',
          retryable: false,
        ),
        missingFields: _requiredFields[currentPhase] ?? const [],
      );
    }

    final idConflict = _findIdConflict(
      emmaCase: emmaCase,
      payload: currentResult,
    );
    if (idConflict != null) {
      return _blocked(
        emmaCase: emmaCase,
        currentPhase: currentPhase,
        currentState: currentState,
        nextPhase: nextPhase,
        optionId: optionId,
        reason: 'Payload and case header identity conflict at $idConflict',
        error: EmmaErrorBlock(
          errorClass: EmmaErrorClass.idConflict,
          errorMessage: 'ID conflict detected at $idConflict',
          blocking: true,
          sourcePhase: currentPhase,
          sourceField: idConflict,
          retryable: false,
        ),
        missingFields: const [],
      );
    }

    final required = _requiredFields[currentPhase] ?? const <String>[];
    final missing = required
        .where((field) => !_hasValueAtPath(currentResult, field))
        .toList();

    if (missing.isNotEmpty) {
      return _blocked(
        emmaCase: emmaCase,
        currentPhase: currentPhase,
        currentState: currentState,
        nextPhase: nextPhase,
        optionId: optionId,
        reason: 'Phase gate blocked because handoff fields are missing',
        error: EmmaErrorBlock(
          errorClass: EmmaErrorClass.missingRequiredInput,
          errorMessage: 'Missing handoff fields: ${missing.join(', ')}',
          blocking: true,
          sourcePhase: currentPhase,
          sourceField: missing.first,
          retryable: false,
        ),
        missingFields: missing,
      );
    }

    final auditEntry = EmmaAuditEntry(
      eventId: 'evt_${DateTime.now().microsecondsSinceEpoch}',
      eventTimestamp: DateTime.now(),
      eventType: 'PHASE_TRANSITION_APPROVED',
      sourcePhase: currentPhase,
      targetPhase: nextPhase,
      decisionSummary:
          '${currentPhase.value} to ${nextPhase.value} gate passed',
      ruleBasis: required.map((field) => '$field=present').toList(),
      errorClass: EmmaErrorClass.none,
      actor: 'SYSTEM',
    );

    return MasterOrchestratorResult(
      orchestratorStatus: 'READY',
      orchestrationAction: EmmaOrchestrationAction.advanceToNextPhase,
      displayMessage: '',
      decisionReason:
          '${currentPhase.value} completed with required handoff fields; transition allowed',
      currentPhase: currentPhase,
      currentState: currentState,
      nextPhase: nextPhase,
      nextState: _nextStates[currentPhase],
      nextActor: EmmaNextActor.system,
      phaseGate: EmmaPhaseGate(
        gatePassed: true,
        sourcePhase: currentPhase,
        targetPhase: nextPhase,
        requiredHandoffFields: required,
        missingHandoffFields: const [],
      ),
      caseKeys: EmmaOrchestratorCaseKeys(
        globalCaseId: emmaCase.caseHeader.globalCaseId,
        tripId: emmaCase.caseHeader.tripId,
        optionId: optionId,
        idempotencyKey: emmaCase.identity.idempotencyKey,
      ),
      error: EmmaErrorBlock.none(),
      auditTraceDelta: [auditEntry],
    );
  }

  bool _hasRequiredBaseIds(EmmaCaseContract emmaCase) {
    return emmaCase.caseHeader.globalCaseId.isNotEmpty &&
        emmaCase.caseHeader.tripId.isNotEmpty &&
        emmaCase.caseHeader.userId.isNotEmpty &&
        emmaCase.identity.traceId.isNotEmpty &&
        emmaCase.identity.idempotencyKey.isNotEmpty;
  }

  String? _findIdConflict({
    required EmmaCaseContract emmaCase,
    required Map<String, dynamic> payload,
  }) {
    final globalCaseId = payload['global_case_id']?.toString();
    if (globalCaseId != null &&
        globalCaseId.isNotEmpty &&
        globalCaseId != emmaCase.caseHeader.globalCaseId) {
      return 'global_case_id';
    }

    final tripId = payload['trip_id']?.toString();
    if (tripId != null &&
        tripId.isNotEmpty &&
        tripId != emmaCase.caseHeader.tripId) {
      return 'trip_id';
    }

    final userId = payload['user_id']?.toString();
    if (userId != null &&
        userId.isNotEmpty &&
        userId != emmaCase.caseHeader.userId) {
      return 'user_id';
    }

    final traceId = payload['trace_id']?.toString();
    if (traceId != null &&
        traceId.isNotEmpty &&
        traceId != emmaCase.identity.traceId) {
      return 'trace_id';
    }

    final idempotencyKey = payload['idempotency_key']?.toString();
    if (idempotencyKey != null &&
        idempotencyKey.isNotEmpty &&
        idempotencyKey != emmaCase.identity.idempotencyKey) {
      return 'idempotency_key';
    }

    return null;
  }

  bool _hasValueAtPath(Map<String, dynamic> payload, String path) {
    Object? current = payload;
    for (final segment in path.split('.')) {
      if (current is! Map) {
        return false;
      }
      current = _map(current)[segment];
      if (current == null) {
        return false;
      }
    }

    if (current is String) {
      return current.isNotEmpty;
    }
    if (current is List) {
      return current.isNotEmpty;
    }
    if (current is Map) {
      return current.isNotEmpty;
    }
    return true;
  }

  MasterOrchestratorResult _blocked({
    required EmmaCaseContract emmaCase,
    required EmmaPhase currentPhase,
    required String currentState,
    required EmmaPhase? nextPhase,
    required String? optionId,
    required String reason,
    required EmmaErrorBlock error,
    required List<String> missingFields,
  }) {
    return MasterOrchestratorResult(
      orchestratorStatus: 'READY',
      orchestrationAction: EmmaOrchestrationAction.blockCase,
      displayMessage: '',
      decisionReason: reason,
      currentPhase: currentPhase,
      currentState: currentState,
      nextPhase: nextPhase,
      nextState: null,
      nextActor: EmmaNextActor.ops,
      phaseGate: EmmaPhaseGate(
        gatePassed: false,
        sourcePhase: currentPhase,
        targetPhase: nextPhase ?? currentPhase,
        requiredHandoffFields: _requiredFields[currentPhase] ?? const [],
        missingHandoffFields: missingFields,
      ),
      caseKeys: EmmaOrchestratorCaseKeys(
        globalCaseId: emmaCase.caseHeader.globalCaseId,
        tripId: emmaCase.caseHeader.tripId,
        optionId: optionId,
        idempotencyKey: emmaCase.identity.idempotencyKey,
      ),
      error: error,
      auditTraceDelta: const [],
    );
  }
}
