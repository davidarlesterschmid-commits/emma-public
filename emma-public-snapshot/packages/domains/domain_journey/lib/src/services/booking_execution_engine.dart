import 'package:domain_journey/src/entities/booking_execution_models.dart';

class BookingExecutionEngine {
  const BookingExecutionEngine();

  static const promptTemplate = '''
Technisches Prompt-Template: emma Phase 3 - Booking Execution Engine v1.0

Rolle
Du bist das Modul "emma-booking-executor".
Deine Aufgabe ist es, eine bereits fachlich ausgewaehlte Mobilitaetsoption deterministisch in einen ausfuehrbaren Buchungsvorgang zu ueberfuehren.
''';

  BookingExecutionOutput evaluate(BookingExecutionInput input) {
    final dataGaps = <String>[];
    final checkedLegs = <String>[];
    final blockedLegs = <String>[];

    final trip = _TripContext.fromInput(input.tripContext, dataGaps);
    final selected = _SelectedOption.fromInput(input.selectedOption, dataGaps);
    final providers = _ProviderStatusIndex.fromInput(
      input.providerExecutionStatus,
    );
    final rules = _ExecutionRules.fromInput(input.serviceRules);
    final user = _UserContext.fromInput(input.userContext, dataGaps);
    final execution = _ExecutionContext.fromInput(
      input.executionContext,
      dataGaps,
    );
    final phase2 = _Phase2Context.fromInput(input.phase2Result, dataGaps);
    final previousState = _PreviousExecutionState.fromInput(
      input.executionContext['previous_execution_state'],
    );

    final providerStates = providers.toMetadataMap();
    final hasPaidLeg = selected.legs.any((leg) => leg.priceEur > 0);
    final needsDataSharing = selected.providerBundle.isNotEmpty;

    final prevalidationIssues = <String>[];
    if (phase2.recommendationStatus == 'NO_ACTIONABLE_OPTION') {
      prevalidationIssues.add('phase2_has_no_actionable_option');
    }
    if (phase2.recommendedOptionId == null ||
        phase2.recommendedOptionId != selected.optionId) {
      prevalidationIssues.add('recommended_option_mismatch');
    }
    if (execution.idempotencyKey.isEmpty) {
      prevalidationIssues.add('missing_idempotency_key');
    }
    if (selected.legs.isEmpty) {
      prevalidationIssues.add('missing_selected_legs');
    }

    var consentOk = user.termsAccepted;
    if (needsDataSharing && !user.dataSharingConsent) {
      consentOk = false;
    }
    if (hasPaidLeg && !user.paymentConsent) {
      consentOk = false;
    }

    final paymentPolicyOk =
        !hasPaidLeg || (user.defaultPaymentMethodAvailable && user.pspReady);

    var budgetOk = true;
    if (user.budgetEnabled) {
      if (user.remainingAmountEur == null) {
        budgetOk = false;
        dataGaps.add('missing_remaining_budget');
      } else if (user.remainingAmountEur! < selected.totalPriceEur) {
        budgetOk = false;
      }
    }
    if (rules.maxTotalPriceEur != null &&
        selected.totalPriceEur > rules.maxTotalPriceEur!) {
      budgetOk = false;
    }

    final oneTapOk = !selected.bookableWithOneTap || rules.oneTapAllowed;
    final partialBookingOk = rules.partialBookingAllowed;

    var inventoryOk = true;
    var guaranteeOk = true;
    final fullyExecutableLegs = <_Leg>[];

    for (final leg in selected.legs) {
      checkedLegs.add(leg.legId);
      final providerStatus = providers.byProvider(leg.provider);
      final legIssues = <String>[];

      if (leg.exclusionFlags.isNotEmpty) {
        legIssues.add('exclusion_flag_present');
      }
      if (leg.inventoryStatus != 'AVAILABLE') {
        legIssues.add('leg_inventory_not_available');
      }
      if (leg.reservationRequired &&
          leg.reservationStatus != 'CONFIRMED' &&
          leg.reservationStatus != 'HELD') {
        legIssues.add('reservation_not_secured');
      }
      if (!leg.bookable) {
        legIssues.add('leg_not_bookable');
      }
      if (_hasHardPolicyFlag(leg.policyFlags)) {
        legIssues.add('hard_policy_flag_present');
      }
      if (providerStatus == null) {
        legIssues.add('missing_provider_status');
      } else {
        if (!providerStatus.apiAvailable) {
          legIssues.add('provider_api_unavailable');
        }
        if (providerStatus.bookingState != 'READY') {
          legIssues.add('provider_booking_not_ready');
        }
        if (leg.priceEur > 0 && providerStatus.paymentState != 'READY') {
          legIssues.add('provider_payment_not_ready');
        }
        if (providerStatus.inventoryState != 'AVAILABLE') {
          legIssues.add('provider_inventory_not_available');
        }
      }

      if (legIssues.isEmpty) {
        fullyExecutableLegs.add(leg);
      } else {
        blockedLegs.add(leg.legId);
        inventoryOk = false;
        guaranteeOk = false;
      }
    }

    final fullChainExecutable =
        prevalidationIssues.isEmpty &&
        consentOk &&
        paymentPolicyOk &&
        budgetOk &&
        oneTapOk &&
        blockedLegs.isEmpty &&
        (!rules.requiresFullChainBookability ||
            fullyExecutableLegs.length == selected.legs.length);

    final requiresAtomicCommit =
        selected.legs.length > 1 || rules.requiresFullChainBookability;

    final policyResults = BookingPolicyResults(
      consentOk: consentOk,
      paymentOk: paymentPolicyOk,
      budgetOk: budgetOk,
      inventoryOk: inventoryOk,
      guaranteeOk: guaranteeOk,
      partialBookingOk: partialBookingOk,
    );

    if (prevalidationIssues.isNotEmpty) {
      dataGaps.addAll(prevalidationIssues);
      return _buildBlockedOutput(
        input: input,
        trip: trip,
        selected: selected,
        execution: execution,
        checkedLegs: checkedLegs,
        blockedLegs: blockedLegs,
        providerStates: providerStates,
        policyResults: policyResults,
        dataGaps: dataGaps,
        reason: 'Prevalidation failed: ${prevalidationIssues.join(', ')}',
      );
    }

    if (!consentOk || selected.requiresUserInput) {
      final userReason = !user.termsAccepted
          ? 'Terms acceptance missing'
          : !user.dataSharingConsent && needsDataSharing
          ? 'Data sharing consent missing for provider execution'
          : !user.paymentConsent && hasPaidLeg
          ? 'Payment consent missing for paid leg'
          : 'Additional user input required for execution';
      return _buildUserConfirmationOutput(
        input: input,
        trip: trip,
        selected: selected,
        execution: execution,
        checkedLegs: checkedLegs,
        blockedLegs: blockedLegs.isEmpty ? checkedLegs.toList() : blockedLegs,
        providerStates: providerStates,
        policyResults: policyResults,
        dataGaps: dataGaps,
        reason: userReason,
      );
    }

    if (!paymentPolicyOk) {
      return _buildBlockedOutput(
        input: input,
        trip: trip,
        selected: selected,
        execution: execution,
        checkedLegs: checkedLegs,
        blockedLegs: blockedLegs.isEmpty ? checkedLegs.toList() : blockedLegs,
        providerStates: providerStates,
        policyResults: policyResults,
        dataGaps: dataGaps,
        reason: 'Payment execution not ready for paid chain',
      );
    }

    if (!budgetOk || !oneTapOk) {
      return _buildBlockedOutput(
        input: input,
        trip: trip,
        selected: selected,
        execution: execution,
        checkedLegs: checkedLegs,
        blockedLegs: blockedLegs,
        providerStates: providerStates,
        policyResults: policyResults,
        dataGaps: dataGaps,
        reason: !budgetOk
            ? 'Budget or price policy violated'
            : 'One tap not allowed by booking policy',
      );
    }

    if (!fullChainExecutable) {
      if (previousState.hasCommittedWork) {
        final rollbackPossible = previousState.affectedLegIds.every(
          (legId) => selected.legById(legId)?.rollbackSupported ?? false,
        );
        final userCharged = previousState.userCharged;
        if (rollbackPossible && rules.rollbackRequiredOnAnyFailure) {
          return _buildRollbackOutput(
            input: input,
            trip: trip,
            selected: selected,
            execution: execution,
            checkedLegs: checkedLegs,
            blockedLegs: blockedLegs,
            providerStates: providerStates,
            policyResults: policyResults,
            dataGaps: dataGaps,
            previousState: previousState,
            requiresAtomicCommit: requiresAtomicCommit,
            reason:
                'Chain not executable after partial execution; rollback required by policy',
          );
        }
        if (userCharged ||
            !rollbackPossible ||
            rules.compensationRequiredIfUserCharged) {
          return _buildCompensationOutput(
            input: input,
            trip: trip,
            selected: selected,
            execution: execution,
            checkedLegs: checkedLegs,
            blockedLegs: blockedLegs,
            providerStates: providerStates,
            policyResults: policyResults,
            dataGaps: dataGaps,
            reason: userCharged
                ? 'User charged but full chain can no longer be fulfilled'
                : 'Rollback not fully possible after partial execution',
          );
        }
      }

      return _buildBlockedOutput(
        input: input,
        trip: trip,
        selected: selected,
        execution: execution,
        checkedLegs: checkedLegs,
        blockedLegs: blockedLegs,
        providerStates: providerStates,
        policyResults: policyResults,
        dataGaps: dataGaps,
        reason: blockedLegs.isNotEmpty
            ? 'Full chain execution blocked by leg or provider state'
            : 'Full chain guarantee not satisfied',
      );
    }

    return BookingExecutionOutput(
      schemaVersion: input.schemaVersion,
      executionStatus: 'COMMIT_READY',
      displayMessage: _truncate(
        'Deine Buchung ist vollstaendig vorbereitet und kann jetzt verbindlich ausgeloest werden.',
      ),
      executionReason:
          'All legs available, payment ready, full-chain guarantee satisfied, atomic commit possible',
      transactionPlan: TransactionPlan(
        idempotencyKey: execution.idempotencyKey,
        commitScope: 'FULL_CHAIN',
        requiresAtomicCommit: requiresAtomicCommit,
        steps: _buildCommitSteps(selected.legs),
      ),
      trustLayerAction: BookingTrustLayerAction(
        type: 'ONE_TAP_CONFIRM',
        primaryCta: 'Jetzt buchen',
        payload: _trustPayload(trip.tripId, selected, 'FULL_CHAIN'),
      ),
      rollbackPlan: const RollbackPlan(
        required: false,
        rollbackScope: null,
        steps: [],
      ),
      compensationPlan: const CompensationPlan(
        required: false,
        reason: null,
        suggestedAction: null,
      ),
      technicalMetadata: BookingTechnicalMetadata(
        checkedLegs: checkedLegs,
        blockedLegs: blockedLegs,
        providerStates: providerStates,
        policyResults: policyResults,
        dataGaps: dataGaps.toSet().toList(),
      ),
    );
  }

