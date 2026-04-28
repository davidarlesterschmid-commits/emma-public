import 'package:domain_journey/src/contracts/case/canonical_case.dart';
import 'package:domain_journey/src/contracts/common/contract_enums.dart';
import 'package:domain_journey/src/contracts/common/contract_models.dart';
import 'package:domain_journey/src/contracts/handoff/handoffs.dart';
import 'package:domain_journey/src/contracts/messages/phase_envelope.dart';
import 'package:domain_journey/src/contracts/orchestrator/master_orchestrator.dart';
import 'package:domain_journey/src/entities/journey_phase.dart';
import 'package:domain_journey/src/entities/journey_state.dart';

class JourneyContractBundle {
  const JourneyContractBundle({
    required this.canonicalCase,
    required this.orchestratorResult,
    required this.phaseEnvelopes,
    required this.handoffs,
    required this.contractToUxMapping,
  });

  final CanonicalCase canonicalCase;
  final MasterOrchestratorResult orchestratorResult;
  final List<EmmaPhaseEnvelope> phaseEnvelopes;
  final HandoffBundle handoffs;
  final Map<String, List<String>> contractToUxMapping;
}

class JourneyContractMapper {
  const JourneyContractMapper();

  JourneyContractBundle buildBundle(JourneyState state) {
    const globalCaseId = 'case-2026-04-09-001';
    const tripId = 'trip-2026-04-09-work';
    final userId = state.userId;
    const traceId = 'trace-2026-04-09-001';
    const requestId = 'req-2026-04-09-001';
    const idempotencyKey = 'idem-2026-04-09-001';
    final now = DateTime.parse('2026-04-08T20:05:00+02:00');
    final currentPhase = _toContractPhase(state.currentPhase);
    final phasePayloads = _buildPhasePayloads(
      state: state,
      tripId: tripId,
      globalCaseId: globalCaseId,
      userId: userId,
      traceId: traceId,
      idempotencyKey: idempotencyKey,
    );

    final canonicalCase = EmmaCaseContract(
      schemaVersion: 'emma.case.v1',
      contractPackageVersion: '1.0.0',
      caseHeader: EmmaCaseHeader(
        globalCaseId: globalCaseId,
        tripId: tripId,
        userId: userId,
        currentPhase: currentPhase,
        currentState: 'BOOKING_PENDING',
        caseStatus: EmmaCaseStatus.active,
        priority: EmmaPriority.high,
        caseOwner: 'SYSTEM',
        createdAt: now,
        updatedAt: now,
      ),
      identity: const EmmaCaseIdentity(
        traceId: traceId,
        parentTraceId: null,
        requestId: requestId,
        idempotencyKey: idempotencyKey,
        correlationId: null,
      ),
      context: EmmaCaseContext(
        userProfile: state.context,
        calendarData: const {},
        realtimeStatus: const {},
        environmentalData: const {},
        currentLocation: const {},
        serviceRules: const {},
        partnerContext: const {},
      ),
      phaseState: EmmaCasePhaseState(
        phase1: _phaseSnapshot(EmmaPhase.phase1, currentPhase, phasePayloads),
        phase2: _phaseSnapshot(EmmaPhase.phase2, currentPhase, phasePayloads),
        phase3: _phaseSnapshot(EmmaPhase.phase3, currentPhase, phasePayloads),
        phase4: _phaseSnapshot(EmmaPhase.phase4, currentPhase, phasePayloads),
        phase5: _phaseSnapshot(EmmaPhase.phase5, currentPhase, phasePayloads),
      ),
      sharedEntities: const EmmaSharedEntities(
        selectedOptionId: 'rec_001',
        bookingId: null,
        incidentIds: ['CLAIM-2026-X99'],
        settlementId: null,
        providerBundle: ['teilAuto', 'MDV_VDV_KA'],
      ),
      financialState: const EmmaFinancialState(
        currency: 'EUR',
        charges: [],
        refunds: [],
        compensations: [],
        budgetConsumedEur: 1.6,
        budgetReversibleEur: 1.6,
        userOutOfPocketEur: 0,
      ),
      auditTrace: [
        EmmaAuditEntry(
          eventId: 'evt_1001',
          eventTimestamp: now,
          eventType: 'PHASE_TRANSITION_APPROVED',
          sourcePhase: EmmaPhase.phase1,
          targetPhase: EmmaPhase.phase2,
          decisionSummary: 'Phase 1 to Phase 2 gate passed',
          ruleBasis: const ['intent_detected=true', 'action_type!=NONE'],
          errorClass: EmmaErrorClass.none,
          actor: 'SYSTEM',
        ),
      ],
      errors: const [],
    );

    final envelopes = phasePayloads.entries
        .map(
          (entry) => EmmaPhaseEnvelope(
            schemaVersion: 'emma.message.v1',
            messageType: EmmaMessageType.phaseResult,
            phase: entry.key,
            producer: 'journey-contract-mapper',
            generatedAt: now,
            caseKeys: EmmaCaseKeys(
              globalCaseId: globalCaseId,
              tripId: tripId,
              userId: userId,
              selectedOptionId: 'rec_001',
              bookingId: null,
              traceId: traceId,
              requestId: requestId,
              idempotencyKey: idempotencyKey,
            ),
            phaseMeta: EmmaPhaseMeta(
              phaseStatus: entry.key.index < currentPhase.index
                  ? EmmaPhaseStatus.completed
                  : entry.key == currentPhase
                  ? EmmaPhaseStatus.inProgress
                  : EmmaPhaseStatus.notStarted,
              currentState: _stateForPhase(entry.key),
              nextActor: entry.key == EmmaPhase.phase3
                  ? EmmaNextActor.user
                  : EmmaNextActor.system,
            ),
            payload: entry.value,
            error: EmmaErrorBlock.none(),
            auditEntry: EmmaAuditEntry(
              eventId: 'evt_${entry.key.index + 2000}',
              eventTimestamp: now,
              eventType: 'PHASE_RESULT_WRITTEN',
              sourcePhase: entry.key,
              targetPhase: entry.key,
              decisionSummary:
                  '${entry.key.value} payload projected from UX state',
              ruleBasis: const ['mapper_projection=true'],
              errorClass: EmmaErrorClass.none,
              actor: 'SYSTEM',
            ),
          ),
        )
        .toList();

    final handoffs = HandoffBundle(
      phase1ToPhase2: Phase1ToPhase2Handoff(
        globalCaseId: globalCaseId,
        tripId: tripId,
        userId: userId,
        traceId: traceId,
        idempotencyKey: idempotencyKey,
        intentDetected: true,
        confidenceScore: 0.95,
        actionType: 'ACTION_REQUIRED',
        triggerReason: "Calendar event 'Work' + S-Bahn disruption",
      ),
      phase2ToPhase3: Phase2ToPhase3Handoff(
        globalCaseId: globalCaseId,
        tripId: tripId,
        userId: userId,
        traceId: traceId,
        idempotencyKey: 'idem_112',
        recommendedOptionId: 'rec_001',
        recommendationStatus: 'ONE_TAP_BOOKABLE',
        selectionReason: 'Selected rec_001 because guarantee=HIGH',
        providerBundle: ['teilAuto', 'MDV_VDV_KA'],
      ),
      phase3ToPhase4: Phase3ToPhase4Handoff(
        globalCaseId: globalCaseId,
        tripId: tripId,
        userId: userId,
        traceId: traceId,
        idempotencyKey: 'idem_113',
        selectedOptionId: 'rec_001',
        executionStatus: 'COMMIT_READY',
        commitScope: 'FULL_CHAIN',
        providerBundle: ['teilAuto', 'MDV_VDV_KA'],
      ),
      phase4ToPhase5: Phase4ToPhase5Handoff(
        globalCaseId: globalCaseId,
        tripId: tripId,
        userId: userId,
        traceId: traceId,
        idempotencyKey: 'idem_114',
        controlStatus: 'JOURNEY_COMPLETED',
        incidentSummary: {
          'active_incident': false,
          'incident_ids': ['CLAIM-2026-X99'],
        },
        fulfillmentSummary: {
          'booking_state': 'COMMITTED',
          'payment_state': 'CAPTURED',
          'entitlement_state': 'VALID',
        },
        evidenceLog: {'required': true, 'entries': []},
      ),
    );

    final orchestratorResult = const MasterOrchestrator().evaluate(
      canonicalCase,
    );

    return JourneyContractBundle(
      canonicalCase: canonicalCase,
      orchestratorResult: orchestratorResult,
      phaseEnvelopes: envelopes,
      handoffs: handoffs,
      contractToUxMapping: const {
        'PHASE_1': ['demandRecognition', 'intentValidation'],
        'PHASE_2': ['orchestration', 'fareOptimization'],
        'PHASE_3': ['transaction'],
        'PHASE_4': ['activeMonitoring', 'crisisManagement'],
        'PHASE_5': ['optimization'],
      },
    );
  }

