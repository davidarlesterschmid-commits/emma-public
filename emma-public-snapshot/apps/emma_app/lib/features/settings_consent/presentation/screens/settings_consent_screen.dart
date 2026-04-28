import 'package:emma_app/features/settings_consent/presentation/view_models/consent_settings_ui_notifier.dart';
import 'package:emma_app/features/settings_consent/presentation/widgets/settings_consent_body.dart';
import 'package:emma_app/l10n/app_localizations.dart';
import 'package:emma_app/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsConsentScreen extends ConsumerWidget {
  const SettingsConsentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(consentSettingsUiProvider);
    final n = ref.read(consentSettingsUiProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsScreenTitle)),
      body: SettingsConsentBody(
        state: state,
        onRetry: n.retry,
        onOpenConsentDetail: () => context.push(AppRoutes.consent),
        consentToggles: true,
        onSetAnalytics: n.setAnalytics,
        onSetMarketing: n.setMarketing,
        loadingSemanticsLabel: l.semanticsSettingsLoading,
      ),
    );
  }
}
