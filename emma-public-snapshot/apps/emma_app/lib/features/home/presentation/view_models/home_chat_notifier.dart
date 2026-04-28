import 'package:emma_app/core/infra_providers.dart';
import 'package:emma_app/features/home/domain/assistant_intake/assistant_intake_models.dart';
import 'package:emma_app/features/home/domain/assistant_intake/assistant_intake_service.dart';
import 'package:emma_app/features/home/presentation/view_models/home_chat_state.dart';
import 'package:emma_contracts/emma_contracts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeChatNotifier extends Notifier<HomeChatState> {
  final _intake = const AssistantIntakeService();

  @override
  HomeChatState build() => const HomeChatState();

  /// Eingabemodus für den Startscreen; Intake wertet [AssistantInputMode] aus.
  void setInputMode(AssistantInputMode mode) {
    if (state.inputMode == mode) return;
    state = state.copyWith(inputMode: mode);
  }

  ChatPort get _chatPort => ref.read(chatPortProvider);
  DirectionsPort get _directionsPort => ref.read(directionsPortProvider);

  Future<void> sendMessage(String userText) async {
    final trimmed = userText.trim();
    if (trimmed.isEmpty || state.isSending) return;

    _append(HomeChatMessage(text: trimmed, isUser: true), isSending: true);

    final intakeResult = _intake.process(
      trimmed,
      inputMode: state.inputMode,
    );

    state = state.copyWith(lastIntakeResult: intakeResult);
    final canUseLegacyRouteSummary =
        _isRouteQuery(trimmed) && _extractLocations(trimmed) != null;

    try {
      // PRIORITY 1: Follow-ups (dialogic flow)
      if (intakeResult.needsFollowUp && !canUseLegacyRouteSummary) {
        final followUps = intakeResult.followUpQuestions
            .map((q) => q.prompt)
            .join('\n');

        _append(
          HomeChatMessage(text: followUps, isUser: false),
          isSending: false,
        );
        return;
      }

      // PRIORITY 2: Journey-ready → inform user (no auto execution)
      if (intakeResult.isJourneyReady) {
        _append(
          const HomeChatMessage(
            text:
                'Deine Anfrage ist vollständig. Ich kann jetzt passende Verbindungen für dich vorbereiten.',
            isUser: false,
          ),
          isSending: false,
        );
        return;
      }

      // PRIORITY 3: fallback to existing logic
      final prompt = await _buildPrompt(trimmed);
      final reply = await _chatPort.reply(prompt);

      if (!ref.mounted) return;

      _append(
        HomeChatMessage(text: reply, isUser: false),
        isSending: false,
      );
    } on ChatException catch (e) {
      if (!ref.mounted) return;
      _append(
        HomeChatMessage(text: 'Fehler: ${e.message}', isUser: false),
        isSending: false,
      );
    } catch (e) {
      if (!ref.mounted) return;
      _append(
        HomeChatMessage(text: 'Fehler: $e', isUser: false),
        isSending: false,
      );
    }
  }

  void clear() {
    state = const HomeChatState();
  }

  Future<String> _buildPrompt(String userText) async {
    if (!_isRouteQuery(userText)) {
      return userText;
    }
    final locations = _extractLocations(userText);
    if (locations == null) {
      return userText;
    }
    final summary = await _directionsPort.summarize(
      origin: locations.$1,
      destination: locations.$2,
    );
    return _routePromptTemplate(
      userText: userText,
      summary: summary,
    );
  }

  void _append(HomeChatMessage message, {required bool isSending}) {
    state = state.copyWith(
      messages: [...state.messages, message],
      isSending: isSending,
    );
  }

  bool _isRouteQuery(String text) {
    final lower = text.toLowerCase();
    return (lower.contains('von') && lower.contains('nach')) ||
        lower.contains('verbindung') ||
        lower.contains('route') ||
        lower.contains('wie komme ich') ||
        lower.contains('fahrt') ||
        lower.contains('strecke');
  }

  (String, String)? _extractLocations(String text) {
    final patterns = <RegExp>[
      RegExp(r'von\s+(.+?)\s+nach\s+([^?.!\s]+)', caseSensitive: false),
      RegExp(r'von\s+(.+?)\s+nach\s+(.+)$', caseSensitive: false),
      RegExp(r'zwischen\s+(.+?)\s+und\s+([^?.!\s]+)', caseSensitive: false),
      RegExp(r'zwischen\s+(.+?)\s+und\s+(.+)$', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return (match.group(1)!.trim(), match.group(2)!.trim());
      }
    }
    return null;
  }

  String _routePromptTemplate({
    required String userText,
    required DirectionsSummary summary,
  }) {
    return '''
Der Nutzer fragt: "$userText"

Hier sind die Routeninformationen:
Auto: ${summary.durationDriving} (${summary.distanceDriving})
OEPNV: ${summary.durationTransit} (${summary.distanceTransit})

Praesentiere diese Infos uebersichtlich und freundlich.
''';
  }
}

final homeChatProvider =
    NotifierProvider<HomeChatNotifier, HomeChatState>(HomeChatNotifier.new);
