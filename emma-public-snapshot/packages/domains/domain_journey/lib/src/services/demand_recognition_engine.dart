import 'package:domain_journey/src/entities/demand_recognition_models.dart';

class DemandRecognitionEngine {
  const DemandRecognitionEngine();

  static const promptTemplate = '''
Technisches Prompt-Template: emma Phase 1 - Demand Recognition v1.1

Rolle
Du bist das Modul "emma-context-engine".
Deine Aufgabe ist es, aus strukturierten Kontextdaten zu erkennen, ob in den naechsten 60 Minuten ein relevanter Mobilitaetsbedarf entsteht, und daraus genau eine deterministische, frontend-taugliche Handlungsausgabe abzuleiten.
''';

  DemandRecognitionOutput evaluate(DemandRecognitionInput input) {
    final dataGaps = <String>[];
    final now = _parseNow(
      input.environmentalData['current_time_local']?.toString(),
    );
    if (now == null) {
      dataGaps.add('missing_current_time_local');
    }

    final eventMatch = _findRelevantEvent(input.calendarData, now, dataGaps);
    final routineMatch = _findRelevantRoutine(input.userProfile, now);
    final tripMatch = _inferStandardTrip(
      input.userProfile,
      now,
      input.currentLocation,
    );

    final calendarDetected = eventMatch != null;
    final routineDetected = routineMatch != null;
    final tripDetected = tripMatch != null;
    final intentDetected =
        now != null && (calendarDetected || routineDetected || tripDetected);

    if (!intentDetected) {
      if ((input.candidateOptions).isEmpty) {
        dataGaps.add('missing_candidate_options');
      }
      return _noneOutput(dataGaps: dataGaps);
    }

    final realtimeIssue = _hasRealtimeIssue(input.realtimeStatus);
    final weatherIssue = _hasWeatherIssue(input.environmentalData);
    final budgetIssue = _hasBudgetIssue(
      input.userProfile,
      input.candidateOptions,
    );
    final selectedOption = _selectBestOption(input.candidateOptions);
    final optimizationFound = _hasMeaningfulBenefit(
      selectedOption,
      realtimeIssue,
      budgetIssue,
    );
    final affectedProviders = _collectProviders(
      input.realtimeStatus,
      selectedOption,
    );
    final triggerParts = <String>[
      if (eventMatch != null) 'calendar_event=${eventMatch.title}',
      if (routineMatch != null) 'routine=${routineMatch.name}',
      if (tripMatch != null) 'standard_trip=$tripMatch',
      if (realtimeIssue) 'realtime_issue=true',
      if (weatherIssue) 'weather_issue=true',
      if (budgetIssue) 'budget_issue=true',
      if (selectedOption?.routeId != null)
        'candidate_option=${selectedOption!.routeId}',
    ];

    final confidence = _computeConfidence(
      calendarDetected: calendarDetected,
      routineDetected: routineDetected,
      tripDetected: tripDetected,
      realtimeIssue: realtimeIssue,
      weatherIssue: weatherIssue,
      budgetIssue: budgetIssue,
      hasSelectedOption: selectedOption != null,
    );

    final decisionBasis = DecisionBasis(
      calendarMatch: calendarDetected,
      routineMatch: routineDetected,
      realtimeIssue: realtimeIssue,
      weatherIssue: weatherIssue,
      budgetIssue: budgetIssue,
      optimizationFound: optimizationFound,
    );

    if ((input.candidateOptions).isEmpty) {
      dataGaps.add('missing_candidate_options');
    }

    final hasDeterministicAction =
        selectedOption != null &&
        optimizationFound &&
        (realtimeIssue || budgetIssue || weatherIssue) &&
        selectedOption.hasActionablePayload;

    if (hasDeterministicAction) {
      final message = _truncateMessage(
        'Du musst in ${_minutesUntilLabel(eventMatch?.start, routineMatch?.start, now)} los. '
        '${_issueLeadText(realtimeIssue, weatherIssue, budgetIssue)} '
        'Ich habe eine sichere Alternative fuer dich vorbereitet.',
      );
      return DemandRecognitionOutput(
        intentDetected: true,
        confidenceScore: confidence < 0.9 ? 0.9 : confidence,
        triggerReason: triggerParts.join(' + '),
        actionType: 'ACTION_REQUIRED',
        displayMessage: message,
        trustLayerAction: TrustLayerAction(
          type: 'ONE_TAP_CONFIRM',
          primaryCta: 'Route buchen',
          payload: selectedOption.payload,
        ),
        technicalMetadata: TechnicalMetadata(
          phases: const [1],
          decisionBasis: decisionBasis,
          affectedProviders: affectedProviders,
          usedCandidateOptionId: selectedOption.routeId,
          dataGaps: dataGaps,
        ),
      );
    }

    final infoMessage = _truncateMessage(
      realtimeIssue || weatherIssue || budgetIssue
          ? 'Deine Verbindung braucht Aufmerksamkeit. Ich habe die Lage geprueft.'
          : 'Du musst in ${_minutesUntilLabel(eventMatch?.start, routineMatch?.start, now)} los. '
                'Deine Standardverbindung ist aktuell planbar.',
    );

    return DemandRecognitionOutput(
      intentDetected: true,
      confidenceScore: confidence,
      triggerReason: triggerParts.isEmpty
          ? 'intent_detected=true + no_relevant_issue'
          : triggerParts.join(' + '),
      actionType: 'INFO',
      displayMessage: infoMessage,
      trustLayerAction: TrustLayerAction(
        type: selectedOption == null ? 'DISMISS' : 'OPEN_DETAILS',
        primaryCta: selectedOption == null ? 'Verstanden' : 'Details ansehen',
        payload: selectedOption?.payload,
      ),
      technicalMetadata: TechnicalMetadata(
        phases: const [1],
        decisionBasis: decisionBasis,
        affectedProviders: affectedProviders,
        usedCandidateOptionId: selectedOption?.routeId,
        dataGaps: dataGaps,
      ),
    );
  }