  BookingExecutionOutput _buildBlockedOutput({
    required BookingExecutionInput input,
    required _TripContext trip,
    required _SelectedOption selected,
    required _ExecutionContext execution,
    required List<String> checkedLegs,
    required List<String> blockedLegs,
    required Map<String, dynamic> providerStates,
    required BookingPolicyResults policyResults,
    required List<String> dataGaps,
    required String reason,
  }) {
    return BookingExecutionOutput(
      schemaVersion: input.schemaVersion,
      executionStatus: 'EXECUTION_BLOCKED',
      displayMessage: _truncate(
        'Diese Option kann aktuell nicht zuverlaessig vollstaendig gebucht werden.',
      ),
      executionReason: reason,
      transactionPlan: TransactionPlan(
        idempotencyKey: execution.idempotencyKey,
        commitScope: 'NO_COMMIT',
        requiresAtomicCommit: true,
        steps: _buildPrecheckSteps(selected.legs),
      ),
      trustLayerAction: BookingTrustLayerAction(
        type: 'OPEN_DETAILS',
        primaryCta: 'Details ansehen',
        payload: _trustPayload(trip.tripId, selected, 'NO_COMMIT'),
      ),
      rollbackPlan: const RollbackPlan(
        required: false,
        rollbackScope: null,
        steps: [],
      ),
      compensationPlan: const CompensationPlan(
        required: false,
        reason: null,
        suggestedAction: null,
      ),
      technicalMetadata: BookingTechnicalMetadata(
        checkedLegs: checkedLegs,
        blockedLegs: blockedLegs.toSet().toList(),
        providerStates: providerStates,
        policyResults: policyResults,
        dataGaps: dataGaps.toSet().toList(),
      ),
    );
  }

