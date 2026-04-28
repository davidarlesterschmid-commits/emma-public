import 'package:domain_journey/src/entities/option_orchestration_models.dart';

class OptionOrchestrationEngine {
  const OptionOrchestrationEngine();

  static const promptTemplate = '''
Technisches Prompt-Template: emma Phase 2 - Option Orchestration v1.0

Rolle
Du bist das Modul "emma-option-orchestrator".
Deine Aufgabe ist es, aus bereits vorliegenden Mobilitaetsoptionen genau eine fachlich beste, umsetzbare und vertrauenswuerdige Empfehlung auszuwaehlen oder eine sichere Eskalation auszugeben.
''';

  OptionOrchestrationOutput evaluate(OptionOrchestrationInput input) {
    final dataGaps = <String>[];
    final consideredCount = input.candidateOptions.length;
    final discardedIds = <String>[];
    final discardReasons = <String, String>{};

    final intentDetected = input.phase1Result['intent_detected'] == true;
    if (!intentDetected) {
      return _noActionOutput(
        input: input,
        consideredCount: consideredCount,
        eligibleCount: 0,
        discardedIds: discardedIds,
        discardReasons: discardReasons,
        dataGaps: dataGaps,
        displayMessage: '',
        trustType: consideredCount > 0 ? 'OPEN_DETAILS' : 'NONE',
      );
    }

    if (input.candidateOptions.isEmpty) {
      dataGaps.add('missing_candidate_options');
      return _noActionOutput(
        input: input,
        consideredCount: consideredCount,
        eligibleCount: 0,
        discardedIds: discardedIds,
        discardReasons: discardReasons,
        dataGaps: dataGaps,
        displayMessage:
            'Ich habe aktuell keine belastbare Option gefunden. Bitte pruefe die Details.',
        trustType: 'OPEN_DETAILS',
      );
    }

    final userPreferences = _UserPreferences.fromInput(input.userProfile);
    dataGaps.addAll(userPreferences.dataGaps);
    final rules = _ServiceRules.fromInput(input.serviceRules);
    final tripContext = _TripContext.fromInput(input.tripContext, dataGaps);
    final parsedOptions = input.candidateOptions
        .map((item) => _ParsedOption.fromMap(item, dataGaps))
        .toList();

    final eligible = <_ParsedOption>[];
    for (final option in parsedOptions) {
      final discardReason = _discardReason(
        option: option,
        rules: rules,
        tripContext: tripContext,
        userPreferences: userPreferences,
      );
      if (discardReason != null) {
        if (option.optionId != null) {
          discardedIds.add(option.optionId!);
          discardReasons[option.optionId!] = discardReason;
        }
      } else {
        eligible.add(option);
      }
    }

    if (eligible.isEmpty) {
      return _noActionOutput(
        input: input,
        consideredCount: consideredCount,
        eligibleCount: 0,
        discardedIds: discardedIds,
        discardReasons: discardReasons,
        dataGaps: dataGaps,
        displayMessage:
            'Ich habe aktuell keine belastbare, garantiefaehige Option gefunden. Bitte pruefe die verfuegbaren Details.',
        trustType: 'OPEN_DETAILS',
      );
    }

    eligible.sort(
      (a, b) => _compareOptions(
        a,
        b,
        targetArrival: tripContext.targetArrivalTime,
        preferredModes: userPreferences.preferredModes,
        dislikedModes: userPreferences.dislikedModes,
      ),
    );

    final selected = eligible.first;
    final recommendationStatus = _recommendationStatus(
      selected: selected,
      targetArrival: tripContext.targetArrivalTime,
    );

    return OptionOrchestrationOutput(
      schemaVersion: input.schemaVersion,
      recommendationStatus: recommendationStatus,
      recommendedOptionId: selected.optionId,
      displayMessage: _displayMessageForStatus(recommendationStatus),
      selectionReason: _buildSelectionReason(selected),
      trustLayerAction: _trustLayerAction(
        input: input,
        option: selected,
        recommendationStatus: recommendationStatus,
      ),
      alternativesSummary: AlternativesSummary(
        consideredOptionsCount: consideredCount,
        eligibleOptionsCount: eligible.length,
        discardedOptionIds: discardedIds,
        discardReasons: discardReasons,
      ),
      technicalMetadata: OptionTechnicalMetadata(
        decisionPath: const DecisionPath(
          hardFiltersApplied: true,
          guaranteeRuleApplied: true,
          budgetRuleApplied: true,
          preferenceRuleApplied: true,
        ),
        selectedBecause: _selectedBecause(
          selected: selected,
          eligible: eligible,
          targetArrival: tripContext.targetArrivalTime,
        ),
        affectedProviders: selected.providerBundle,
        dataGaps: dataGaps.toSet().toList(),
      ),
    );
  }

