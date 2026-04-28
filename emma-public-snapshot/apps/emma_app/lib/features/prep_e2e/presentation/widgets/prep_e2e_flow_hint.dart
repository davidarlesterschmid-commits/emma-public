import 'package:emma_app/features/home/presentation/view_models/home_chat_state.dart';
import 'package:emma_app/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Reines UI: leitet [HomeChatState] auf Phasen-Hinweise um (ohne Businesslogik).
class PrepE2eFlowHint extends StatelessWidget {
  const PrepE2eFlowHint({super.key, required this.state});

  final HomeChatState state;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    if (state.isSending) {
      return _HintCard(
        icon: Icons.hourglass_top_outlined,
        title: 'Anfrage',
        body: 'Laden — wird für die spätere Domain-übergabe vorbereitet',
        color: color,
      );
    }
    if (state.isJourneyReady) {
      return _HintCard(
        icon: Icons.alt_route,
        title: 'Auswahl',
        body:
            'Struktur vorhanden. Verbindungswahl (Demo) öffnet eine Platzhalter-Liste.',
        color: color,
        action: TextButton(
          onPressed: () => context.push(AppRoutes.prepE2eRouting),
          child: const Text('Zur Routenliste (Demo)'),
        ),
      );
    }
    if (state.needsFollowUp) {
      return _HintCard(
        icon: Icons.edit_note,
        title: 'Rückfrage',
        body: 'Es fehlen noch Angaben; Chat steuert die Nachfrage.',
        color: color,
      );
    }
    if (state.hasMessages) {
      return _HintCard(
        icon: Icons.check_circle_outline,
        title: 'Antwort',
        body: 'Ergebnis im Chat. Detail-Screen: „Ergebnis (Demo)“.',
        color: color,
        action: TextButton(
          onPressed: () => context.push(AppRoutes.prepE2eResult),
          child: const Text('Ergebnis-Screen (Demo)'),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _HintCard extends StatelessWidget {
  const _HintCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
    this.action,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color color;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(
                  'E2E-Phase: $title',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: color,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              body,
              style: const TextStyle(fontSize: 12.5, height: 1.3),
            ),
            ?action,
          ],
        ),
      ),
    );
  }
}
