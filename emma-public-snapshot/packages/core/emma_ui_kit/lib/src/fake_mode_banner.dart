import 'package:flutter/material.dart';

/// Sichtbarer Hinweis, dass der Build im Fake-/Demo-Modus laeuft (ADR-03 /
/// ADR-05). Zeigt eine schmale Leiste mit einheitlichem Text.
///
/// Das Widget ist bewusst frei von App-Config-Abhaengigkeiten — der
/// aufrufende Screen entscheidet ueber [isActive]. Dadurch bleibt
/// `emma_ui_kit` frei von `emma_app`-Importen (Packages duerfen Apps
/// nicht importieren).
///
/// Barrierefrei: Die Leiste ist ein [Semantics]-Header, damit
/// Screenreader den Demo-Hinweis vorlesen.
class FakeModeBanner extends StatelessWidget {
  const FakeModeBanner({
    super.key,
    required this.isActive,
    this.label = 'Demo-Modus — keine echten Buchungen, keine echten Zahlungen.',
  });

  /// Ob der Banner gerendert wird. Wenn `false`, liefert das Widget
  /// einen [SizedBox.shrink], damit Aufrufer das Widget unkonditional
  /// einhaengen koennen.
  final bool isActive;

  /// Text der Demo-Leiste. Default deckt den MVP-Claim aus ADR-03 ab.
  final String label;

  @override
  Widget build(BuildContext context) {
    if (!isActive) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    return Semantics(
      header: true,
      liveRegion: true,
      label: label,
      child: Material(
        color: theme.colorScheme.tertiaryContainer,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: theme.colorScheme.onTertiaryContainer,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onTertiaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
