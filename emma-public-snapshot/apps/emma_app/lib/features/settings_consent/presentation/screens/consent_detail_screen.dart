import 'package:emma_app/features/settings_consent/presentation/view_models/consent_settings_ui_notifier.dart';
import 'package:emma_app/features/settings_consent/presentation/widgets/settings_consent_body.dart';
import 'package:emma_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConsentDetailScreen extends ConsumerWidget {
  const ConsentDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(consentSettingsUiProvider);
    final n = ref.read(consentSettingsUiProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l.consentScreenAppBar)),
      body: SettingsConsentBody(
        state: state,
        onRetry: n.retry,
        onOpenConsentDetail: null,
        consentToggles: true,
        onSetAnalytics: n.setAnalytics,
        onSetMarketing: n.setMarketing,
        loadingSemanticsLabel: l.semanticsConsentLoading,
      ),
    );
  }
}
