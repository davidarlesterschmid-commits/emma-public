enum AssistantInputMode {
  chat,
  voice,
}

enum AssistantIntakeStatus {
  notTravelIntent,
  needsFollowUp,
  journeyReady,
}

enum AssistantBookingStubKind {
  publicTransportTicket,
  taxiFallback,
  onDemandShuttle,
}

class AssistantExecutionSafetyPolicy {
  const AssistantExecutionSafetyPolicy({
    required this.bookingAllowed,
    required this.activationAllowed,
    required this.paymentAllowed,
    required this.explicitApprovalRequired,
  });

  const AssistantExecutionSafetyPolicy.noCommit()
    : bookingAllowed = false,
      activationAllowed = false,
      paymentAllowed = false,
      explicitApprovalRequired = true;

  final bool bookingAllowed;
  final bool activationAllowed;
  final bool paymentAllowed;
  final bool explicitApprovalRequired;
}

class AssistantFollowUpQuestion {
  const AssistantFollowUpQuestion({
    required this.fieldKey,
    required this.prompt,
    required this.reason,
  });

  final String fieldKey;
  final String prompt;
  final String reason;
}

class StructuredTravelRequest {
  const StructuredTravelRequest({
    required this.inputMode,
    required this.rawUserText,
    required this.tripPurpose,
    required this.origin,
    required this.destination,
    required this.targetDateHint,
    required this.latestArrivalTimeLocal,
    required this.approvalStatus,
  });

  final AssistantInputMode inputMode;
  final String rawUserText;
  final String tripPurpose;
  final String? origin;
  final String? destination;
  final String targetDateHint;
  final String? latestArrivalTimeLocal;
  final String approvalStatus;

  bool get hasOrigin => origin != null && origin!.trim().isNotEmpty;
  bool get hasDestination =>
      destination != null && destination!.trim().isNotEmpty;
  bool get hasArrivalTime =>
      latestArrivalTimeLocal != null &&
      latestArrivalTimeLocal!.trim().isNotEmpty;

  StructuredTravelRequest copyWith({
    AssistantInputMode? inputMode,
    String? rawUserText,
    String? tripPurpose,
    String? origin,
    String? destination,
    String? targetDateHint,
    String? latestArrivalTimeLocal,
    String? approvalStatus,
  }) {
    return StructuredTravelRequest(
      inputMode: inputMode ?? this.inputMode,
      rawUserText: rawUserText ?? this.rawUserText,
      tripPurpose: tripPurpose ?? this.tripPurpose,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      targetDateHint: targetDateHint ?? this.targetDateHint,
      latestArrivalTimeLocal:
          latestArrivalTimeLocal ?? this.latestArrivalTimeLocal,
      approvalStatus: approvalStatus ?? this.approvalStatus,
    );
  }
}

class JourneyReadyInput {
  const JourneyReadyInput({
    required this.origin,
    required this.destination,
    required this.targetDateHint,
    required this.latestArrivalTimeLocal,
    required this.tripPurpose,
    required this.requiresExplicitApproval,
  });

  final String origin;
  final String destination;
  final String targetDateHint;
  final String latestArrivalTimeLocal;
  final String tripPurpose;
  final bool requiresExplicitApproval;
}

class AssistantBookingStubOption {
  const AssistantBookingStubOption({
    required this.kind,
    required this.title,
    required this.description,
    required this.safetyNotice,
  });

  final AssistantBookingStubKind kind;
  final String title;
  final String description;
  final String safetyNotice;
}

class AssistantIntakeResult {
  const AssistantIntakeResult({
    required this.status,
    required this.normalizedText,
    required this.isTravelIntent,
    required this.missingRequiredFields,
    required this.followUpQuestions,
    required this.executionSafetyPolicy,
    required this.structuredRequest,
    required this.journeyReadyInput,
    this.bookingStubOptions = const <AssistantBookingStubOption>[],
  });

  final AssistantIntakeStatus status;
  final String normalizedText;
  final bool isTravelIntent;
  final List<String> missingRequiredFields;
  final List<AssistantFollowUpQuestion> followUpQuestions;
  final AssistantExecutionSafetyPolicy executionSafetyPolicy;
  final StructuredTravelRequest? structuredRequest;
  final JourneyReadyInput? journeyReadyInput;
  final List<AssistantBookingStubOption> bookingStubOptions;

  bool get needsFollowUp => status == AssistantIntakeStatus.needsFollowUp;
  bool get isJourneyReady => status == AssistantIntakeStatus.journeyReady;
}
