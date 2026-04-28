import 'package:domain_journey/src/contracts/common/contract_enums.dart';

Map<String, dynamic> _asStringDynamicMap(Object? input) =>
    Map<String, dynamic>.from(input as Map? ?? const {});

class EmmaCaseKeys {
  const EmmaCaseKeys({
    required this.globalCaseId,
    required this.tripId,
    required this.userId,
    required this.traceId,
    required this.requestId,
    required this.idempotencyKey,
    this.selectedOptionId,
    this.bookingId,
  });

  factory EmmaCaseKeys.fromJson(Map<String, dynamic> json) {
    return EmmaCaseKeys(
      globalCaseId: json['global_case_id']?.toString() ?? '',
      tripId: json['trip_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      traceId: json['trace_id']?.toString() ?? '',
      requestId: json['request_id']?.toString() ?? '',
      idempotencyKey: json['idempotency_key']?.toString() ?? '',
      selectedOptionId: json['selected_option_id']?.toString(),
      bookingId: json['booking_id']?.toString(),
    );
  }

  final String globalCaseId;
  final String tripId;
  final String userId;
  final String traceId;
  final String requestId;
  final String idempotencyKey;
  final String? selectedOptionId;
  final String? bookingId;

  Map<String, dynamic> toJson() {
    return {
      'global_case_id': globalCaseId,
      'trip_id': tripId,
      'user_id': userId,
      'selected_option_id': selectedOptionId,
      'booking_id': bookingId,
      'trace_id': traceId,
      'request_id': requestId,
      'idempotency_key': idempotencyKey,
    };
  }
}

class EmmaErrorBlock {
  const EmmaErrorBlock({
    required this.errorClass,
    required this.blocking,
    required this.retryable,
    this.errorMessage,
    this.sourcePhase,
    this.sourceField,
  });

  factory EmmaErrorBlock.none() {
    return const EmmaErrorBlock(
      errorClass: EmmaErrorClass.none,
      errorMessage: null,
      blocking: false,
      sourcePhase: null,
      sourceField: null,
      retryable: false,
    );
  }

  factory EmmaErrorBlock.fromJson(Map<String, dynamic> json) {
    return EmmaErrorBlock(
      errorClass: EmmaErrorClass.fromValue(
        json['error_class']?.toString() ?? EmmaErrorClass.none.value,
      ),
      errorMessage: json['error_message']?.toString(),
      blocking: json['blocking'] == true,
      sourcePhase: json['source_phase'] == null
          ? null
          : EmmaPhase.fromValue(json['source_phase'].toString()),
      sourceField: json['source_field']?.toString(),
      retryable: json['retryable'] == true,
    );
  }

  final EmmaErrorClass errorClass;
  final String? errorMessage;
  final bool blocking;
  final EmmaPhase? sourcePhase;
  final String? sourceField;
  final bool retryable;

  Map<String, dynamic> toJson() {
    return {
      'error_class': errorClass.value,
      'error_message': errorMessage,
      'blocking': blocking,
      'source_phase': sourcePhase?.value,
      'source_field': sourceField,
      'retryable': retryable,
    };
  }
}

class EmmaAuditEntry {
  const EmmaAuditEntry({
    required this.eventId,
    required this.eventTimestamp,
    required this.eventType,
    required this.decisionSummary,
    required this.ruleBasis,
    required this.errorClass,
    required this.actor,
    this.sourcePhase,
    this.targetPhase,
  });