  OptionOrchestrationOutput _noActionOutput({
    required OptionOrchestrationInput input,
    required int consideredCount,
    required int eligibleCount,
    required List<String> discardedIds,
    required Map<String, String> discardReasons,
    required List<String> dataGaps,
    required String displayMessage,
    required String trustType,
  }) {
    return OptionOrchestrationOutput(
      schemaVersion: input.schemaVersion,
      recommendationStatus: 'NO_ACTIONABLE_OPTION',
      recommendedOptionId: null,
      displayMessage: _truncateMessage(displayMessage),
      selectionReason:
          'No eligible candidate option after precheck and hard filters',
      trustLayerAction: OptionTrustLayerAction(
        type: trustType,
        primaryCta: trustType == 'OPEN_DETAILS' ? 'Details ansehen' : null,
        payload: null,
      ),
      alternativesSummary: AlternativesSummary(
        consideredOptionsCount: consideredCount,
        eligibleOptionsCount: eligibleCount,
        discardedOptionIds: discardedIds,
        discardReasons: discardReasons,
      ),
      technicalMetadata: OptionTechnicalMetadata(
        decisionPath: const DecisionPath(
          hardFiltersApplied: true,
          guaranteeRuleApplied: true,
          budgetRuleApplied: true,
          preferenceRuleApplied: true,
        ),
        selectedBecause: const SelectedBecause(
          bestGuaranteeLevel: false,
          earliestViableArrival: false,
          budgetCompliant: false,
          lowestComplexity: false,
          lowestCost: false,
        ),
        affectedProviders: const [],
        dataGaps: dataGaps.toSet().toList(),
      ),
    );
  }

  String? _discardReason({
    required _ParsedOption option,
    required _ServiceRules rules,
    required _TripContext tripContext,
    required _UserPreferences userPreferences,
  }) {
    if (option.exclusionFlags.isNotEmpty) {
      return 'exclusion_flag_present';
    }
    if (rules.enforceBudgetCompliance && !option.budgetCompliant) {
      return 'budget_non_compliant';
    }
    if (userPreferences.accessibilityFlags.isNotEmpty &&
        !option.accessibilityFit) {
      return 'accessibility_mismatch';
    }
    if (_violatesGuarantee(option, rules)) {
      return 'guarantee_policy_violation';
    }
    if (_exceedsHardArrivalCutoff(
      option,
      tripContext.targetArrivalTime,
      rules.hardCutoffArrivalDelayMin,
    )) {
      return 'arrival_after_hard_cutoff';
    }
    return null;
  }

  bool _violatesGuarantee(_ParsedOption option, _ServiceRules rules) {
    if (!rules.guaranteeEnabled) return false;
    final lowerFlags = option.policyFlags
        .map((item) => item.toLowerCase())
        .toList();
    if (lowerFlags.any(
      (flag) =>
          flag.contains('guarantee_violation') ||
          flag.contains('hard_guarantee_violation'),
    )) {
      return true;
    }
    if (rules.allowedFallbackModes.isEmpty || option.modes.isEmpty) {
      return false;
    }
    return option.modes.any(
      (mode) => !rules.allowedFallbackModes.contains(mode),
    );
  }

  bool _exceedsHardArrivalCutoff(
    _ParsedOption option,
    DateTime? targetArrival,
    int? hardCutoffMinutes,
  ) {
    if (targetArrival == null ||
        hardCutoffMinutes == null ||
        option.arrivalTime == null) {
      return false;
    }
    final delay = option.arrivalTime!.difference(targetArrival).inMinutes;
    return delay > hardCutoffMinutes;
  }