  EmmaPhase _toContractPhase(JourneyPhase phase) {
    switch (phase) {
      case JourneyPhase.demandRecognition:
      case JourneyPhase.intentValidation:
        return EmmaPhase.phase1;
      case JourneyPhase.orchestration:
      case JourneyPhase.fareOptimization:
        return EmmaPhase.phase2;
      case JourneyPhase.transaction:
        return EmmaPhase.phase3;
      case JourneyPhase.activeMonitoring:
      case JourneyPhase.crisisManagement:
        return EmmaPhase.phase4;
      case JourneyPhase.optimization:
        return EmmaPhase.phase5;
    }
  }

  EmmaPhaseSnapshot _phaseSnapshot(
    EmmaPhase phase,
    EmmaPhase currentPhase,
    Map<EmmaPhase, Map<String, dynamic>> payloads,
  ) {
    final status = phase.index < currentPhase.index
        ? EmmaPhaseStatus.completed
        : phase == currentPhase
        ? EmmaPhaseStatus.inProgress
        : EmmaPhaseStatus.notStarted;

    return EmmaPhaseSnapshot(
      phaseStatus: status,
      inputSnapshotRef: 'snapshot_${phase.index + 1}',
      result: payloads[phase],
      completedAt: status == EmmaPhaseStatus.completed
          ? DateTime.parse('2026-04-08T20:05:00+02:00')
          : null,
    );
  }

