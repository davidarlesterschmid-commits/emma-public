import 'package:emma_app/features/home/domain/assistant_intake/assistant_intake_models.dart';
import 'package:flutter/foundation.dart';

@immutable
class HomeChatMessage {
  const HomeChatMessage({required this.text, required this.isUser});

  final String text;
  final bool isUser;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeChatMessage &&
        other.text == text &&
        other.isUser == isUser;
  }

  @override
  int get hashCode => Object.hash(text, isUser);
}

@immutable
class HomeChatState {
  const HomeChatState({
    this.messages = const <HomeChatMessage>[],
    this.isSending = false,
    this.lastIntakeResult,
    this.inputMode = AssistantInputMode.chat,
  });

  final List<HomeChatMessage> messages;
  final bool isSending;
  final AssistantIntakeResult? lastIntakeResult;
  final AssistantInputMode inputMode;

  bool get hasMessages => messages.isNotEmpty;
  bool get hasStructuredTravelRequest => lastIntakeResult?.isTravelIntent ?? false;
  bool get needsFollowUp => lastIntakeResult?.needsFollowUp ?? false;
  bool get isJourneyReady => lastIntakeResult?.isJourneyReady ?? false;

  HomeChatState copyWith({
    List<HomeChatMessage>? messages,
    bool? isSending,
    AssistantIntakeResult? lastIntakeResult,
    bool clearIntakeResult = false,
    AssistantInputMode? inputMode,
  }) {
    return HomeChatState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      lastIntakeResult:
          clearIntakeResult ? null : lastIntakeResult ?? this.lastIntakeResult,
      inputMode: inputMode ?? this.inputMode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HomeChatState &&
        listEquals(other.messages, messages) &&
        other.isSending == isSending &&
        other.lastIntakeResult == lastIntakeResult &&
        other.inputMode == inputMode;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(messages),
        isSending,
        lastIntakeResult,
        inputMode,
      );
}
