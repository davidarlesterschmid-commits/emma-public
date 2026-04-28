import 'package:domain_journey/src/contracts/common/contract_enums.dart';
import 'package:domain_journey/src/contracts/common/contract_models.dart';

Map<String, dynamic> _map(Object? input) =>
    Map<String, dynamic>.from(input as Map? ?? const {});

class EmmaCaseContract {
  const EmmaCaseContract({
    required this.schemaVersion,
    required this.contractPackageVersion,
    required this.caseHeader,
    required this.identity,
    required this.context,
    required this.phaseState,
    required this.sharedEntities,
    required this.financialState,
    required this.auditTrace,
    required this.errors,
  });

  factory EmmaCaseContract.fromJson(Map<String, dynamic> json) {
    return EmmaCaseContract(
      schemaVersion: json['schema_version']?.toString() ?? 'emma.case.v1',
      contractPackageVersion:
          json['contract_package_version']?.toString() ?? '1.0.0',
      caseHeader: EmmaCaseHeader.fromJson(_map(json['case_header'])),
      identity: EmmaCaseIdentity.fromJson(_map(json['identity'])),
      context: EmmaCaseContext.fromJson(_map(json['context'])),
      phaseState: EmmaCasePhaseState.fromJson(_map(json['phase_state'])),
      sharedEntities: EmmaSharedEntities.fromJson(
        _map(json['shared_entities']),
      ),
      financialState: EmmaFinancialState.fromJson(
        _map(json['financial_state']),
      ),
      auditTrace: (json['audit_trace'] as List? ?? const [])
          .map((item) => EmmaAuditEntry.fromJson(_map(item)))
          .toList(),
      errors: (json['errors'] as List? ?? const [])
          .map((item) => EmmaErrorBlock.fromJson(_map(item)))
          .toList(),
    );
  }

  final String schemaVersion;
  final String contractPackageVersion;
  final EmmaCaseHeader caseHeader;
  final EmmaCaseIdentity identity;
  final EmmaCaseContext context;
  final EmmaCasePhaseState phaseState;
  final EmmaSharedEntities sharedEntities;
  final EmmaFinancialState financialState;
  final List<EmmaAuditEntry> auditTrace;
  final List<EmmaErrorBlock> errors;

  Map<String, dynamic> toJson() {
    return {
      'schema_version': schemaVersion,
      'contract_package_version': contractPackageVersion,
      'case_header': caseHeader.toJson(),
      'identity': identity.toJson(),
      'context': context.toJson(),
      'phase_state': phaseState.toJson(),
      'shared_entities': sharedEntities.toJson(),
      'financial_state': financialState.toJson(),
      'audit_trace': auditTrace.map((entry) => entry.toJson()).toList(),
      'errors': errors.map((error) => error.toJson()).toList(),
    };
  }
}