  DemandRecognitionOutput _noneOutput({required List<String> dataGaps}) {
    return DemandRecognitionOutput(
      intentDetected: false,
      confidenceScore: 0.0,
      triggerReason: 'no_mobility_trigger_in_next_60m',
      actionType: 'NONE',
      displayMessage: '',
      trustLayerAction: const TrustLayerAction(
        type: 'NONE',
        primaryCta: null,
        payload: null,
      ),
      technicalMetadata: TechnicalMetadata(
        phases: const [1],
        decisionBasis: const DecisionBasis(
          calendarMatch: false,
          routineMatch: false,
          realtimeIssue: false,
          weatherIssue: false,
          budgetIssue: false,
          optimizationFound: false,
        ),
        affectedProviders: const [],
        usedCandidateOptionId: null,
        dataGaps: dataGaps,
      ),
    );
  }

  DateTime? _parseNow(String? input) {
    if (input == null || input.isEmpty) return null;
    return DateTime.tryParse(input);
  }

  _EventMatch? _findRelevantEvent(
    Map<String, dynamic> calendarData,
    DateTime? now,
    List<String> dataGaps,
  ) {
    if (now == null) return null;
    final events = (calendarData['events'] as List? ?? const []);
    for (final item in events) {
      final event = Map<String, dynamic>.from(item as Map);
      final start = DateTime.tryParse(
        event['start_time_local']?.toString() ?? '',
      );
      final location =
          event['location']?.toString() ??
          event['destination']?.toString() ??
          '';
      if (start == null) continue;
      if (location.isEmpty) {
        dataGaps.add('missing_event_destination');
        continue;
      }
      final minutes = start.difference(now).inMinutes;
      if (minutes >= 0 && minutes <= 60) {
        return _EventMatch(
          title: event['title']?.toString() ?? 'event',
          start: start,
        );
      }
    }
    return null;
  }

  _RoutineMatch? _findRelevantRoutine(
    Map<String, dynamic> userProfile,
    DateTime? now,
  ) {
    if (now == null) return null;
    final routines = (userProfile['routines'] as List? ?? const []);
    for (final item in routines) {
      final routine = Map<String, dynamic>.from(item as Map);
      final startValue =
          routine['start_time_local']?.toString() ??
          routine['start_time']?.toString();
      if (startValue == null || startValue.isEmpty) {
        continue;
      }

      final start = _routineTimeToDate(startValue, now);
      if (start == null) continue;
      final minutes = start.difference(now).inMinutes;
      if (minutes >= 0 && minutes <= 60) {
        return _RoutineMatch(
          name: routine['name']?.toString() ?? 'routine',
          start: start,
        );
      }
    }
    return null;
  }

  String? _inferStandardTrip(
    Map<String, dynamic> userProfile,
    DateTime? now,
    Map<String, dynamic> currentLocation,
  ) {
    if (now == null) return null;
    final currentLat = (currentLocation['lat'] as num?)?.toDouble();
    final currentLon = (currentLocation['lon'] as num?)?.toDouble();
    final home = Map<String, dynamic>.from(
      userProfile['home_location'] as Map? ?? const {},
    );
    final work = Map<String, dynamic>.from(
      userProfile['work_location'] as Map? ?? const {},
    );
    final nearHome = _isNear(currentLat, currentLon, home);
    final nearWork = _isNear(currentLat, currentLon, work);
    final hour = now.hour;

    if (nearHome && hour >= 6 && hour <= 10) {
      return 'home_to_work';
    }
    if (nearWork && hour >= 15 && hour <= 20) {
      return 'work_to_home';
    }
    return null;
  }