  factory EmmaAuditEntry.fromJson(Map<String, dynamic> json) {
    return EmmaAuditEntry(
      eventId: json['event_id']?.toString() ?? '',
      eventTimestamp: DateTime.parse(json['event_timestamp'].toString()),
      eventType: json['event_type']?.toString() ?? '',
      sourcePhase: json['source_phase'] == null
          ? null
          : EmmaPhase.fromValue(json['source_phase'].toString()),
      targetPhase: json['target_phase'] == null
          ? null
          : EmmaPhase.fromValue(json['target_phase'].toString()),
      decisionSummary: json['decision_summary']?.toString() ?? '',
      ruleBasis: (json['rule_basis'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
      errorClass: EmmaErrorClass.fromValue(
        json['error_class']?.toString() ?? EmmaErrorClass.none.value,
      ),
      actor: json['actor']?.toString() ?? 'SYSTEM',
    );
  }

  final String eventId;
  final DateTime eventTimestamp;
  final String eventType;
  final EmmaPhase? sourcePhase;
  final EmmaPhase? targetPhase;
  final String decisionSummary;
  final List<String> ruleBasis;
  final EmmaErrorClass errorClass;
  final String actor;

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'event_timestamp': eventTimestamp.toIso8601String(),
      'event_type': eventType,
      'source_phase': sourcePhase?.value,
      'target_phase': targetPhase?.value,
      'decision_summary': decisionSummary,
      'rule_basis': ruleBasis,
      'error_class': errorClass.value,
      'actor': actor,
    };
  }
}

class EmmaTrustLayerAction {
  const EmmaTrustLayerAction({
    required this.type,
    required this.primaryCta,
    required this.payload,
  });

  factory EmmaTrustLayerAction.fromJson(Map<String, dynamic> json) {
    return EmmaTrustLayerAction(
      type: EmmaTrustLayerActionType.fromValue(
        json['type']?.toString() ?? EmmaTrustLayerActionType.sendInfo.value,
      ),
      primaryCta: json['primary_cta']?.toString(),
      payload: json['payload'] == null
          ? null
          : _asStringDynamicMap(json['payload']),
    );
  }

  final EmmaTrustLayerActionType type;
  final String? primaryCta;
  final Map<String, dynamic>? payload;

  Map<String, dynamic> toJson() {
    return {'type': type.value, 'primary_cta': primaryCta, 'payload': payload};
  }
}

class EmmaPhaseMeta {
  const EmmaPhaseMeta({
    required this.phaseStatus,
    required this.currentState,
    required this.nextActor,
  });

  factory EmmaPhaseMeta.fromJson(Map<String, dynamic> json) {
    return EmmaPhaseMeta(
      phaseStatus: EmmaPhaseStatus.fromValue(
        json['phase_status']?.toString() ?? EmmaPhaseStatus.notStarted.value,
      ),
      currentState: json['current_state']?.toString() ?? '',
      nextActor: EmmaNextActor.fromValue(
        json['next_actor']?.toString() ?? EmmaNextActor.system.value,
      ),
    );
  }

  final EmmaPhaseStatus phaseStatus;
  final String currentState;
  final EmmaNextActor nextActor;

  Map<String, dynamic> toJson() {
    return {
      'phase_status': phaseStatus.value,
      'current_state': currentState,
      'next_actor': nextActor.value,
    };
  }
}

class EmmaEvidenceEntry {
  const EmmaEvidenceEntry({
    required this.eventTimestamp,
    required this.eventType,
    required this.summary,
    this.provider,
    this.referenceId,
  });

  factory EmmaEvidenceEntry.fromJson(Map<String, dynamic> json) {
    return EmmaEvidenceEntry(
      eventTimestamp: DateTime.parse(json['event_timestamp'].toString()),
      eventType: json['event_type']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      provider: json['provider']?.toString(),
      referenceId: json['reference_id']?.toString(),
    );
  }

  final DateTime eventTimestamp;
  final String eventType;
  final String summary;
  final String? provider;
  final String? referenceId;

  Map<String, dynamic> toJson() {
    return {
      'event_timestamp': eventTimestamp.toIso8601String(),
      'event_type': eventType,
      'summary': summary,
      'provider': provider,
      'reference_id': referenceId,
    };
  }
}

class EmmaEvidenceLog {
  const EmmaEvidenceLog({required this.required, required this.entries});

  factory EmmaEvidenceLog.fromJson(Map<String, dynamic> json) {
    return EmmaEvidenceLog(
      required: json['required'] == true,
      entries: (json['entries'] as List? ?? const [])
          .map((item) => EmmaEvidenceEntry.fromJson(_asStringDynamicMap(item)))
          .toList(),
    );
  }

  final bool required;
  final List<EmmaEvidenceEntry> entries;

  Map<String, dynamic> toJson() {
    return {
      'required': required,
      'entries': entries.map((entry) => entry.toJson()).toList(),
    };
  }
}
