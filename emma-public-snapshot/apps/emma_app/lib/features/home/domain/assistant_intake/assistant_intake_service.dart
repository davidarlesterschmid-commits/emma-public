import 'package:emma_app/features/home/domain/assistant_intake/assistant_intake_models.dart';

class AssistantIntakeService {
  const AssistantIntakeService();

  AssistantIntakeResult process(
    String userInput, {
    required AssistantInputMode inputMode,
    StructuredTravelRequest? previous,
  }) {
    final normalized = userInput.trim();

    final isTravelIntent = _looksLikeTravelIntent(normalized) || previous != null;

    if (!isTravelIntent) {
      return AssistantIntakeResult(
        status: AssistantIntakeStatus.notTravelIntent,
        normalizedText: normalized,
        isTravelIntent: false,
        missingRequiredFields: const [],
        followUpQuestions: const [],
        executionSafetyPolicy:
            const AssistantExecutionSafetyPolicy.noCommit(),
        structuredRequest: null,
        journeyReadyInput: null,
      );
    }

    final parsed = _merge(previous, _parseRequest(normalized, inputMode));

    final missing = _validate(parsed);

    if (missing.isNotEmpty) {
      return AssistantIntakeResult(
        status: AssistantIntakeStatus.needsFollowUp,
        normalizedText: normalized,
        isTravelIntent: true,
        missingRequiredFields: missing,
        followUpQuestions: _buildFollowUps(missing),
        executionSafetyPolicy:
            const AssistantExecutionSafetyPolicy.noCommit(),
        structuredRequest: parsed,
        journeyReadyInput: null,
      );
    }

    return AssistantIntakeResult(
      status: AssistantIntakeStatus.journeyReady,
      normalizedText: normalized,
      isTravelIntent: true,
      missingRequiredFields: const [],
      followUpQuestions: const [],
      executionSafetyPolicy:
          const AssistantExecutionSafetyPolicy.noCommit(),
      structuredRequest: parsed,
      journeyReadyInput: JourneyReadyInput(
        origin: parsed.origin!,
        destination: parsed.destination!,
        targetDateHint: parsed.targetDateHint,
        latestArrivalTimeLocal: parsed.latestArrivalTimeLocal!,
        tripPurpose: parsed.tripPurpose,
        requiresExplicitApproval: true,
      ),
      bookingStubOptions: _buildBookingStubs(parsed),
    );
  }

  StructuredTravelRequest _merge(
    StructuredTravelRequest? prev,
    StructuredTravelRequest current,
  ) {
    if (prev == null) return current;

    return current.copyWith(
      origin: current.origin ?? prev.origin,
      destination: current.destination ?? prev.destination,
      latestArrivalTimeLocal:
          current.latestArrivalTimeLocal ?? prev.latestArrivalTimeLocal,
    );
  }

  bool _looksLikeTravelIntent(String text) {
    final lower = text.toLowerCase();
    return lower.contains('nach') ||
        lower.contains('von') ||
        lower.contains('fahrt') ||
        lower.contains('reise');
  }

  StructuredTravelRequest _parseRequest(
    String text,
    AssistantInputMode mode,
  ) {
    final lower = text.toLowerCase();

    String? origin;
    String? destination;
    String? time;

    if (lower.contains('von') && lower.contains('nach')) {
      final parts = lower.split('nach');
      origin = parts.first.replaceAll('von', '').trim();
      destination = parts.last.trim();
    }

    if (lower.contains('um')) {
      time = lower.split('um').last.trim();
    }

    return StructuredTravelRequest(
      inputMode: mode,
      rawUserText: text,
      tripPurpose: 'unknown',
      origin: origin,
      destination: destination,
      targetDateHint: 'today',
      latestArrivalTimeLocal: time,
      approvalStatus: 'NOT_APPROVED',
    );
  }

  List<String> _validate(StructuredTravelRequest request) {
    final missing = <String>[];

    if (!request.hasOrigin) missing.add('origin');
    if (!request.hasDestination) missing.add('destination');
    if (!request.hasArrivalTime) missing.add('time');

    return missing;
  }

  List<AssistantFollowUpQuestion> _buildFollowUps(
    List<String> missing,
  ) {
    final questions = <AssistantFollowUpQuestion>[];

    for (final field in missing) {
      switch (field) {
        case 'origin':
          questions.add(const AssistantFollowUpQuestion(
            fieldKey: 'origin',
            prompt: 'Wo startet deine Reise?',
            reason: 'Startort fehlt',
          ));
          break;
        case 'destination':
          questions.add(const AssistantFollowUpQuestion(
            fieldKey: 'destination',
            prompt: 'Wohin möchtest du reisen?',
            reason: 'Zielort fehlt',
          ));
          break;
        case 'time':
          questions.add(const AssistantFollowUpQuestion(
            fieldKey: 'time',
            prompt: 'Wann musst du ankommen?',
            reason: 'Zeitangabe fehlt',
          ));
          break;
      }
    }

    return questions;
  }

  List<AssistantBookingStubOption> _buildBookingStubs(
    StructuredTravelRequest request,
  ) {
    return const [
      AssistantBookingStubOption(
        kind: AssistantBookingStubKind.publicTransportTicket,
        title: 'ÖPNV-Ticket buchen (Stub)',
        description: 'Klassische Verbindung mit Bahn/Bus.',
        safetyNotice: 'Demo – keine echte Buchung',
      ),
      AssistantBookingStubOption(
        kind: AssistantBookingStubKind.taxiFallback,
        title: 'Taxi als Ersatz buchen (Stub)',
        description: 'Direkte Fahrt ohne Umstieg.',
        safetyNotice: 'Demo – keine echte Buchung',
      ),
      AssistantBookingStubOption(
        kind: AssistantBookingStubKind.onDemandShuttle,
        title: 'On-Demand Shuttle (Stub)',
        description: 'Flexible Sammelfahrt.',
        safetyNotice: 'Demo – keine echte Buchung',
      ),
    ];
  }
}
