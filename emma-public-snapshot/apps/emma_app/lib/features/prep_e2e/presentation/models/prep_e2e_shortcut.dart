import 'package:emma_app/routing/app_routes.dart';
import 'package:flutter/foundation.dart';

/// Strukturvorlage für Startscreen-Shortcuts (E2E-UI, keine Logik).
@immutable
class PrepE2eNavShortcut {
  const PrepE2eNavShortcut({
    required this.label,
    required this.route,
    required this.semanticLabel,
  });

  final String label;
  final String route;
  final String semanticLabel;
}

/// Feste E2E-Navigation — nur Platzhalter-Routen, keine Domain.
const kPrepE2eNavShortcuts = <PrepE2eNavShortcut>[
  PrepE2eNavShortcut(
    label: 'Routenwahl (Demo)',
    route: AppRoutes.prepE2eRouting,
    semanticLabel: 'Zur Demoseite Verbindungsauswahl wechseln',
  ),
  PrepE2eNavShortcut(
    label: 'Wallet (Demo)',
    route: AppRoutes.prepE2eWallet,
    semanticLabel: 'Zur simulierten Wallet-Ansicht wechseln',
  ),
  PrepE2eNavShortcut(
    label: 'Ergebnis (Demo)',
    route: AppRoutes.prepE2eResult,
    semanticLabel: 'Zur Demoseite Ergebnisanzeige wechseln',
  ),
];