  int _compareOptions(
    _ParsedOption a,
    _ParsedOption b, {
    required DateTime? targetArrival,
    required List<String> preferredModes,
    required List<String> dislikedModes,
  }) {
    final guaranteeCompare = b.guaranteeRank.compareTo(a.guaranteeRank);
    if (guaranteeCompare != 0) return guaranteeCompare;

    final punctualityCompare = _comparePunctuality(a, b, targetArrival);
    if (punctualityCompare != 0) return punctualityCompare;

    final budgetCompare = _boolCompare(a.budgetCompliant, b.budgetCompliant);
    if (budgetCompare != 0) return budgetCompare;

    final costCompare = _compareNullableDouble(
      a.estimatedCostEur,
      b.estimatedCostEur,
    );
    if (costCompare != 0) return costCompare;

    final transferCompare = a.transferCount.compareTo(b.transferCount);
    if (transferCompare != 0) return transferCompare;

    final walkingCompare = a.walkingMin.compareTo(b.walkingMin);
    if (walkingCompare != 0) return walkingCompare;

    final inputCompare = _boolCompare(
      !a.requiresUserInput,
      !b.requiresUserInput,
    );
    if (inputCompare != 0) return inputCompare;

    final oneTapCompare = _boolCompare(
      a.bookableWithOneTap,
      b.bookableWithOneTap,
    );
    if (oneTapCompare != 0) return oneTapCompare;

    final realtimeCompare = a.realtimeRiskScore.compareTo(b.realtimeRiskScore);
    if (realtimeCompare != 0) return realtimeCompare;

    final capacityCompare = a.capacityRiskScore.compareTo(b.capacityRiskScore);
    if (capacityCompare != 0) return capacityCompare;

    final preferenceCompare = _preferenceScore(
      b,
      preferredModes,
      dislikedModes,
    ).compareTo(_preferenceScore(a, preferredModes, dislikedModes));
    if (preferenceCompare != 0) return preferenceCompare;

    final arrivalCompare = _compareNullableDateTime(
      a.arrivalTime,
      b.arrivalTime,
    );
    if (arrivalCompare != 0) return arrivalCompare;

    final tieTransferCompare = a.transferCount.compareTo(b.transferCount);
    if (tieTransferCompare != 0) return tieTransferCompare;

    final tieCostCompare = _compareNullableDouble(
      a.estimatedCostEur,
      b.estimatedCostEur,
    );
    if (tieCostCompare != 0) return tieCostCompare;

    final tieRealtimeCompare = a.realtimeRiskScore.compareTo(
      b.realtimeRiskScore,
    );
    if (tieRealtimeCompare != 0) return tieRealtimeCompare;

    return (a.optionId ?? '~').compareTo(b.optionId ?? '~');
  }

  int _comparePunctuality(
    _ParsedOption a,
    _ParsedOption b,
    DateTime? targetArrival,
  ) {
    final aStatus = _arrivalCategory(a.arrivalTime, targetArrival);
    final bStatus = _arrivalCategory(b.arrivalTime, targetArrival);
    final categoryCompare = aStatus.compareTo(bStatus);
    if (categoryCompare != 0) return categoryCompare;
    return _compareNullableDateTime(a.arrivalTime, b.arrivalTime);
  }

  int _arrivalCategory(DateTime? arrivalTime, DateTime? targetArrival) {
    if (arrivalTime == null || targetArrival == null) return 1;
    return arrivalTime.isAfter(targetArrival) ? 1 : 0;
  }

  int _boolCompare(bool a, bool b) {
    if (a == b) return 0;
    return a ? -1 : 1;
  }

  int _compareNullableDouble(double? a, double? b) {
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;
    return a.compareTo(b);
  }

  int _compareNullableDateTime(DateTime? a, DateTime? b) {
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;
    return a.compareTo(b);
  }

  int _preferenceScore(
    _ParsedOption option,
    List<String> preferredModes,
    List<String> dislikedModes,
  ) {
    var score = 0;
    for (final mode in option.modes) {
      if (preferredModes.contains(mode)) score += 1;
      if (dislikedModes.contains(mode)) score -= 1;
    }
    return score;
  }