  BookingExecutionOutput _buildUserConfirmationOutput({
    required BookingExecutionInput input,
    required _TripContext trip,
    required _SelectedOption selected,
    required _ExecutionContext execution,
    required List<String> checkedLegs,
    required List<String> blockedLegs,
    required Map<String, dynamic> providerStates,
    required BookingPolicyResults policyResults,
    required List<String> dataGaps,
    required String reason,
  }) {
    return BookingExecutionOutput(
      schemaVersion: input.schemaVersion,
      executionStatus: 'USER_CONFIRMATION_REQUIRED',
      displayMessage: _truncate(
        'Vor der Buchung brauche ich noch deine Freigabe fuer die Zahlung.',
      ),
      executionReason: reason,
      transactionPlan: TransactionPlan(
        idempotencyKey: execution.idempotencyKey,
        commitScope: 'NO_COMMIT',
        requiresAtomicCommit: true,
        steps: _buildPrecheckSteps(selected.legs),
      ),
      trustLayerAction: BookingTrustLayerAction(
        type: 'REQUEST_USER_INPUT',
        primaryCta: 'Freigabe erteilen',
        payload: _trustPayload(trip.tripId, selected, 'NO_COMMIT'),
      ),
      rollbackPlan: const RollbackPlan(
        required: false,
        rollbackScope: null,
        steps: [],
      ),
      compensationPlan: const CompensationPlan(
        required: false,
        reason: null,
        suggestedAction: null,
      ),
      technicalMetadata: BookingTechnicalMetadata(
        checkedLegs: checkedLegs,
        blockedLegs: blockedLegs.toSet().toList(),
        providerStates: providerStates,
        policyResults: policyResults,
        dataGaps: dataGaps.toSet().toList(),
      ),
    );
  }

