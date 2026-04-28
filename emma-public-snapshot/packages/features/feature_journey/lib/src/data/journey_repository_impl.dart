import 'package:domain_journey/contracts.dart';
import 'package:domain_journey/domain_journey.dart';
import 'package:emma_contracts/emma_contracts.dart';
import 'package:emma_core/emma_core.dart';

/// Konkrete [JourneyRepository]-Impl fuer `feature_journey`.
///
/// Injiziert drei Ports (Tariff, Budget, Routing) sowie optionale
/// Services. Keine App-Dependencies — alle Typen stammen aus
/// `domain_journey` oder `emma_contracts`.
class JourneyRepositoryImpl implements JourneyRepository {
  /// [budgetPort] ist Pflicht-Dependency — die Journey-Engine besitzt
  /// keine employer-mobility-Verdrahtung. Die Composition Root injiziert
  /// sie aus `feature_employer_mobility` (oder einem Test-Fake).
  JourneyRepositoryImpl({
    required BudgetPort budgetPort,
    required TariffPort tariffPort,
    RoutingPort? routingPort,
    FareDecisionService? fareDecisionService,
    BookingIntentService? bookingIntentService,
    PaymentIntentService? paymentIntentService,
    JourneyOperationsService? journeyOperationsService,
    TravelOptionSelectionService? travelOptionSelectionService,
    ReaccommodationService? reaccommodationService,
  }) : _budgetPort = budgetPort,
       _tariffPort = tariffPort,
       _routingPort = routingPort,
       _fareDecisionService =
           fareDecisionService ?? const FareDecisionService(),
       _bookingIntentService =
           bookingIntentService ?? const BookingIntentService(),
       _paymentIntentService =
           paymentIntentService ?? const PaymentIntentService(),
       _journeyOperationsService =
           journeyOperationsService ?? const JourneyOperationsService(),
       _travelOptionSelectionService =
           travelOptionSelectionService ?? const TravelOptionSelectionService(),
       _reaccommodationService =
           reaccommodationService ?? const ReaccommodationService();

  final JourneyContractMapper _mapper = const JourneyContractMapper();
  final TariffPort _tariffPort;
  final BudgetPort _budgetPort;
  final RoutingPort? _routingPort;
  final FareDecisionService _fareDecisionService;
  final BookingIntentService _bookingIntentService;
  final PaymentIntentService _paymentIntentService;
  final JourneyOperationsService _journeyOperationsService;
  final TravelOptionSelectionService _travelOptionSelectionService;
  final ReaccommodationService _reaccommodationService;

  JourneyCase? _cachedCase;

  @override
  Future<JourneyCase> getJourneyCase(String userId) async {
    final journeyCase = _cachedCase ?? await _buildInitialJourneyCase(userId);
    _cachedCase = journeyCase;
    return journeyCase;
  }

  @override
  Future<JourneyState> getJourneyState(String userId) async {
    final journeyCase = await getJourneyCase(userId);
    return _toJourneyState(journeyCase);
  }

  @override
  Future<JourneyCase> selectTravelOption(
    JourneyCase journeyCase,
    TravelOption option,
  ) async {
    final materialized = await _withDecisionArtifacts(
      journeyCase.copyWith(
        status: JourneyLifecycleStatus.readyForConfirmation,
        currentStep: JourneyPhase.transaction,
        selectedOption: option,
        selectedOptionId: option.optionId,
        phases: _activatePhase(journeyCase.phases, JourneyPhase.transaction),
        events: [
          ...journeyCase.events,
          JourneyEvent(
            title: 'Nutzer',
            message:
                'Route ${option.optionId} wurde fuer die Mock-Buchung ausgewaehlt.',
            timestampLabel: '07:20',
            isUser: true,
          ),
        ],
      ),
      option,
    );
    _cachedCase = materialized;
    return materialized;
  }

  @override
  Future<JourneyCase> confirmMockBooking(JourneyCase journeyCase) async {
    final updated = journeyCase.copyWith(
      status: JourneyLifecycleStatus.booked,
      currentStep: JourneyPhase.activeMonitoring,
      phases: journeyCase.phases.map((phase) {
        if (phase.phase == JourneyPhase.transaction) {
          return phase.copyWith(
            status: JourneyPhaseStatus.completed,
            headline: 'Mock-Buchung revisionssicher bestaetigt',
            blueprint: {
              ...phase.blueprint,
              'mock_booking_status': 'CONFIRMED',
              'productive_ticketing': false,
            },
          );
        }
        if (phase.phase == JourneyPhase.activeMonitoring) {
          return phase.copyWith(
            status: JourneyPhaseStatus.active,
            headline: 'Reiseakte ist aktiv und begleitet die Mock-Reise',
            description:
                'Buchungs-, Tarif- und Budgetentscheidungen sind in der Reiseakte gespeichert; emma ueberwacht jetzt den Verlauf.',
          );
        }
        return phase;
      }).toList(),
      events: [
        ...journeyCase.events,
        const JourneyEvent(
          title: 'emma',
          message:
              'Die Buchung wurde mock-basiert bestaetigt. Es wurde kein produktives Ticketing oder Payment ausgeloest.',
          timestampLabel: '07:25',
          isUser: false,
        ),
      ],
      context: {
        ...journeyCase.context,
        'mock_booking': {
          'status': 'CONFIRMED',
          'receipt_id': 'mock-receipt-${journeyCase.journeyId}',
          'productive_integrations': false,
        },
      },
    );
    _cachedCase = updated;
    return updated;
  }