  String _recommendationStatus({
    required _ParsedOption selected,
    required DateTime? targetArrival,
  }) {
    if (selected.bookableWithOneTap && !selected.requiresUserInput) {
      return 'ONE_TAP_BOOKABLE';
    }
    final onTime =
        targetArrival == null ||
        selected.arrivalTime == null ||
        !selected.arrivalTime!.isAfter(targetArrival);
    if (selected.guaranteeLevel == 'HIGH' && onTime) {
      return 'REVIEW_REQUIRED';
    }
    return 'FALLBACK_REQUIRED';
  }

  OptionTrustLayerAction _trustLayerAction({
    required OptionOrchestrationInput input,
    required _ParsedOption option,
    required String recommendationStatus,
  }) {
    final payload = option.payload(
      tripId: input.tripContext['trip_id']?.toString(),
    );
    switch (recommendationStatus) {
      case 'ONE_TAP_BOOKABLE':
        return OptionTrustLayerAction(
          type: 'ONE_TAP_CONFIRM',
          primaryCta: 'Route buchen',
          payload: payload,
        );
      case 'REVIEW_REQUIRED':
      case 'FALLBACK_REQUIRED':
        return OptionTrustLayerAction(
          type: 'OPEN_DETAILS',
          primaryCta: 'Details ansehen',
          payload: payload,
        );
      default:
        return const OptionTrustLayerAction(
          type: 'NONE',
          primaryCta: null,
          payload: null,
        );
    }
  }

  String _displayMessageForStatus(String recommendationStatus) {
    switch (recommendationStatus) {
      case 'ONE_TAP_BOOKABLE':
        return 'Deine beste Option ist vorbereitet. Du kommst puenktlich an und musst nichts weiter anpassen.';
      case 'REVIEW_REQUIRED':
        return 'Ich habe die stabilste verfuegbare Alternative gewaehlt. Bitte pruefe die Details vor der Buchung.';
      case 'FALLBACK_REQUIRED':
        return 'Aktuell ist keine starke Direktoption verfuegbar. Ich zeige dir die beste zulaessige Alternative.';
      default:
        return 'Ich habe aktuell keine belastbare Option gefunden. Bitte pruefe die Details.';
    }
  }

  String _buildSelectionReason(_ParsedOption option) {
    return 'Selected ${option.optionId ?? 'unknown'} because '
        'guarantee=${option.guaranteeLevel}, '
        'arrival=${option.arrivalTimeRaw ?? 'unknown'}, '
        'budget_compliant=${option.budgetCompliant}, '
        'transfer_count=${option.transferCount}';
  }

  SelectedBecause _selectedBecause({
    required _ParsedOption selected,
    required List<_ParsedOption> eligible,
    required DateTime? targetArrival,
  }) {
    final bestGuarantee = eligible.every(
      (item) => selected.guaranteeRank >= item.guaranteeRank,
    );
    final selectedArrivalCategory = _arrivalCategory(
      selected.arrivalTime,
      targetArrival,
    );
    final earliestViable = eligible.every((item) {
      final category = _arrivalCategory(item.arrivalTime, targetArrival);
      if (selectedArrivalCategory != category) {
        return selectedArrivalCategory < category;
      }
      return _compareNullableDateTime(selected.arrivalTime, item.arrivalTime) <=
          0;
    });
    final lowestComplexity = eligible.every(
      (item) =>
          _compareComplexity(
            _complexityTuple(selected),
            _complexityTuple(item),
          ) <=
          0,
    );
    final lowestCost = eligible.every(
      (item) =>
          _compareNullableDouble(
            selected.estimatedCostEur,
            item.estimatedCostEur,
          ) <=
          0,
    );

    return SelectedBecause(
      bestGuaranteeLevel: bestGuarantee,
      earliestViableArrival: earliestViable,
      budgetCompliant: selected.budgetCompliant,
      lowestComplexity: lowestComplexity,
      lowestCost: lowestCost,
    );
  }

