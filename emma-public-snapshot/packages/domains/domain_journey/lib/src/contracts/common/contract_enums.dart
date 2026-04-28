enum EmmaPhase {
  phase1('PHASE_1'),
  phase2('PHASE_2'),
  phase3('PHASE_3'),
  phase4('PHASE_4'),
  phase5('PHASE_5');

  const EmmaPhase(this.value);

  final String value;

  static EmmaPhase fromValue(String value) {
    return EmmaPhase.values.firstWhere(
      (phase) => phase.value == value,
      orElse: () => throw ArgumentError.value(value, 'value', 'Unknown phase'),
    );
  }
}

enum EmmaPhaseStatus {
  notStarted('NOT_STARTED'),
  inProgress('IN_PROGRESS'),
  completed('COMPLETED'),
  blocked('BLOCKED'),
  waitingForInput('WAITING_FOR_INPUT'),
  rolledBack('ROLLED_BACK'),
  failed('FAILED'),
  manualReview('MANUAL_REVIEW');

  const EmmaPhaseStatus(this.value);

  final String value;

  static EmmaPhaseStatus fromValue(String value) {
    return EmmaPhaseStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () =>
          throw ArgumentError.value(value, 'value', 'Unknown phase status'),
    );
  }
}

enum EmmaCaseStatus {
  open('OPEN'),
  active('ACTIVE'),
  blocked('BLOCKED'),
  pendingReview('PENDING_REVIEW'),
  pendingSettlement('PENDING_SETTLEMENT'),
  closed('CLOSED');

  const EmmaCaseStatus(this.value);

  final String value;

  static EmmaCaseStatus fromValue(String value) {
    return EmmaCaseStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () =>
          throw ArgumentError.value(value, 'value', 'Unknown case status'),
    );
  }
}

enum EmmaPriority {
  low('LOW'),
  normal('NORMAL'),
  high('HIGH'),
  critical('CRITICAL');

  const EmmaPriority(this.value);

  final String value;

  static EmmaPriority fromValue(String value) {
    return EmmaPriority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () =>
          throw ArgumentError.value(value, 'value', 'Unknown priority'),
    );
  }
}

enum EmmaNextActor {
  system('SYSTEM'),
  user('USER'),
  ops('OPS'),
  provider('PROVIDER');

  const EmmaNextActor(this.value);

  final String value;

  static EmmaNextActor fromValue(String value) {
    return EmmaNextActor.values.firstWhere(
      (actor) => actor.value == value,
      orElse: () =>
          throw ArgumentError.value(value, 'value', 'Unknown next actor'),
    );
  }
}

enum EmmaErrorClass {
  none('NONE'),
  schemaError('SCHEMA_ERROR'),
  missingRequiredInput('MISSING_REQUIRED_INPUT'),
  idConflict('ID_CONFLICT'),
  stateConflict('STATE_CONFLICT'),
  policyConflict('POLICY_CONFLICT'),
  upstreamPhaseMissing('UPSTREAM_PHASE_MISSING'),
  transitionNotAllowed('TRANSITION_NOT_ALLOWED'),
  idempotencyConflict('IDEMPOTENCY_CONFLICT'),
  providerExecutionFailure('PROVIDER_EXECUTION_FAILURE'),
  rollbackRequired('ROLLBACK_REQUIRED'),
  manualReviewRequired('MANUAL_REVIEW_REQUIRED');

  const EmmaErrorClass(this.value);

  final String value;

  static EmmaErrorClass fromValue(String value) {
    return EmmaErrorClass.values.firstWhere(
      (errorClass) => errorClass.value == value,
      orElse: () =>
          throw ArgumentError.value(value, 'value', 'Unknown error class'),
    );
  }
}

enum EmmaSeverity {
  low('LOW'),
  medium('MEDIUM'),
  high('HIGH'),
  critical('CRITICAL');

  const EmmaSeverity(this.value);

  final String value;
}

enum EmmaGuaranteeLevel {
  low('LOW'),
  medium('MEDIUM'),
  high('HIGH');

  const EmmaGuaranteeLevel(this.value);

  final String value;
}

enum EmmaMessageType {
  phaseResult('PHASE_RESULT');

  const EmmaMessageType(this.value);

  final String value;
}

enum EmmaOrchestrationAction {
  executeCurrentPhase('EXECUTE_CURRENT_PHASE'),
  advanceToNextPhase('ADVANCE_TO_NEXT_PHASE'),
  waitForInput('WAIT_FOR_INPUT'),
  blockCase('BLOCK_CASE'),
  triggerRollbackPath('TRIGGER_ROLLBACK_PATH'),
  triggerManualReview('TRIGGER_MANUAL_REVIEW'),
  closeCase('CLOSE_CASE');

  const EmmaOrchestrationAction(this.value);

  final String value;
}

enum EmmaTrustLayerActionType {
  oneTapConfirm('ONE_TAP_CONFIRM'),
  openDetails('OPEN_DETAILS'),
  sendInfo('SEND_INFO');

  const EmmaTrustLayerActionType(this.value);

  final String value;

  static EmmaTrustLayerActionType fromValue(String value) {
    return EmmaTrustLayerActionType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => throw ArgumentError.value(
        value,
        'value',
        'Unknown trust layer action type',
      ),
    );
  }
}

extension EmmaPhaseCompat on EmmaPhase {
  String get schemaValue => value;
}

extension EmmaPhaseStatusCompat on EmmaPhaseStatus {
  String get schemaValue => value;
}

extension EmmaCaseStatusCompat on EmmaCaseStatus {
  String get schemaValue => value;
}

extension EmmaPriorityCompat on EmmaPriority {
  String get schemaValue => value;
}

extension EmmaNextActorCompat on EmmaNextActor {
  String get schemaValue => value;
}

extension EmmaErrorClassCompat on EmmaErrorClass {
  String get schemaValue => value;
}

extension EmmaMessageTypeCompat on EmmaMessageType {
  String get schemaValue => value;
}

extension EmmaOrchestrationActionCompat on EmmaOrchestrationAction {
  String get schemaValue => value;
}
