import 'package:emma_app/core/config/app_config.dart';
import 'package:emma_app/features/home/domain/assistant_intake/assistant_intake_models.dart';
import 'package:emma_app/features/home/presentation/view_models/home_chat_notifier.dart';
import 'package:emma_app/features/home/presentation/view_models/home_chat_state.dart';
import 'package:emma_app/features/home/presentation/widgets/structured_intake_preview_card.dart';
import 'package:emma_app/features/prep_e2e/presentation/widgets/prep_e2e_flow_hint.dart';
import 'package:emma_app/features/prep_e2e/presentation/widgets/prep_e2e_journey_status_bar.dart';
import 'package:emma_app/features/prep_e2e/presentation/widgets/prep_e2e_shortcut_row.dart';
import 'package:emma_app/routing/app_routes.dart';
import 'package:emma_ui_kit/emma_ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Home-Chat-Screen.
///
/// Nur View-Schicht: liest [homeChatProvider] fuer State, delegiert
/// Eingaben an [HomeChatNotifier]. Keine Adapter-Importe, keine Regex-
/// oder Prompt-Logik, kein Umgang mit API-Keys.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _lastRenderedMessageCount = 0;

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottomSoon() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _handleSubmit() async {
    final text = _chatController.text;
    if (text.trim().isEmpty) return;
    _chatController.clear();
    await ref.read(homeChatProvider.notifier).sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(homeChatProvider);

    // Nach jedem State-Update, bei dem eine Nachricht neu dazukommt,
    // scrollen. Rein reaktiv — keine setState-Kopplung.
    if (chatState.messages.length != _lastRenderedMessageCount) {
      _lastRenderedMessageCount = chatState.messages.length;
      _scrollToBottomSoon();
    }

    final emmaGreen = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Zonen-Layout: (1) Top — Banner, E2E-Status, Shortcuts, Navigation
            const FakeModeBanner(isActive: AppConfig.useFakes),
            const _M07InfoBanner(),
            const PrepE2eJourneyStatusBar(),
            _HomeQuickNavRow(color: emmaGreen),
            PrepE2eShortcutRow(accentColor: emmaGreen),
            // (2) Mitte — Intake, Phasen-Hinweis, Marke, Chat
            StructuredIntakePreviewCard(result: chatState.lastIntakeResult),
            PrepE2eFlowHint(state: chatState),
            _HomeHeader(color: emmaGreen),
            Expanded(
              child: chatState.hasMessages
                  ? _ChatList(
                      messages: chatState.messages,
                      scrollController: _scrollController,
                      userBubbleColor: emmaGreen,
                    )
                  : const _EmptyHint(),
            ),
            // (3) Unten — Eingabemodus + Composer
            if (chatState.isSending) _SendingIndicator(color: emmaGreen),
            _StartInputPanel(
              controller: _chatController,
              color: emmaGreen,
              enabled: !chatState.isSending,
              inputMode: chatState.inputMode,
              onInputModeChanged: (mode) {
                ref.read(homeChatProvider.notifier).setInputMode(mode);
              },
              onSubmit: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}

/// Kompakter M07-Hinweis: Spez & Journey-Engine im Aufbau, keine
/// vollstaendige Garantie-Engine.
class _M07InfoBanner extends StatelessWidget {
  const _M07InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          'Hinweis Mobilitaetsgarantie: Ersatzlogik in Planung, siehe M07',
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Text(
            'Mobilitaetsgarantie (M07): Optionen in der Suche; '
            'Ersatzpfade in Arbeit.',
            style: TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}

class _HomeQuickNavRow extends StatelessWidget {
  const _HomeQuickNavRow({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: <Widget>[
          _QuickChip(
            label: 'Reise suchen',
            icon: Icons.route,
            color: color,
            onTap: () => context.push(AppRoutes.journey),
            semanticLabel: 'Zur Reisesuche wechseln',
          ),
          if (AppConfig.useFakes) ...[
            _QuickChip(
              label: 'Tickets (Demo)',
              icon: Icons.confirmation_number_outlined,
              color: color,
              onTap: () => context.push(AppRoutes.ticketing),
              semanticLabel: 'Zum Ticketkatalog (Demo) wechseln',
            ),
            _QuickChip(
              label: 'Rechnungen (Demo)',
              icon: Icons.receipt_long,
              color: color,
              onTap: () => context.push(AppRoutes.accountInvoices),
              semanticLabel: 'Zur Rechnungsliste (Demo) wechseln',
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.semanticLabel,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: ActionChip(
        avatar: Icon(icon, size: 20, color: color),
        label: Text(label),
        onPressed: onTap,
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'e',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'emma',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          'Frag mich z.B.:\n"Wie komme ich von Leipzig nach Halle?"',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _ChatList extends StatelessWidget {
  const _ChatList({
    required this.messages,
    required this.scrollController,
    required this.userBubbleColor,
  });

  final List<HomeChatMessage> messages;
  final ScrollController scrollController;
  final Color userBubbleColor;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: messages.length,
      itemBuilder: (context, index) => _ChatBubble(
        message: messages[index],
        userBubbleColor: userBubbleColor,
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message, required this.userBubbleColor});

  final HomeChatMessage message;
  final Color userBubbleColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? userBubbleColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _SendingIndicator extends StatelessWidget {
  const _SendingIndicator({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: color,
          ),
        ),
      ),
    );
  }
}

/// Eingabebereich: Text- vs. Sprachmodus (letzterer nur vorbereitet) + Tastatur.
class _StartInputPanel extends StatelessWidget {
  const _StartInputPanel({
    required this.controller,
    required this.color,
    required this.enabled,
    required this.inputMode,
    required this.onInputModeChanged,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final Color color;
  final bool enabled;
  final AssistantInputMode inputMode;
  final void Function(AssistantInputMode) onInputModeChanged;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            label: 'Eingabemodus wählen, Tastatur oder Sprachmodus',
            child: Material(
              type: MaterialType.transparency,
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 4, right: 4),
                    child: Text(
                      'Eingang',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ToggleButtons(
                    isSelected: <bool>[
                      inputMode == AssistantInputMode.chat,
                      inputMode == AssistantInputMode.voice,
                    ],
                    onPressed: enabled
                        ? (index) {
                            onInputModeChanged(
                              index == 0
                                  ? AssistantInputMode.chat
                                  : AssistantInputMode.voice,
                            );
                          }
                        : null,
                    borderRadius: BorderRadius.circular(8),
                    constraints: const BoxConstraints(
                      minWidth: 96,
                      minHeight: 36,
                    ),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.keyboard, size: 18),
                            SizedBox(width: 4),
                            Text('Tastatur'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.mic_none, size: 18),
                            SizedBox(width: 4),
                            Text('Sprache'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (inputMode == AssistantInputMode.voice)
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 4, 4, 0),
              child: _VoiceStubBanner(),
            ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  decoration: InputDecoration(
                    hintText: 'Frag emma...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  onSubmitted: enabled ? (_) => onSubmit() : null,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: enabled ? onSubmit : null,
                icon: Icon(Icons.send_rounded, color: color),
                tooltip: 'Senden',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VoiceStubBanner extends StatelessWidget {
  const _VoiceStubBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Sprach-E2E: Verarbeitung vorbereitet; Eingabe vorerst per Tastatur (Demo).',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
          fontSize: 11.5,
          height: 1.25,
        ),
      ),
    );
  }
}