  BookingExecutionOutput _buildRollbackOutput({
    required BookingExecutionInput input,
    required _TripContext trip,
    required _SelectedOption selected,
    required _ExecutionContext execution,
    required List<String> checkedLegs,
    required List<String> blockedLegs,
    required Map<String, dynamic> providerStates,
    required BookingPolicyResults policyResults,
    required List<String> dataGaps,
    required _PreviousExecutionState previousState,
    required bool requiresAtomicCommit,
    required String reason,
  }) {
    final rollbackSteps = <ExecutionStep>[];
    var stepNo = 1;
    for (final legId in previousState.affectedLegIds) {
      final leg = selected.legById(legId);
      if (leg == null) continue;
      rollbackSteps.add(
        ExecutionStep(
          stepNo: stepNo++,
          action: 'ROLLBACK',
          provider: leg.provider,
          legId: leg.legId,
          mandatory: true,
        ),
      );
    }

    return BookingExecutionOutput(
      schemaVersion: input.schemaVersion,
      executionStatus: 'ROLLBACK_REQUIRED',
      displayMessage: _truncate(
        'Die Buchung konnte nicht vollstaendig abgeschlossen werden. Ich stelle den vorherigen Zustand wieder her.',
      ),
      executionReason: reason,
      transactionPlan: TransactionPlan(
        idempotencyKey: execution.idempotencyKey,
        commitScope: 'NO_COMMIT',
        requiresAtomicCommit: requiresAtomicCommit,
        steps: const [],
      ),
      trustLayerAction: BookingTrustLayerAction(
        type: 'OPEN_DETAILS',
        primaryCta: 'Details ansehen',
        payload: _trustPayload(trip.tripId, selected, 'NO_COMMIT'),
      ),
      rollbackPlan: RollbackPlan(
        required: true,
        rollbackScope: 'FULL_CHAIN',
        steps: rollbackSteps,
      ),
      compensationPlan: const CompensationPlan(
        required: false,
        reason: null,
        suggestedAction: null,
      ),
      technicalMetadata: BookingTechnicalMetadata(
        checkedLegs: checkedLegs,
        blockedLegs: blockedLegs.toSet().toList(),
        providerStates: providerStates,
        policyResults: policyResults,
        dataGaps: dataGaps.toSet().toList(),
      ),
    );
  }

