import 'package:emma_app/features/settings_consent/domain/settings_consent_state.dart';
import 'package:emma_app/l10n/app_localizations.dart';
import 'package:emma_contracts/emma_contracts.dart';
import 'package:flutter/material.dart';

class SettingsConsentBody extends StatelessWidget {
  const SettingsConsentBody({
    super.key,
    required this.state,
    required this.onRetry,
    this.onOpenConsentDetail,
    this.consentToggles = true,
    this.onSetAnalytics,
    this.onSetMarketing,
    this.loadingSemanticsLabel,
  });

  final SettingsConsentViewState state;
  final VoidCallback onRetry;
  final VoidCallback? onOpenConsentDetail;
  final bool consentToggles;
  final void Function(bool value)? onSetAnalytics;
  final void Function(bool value)? onSetMarketing;
  final String? loadingSemanticsLabel;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    if (state.phase == SettingsConsentPhase.loading) {
      return Semantics(
        label: loadingSemanticsLabel ?? l.semanticsSettingsLoading,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
    if (state.phase == SettingsConsentPhase.error) {
      return Semantics(
        label: l.semanticsError,
        child: _ErrorBody(
          message: state.errorMessage ?? l.errorUnknown,
          retryLabel: l.errorRetry,
          onRetry: onRetry,
        ),
      );
    }
    final u = state.userConsent;
    if (u == null) {
      return const SizedBox.shrink();
    }
    return _ReadyBody(
      l: l,
      consent: u,
      onOpenDetail: onOpenConsentDetail,
      showToggles: consentToggles,
      onSetAnalytics: onSetAnalytics,
      onSetMarketing: onSetMarketing,
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, semanticLabel: null),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: Text(retryLabel)),
          ],
        ),
      ),
    );
  }
}

class _ReadyBody extends StatelessWidget {
  const _ReadyBody({
    required this.l,
    required this.consent,
    this.onOpenDetail,
    required this.showToggles,
    this.onSetAnalytics,
    this.onSetMarketing,
  });

  final AppLocalizations l;
  final UserConsentState consent;
  final VoidCallback? onOpenDetail;
  final bool showToggles;
  final void Function(bool value)? onSetAnalytics;
  final void Function(bool value)? onSetMarketing;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(l.settingsEmptyHint, style: const TextStyle(fontSize: 16)),
        if (showToggles) ...[
          const SizedBox(height: 16),
          Semantics(
            label: l.semanticsToggles,
            child: Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(l.consentToggleAnalytics),
                    value: consent.analyticsEnabled,
                    onChanged: (v) => onSetAnalytics?.call(v),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text(l.consentToggleMarketing),
                    value: consent.marketingEnabled,
                    onChanged: (v) => onSetMarketing?.call(v),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        if (onOpenDetail != null)
          FilledButton.tonal(
            onPressed: onOpenDetail,
            child: Text(l.openConsentAction),
          ),
      ],
    );
  }
}