  @override
  Future<JourneyCase> advanceJourneyCase(JourneyCase journeyCase) async {
    final currentIndex = JourneyPhase.values.indexOf(journeyCase.currentStep);
    if (currentIndex >= JourneyPhase.values.length - 1) {
      return journeyCase;
    }

    final nextStep = JourneyPhase.values[currentIndex + 1];
    final updatedPhases = journeyCase.phases.map((phase) {
      if (phase.phase == journeyCase.currentStep) {
        return phase.copyWith(status: JourneyPhaseStatus.completed);
      }
      if (phase.phase == nextStep) {
        return phase.copyWith(status: JourneyPhaseStatus.active);
      }
      return phase;
    }).toList();

    final nextStatus = switch (nextStep) {
      JourneyPhase.transaction => JourneyLifecycleStatus.readyForConfirmation,
      JourneyPhase.activeMonitoring =>
        JourneyLifecycleStatus.awaitingPartnerHandoff,
      JourneyPhase.crisisManagement => JourneyLifecycleStatus.disrupted,
      JourneyPhase.optimization => JourneyLifecycleStatus.completed,
      _ => journeyCase.status,
    };

    final nextEvents = [
      ...journeyCase.events,
      JourneyEvent(
        title: 'System',
        message:
            'Journey wurde in ${nextStep.title} ueberfuehrt. Status: ${nextStatus.name}.',
        timestampLabel: '07:${10 + currentIndex}',
        isUser: false,
      ),
    ];

    final updatedReportingEvents = [
      ...journeyCase.reportingEvents,
      ..._buildStepReportingEvent(journeyCase.journeyId, nextStep, nextStatus),
    ];

    var advancedCase = journeyCase.copyWith(
      currentStep: nextStep,
      status: nextStatus,
      phases: updatedPhases,
      events: nextEvents,
      reportingEvents: updatedReportingEvents,
    );
    if (nextStep == JourneyPhase.activeMonitoring ||
        nextStep == JourneyPhase.crisisManagement) {
      advancedCase = await evaluatePhase4Control(advancedCase);
    }
    _cachedCase = advancedCase;
    return advancedCase;
  }

  @override
  Future<JourneyCase> simulateDisruption(JourneyCase journeyCase) async {
    final disrupted = journeyCase.copyWith(
      status: JourneyLifecycleStatus.disrupted,
      currentStep: JourneyPhase.activeMonitoring,
      context: {
        ...journeyCase.context,
        'phase4_monitoring': {
          ...Map<String, dynamic>.from(
            journeyCase.context['phase4_monitoring'] as Map? ?? const {},
          ),
          'journey_at_risk': true,
          'guarantee_at_risk': true,
          'active_incident': true,
          'incident_ids': const ['mock-disruption-001'],
          'affected_leg_ids': const ['leg-rail-001'],
          'highest_severity': 'high',
          'reaccommodation_options': _buildFallbackReaccommodationOptions(
            journeyCase.selectedOption ?? await _fallbackSelectedOption(),
            journeyCase.intent.targetArrivalTime,
          ).map((option) => option.toJson()).toList(),
        },
      },
      events: [
        ...journeyCase.events,
        const JourneyEvent(
          title: 'System',
          message:
              'Mock-Stoerfall erkannt: Anschlussrisiko auf der Bahnstrecke. Fallback wird bewertet.',
          timestampLabel: '07:35',
          isUser: false,
        ),
      ],
    );
    return evaluatePhase4Control(disrupted);
  }

