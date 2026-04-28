import 'package:emma_app/features/prep_e2e/presentation/models/prep_e2e_shortcut.dart';
import 'package:emma_app/presentation/providers/e2e_ui_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Shortcut-Zeile für E2E — nur Navigation, [kPrepE2eNavShortcuts] als Quelle.
class PrepE2eShortcutRow extends ConsumerWidget {
  const PrepE2eShortcutRow({super.key, required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'E2E-Shortcuts (UI vorbereitet)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in kPrepE2eNavShortcuts)
                ActionChip(
                  avatar: Icon(Icons.open_in_new, size: 18, color: accentColor),
                  label: Text(s.label),
                  onPressed: () => context.push(s.route),
                ),
              ActionChip(
                avatar: Icon(Icons.play_arrow, size: 18, color: accentColor),
                label: const Text('Reise aktiv (Demo)'),
                onPressed: () {
                  ref.read(e2eJourneyActiveProvider.notifier).activate();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