  List<int> _complexityTuple(_ParsedOption option) {
    return [
      option.transferCount,
      option.walkingMin,
      option.requiresUserInput ? 1 : 0,
      option.bookableWithOneTap ? 0 : 1,
    ];
  }

  int _compareComplexity(List<int> a, List<int> b) {
    for (var i = 0; i < a.length; i++) {
      final compare = a[i].compareTo(b[i]);
      if (compare != 0) return compare;
    }
    return 0;
  }

  String _truncateMessage(String message) {
    if (message.length <= 180) return message;
    return message.substring(0, 180);
  }
}

class _TripContext {
  const _TripContext({required this.targetArrivalTime});

  factory _TripContext.fromInput(
    Map<String, dynamic> json,
    List<String> dataGaps,
  ) {
    final raw = json['target_arrival_time']?.toString();
    final parsed = _tryParseDateTime(raw);
    if (raw == null || raw.isEmpty) {
      dataGaps.add('missing_target_arrival_time');
    } else if (parsed == null) {
      dataGaps.add('invalid_target_arrival_time');
    }
    return _TripContext(targetArrivalTime: parsed);
  }

  final DateTime? targetArrivalTime;
}

class _ServiceRules {
  const _ServiceRules({
    required this.guaranteeEnabled,
    required this.allowedFallbackModes,
    required this.enforceBudgetCompliance,
    required this.hardCutoffArrivalDelayMin,
  });

  factory _ServiceRules.fromInput(Map<String, dynamic> json) {
    final guaranteePolicy = Map<String, dynamic>.from(
      json['guarantee_policy'] as Map? ?? const {},
    );
    final budgetPolicy = Map<String, dynamic>.from(
      json['budget_policy'] as Map? ?? const {},
    );
    return _ServiceRules(
      guaranteeEnabled: guaranteePolicy['enabled'] == true,
      allowedFallbackModes:
          (guaranteePolicy['allowed_fallback_modes'] as List? ?? const [])
              .map((item) => item.toString().toLowerCase())
              .toList(),
      enforceBudgetCompliance:
          budgetPolicy['enforce_budget_compliance'] != false,
      hardCutoffArrivalDelayMin:
          (guaranteePolicy['hard_cutoff_arrival_delay_min'] as num?)?.toInt(),
    );
  }

  final bool guaranteeEnabled;
  final List<String> allowedFallbackModes;
  final bool enforceBudgetCompliance;
  final int? hardCutoffArrivalDelayMin;
}

class _UserPreferences {
  const _UserPreferences({
    required this.preferredModes,
    required this.dislikedModes,
    required this.accessibilityFlags,
    required this.dataGaps,
  });