  @override
  Future<JourneyCase> acceptFallback(JourneyCase journeyCase) async {
    final selectedFallback =
        journeyCase
            .phase4Fulfillment
            ?.technicalMetadata
            .selectedReaccommodationOptionId ??
        'fallback-unavailable';
    final updated = journeyCase.copyWith(
      status: JourneyLifecycleStatus.active,
      currentStep: JourneyPhase.optimization,
      phases: journeyCase.phases.map((phase) {
        if (phase.phase == JourneyPhase.crisisManagement) {
          return phase.copyWith(
            status: JourneyPhaseStatus.completed,
            headline: 'Fallback-Angebot mock-basiert angenommen',
            blueprint: {
              ...phase.blueprint,
              'fallback_acceptance_status': 'ACCEPTED',
              'selected_reaccommodation_option_id': selectedFallback,
            },
          );
        }
        if (phase.phase == JourneyPhase.optimization) {
          return phase.copyWith(
            status: JourneyPhaseStatus.active,
            headline: 'Abschluss der Mock-Reise ist vorbereitet',
            description:
                'Fallback, Reiseakte und Reporting sind zusammengefuehrt; der MVP-Flow kann abgeschlossen werden.',
          );
        }
        return phase;
      }).toList(),
      events: [
        ...journeyCase.events,
        JourneyEvent(
          title: 'Nutzer',
          message: 'Fallback $selectedFallback wurde angenommen.',
          timestampLabel: '07:45',
          isUser: true,
        ),
      ],
      context: {
        ...journeyCase.context,
        'fallback_acceptance': {
          'status': 'ACCEPTED',
          'selected_reaccommodation_option_id': selectedFallback,
          'productive_integrations': false,
        },
      },
    );
    _cachedCase = updated;
    return updated;
  }

  @override
  Future<JourneyCase> completeJourney(JourneyCase journeyCase) async {
    final updated = journeyCase.copyWith(
      status: JourneyLifecycleStatus.completed,
      currentStep: JourneyPhase.optimization,
      phases: journeyCase.phases.map((phase) {
        if (phase.phase == JourneyPhase.optimization) {
          return phase.copyWith(
            status: JourneyPhaseStatus.completed,
            headline: 'Mock-End-to-End-Journey abgeschlossen',
            description:
                'Planung, Routenauswahl, Buchung, Reiseakte, Stoerfall, Fallback und Abschluss sind deterministisch durchlaufen.',
            blueprint: {
              ...phase.blueprint,
              'journey_mvp_status': 'COMPLETED',
              'productive_integrations': false,
            },
          );
        }
        return phase;
      }).toList(),
      events: [
        ...journeyCase.events,
        const JourneyEvent(
          title: 'emma',
          message:
              'Die Mock-Reise wurde abgeschlossen. Reporting und Lernsignal sind als MVP-Artefakte vermerkt.',
          timestampLabel: '08:10',
          isUser: false,
        ),
      ],
      context: {
        ...journeyCase.context,
        'journey_mvp': {
          'status': 'COMPLETED',
          'scope': 'mock_end_to_end',
          'productive_integrations': false,
        },
      },
    );
    _cachedCase = updated;
    return updated;
  }

  @override
  Future<JourneyCase> evaluatePhase4Control(JourneyCase journeyCase) async {
    final options = await getReaccommodationOptions(journeyCase);
    final result = _reaccommodationService.evaluateReaccommodation(
      journeyCase: journeyCase,
      options: options,
    );
    final updatedCase = _applyPhase4Result(journeyCase, result);
    _cachedCase = updatedCase;
    return updatedCase;
  }