  BookingExecutionOutput _buildCompensationOutput({
    required BookingExecutionInput input,
    required _TripContext trip,
    required _SelectedOption selected,
    required _ExecutionContext execution,
    required List<String> checkedLegs,
    required List<String> blockedLegs,
    required Map<String, dynamic> providerStates,
    required BookingPolicyResults policyResults,
    required List<String> dataGaps,
    required String reason,
  }) {
    return BookingExecutionOutput(
      schemaVersion: input.schemaVersion,
      executionStatus: 'COMPENSATION_REQUIRED',
      displayMessage: _truncate(
        'Die Buchung ist nicht voll nutzbar. Ich leite jetzt die notwendige Nachbereitung ein.',
      ),
      executionReason: reason,
      transactionPlan: TransactionPlan(
        idempotencyKey: execution.idempotencyKey,
        commitScope: 'NO_COMMIT',
        requiresAtomicCommit: true,
        steps: const [],
      ),
      trustLayerAction: BookingTrustLayerAction(
        type: 'OPEN_DETAILS',
        primaryCta: 'Details ansehen',
        payload: _trustPayload(trip.tripId, selected, 'NO_COMMIT'),
      ),
      rollbackPlan: const RollbackPlan(
        required: false,
        rollbackScope: null,
        steps: [],
      ),
      compensationPlan: const CompensationPlan(
        required: true,
        reason: 'Service recovery required after partial execution failure',
        suggestedAction: 'Refund and manual support review',
      ),
      technicalMetadata: BookingTechnicalMetadata(
        checkedLegs: checkedLegs,
        blockedLegs: blockedLegs.toSet().toList(),
        providerStates: providerStates,
        policyResults: policyResults,
        dataGaps: dataGaps.toSet().toList(),
      ),
    );
  }

  List<ExecutionStep> _buildCommitSteps(List<_Leg> legs) {
    final steps = <ExecutionStep>[];
    var stepNo = 1;
    for (final leg in legs) {
      steps.add(
        ExecutionStep(
          stepNo: stepNo++,
          action: 'PRECHECK',
          provider: leg.provider,
          legId: leg.legId,
          mandatory: true,
        ),
      );
      if (leg.reservationRequired && leg.reservationStatus == 'HELD') {
        steps.add(
          ExecutionStep(
            stepNo: stepNo++,
            action: 'RESERVE',
            provider: leg.provider,
            legId: leg.legId,
            mandatory: true,
          ),
        );
      }
      if (leg.priceEur > 0) {
        steps.add(
          ExecutionStep(
            stepNo: stepNo++,
            action: 'AUTHORIZE_PAYMENT',
            provider: leg.provider,
            legId: leg.legId,
            mandatory: true,
          ),
        );
      }
      steps.add(
        ExecutionStep(
          stepNo: stepNo++,
          action: leg.fulfillmentType == 'TICKET'
              ? 'ISSUE_TICKET'
              : 'CONFIRM_BOOKING',
          provider: leg.provider,
          legId: leg.legId,
          mandatory: true,
        ),
      );
    }
    steps.add(
      ExecutionStep(
        stepNo: stepNo,
        action: 'COMMIT',
        provider: '',
        legId: legs.first.legId,
        mandatory: true,
      ),
    );
    return steps;
  }

  List<ExecutionStep> _buildPrecheckSteps(List<_Leg> legs) {
    if (legs.isEmpty) {
      return const [
        ExecutionStep(
          stepNo: 1,
          action: 'PRECHECK',
          provider: '',
          legId: '',
          mandatory: true,
        ),
      ];
    }
    return List<ExecutionStep>.generate(legs.length, (index) {
      final leg = legs[index];
      return ExecutionStep(
        stepNo: index + 1,
        action: 'PRECHECK',
        provider: leg.provider,
        legId: leg.legId,
        mandatory: true,
      );
    });
  }