  bool _isNear(double? lat, double? lon, Map<String, dynamic> point) {
    final pointLat = (point['lat'] as num?)?.toDouble();
    final pointLon = (point['lon'] as num?)?.toDouble();
    if (lat == null || lon == null || pointLat == null || pointLon == null) {
      return false;
    }
    return (lat - pointLat).abs() <= 0.02 && (lon - pointLon).abs() <= 0.02;
  }

  DateTime? _routineTimeToDate(String value, DateTime now) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed;
    final parts = value.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  bool _hasRealtimeIssue(Map<String, dynamic> realtimeStatus) {
    final disruptions = (realtimeStatus['disruptions'] as List? ?? const []);
    final capacity = (realtimeStatus['capacity_alerts'] as List? ?? const []);
    final networkState = (realtimeStatus['network_state'] as List? ?? const []);

    bool hasNegativeSignal(List items) {
      for (final item in items) {
        final text = item.toString().toLowerCase();
        if (text.contains('cancel') ||
            text.contains('ausfall') ||
            text.contains('delay') ||
            text.contains('verspaet') ||
            text.contains('störung') ||
            text.contains('stoerung') ||
            text.contains('full') ||
            text.contains('overcrowd')) {
          return true;
        }
      }
      return false;
    }

    return hasNegativeSignal(disruptions) ||
        hasNegativeSignal(capacity) ||
        hasNegativeSignal(networkState);
  }

  bool _hasWeatherIssue(Map<String, dynamic> environmentalData) {
    final origin = Map<String, dynamic>.from(
      environmentalData['weather_origin'] as Map? ?? const {},
    );
    final destination = Map<String, dynamic>.from(
      environmentalData['weather_destination'] as Map? ?? const {},
    );
    return _weatherImpactsWalking(origin) ||
        _weatherImpactsWalking(destination);
  }

  bool _weatherImpactsWalking(Map<String, dynamic> weather) {
    final precipitation =
        (weather['precipitation_probability'] as num?)?.toDouble() ?? 0;
    final wind = (weather['wind_speed_kmh'] as num?)?.toDouble() ?? 0;
    final condition = weather['condition']?.toString().toLowerCase() ?? '';
    return precipitation >= 70 ||
        wind >= 40 ||
        condition.contains('storm') ||
        condition.contains('snow');
  }

  bool _hasBudgetIssue(
    Map<String, dynamic> userProfile,
    List<Map<String, dynamic>> options,
  ) {
    final budget = Map<String, dynamic>.from(
      userProfile['mobility_budget'] as Map? ?? const {},
    );
    if (budget['enabled'] != true) return false;
    final remaining = (budget['remaining_amount_eur'] as num?)?.toDouble();
    if (remaining == null) return false;
    return options.any((option) {
      final cost = _parseCurrency(option['estimated_cost']?.toString());
      return cost != null && cost > remaining;
    });
  }

  _CandidateOption? _selectBestOption(List<Map<String, dynamic>> options) {
    if (options.isEmpty) return null;
    final parsed = options
        .map(_CandidateOption.fromMap)
        .where((item) => item.routeId != null)
        .toList();
    if (parsed.isEmpty) return null;
    parsed.sort((a, b) => b.rank.compareTo(a.rank));
    return parsed.first;
  }

  bool _hasMeaningfulBenefit(
    _CandidateOption? option,
    bool realtimeIssue,
    bool budgetIssue,
  ) {
    if (option == null) return false;
    if (realtimeIssue || budgetIssue) return true;
    if (option.minutesSaved != null && option.minutesSaved! >= 10) return true;
    if (option.guaranteeLevel == 'HIGH') return true;
    return false;
  }

  double _computeConfidence({
    required bool calendarDetected,
    required bool routineDetected,
    required bool tripDetected,
    required bool realtimeIssue,
    required bool weatherIssue,
    required bool budgetIssue,
    required bool hasSelectedOption,
  }) {
    double score = 0.0;
    if (calendarDetected) score += 0.5;
    if (routineDetected) score += 0.35;
    if (tripDetected) score += 0.3;
    if (realtimeIssue) score += 0.2;
    if (weatherIssue) score += 0.1;
    if (budgetIssue) score += 0.1;
    if (hasSelectedOption) score += 0.1;
    return score.clamp(0.0, 1.0);
  }