  @override
  Future<List<ReaccommodationOption>> getReaccommodationOptions(
    JourneyCase journeyCase,
  ) async {
    final monitoring = Map<String, dynamic>.from(
      journeyCase.context['phase4_monitoring'] as Map? ?? const {},
    );
    final rawOptions =
        (monitoring['reaccommodation_options'] as List? ?? const [])
            .map(
              (item) => ReaccommodationOption.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList();
    if (rawOptions.isNotEmpty) {
      return rawOptions;
    }

    final riskDetected =
        monitoring['journey_at_risk'] == true ||
        monitoring['guarantee_at_risk'] == true ||
        monitoring['active_incident'] == true;
    if (!riskDetected || journeyCase.selectedOption == null) {
      return const [];
    }

    return _buildFallbackReaccommodationOptions(
      journeyCase.selectedOption!,
      journeyCase.intent.targetArrivalTime,
    );
  }

  @override
  Future<void> updateJourneyCase(JourneyCase journeyCase) async {
    _cachedCase = journeyCase;
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }

  @override
  Future<void> updateJourneyState(JourneyState state) async {
    final currentCase =
        _cachedCase ?? await _buildInitialJourneyCase(state.userId);
    _cachedCase = currentCase.copyWith(
      currentStep: state.currentPhase,
      phases: state.phases,
      events: state.events,
      context: state.context,
      phase4Fulfillment: state.context['phase4_fulfillment'] == null
          ? currentCase.phase4Fulfillment
          : JourneyFulfillmentControl.fromJson(
              Map<String, dynamic>.from(
                state.context['phase4_fulfillment'] as Map,
              ),
            ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }

  @override
  Future<JourneyPhase> getNextStep(JourneyState state) async {
    final currentIndex = JourneyPhase.values.indexOf(state.currentPhase);
    if (currentIndex >= JourneyPhase.values.length - 1) {
      return state.currentPhase;
    }
    return JourneyPhase.values[currentIndex + 1];
  }

  Future<JourneyCase> _withDecisionArtifacts(
    JourneyCase journeyCase,
    TravelOption selectedOption,
  ) async {
    final tariffs = await _tariffPort.getAvailableTariffs();
    final budget = await _budgetPort.getBudget();
    final tariffQuote = await _tariffPort.quote(
      originStationId: 'leipzig_hbf',
      destinationStationId: 'halle_hbf',
      departureAt: journeyCase.intent.targetArrivalTime,
      passengerClass: 'adult',
    );
    final tariffPrice = tariffQuote == null
        ? null
        : TariffPriceSnapshot(
            priceEuroCents: tariffQuote.priceEuroCents,
            productCode: tariffQuote.productCode,
            ruleTrace: tariffQuote.ruleTrace,
            isFallback: tariffQuote.isFallback,
            ruleSetVersion: tariffQuote.ruleSetVersion,
            fixtureBundleId: tariffQuote.fixtureBundleId,
          );
    final fareDecision = _fareDecisionService.buildDecision(
      journeyId: journeyCase.journeyId,
      selectedOption: selectedOption,
      userIntent: journeyCase.intent,
      availableTariffs: tariffs,
      mobilityBudget: budget,
      tariffPrice: tariffPrice,
    );
    final bookingIntent = _bookingIntentService.buildIntent(
      journeyId: journeyCase.journeyId,
      selectedOption: selectedOption,
      fareDecision: fareDecision,
    );
    final paymentIntent = _paymentIntentService.buildIntent(
      journeyId: journeyCase.journeyId,
      bookingIntent: bookingIntent,
      fareDecision: fareDecision,
    );
    final withArtifacts = journeyCase.copyWith(
      selectedOption: selectedOption,
      selectedOptionId: selectedOption.optionId,
      fareDecision: fareDecision,
      bookingIntent: bookingIntent,
      paymentIntent: paymentIntent,
    );
    final operations = _journeyOperationsService.buildOperations(
      journeyCase: withArtifacts,
      selectedOption: selectedOption,
      fareDecision: fareDecision,
      bookingIntent: bookingIntent,
      paymentIntent: paymentIntent,
    );
    return withArtifacts.copyWith(
      supportCases: operations.supportCases,
      reportingEvents: [
        ...journeyCase.reportingEvents,
        ...operations.reportingEvents,
      ],
      supportCaseIds: operations.supportCases
          .map((item) => item.caseId)
          .toList(),
    );
  }

  List<JourneyPhaseState> _activatePhase(
    List<JourneyPhaseState> phases,
    JourneyPhase activePhase,
  ) {
    return phases.map((phase) {
      if (phase.phase.index < activePhase.index) {
        return phase.copyWith(status: JourneyPhaseStatus.completed);
      }
      if (phase.phase == activePhase) {
        return phase.copyWith(status: JourneyPhaseStatus.active);
      }
      return phase.copyWith(status: JourneyPhaseStatus.upcoming);
    }).toList();
  }

  Future<TravelOption> _fallbackSelectedOption() async {
    final cached = _cachedCase?.selectedOption;
    if (cached != null) return cached;
    return TravelOption(
      optionId: 'rec_001',
      legs: const [
        TravelLeg(
          mode: 'rail',
          provider: 'MDV',
          originLabel: 'Leipzig Hauptbahnhof',
          destinationLabel: 'Halle Hauptbahnhof',
        ),
      ],
      providerCandidates: const ['MDV_VDV_KA'],
      estimatedArrival: DateTime.parse('2026-04-09T08:00:00Z'),
      estimatedDurationMinutes: 42,
      estimatedCostEuro: 3.5,
      reliabilityScore: 0.9,
      guaranteeScore: 0.9,
      budgetCompatible: true,
      requiresPartnerBooking: false,
    );
  }

  JourneyState _toJourneyState(JourneyCase journeyCase) {
    final state = JourneyState(
      id: journeyCase.journeyId,
      userId: journeyCase.userId,
      currentPhase: journeyCase.currentStep,
      phases: journeyCase.phases,
      events: journeyCase.events,
      context: {
        ...journeyCase.context,
        'journey_status': journeyCase.status.name,
        'selected_option_id': journeyCase.selectedOptionId,
        if (journeyCase.selectedOption != null)
          'selected_option': journeyCase.selectedOption!.toJson(),
        'user_intent': {
          'intent_id': journeyCase.intent.intentId,
          'source': journeyCase.intent.source,
          'raw_text': journeyCase.intent.rawText,
          'origin': journeyCase.intent.origin,
          'destination': journeyCase.intent.destination,
          'trip_purpose': journeyCase.intent.tripPurpose,
          'needs_clarification': journeyCase.intent.needsClarification,
        },
        if (journeyCase.fareDecision != null)
          'fare_decision': journeyCase.fareDecision!.toJson(),
        if (journeyCase.bookingIntent != null)
          'booking_intent': journeyCase.bookingIntent!.toJson(),
        if (journeyCase.paymentIntent != null)
          'payment_intent': journeyCase.paymentIntent!.toJson(),
        'support_cases': journeyCase.supportCases
            .map((item) => item.toJson())
            .toList(),
        'reporting_events': journeyCase.reportingEvents
            .map((item) => item.toJson())
            .toList(),
        if (journeyCase.phase4Fulfillment != null)
          'phase4_fulfillment': journeyCase.phase4Fulfillment!.toJson(),
        if (journeyCase.phase4Fulfillment != null)
          'reaccommodation_options': journeyCase
              .phase4Fulfillment!
              .reaccommodationOptions
              .map((item) => item.toJson())
              .toList(),
        if (journeyCase.phase4Fulfillment != null)
          'selected_reaccommodation_option_id': journeyCase
              .phase4Fulfillment!
              .technicalMetadata
              .selectedReaccommodationOptionId,
      },
    );
    return state.copyWith(contractBundle: _mapper.buildBundle(state));
  }

  Future<JourneyCase> _buildInitialJourneyCase(String userId) async {
    final intent = UserIntent(
      intentId: 'intent-2026-04-09-commute',
      userId: userId,
      source: 'chat',
      rawText:
          'Ich muss rechtzeitig dienstlich nach Leipzig kommen und brauche eine verlaessliche Alternative zur ausgefallenen S-Bahn.',
      origin: 'Leipzig Hauptbahnhof',
      destination: 'Berlin Hauptbahnhof',
      targetArrivalTime: DateTime.parse('2026-04-09T08:00:00Z'),
      tripPurpose: 'PENDELREISE_DIENSTLICH',
      preferencesSnapshot: const {
        'priority_order': ['zuverlaessig', 'schnell', 'budgetschonend'],
        'employer_context': 'BMM',
      },
      needsClarification: false,
    );

    final fallbackOption = TravelOption(
      optionId: 'rec_001',
      legs: const [
        TravelLeg(
          mode: 'carshare',
          provider: 'teilAuto',
          originLabel: 'Markkleeberg',
          destinationLabel: 'Leipzig Bayerischer Bahnhof',
        ),
        TravelLeg(
          mode: 'rail',
          provider: 'MDV',
          originLabel: 'Leipzig Bayerischer Bahnhof',
          destinationLabel: 'Hauptstrasse 10, Leipzig',
        ),
      ],
      providerCandidates: const ['teilAuto', 'MDV_VDV_KA'],
      estimatedArrival: DateTime.parse('2026-04-09T08:45:00Z'),
      estimatedDurationMinutes: 43,
      estimatedCostEuro: 2.10,
      reliabilityScore: 0.94,
      guaranteeScore: 0.98,
      budgetCompatible: true,
      requiresPartnerBooking: true,
    );
    final routeOptions =
        await _routingPort?.searchOptions(intent: intent) ?? const [];
    final selectedOption =
        _travelOptionSelectionService.selectBest(routeOptions) ??
        fallbackOption;

    final tariffs = await _tariffPort.getAvailableTariffs();
    final budget = await _budgetPort.getBudget();

    final tariffQuote = await _tariffPort.quote(
      originStationId: 'leipzig_hbf',
      destinationStationId: 'halle_hbf',
      departureAt: intent.targetArrivalTime,
      passengerClass: 'adult',
    );
    final tariffPrice = tariffQuote == null
        ? null
        : TariffPriceSnapshot(
            priceEuroCents: tariffQuote.priceEuroCents,
            productCode: tariffQuote.productCode,
            ruleTrace: tariffQuote.ruleTrace,
            isFallback: tariffQuote.isFallback,
            ruleSetVersion: tariffQuote.ruleSetVersion,
            fixtureBundleId: tariffQuote.fixtureBundleId,
          );
    if (tariffQuote != null) {
      EmmaLogger.info('tariff.ruleTrace=${tariffQuote.ruleTrace.join(" > ")}');
    }

    final fareDecision = _fareDecisionService.buildDecision(
      journeyId: 'journey-2026-04-09-work',
      selectedOption: selectedOption,
      userIntent: intent,
      availableTariffs: tariffs,
      mobilityBudget: budget,
      tariffPrice: tariffPrice,
    );
    final bookingIntent = _bookingIntentService.buildIntent(
      journeyId: 'journey-2026-04-09-work',
      selectedOption: selectedOption,
      fareDecision: fareDecision,
    );
    final paymentIntent = _paymentIntentService.buildIntent(
      journeyId: 'journey-2026-04-09-work',
      bookingIntent: bookingIntent,
      fareDecision: fareDecision,
    );

    final baseCase = JourneyCase(
      journeyId: 'journey-2026-04-09-work',
      userId: userId,
      status: JourneyLifecycleStatus.readyForConfirmation,
      currentStep: JourneyPhase.transaction,
      intent: intent,
      selectedOption: selectedOption,
      selectedOptionId: selectedOption.optionId,
      fareDecision: fareDecision,
      bookingIntent: bookingIntent,
      paymentIntent: paymentIntent,
      phases: const [
        JourneyPhaseState(
          phase: JourneyPhase.demandRecognition,
          status: JourneyPhaseStatus.completed,
          headline: 'S-Bahn-Ausfall erkannt und Alternative vorbereitet',
          description:
              'emma hat Kalender, Stoerung und regionale Alternativen zusammengefuehrt und direkt eine belastbare Option vorbereitet.',
          blueprint: {
            'intent_detected': true,
            'confidence_score': 0.95,
            'trigger_reason': "Calendar event 'Work' + S-Bahn disruption",
            'display_message':
                'Guten Morgen! Deine S-Bahn faellt heute aus. Ich habe eine Route mit teilAuto und der RB75 fuer dich vorbereitet. Passt das?',
          },
          trustLayer: TrustLayerCard(
            type: 'ONE_TAP_CONFIRM',
            primaryCta: 'Route buchen',
            summaryItems: [
              TrustSummaryItem(label: 'Ankunft', value: '08:45'),
              TrustSummaryItem(label: 'Route', value: 'teilAuto + RB75'),
            ],
            payload: {'route_id': 'uuid-12345', 'arrival_time': '08:45'},
          ),
        ),
        JourneyPhaseState(
          phase: JourneyPhase.intentValidation,
          status: JourneyPhaseStatus.completed,
          headline: 'Pendelreise als dienstlicher Anlass validiert',
          description:
              'Der Mobility-Anlass ist fuer BMM sauber klassifiziert und auf Zuverlaessigkeit sowie schnelle Ankunft optimiert.',
          blueprint: {
            'occasion_validated': true,
            'journey_type': 'PENDELREISE_DIENSTLICH',
            'mobility_goal': {
              'destination_name': 'Hauptstrasse 10, Leipzig',
              'arrival_time_target': '2026-04-09T08:00:00Z',
              'priorities': ['zuverlaessig', 'schnell'],
            },
          },
        ),
        JourneyPhaseState(
          phase: JourneyPhase.orchestration,
          status: JourneyPhaseStatus.completed,
          headline: 'Empfehlung mit maximalem Garantie-Score kuratiert',
          description:
              'Die Journey-Orchestrierung priorisiert Sicherheit vor Suche und zeigt nur fachlich tragfaehige Optionen im regionalen Partnernetz.',
          blueprint: {
            'recommendations': [
              {
                'id': 'rec_001',
                'label': 'Empfehlung: Maximale Sicherheit',
                'score_guarantee': 0.98,
                'cost_impact': {
                  'total_price': 0.00,
                  'note': 'Gedeckt durch MDV-Jobticket',
                },
                'legs': ['teilAuto', 'RB75'],
              },
            ],
          },
          trustLayer: TrustLayerCard(
            type: 'OPEN_DETAILS',
            primaryCta: 'Sicher ankommen',
            summaryItems: [
              TrustSummaryItem(label: 'Garantie-Score', value: '0.98'),
              TrustSummaryItem(label: 'Kosten', value: '2,10 EUR'),
            ],
          ),
        ),
        JourneyPhaseState(
          phase: JourneyPhase.fareOptimization,
          status: JourneyPhaseStatus.completed,
          headline: 'Bestandstickets und Arbeitgeberbudget kombiniert',
          description:
              'Tariflogik und Benefit-Engine rechnen Bestandstarife, Budgetlogik und Zuschuesse nachvollziehbar zusammen.',
          blueprint: {
            'fare_configuration': {'status': 'computed_in_service'},
          },
        ),
        JourneyPhaseState(
          phase: JourneyPhase.transaction,
          status: JourneyPhaseStatus.active,
          headline: 'Trust Layer wartet auf rechtssichere Bestaetigung',
          description:
              'Die Buchung ist als verbindlicher Bundle-Kauf vorbereitet und zeigt alle zahlungs- und haftungsrelevanten Punkte transparent an.',
          blueprint: {
            'booking_intent_status': 'computed_in_service',
            'payment_intent_status': 'computed_in_service',
          },
          trustLayer: TrustLayerCard(
            type: 'LEGAL_CONFIRMATION',
            primaryCta: 'Jetzt verbindlich buchen',
            legalText: 'Kauf loest zahlungspflichtige Bestellung aus.',
            summaryItems: [
              TrustSummaryItem(label: 'Budget-Abbuchung', value: '1,60 EUR'),
              TrustSummaryItem(label: 'Partner', value: 'teilAuto + MDV'),
            ],
            payload: {
              'bundle_id': 'bundle-2026-04-09-001',
              'confirmation_required': true,
            },
          ),
        ),
        JourneyPhaseState(
          phase: JourneyPhase.activeMonitoring,
          status: JourneyPhaseStatus.upcoming,
          headline: 'TRIAS-Monitoring steht fuer die aktive Begleitung bereit',
          description:
              'Sobald die Reise laeuft, beobachtet emma Anschlussrisiken und aktiviert nur dann Eskalationen, wenn ein belastbarer Mehrwert entsteht.',
          blueprint: {'monitoring_status': 'READY', 'handoff_required': true},
          riskHint:
              'Reisemonitoring schaltet erst nach erfolgreicher Buchung live.',
        ),
        JourneyPhaseState(
          phase: JourneyPhase.crisisManagement,
          status: JourneyPhaseStatus.upcoming,
          headline: 'Mobilitaetsgarantie ist als Eskalationspfad hinterlegt',
          description:
              'Wenn die Kette kippt, wechselt emma von Monitoring auf Loesung und organisiert Ersatzmobilitaet inklusive Kostenuebernahme.',
          blueprint: {
            'guarantee_case': {
              'eligibility': 'PRECHECKED',
              'support_handoff_ready': true,
            },
          },
        ),
        JourneyPhaseState(
          phase: JourneyPhase.optimization,
          status: JourneyPhaseStatus.upcoming,
          headline: 'Abrechnung und Lernlogik schliessen die Journey ab',
          description:
              'Nach der Reise finalisiert emma Reporting, Kostenabgrenzung und neue Praeferenzsignale fuer die naechste Empfehlung.',
          blueprint: {
            'reporting_status': 'PENDING',
            'learning_delta': {
              'preference_updates': [
                {'key': 'on_demand_acceptance', 'value': 'HIGH'},
              ],
            },
          },
        ),
      ],
      events: const [
        JourneyEvent(
          title: 'emma',
          message:
              'Ich habe eine stoerungsrobuste Pendelreise fuer dich vorbereitet und die Budgetlogik bereits geprueft.',
          timestampLabel: '07:05',
          isUser: false,
        ),
        JourneyEvent(
          title: 'System',
          message:
              'Booking Intent und Payment Intent sind vorbereitet. Externe Partner-Handoffs warten auf Bestaetigung.',
          timestampLabel: '07:06',
          isUser: false,
        ),
      ],
      context: const {
        'master_identity': 'Zentrale Mobilitaetsabwicklungsinstanz',
        'mission': 'Organisieren und begleiten statt suchen und buchen',
        'governance': {
          'ip_owner': 'emma eG',
          'operational_partner': 'Partnerhub Operations GmbH',
          'liability_model': 'emma Ersthaftung mit revisionssicherem Logging',
          'regional_priority': 'Mitteldeutschland-Prinzip',
        },
        'phase4_monitoring': {
          'journey_at_risk': false,
          'guarantee_at_risk': false,
          'active_incident': false,
          'incident_ids': <String>[],
          'affected_leg_ids': <String>[],
          'guarantee_policy': {
            'policy_code': 'MOBILITY_GUARANTEE_STANDARD',
            'automatic_action_allowed': true,
          },
        },
      },
    );

    final operations = _journeyOperationsService.buildOperations(
      journeyCase: baseCase,
      selectedOption: selectedOption,
      fareDecision: fareDecision,
      bookingIntent: bookingIntent,
      paymentIntent: paymentIntent,
    );

    final initialPhase4Result = _reaccommodationService.evaluateReaccommodation(
      journeyCase: baseCase,
      options: const [],
    );
    return baseCase.copyWith(
      supportCases: operations.supportCases,
      reportingEvents: operations.reportingEvents,
      supportCaseIds: operations.supportCases
          .map((item) => item.caseId)
          .toList(),
      phase4Fulfillment: initialPhase4Result,
      context: {
        ...baseCase.context,
        'phase4_fulfillment': initialPhase4Result.toJson(),
        'selected_reaccommodation_option_id': initialPhase4Result
            .technicalMetadata
            .selectedReaccommodationOptionId,
        'reaccommodation_options': initialPhase4Result.reaccommodationOptions
            .map((item) => item.toJson())
            .toList(),
      },
    );
  }

  List<JourneyReportingEvent> _buildStepReportingEvent(
    String journeyId,
    JourneyPhase nextStep,
    JourneyLifecycleStatus nextStatus,
  ) {
    return [
      JourneyReportingEvent(
        eventId: 'evt-$journeyId-${nextStep.name}',
        journeyId: journeyId,
        module: 'journey_engine',
        eventType: 'PHASE_ADVANCED',
        severity: 'info',
        payload: {'next_step': nextStep.name, 'next_status': nextStatus.name},
        occurredAt: DateTime.now(),
      ),
    ];
  }

  JourneyCase _applyPhase4Result(
    JourneyCase journeyCase,
    JourneyFulfillmentControl result,
  ) {
    final moveToCrisis = result.controlStatus != 'MONITORING_ONLY';
    final nextStep = moveToCrisis
        ? JourneyPhase.crisisManagement
        : JourneyPhase.activeMonitoring;
    final nextStatus = switch (result.selectedAction.actionType) {
      'ESCALATE_TO_MANUAL_OPS' => JourneyLifecycleStatus.supportRequired,
      'REACCOMMODATE' ||
      'TRIGGER_GUARANTEE' => JourneyLifecycleStatus.disrupted,
      _ => JourneyLifecycleStatus.active,
    };

    final updatedPhases = journeyCase.phases.map((phase) {
      if (phase.phase == JourneyPhase.activeMonitoring) {
        return phase.copyWith(
          status: moveToCrisis
              ? JourneyPhaseStatus.completed
              : JourneyPhaseStatus.active,
          headline: moveToCrisis
              ? 'Monitoring hat einen echten Stoerfall erkannt'
              : 'Monitoring begleitet die Reise ohne Eingriff weiter',
          description: result.displayMessage,
          blueprint: result.toJson(),
          riskHint: moveToCrisis ? result.controlReason : null,
        );
      }
      if (phase.phase == JourneyPhase.crisisManagement) {
        return phase.copyWith(
          status: moveToCrisis
              ? JourneyPhaseStatus.active
              : JourneyPhaseStatus.upcoming,
          headline: moveToCrisis
              ? 'Reaccommodation oder Garantie wurden aktiviert'
              : phase.headline,
          description: moveToCrisis ? result.displayMessage : phase.description,
          blueprint: moveToCrisis ? result.toJson() : phase.blueprint,
          trustLayer: moveToCrisis
              ? _buildPhase4TrustLayer(result)
              : phase.trustLayer,
          riskHint: moveToCrisis ? result.controlReason : phase.riskHint,
        );
      }
      return phase;
    }).toList();

    final updatedContext = {
      ...journeyCase.context,
      'phase4_fulfillment': result.toJson(),
      'selected_reaccommodation_option_id':
          result.technicalMetadata.selectedReaccommodationOptionId,
      'reaccommodation_options': result.reaccommodationOptions
          .map((item) => item.toJson())
          .toList(),
      'phase4_monitoring': {
        ...Map<String, dynamic>.from(
          journeyCase.context['phase4_monitoring'] as Map? ?? const {},
        ),
        'reaccommodation_evaluated': true,
      },
    };

    final nextEvents = [
      ...journeyCase.events,
      JourneyEvent(
        title: 'emma',
        message: result.displayMessage,
        timestampLabel: '07:40',
        isUser: false,
      ),
    ];

    return journeyCase.copyWith(
      currentStep: nextStep,
      status: nextStatus,
      phases: updatedPhases,
      events: nextEvents,
      context: updatedContext,
      phase4Fulfillment: result,
    );
  }

  List<ReaccommodationOption> _buildFallbackReaccommodationOptions(
    TravelOption selectedOption,
    DateTime? targetArrivalTime,
  ) {
    final fallbackDeparture = DateTime.parse('2026-04-09T06:20:00Z');
    final fallbackArrival =
        targetArrivalTime ?? selectedOption.estimatedArrival;
    return [
      ReaccommodationOption(
        optionId: '${selectedOption.optionId}_fallback_direct',
        providerBundle: selectedOption.providerCandidates,
        departureTime: fallbackDeparture,
        arrivalTime: fallbackArrival.add(const Duration(minutes: 5)),
        estimatedCostEur: selectedOption.estimatedCostEuro,
        guaranteeLevel: ReaccommodationGuaranteeLevel.high,
        bookable: true,
        bookableWithOneTap: true,
        requiresUserInput: false,
        policyFlags: const ['BUDGET_OK'],
        exclusionFlags: const [],
      ),
      ReaccommodationOption(
        optionId: '${selectedOption.optionId}_fallback_manual',
        providerBundle: [
          ...selectedOption.providerCandidates,
          'manual_partner',
        ],
        departureTime: fallbackDeparture.add(const Duration(minutes: 10)),
        arrivalTime: fallbackArrival.add(const Duration(minutes: 10)),
        estimatedCostEur: selectedOption.estimatedCostEuro + 8,
        guaranteeLevel: ReaccommodationGuaranteeLevel.medium,
        bookable: true,
        bookableWithOneTap: false,
        requiresUserInput: true,
        policyFlags: const ['BUDGET_OK'],
        exclusionFlags: const [],
      ),
    ];
  }

  TrustLayerCard _buildPhase4TrustLayer(JourneyFulfillmentControl result) {
    final primaryCta = switch (result.selectedAction.actionType) {
      'REACCOMMODATE' => 'Ersatzroute bestaetigen',
      'TRIGGER_GUARANTEE' => 'Garantie aktivieren',
      'ESCALATE_TO_MANUAL_OPS' => 'Ops informieren',
      _ => 'Monitoring ansehen',
    };
    return TrustLayerCard(
      type: result.selectedAction.actionType,
      primaryCta: primaryCta,
      summaryItems: [
        TrustSummaryItem(label: 'Status', value: result.controlStatus),
        TrustSummaryItem(
          label: 'Aktion',
          value: result.selectedAction.actionType,
        ),
      ],
      payload: result.toJson(),
    );
  }
}