  Map<String, dynamic> _trustPayload(
    String? tripId,
    _SelectedOption selected,
    String commitScope,
  ) {
    return {
      'trip_id': tripId,
      'option_id': selected.optionId,
      'total_price_eur': selected.totalPriceEur,
      'currency': selected.currency,
      'provider_bundle': selected.providerBundle,
      'commit_scope': commitScope,
    };
  }

  bool _hasHardPolicyFlag(List<String> flags) {
    return flags.any((flag) {
      final value = flag.toLowerCase();
      return value.contains('hard') ||
          value.contains('block') ||
          value.contains('forbid') ||
          value.contains('violation');
    });
  }

  String _truncate(String message) {
    if (message.length <= 180) return message;
    return message.substring(0, 180);
  }
}

class _TripContext {
  const _TripContext({required this.tripId});

  factory _TripContext.fromInput(
    Map<String, dynamic> json,
    List<String> dataGaps,
  ) {
    final tripId = json['trip_id']?.toString();
    if (tripId == null || tripId.isEmpty) {
      dataGaps.add('missing_trip_id');
    }
    return _TripContext(tripId: tripId);
  }

  final String? tripId;
}

class _Phase2Context {
  const _Phase2Context({
    required this.recommendationStatus,
    required this.recommendedOptionId,
  });

  factory _Phase2Context.fromInput(
    Map<String, dynamic> json,
    List<String> dataGaps,
  ) {
    final recommendationStatus =
        json['recommendation_status']?.toString() ?? 'NO_ACTIONABLE_OPTION';
    final recommendedOptionId = json['recommended_option_id']?.toString();
    if (recommendedOptionId == null || recommendedOptionId.isEmpty) {
      dataGaps.add('missing_phase2_recommended_option_id');
    }
    return _Phase2Context(
      recommendationStatus: recommendationStatus,
      recommendedOptionId: recommendedOptionId,
    );
  }

  final String recommendationStatus;
  final String? recommendedOptionId;
}

class _UserContext {
  const _UserContext({
    required this.termsAccepted,
    required this.paymentConsent,
    required this.dataSharingConsent,
    required this.defaultPaymentMethodAvailable,
    required this.pspReady,
    required this.budgetEnabled,
    required this.remainingAmountEur,
  });

  factory _UserContext.fromInput(
    Map<String, dynamic> json,
    List<String> dataGaps,
  ) {
    final consentState = Map<String, dynamic>.from(
      json['consent_state'] as Map? ?? const {},
    );
    final paymentAssets = Map<String, dynamic>.from(
      json['payment_assets'] as Map? ?? const {},
    );
    final budgetContext = Map<String, dynamic>.from(
      json['budget_context'] as Map? ?? const {},
    );
    if (json['consent_state'] == null) {
      dataGaps.add('missing_consent_state');
    }
    return _UserContext(
      termsAccepted: consentState['terms_accepted'] == true,
      paymentConsent: consentState['payment_consent'] == true,
      dataSharingConsent: consentState['data_sharing_consent'] == true,
      defaultPaymentMethodAvailable:
          paymentAssets['default_payment_method_available'] == true,
      pspReady: paymentAssets['psp_ready'] == true,
      budgetEnabled: budgetContext['budget_enabled'] == true,
      remainingAmountEur: (budgetContext['remaining_amount_eur'] as num?)
          ?.toDouble(),
    );
  }

  final bool termsAccepted;
  final bool paymentConsent;
  final bool dataSharingConsent;
  final bool defaultPaymentMethodAvailable;
  final bool pspReady;
  final bool budgetEnabled;
  final double? remainingAmountEur;
}

class _ExecutionRules {
  const _ExecutionRules({
    required this.oneTapAllowed,
    required this.partialBookingAllowed,
    required this.maxTotalPriceEur,
    required this.requiresFullChainBookability,
    required this.rollbackRequiredOnAnyFailure,
    required this.compensationRequiredIfUserCharged,
  });