  String _stateForPhase(EmmaPhase phase) {
    switch (phase) {
      case EmmaPhase.phase1:
        return 'DEMAND_CONFIRMED';
      case EmmaPhase.phase2:
        return 'OPTION_SELECTED';
      case EmmaPhase.phase3:
        return 'BOOKING_PENDING';
      case EmmaPhase.phase4:
        return 'JOURNEY_ACTIVE';
      case EmmaPhase.phase5:
        return 'SETTLEMENT_PENDING';
    }
  }

  Map<EmmaPhase, Map<String, dynamic>> _buildPhasePayloads({
    required JourneyState state,
    required String tripId,
    required String globalCaseId,
    required String userId,
    required String traceId,
    required String idempotencyKey,
  }) {
    final phase1Blueprint = state.phases
        .firstWhere((phase) => phase.phase == JourneyPhase.demandRecognition)
        .blueprint;
    final phase4Payload = Map<String, dynamic>.from(
      state.context['phase4_fulfillment'] as Map? ??
          {
            'control_status': 'MONITORING_ONLY',
            'display_message': 'Ich ueberwache die Reise weiter.',
            'control_reason':
                'Keine aktive Gefaehrdung fuer die bestehende Reise erkannt.',
            'selected_action': {
              'action_type': 'SEND_INFO',
              'target_option_id': null,
              'guarantee_case': false,
              'manual_ops_escalation': false,
            },
            'incident_summary': {
              'active_incident': false,
              'incident_ids': ['CLAIM-2026-X99'],
              'highest_severity': null,
              'affected_leg_ids': [],
            },
            'fulfillment_summary': {
              'booking_state': 'COMMITTED',
              'payment_state': 'CAPTURED',
              'entitlement_state': 'VALID',
              'missing_artifacts': <String>[],
              'provider_confirmation_gaps': <String>[],
            },
            'reaccommodation_options': <Map<String, dynamic>>[],
            'guarantee_policy': {
              'policy_code': 'MOBILITY_GUARANTEE_STANDARD',
              'automatic_action_allowed': true,
            },
            'evidence_log': {
              'required': true,
              'entries': <Map<String, dynamic>>[],
            },
            'technical_metadata': {
              'journey_status_evaluated': 'TRIP_SAFE',
              'guarantee_risk_detected': false,
              'reaccommodation_evaluated': true,
              'selected_reaccommodation_option_id': null,
              'affected_providers': ['MDV'],
              'data_gaps': <String>[],
            },
          },
    );

    return {
      EmmaPhase.phase1: {
        'global_case_id': globalCaseId,
        'trip_id': tripId,
        'user_id': userId,
        'trace_id': traceId,
        'idempotency_key': idempotencyKey,
        'intent_detected': phase1Blueprint['intent_detected'] ?? true,
        'confidence_score': phase1Blueprint['confidence_score'] ?? 0.95,
        'trigger_reason':
            phase1Blueprint['trigger_reason']?.toString() ??
            'calendar+disruption',
        'action_type': 'ACTION_REQUIRED',
      },
      EmmaPhase.phase2: {
        'global_case_id': globalCaseId,
        'trip_id': tripId,
        'user_id': userId,
        'trace_id': traceId,
        'idempotency_key': 'idem_112',
        'recommended_option_id': 'rec_001',
        'recommendation_status': 'ONE_TAP_BOOKABLE',
        'selection_reason': 'Selected rec_001 because guarantee=HIGH',
        'trust_layer_action': {
          'payload': {
            'provider_bundle': ['teilAuto', 'MDV_VDV_KA'],
          },
        },
      },
      EmmaPhase.phase3: {
        'global_case_id': globalCaseId,
        'trip_id': tripId,
        'user_id': userId,
        'trace_id': traceId,
        'idempotency_key': 'idem_113',
        'execution_status': 'COMMIT_READY',
        'transaction_plan': {
          'idempotency_key': 'idem_113',
          'commit_scope': 'FULL_CHAIN',
        },
        'trust_layer_action': {
          'payload': {
            'option_id': 'rec_001',
            'provider_bundle': ['teilAuto', 'MDV_VDV_KA'],
          },
        },
      },
      EmmaPhase.phase4: {
        'global_case_id': globalCaseId,
        'trip_id': tripId,
        'user_id': userId,
        'trace_id': traceId,
        'idempotency_key': 'idem_114',
        ...phase4Payload,
      },
      EmmaPhase.phase5: {
        'settlement_status': 'NO_FINANCIAL_ACTION',
        'case_closure_status': 'CLOSED',
        'settlement_plan': {
          'case_owner': 'emma-ops',
          'actions': [
            {
              'step_no': 1,
              'action': 'CLOSE_CASE',
              'mandatory': true,
              'target': 'EMMA',
            },
          ],
        },
        'technical_metadata': {'financial_reconciliation_complete': true},
      },
    };
  }
}
