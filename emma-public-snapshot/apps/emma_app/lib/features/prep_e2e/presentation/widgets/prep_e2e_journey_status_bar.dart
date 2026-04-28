import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:emma_app/presentation/providers/e2e_ui_providers.dart';

/// Sichtbarkeitshinweis: „Reise aktiv“ (nur UI, E2E-Demo).
class PrepE2eJourneyStatusBar extends ConsumerWidget {
  const PrepE2eJourneyStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(e2eJourneyActiveProvider);
    if (!active) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Hinweis: Reise aktiv, Demonstration',
      child: Material(
        color: scheme.tertiaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.directions_transit, color: scheme.onTertiaryContainer),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Reise aktiv (Demo) — reine Anzeige, kein Backend',
                  style: TextStyle(
                    color: scheme.onTertiaryContainer,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  ref.read(e2eJourneyActiveProvider.notifier).deactivate();
                },
                icon: const Icon(Icons.close, size: 20),
                tooltip: 'Status ausblenden',
                color: scheme.onTertiaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