  factory _ExecutionRules.fromInput(Map<String, dynamic> json) {
    final bookingPolicy = Map<String, dynamic>.from(
      json['booking_policy'] as Map? ?? const {},
    );
    final guaranteePolicy = Map<String, dynamic>.from(
      json['guarantee_policy'] as Map? ?? const {},
    );
    final rollbackPolicy = Map<String, dynamic>.from(
      json['rollback_policy'] as Map? ?? const {},
    );
    final maxTotalPrice = (bookingPolicy['max_total_price_eur'] as num?)
        ?.toDouble();
    return _ExecutionRules(
      oneTapAllowed: bookingPolicy['one_tap_allowed'] != false,
      partialBookingAllowed: bookingPolicy['partial_booking_allowed'] == true,
      maxTotalPriceEur: maxTotalPrice == null || maxTotalPrice <= 0
          ? null
          : maxTotalPrice,
      requiresFullChainBookability:
          guaranteePolicy['requires_full_chain_bookability'] != false,
      rollbackRequiredOnAnyFailure:
          rollbackPolicy['rollback_required_on_any_failure'] != false,
      compensationRequiredIfUserCharged:
          rollbackPolicy['compensation_required_if_user_charged'] != false,
    );
  }

  final bool oneTapAllowed;
  final bool partialBookingAllowed;
  final double? maxTotalPriceEur;
  final bool requiresFullChainBookability;
  final bool rollbackRequiredOnAnyFailure;
  final bool compensationRequiredIfUserCharged;
}

class _ExecutionContext {
  const _ExecutionContext({required this.idempotencyKey});

  factory _ExecutionContext.fromInput(
    Map<String, dynamic> json,
    List<String> dataGaps,
  ) {
    final idempotencyKey = json['idempotency_key']?.toString() ?? '';
    if (idempotencyKey.isEmpty) {
      dataGaps.add('missing_idempotency_key');
    }
    return _ExecutionContext(idempotencyKey: idempotencyKey);
  }

  final String idempotencyKey;
}

class _ProviderStatusIndex {
  const _ProviderStatusIndex(this.providers);