  List<String> _collectProviders(
    Map<String, dynamic> realtimeStatus,
    _CandidateOption? option,
  ) {
    final providers = <String>{};
    final disruptions = (realtimeStatus['disruptions'] as List? ?? const []);
    for (final item in disruptions) {
      final map = item is Map
          ? Map<String, dynamic>.from(item)
          : const <String, dynamic>{};
      final provider = map['provider']?.toString();
      if (provider != null && provider.isNotEmpty) {
        providers.add(provider);
      }
    }
    if (option != null) {
      providers.addAll(option.providerBundle);
    }
    return providers.toList();
  }

  String _minutesUntilLabel(
    DateTime? eventStart,
    DateTime? routineStart,
    DateTime? now,
  ) {
    final start = eventStart ?? routineStart;
    if (start == null || now == null) return 'weniger als 60 Minuten';
    return '${start.difference(now).inMinutes} Minuten';
  }

  String _issueLeadText(
    bool realtimeIssue,
    bool weatherIssue,
    bool budgetIssue,
  ) {
    if (realtimeIssue) return 'Deine Standardverbindung ist gestoert.';
    if (weatherIssue) return 'Das Wetter verschlechtert deinen ueblichen Weg.';
    if (budgetIssue) {
      return 'Dein aktuelles Budget spricht gegen die Standardoption.';
    }
    return 'Es gibt eine bessere Verbindung.';
  }

  String _truncateMessage(String message) {
    if (message.length <= 180) return message;
    return message.substring(0, 180);
  }

  double? _parseCurrency(String? input) {
    if (input == null || input.isEmpty) return null;
    final normalized = input
        .replaceAll(RegExp(r'[^0-9,\.]'), '')
        .replaceAll(',', '.');
    return double.tryParse(normalized);
  }
}

class _EventMatch {
  const _EventMatch({required this.title, required this.start});

  final String title;
  final DateTime start;
}

class _RoutineMatch {
  const _RoutineMatch({required this.name, required this.start});

  final String name;
  final DateTime start;
}

class _CandidateOption {
  const _CandidateOption({
    required this.routeId,
    required this.payload,
    required this.guaranteeLevel,
    required this.providerBundle,
    required this.minutesSaved,
    required this.rank,
  });

  factory _CandidateOption.fromMap(Map<String, dynamic> map) {
    final routeId = map['route_id']?.toString() ?? map['id']?.toString();
    final guaranteeLevel = (map['guarantee_level']?.toString() ?? 'LOW')
        .toUpperCase();
    final providerBundle = (map['provider_bundle'] as List? ?? const [])
        .map((item) => item.toString())
        .toList();
    final minutesSaved =
        (map['minutes_saved'] as num?)?.toInt() ??
        (map['time_saving_min'] as num?)?.toInt();
    final budgetCompliant = map['budget_compliant'] as bool?;
    final transfers = (map['transfers'] as num?)?.toInt() ?? 99;
    final rank = _score(
      guaranteeLevel: guaranteeLevel,
      budgetCompliant: budgetCompliant,
      minutesSaved: minutesSaved,
      transfers: transfers,
    );

    final payload = <String, dynamic>{};
    if (routeId != null) payload['route_id'] = routeId;
    if (map.containsKey('estimated_cost')) {
      payload['estimated_cost'] = map['estimated_cost'];
    }
    if (map.containsKey('arrival_time')) {
      payload['arrival_time'] = map['arrival_time'];
    }
    if (map.containsKey('departure_time')) {
      payload['departure_time'] = map['departure_time'];
    }
    if (map.containsKey('provider_bundle')) {
      payload['provider_bundle'] = map['provider_bundle'];
    }
    if (map.containsKey('budget_compliant')) {
      payload['budget_compliant'] = map['budget_compliant'];
    }
    if (map.containsKey('guarantee_level')) {
      payload['guarantee_level'] = map['guarantee_level'];
    }

    return _CandidateOption(
      routeId: routeId,
      payload: payload.isEmpty ? null : payload,
      guaranteeLevel: guaranteeLevel,
      providerBundle: providerBundle,
      minutesSaved: minutesSaved,
      rank: rank,
    );
  }

  final String? routeId;
  final Map<String, dynamic>? payload;
  final String guaranteeLevel;
  final List<String> providerBundle;
  final int? minutesSaved;
  final int rank;

  bool get hasActionablePayload =>
      payload != null &&
      payload!['route_id'] != null &&
      payload!['arrival_time'] != null &&
      payload!['departure_time'] != null;

  static int _score({
    required String guaranteeLevel,
    required bool? budgetCompliant,
    required int? minutesSaved,
    required int transfers,
  }) {
    var score = 0;
    switch (guaranteeLevel) {
      case 'HIGH':
        score += 500;
        break;
      case 'MEDIUM':
        score += 250;
        break;
      default:
        score += 100;
        break;
    }
    if (budgetCompliant == true) score += 200;
    score += (minutesSaved ?? 0) * 10;
    score -= transfers * 5;
    return score;
  }
}