  factory _UserPreferences.fromInput(Map<String, dynamic> json) {
    final trust = Map<String, dynamic>.from(
      json['trust_preferences'] as Map? ?? const {},
    );
    return _UserPreferences(
      preferredModes: (json['preferred_modes'] as List? ?? const [])
          .map((item) => item.toString().toLowerCase())
          .toList(),
      dislikedModes: (json['disliked_modes'] as List? ?? const [])
          .map((item) => item.toString().toLowerCase())
          .toList(),
      accessibilityFlags: (trust['accessibility_flags'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
      dataGaps: const [],
    );
  }

  final List<String> preferredModes;
  final List<String> dislikedModes;
  final List<String> accessibilityFlags;
  final List<String> dataGaps;
}

class _ParsedOption {
  const _ParsedOption({
    required this.optionId,
    required this.providerBundle,
    required this.departureTime,
    required this.arrivalTime,
    required this.arrivalTimeRaw,
    required this.transferCount,
    required this.walkingMin,
    required this.estimatedCostEur,
    required this.budgetCompliant,
    required this.guaranteeLevel,
    required this.bookable,
    required this.bookableWithOneTap,
    required this.requiresUserInput,
    required this.realtimeRiskScore,
    required this.capacityRiskScore,
    required this.accessibilityFit,
    required this.policyFlags,
    required this.exclusionFlags,
    required this.modes,
    required this.guaranteeRank,
  });

  factory _ParsedOption.fromMap(
    Map<String, dynamic> json,
    List<String> dataGaps,
  ) {
    final optionId = json['option_id']?.toString();
    if (optionId == null || optionId.isEmpty) {
      dataGaps.add('missing_option_id');
    }

    final arrivalRaw = json['arrival_time']?.toString();
    final arrivalTime = _tryParseDateTime(arrivalRaw);
    if (arrivalRaw == null || arrivalRaw.isEmpty) {
      dataGaps.add('missing_option_arrival_time');
    } else if (arrivalTime == null) {
      dataGaps.add('invalid_option_arrival_time');
    }

    final departureRaw = json['departure_time']?.toString();
    final departureTime = _tryParseDateTime(departureRaw);
    if (departureRaw != null &&
        departureRaw.isNotEmpty &&
        departureTime == null) {
      dataGaps.add('invalid_option_departure_time');
    }

    final guaranteeLevel = (json['guarantee_level']?.toString() ?? 'LOW')
        .toUpperCase();
    return _ParsedOption(
      optionId: optionId,
      providerBundle: (json['provider_bundle'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
      departureTime: departureTime,
      arrivalTime: arrivalTime,
      arrivalTimeRaw: arrivalRaw,
      transferCount: (json['transfer_count'] as num?)?.toInt() ?? 99,
      walkingMin: (json['walking_min'] as num?)?.toInt() ?? 999,
      estimatedCostEur: (json['estimated_cost_eur'] as num?)?.toDouble(),
      budgetCompliant: json['budget_compliant'] == true,
      guaranteeLevel: guaranteeLevel,
      bookable: json['bookable'] == true,
      bookableWithOneTap: json['bookable_with_one_tap'] == true,
      requiresUserInput: json['requires_user_input'] == true,
      realtimeRiskScore:
          (json['realtime_risk_score'] as num?)?.toDouble() ?? 1.0,
      capacityRiskScore:
          (json['capacity_risk_score'] as num?)?.toDouble() ?? 1.0,
      accessibilityFit: json['accessibility_fit'] != false,
      policyFlags: (json['policy_flags'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
      exclusionFlags: (json['exclusion_flags'] as List? ?? const [])
          .map((item) => item.toString())
          .toList(),
      modes: _extractModes(json),
      guaranteeRank: _guaranteeRank(guaranteeLevel),
    );
  }

  final String? optionId;
  final List<String> providerBundle;
  final DateTime? departureTime;
  final DateTime? arrivalTime;
  final String? arrivalTimeRaw;
  final int transferCount;
  final int walkingMin;
  final double? estimatedCostEur;
  final bool budgetCompliant;
  final String guaranteeLevel;
  final bool bookable;
  final bool bookableWithOneTap;
  final bool requiresUserInput;
  final double realtimeRiskScore;
  final double capacityRiskScore;
  final bool accessibilityFit;
  final List<String> policyFlags;
  final List<String> exclusionFlags;
  final List<String> modes;
  final int guaranteeRank;

  Map<String, dynamic>? payload({required String? tripId}) {
    if (optionId == null || departureTime == null || arrivalTime == null) {
      return null;
    }
    return {
      'trip_id': tripId,
      'option_id': optionId,
      'departure_time': departureTime!.toIso8601String(),
      'arrival_time': arrivalTime!.toIso8601String(),
      'estimated_cost_eur': estimatedCostEur,
      'provider_bundle': providerBundle,
      'guarantee_level': guaranteeLevel,
      'budget_compliant': budgetCompliant,
    };
  }

  static List<String> _extractModes(Map<String, dynamic> json) {
    final directModes = (json['modes'] as List? ?? const [])
        .map((item) => item.toString().toLowerCase())
        .toList();
    if (directModes.isNotEmpty) return directModes;
    final legs = (json['legs'] as List? ?? const []);
    return legs
        .whereType<Map>()
        .map((item) => item['mode']?.toString().toLowerCase())
        .whereType<String>()
        .toList();
  }

  static int _guaranteeRank(String level) {
    switch (level) {
      case 'HIGH':
        return 3;
      case 'MEDIUM':
        return 2;
      default:
        return 1;
    }
  }
}

DateTime? _tryParseDateTime(String? value) {
  if (value == null || value.isEmpty) return null;
  return DateTime.tryParse(value);
}