class EmmaCaseHeader {
  const EmmaCaseHeader({
    required this.globalCaseId,
    required this.tripId,
    required this.userId,
    required this.currentPhase,
    required this.currentState,
    required this.caseStatus,
    required this.priority,
    required this.caseOwner,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmmaCaseHeader.fromJson(Map<String, dynamic> json) {
    return EmmaCaseHeader(
      globalCaseId: json['global_case_id']?.toString() ?? '',
      tripId: json['trip_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      currentPhase: EmmaPhase.fromValue(
        json['current_phase']?.toString() ?? EmmaPhase.phase1.value,
      ),
      currentState: json['current_state']?.toString() ?? '',
      caseStatus: EmmaCaseStatus.fromValue(
        json['case_status']?.toString() ?? EmmaCaseStatus.open.value,
      ),
      priority: EmmaPriority.fromValue(
        json['priority']?.toString() ?? EmmaPriority.normal.value,
      ),
      caseOwner: json['case_owner']?.toString() ?? 'SYSTEM',
      createdAt: DateTime.parse(json['created_at'].toString()),
      updatedAt: DateTime.parse(json['updated_at'].toString()),
    );
  }

  final String globalCaseId;
  final String tripId;
  final String userId;
  final EmmaPhase currentPhase;
  final String currentState;
  final EmmaCaseStatus caseStatus;
  final EmmaPriority priority;
  final String caseOwner;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'global_case_id': globalCaseId,
      'trip_id': tripId,
      'user_id': userId,
      'current_phase': currentPhase.value,
      'current_state': currentState,
      'case_status': caseStatus.value,
      'priority': priority.value,
      'case_owner': caseOwner,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class EmmaCaseIdentity {
  const EmmaCaseIdentity({
    required this.traceId,
    required this.requestId,
    required this.idempotencyKey,
    this.parentTraceId,
    this.correlationId,
  });

  factory EmmaCaseIdentity.fromJson(Map<String, dynamic> json) {
    return EmmaCaseIdentity(
      traceId: json['trace_id']?.toString() ?? '',
      parentTraceId: json['parent_trace_id']?.toString(),
      requestId: json['request_id']?.toString() ?? '',
      idempotencyKey: json['idempotency_key']?.toString() ?? '',
      correlationId: json['correlation_id']?.toString(),
    );
  }

  final String traceId;
  final String? parentTraceId;
  final String requestId;
  final String idempotencyKey;
  final String? correlationId;

  Map<String, dynamic> toJson() {
    return {
      'trace_id': traceId,
      'parent_trace_id': parentTraceId,
      'request_id': requestId,
      'idempotency_key': idempotencyKey,
      'correlation_id': correlationId,
    };
  }
}

class EmmaCaseContext {
  const EmmaCaseContext({
    required this.userProfile,
    required this.calendarData,
    required this.realtimeStatus,
    required this.environmentalData,
    required this.currentLocation,
    required this.serviceRules,
    required this.partnerContext,
  });

  factory EmmaCaseContext.fromJson(Map<String, dynamic> json) {
    return EmmaCaseContext(
      userProfile: _map(json['user_profile']),
      calendarData: _map(json['calendar_data']),
      realtimeStatus: _map(json['realtime_status']),
      environmentalData: _map(json['environmental_data']),
      currentLocation: _map(json['current_location']),
      serviceRules: _map(json['service_rules']),
      partnerContext: _map(json['partner_context']),
    );
  }

  final Map<String, dynamic> userProfile;
  final Map<String, dynamic> calendarData;
  final Map<String, dynamic> realtimeStatus;
  final Map<String, dynamic> environmentalData;
  final Map<String, dynamic> currentLocation;
  final Map<String, dynamic> serviceRules;
  final Map<String, dynamic> partnerContext;

  Map<String, dynamic> toJson() {
    return {
      'user_profile': userProfile,
      'calendar_data': calendarData,
      'realtime_status': realtimeStatus,
      'environmental_data': environmentalData,
      'current_location': currentLocation,
      'service_rules': serviceRules,
      'partner_context': partnerContext,
    };
  }
}

class EmmaPhaseSnapshot {
  const EmmaPhaseSnapshot({
    required this.phaseStatus,
    required this.inputSnapshotRef,
    required this.result,
    required this.completedAt,
  });

  factory EmmaPhaseSnapshot.fromJson(Map<String, dynamic> json) {
    return EmmaPhaseSnapshot(
      phaseStatus: EmmaPhaseStatus.fromValue(
        json['phase_status']?.toString() ?? EmmaPhaseStatus.notStarted.value,
      ),
      inputSnapshotRef: json['input_snapshot_ref']?.toString(),
      result: json['result'] == null ? null : _map(json['result']),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'].toString()),
    );
  }

  final EmmaPhaseStatus phaseStatus;
  final String? inputSnapshotRef;
  final Map<String, dynamic>? result;
  final DateTime? completedAt;

  Map<String, dynamic> toJson() {
    return {
      'phase_status': phaseStatus.value,
      'input_snapshot_ref': inputSnapshotRef,
      'result': result,
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}

class EmmaCasePhaseState {
  const EmmaCasePhaseState({
    required this.phase1,
    required this.phase2,
    required this.phase3,
    required this.phase4,
    required this.phase5,
  });

  factory EmmaCasePhaseState.fromJson(Map<String, dynamic> json) {
    return EmmaCasePhaseState(
      phase1: EmmaPhaseSnapshot.fromJson(_map(json['phase_1'])),
      phase2: EmmaPhaseSnapshot.fromJson(_map(json['phase_2'])),
      phase3: EmmaPhaseSnapshot.fromJson(_map(json['phase_3'])),
      phase4: EmmaPhaseSnapshot.fromJson(_map(json['phase_4'])),
      phase5: EmmaPhaseSnapshot.fromJson(_map(json['phase_5'])),
    );
  }

  final EmmaPhaseSnapshot phase1;
  final EmmaPhaseSnapshot phase2;
  final EmmaPhaseSnapshot phase3;
  final EmmaPhaseSnapshot phase4;
  final EmmaPhaseSnapshot phase5;

  EmmaPhaseSnapshot byPhase(EmmaPhase phase) {
    switch (phase) {
      case EmmaPhase.phase1:
        return phase1;
      case EmmaPhase.phase2:
        return phase2;
      case EmmaPhase.phase3:
        return phase3;
      case EmmaPhase.phase4:
        return phase4;
      case EmmaPhase.phase5:
        return phase5;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'phase_1': phase1.toJson(),
      'phase_2': phase2.toJson(),
      'phase_3': phase3.toJson(),
      'phase_4': phase4.toJson(),
      'phase_5': phase5.toJson(),
    };
  }
}

class EmmaSharedEntities {
  const EmmaSharedEntities({
    required this.selectedOptionId,
    required this.bookingId,
    required this.incidentIds,
    required this.settlementId,
    required this.providerBundle,
  });

  factory EmmaSharedEntities.fromJson(Map<String, dynamic> json) {
    return EmmaSharedEntities(
      selectedOptionId: json['selected_option_id']?.toString(),
      bookingId: json['booking_id']?.toString(),
      incidentIds: (json['incident_ids'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
      settlementId: json['settlement_id']?.toString(),
      providerBundle: (json['provider_bundle'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
    );
  }

  final String? selectedOptionId;
  final String? bookingId;
  final List<String> incidentIds;
  final String? settlementId;
  final List<String> providerBundle;

  Map<String, dynamic> toJson() {
    return {
      'selected_option_id': selectedOptionId,
      'booking_id': bookingId,
      'incident_ids': incidentIds,
      'settlement_id': settlementId,
      'provider_bundle': providerBundle,
    };
  }
}

class EmmaFinancialState {
  const EmmaFinancialState({
    required this.currency,
    required this.charges,
    required this.refunds,
    required this.compensations,
    required this.budgetConsumedEur,
    required this.budgetReversibleEur,
    required this.userOutOfPocketEur,
  });

  factory EmmaFinancialState.fromJson(Map<String, dynamic> json) {
    return EmmaFinancialState(
      currency: json['currency']?.toString() ?? 'EUR',
      charges: (json['charges'] as List? ?? const [])
          .map((item) => _map(item))
          .toList(),
      refunds: (json['refunds'] as List? ?? const [])
          .map((item) => _map(item))
          .toList(),
      compensations: (json['compensations'] as List? ?? const [])
          .map((item) => _map(item))
          .toList(),
      budgetConsumedEur: (json['budget_consumed_eur'] as num?)?.toDouble() ?? 0,
      budgetReversibleEur:
          (json['budget_reversible_eur'] as num?)?.toDouble() ?? 0,
      userOutOfPocketEur:
          (json['user_out_of_pocket_eur'] as num?)?.toDouble() ?? 0,
    );
  }

  final String currency;
  final List<Map<String, dynamic>> charges;
  final List<Map<String, dynamic>> refunds;
  final List<Map<String, dynamic>> compensations;
  final double budgetConsumedEur;
  final double budgetReversibleEur;
  final double userOutOfPocketEur;

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'charges': charges,
      'refunds': refunds,
      'compensations': compensations,
      'budget_consumed_eur': budgetConsumedEur,
      'budget_reversible_eur': budgetReversibleEur,
      'user_out_of_pocket_eur': userOutOfPocketEur,
    };
  }
}