  factory _ProviderStatusIndex.fromInput(Map<String, dynamic> json) {
    final providers = (json['providers'] as List? ?? const [])
        .map(
          (item) =>
              _ProviderStatus.fromMap(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
    return _ProviderStatusIndex(providers);
  }

  final List<_ProviderStatus> providers;

  _ProviderStatus? byProvider(String provider) {
    for (final item in providers) {
      if (item.provider == provider) return item;
    }
    return null;
  }

  Map<String, dynamic> toMetadataMap() {
    final result = <String, dynamic>{};
    for (final item in providers) {
      if (item.paymentState == 'READY' &&
          item.bookingState == 'READY' &&
          item.inventoryState == 'AVAILABLE' &&
          item.apiAvailable) {
        result[item.provider] = 'READY';
      } else if (!item.apiAvailable) {
        result[item.provider] = 'UNAVAILABLE';
      } else {
        result[item.provider] =
            '${item.bookingState}/${item.paymentState}/${item.inventoryState}';
      }
    }
    return result;
  }
}

class _ProviderStatus {
  const _ProviderStatus({
    required this.provider,
    required this.apiAvailable,
    required this.bookingState,
    required this.paymentState,
    required this.inventoryState,
  });

  factory _ProviderStatus.fromMap(Map<String, dynamic> json) {
    return _ProviderStatus(
      provider: json['provider']?.toString() ?? '',
      apiAvailable: json['api_available'] == true,
      bookingState: json['booking_state']?.toString() ?? 'UNKNOWN',
      paymentState: json['payment_state']?.toString() ?? 'UNKNOWN',
      inventoryState: json['inventory_state']?.toString() ?? 'UNKNOWN',
    );
  }

  final String provider;
  final bool apiAvailable;
  final String bookingState;
  final String paymentState;
  final String inventoryState;
}

class _SelectedOption {
  const _SelectedOption({
    required this.optionId,
    required this.providerBundle,
    required this.legs,
    required this.totalPriceEur,
    required this.bookableWithOneTap,
    required this.requiresUserInput,
    required this.currency,
  });

  factory _SelectedOption.fromInput(
    Map<String, dynamic> json,
    List<String> dataGaps,
  ) {
    final optionId = json['option_id']?.toString();
    if (optionId == null || optionId.isEmpty) {
      dataGaps.add('missing_selected_option_id');
    }
    final legs = (json['legs'] as List? ?? const [])
        .map(
          (item) =>
              _Leg.fromMap(Map<String, dynamic>.from(item as Map), dataGaps),
        )
        .toList();
    return _SelectedOption(
      optionId: optionId,
      providerBundle: (json['provider_bundle'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
      legs: legs,
      totalPriceEur: (json['total_price_eur'] as num?)?.toDouble() ?? 0,
      bookableWithOneTap: json['bookable_with_one_tap'] == true,
      requiresUserInput: json['requires_user_input'] == true,
      currency: legs.isEmpty ? 'EUR' : legs.first.currency,
    );
  }

  final String? optionId;
  final List<String> providerBundle;
  final List<_Leg> legs;
  final double totalPriceEur;
  final bool bookableWithOneTap;
  final bool requiresUserInput;
  final String currency;

  _Leg? legById(String legId) {
    for (final leg in legs) {
      if (leg.legId == legId) return leg;
    }
    return null;
  }
}

class _Leg {
  const _Leg({
    required this.legId,
    required this.provider,
    required this.bookable,
    required this.reservationRequired,
    required this.reservationStatus,
    required this.priceEur,
    required this.currency,
    required this.fulfillmentType,
    required this.inventoryStatus,
    required this.rollbackSupported,
    required this.compensationSupported,
    required this.policyFlags,
    required this.exclusionFlags,
  });

  factory _Leg.fromMap(Map<String, dynamic> json, List<String> dataGaps) {
    final legId = json['leg_id']?.toString() ?? '';
    if (legId.isEmpty) {
      dataGaps.add('missing_leg_id');
    }
    return _Leg(
      legId: legId,
      provider: json['provider']?.toString() ?? '',
      bookable: json['bookable'] == true,
      reservationRequired: json['reservation_required'] == true,
      reservationStatus:
          json['reservation_status']?.toString() ?? 'NOT_REQUIRED',
      priceEur: (json['price_eur'] as num?)?.toDouble() ?? 0,
      currency: json['currency']?.toString() ?? 'EUR',
      fulfillmentType: json['fulfillment_type']?.toString() ?? 'TICKET',
      inventoryStatus: json['inventory_status']?.toString() ?? 'UNAVAILABLE',
      rollbackSupported: json['rollback_supported'] != false,
      compensationSupported: json['compensation_supported'] != false,
      policyFlags: (json['policy_flags'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
      exclusionFlags: (json['exclusion_flags'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
    );
  }

  final String legId;
  final String provider;
  final bool bookable;
  final bool reservationRequired;
  final String reservationStatus;
  final double priceEur;
  final String currency;
  final String fulfillmentType;
  final String inventoryStatus;
  final bool rollbackSupported;
  final bool compensationSupported;
  final List<String> policyFlags;
  final List<String> exclusionFlags;
}

class _PreviousExecutionState {
  const _PreviousExecutionState({
    required this.affectedLegIds,
    required this.userCharged,
  });

  factory _PreviousExecutionState.fromInput(Object? raw) {
    final json = raw is Map
        ? Map<String, dynamic>.from(raw)
        : const <String, dynamic>{};
    final affectedLegIds = <String>{
      ..._stringList(json['reserved_leg_ids']),
      ..._stringList(json['booked_leg_ids']),
      ..._stringList(json['paid_leg_ids']),
      ..._stringList(json['committed_leg_ids']),
    }.toList();

    final userCharged =
        json['user_charged'] == true ||
        _stringList(json['paid_leg_ids']).isNotEmpty;

    return _PreviousExecutionState(
      affectedLegIds: affectedLegIds,
      userCharged: userCharged,
    );
  }

  final List<String> affectedLegIds;
  final bool userCharged;

  bool get hasCommittedWork => affectedLegIds.isNotEmpty;

  static List<String> _stringList(Object? raw) {
    return (raw as List? ?? const [])
        .map((item) => item.toString())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}
