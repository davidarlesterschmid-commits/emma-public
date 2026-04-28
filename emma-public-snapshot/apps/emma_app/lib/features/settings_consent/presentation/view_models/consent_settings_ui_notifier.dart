import 'dart:async';

import 'package:emma_app/features/settings_consent/domain/settings_consent_state.dart';
import 'package:emma_app/features/settings_consent/presentation/providers/consent_settings_port_provider.dart';
import 'package:emma_contracts/emma_contracts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Orchestriert Lade- und Umschalt-Logik für beide Einstellungs-Screens
/// (ein gemeinsamer State, damit die Schalter synchron bleiben).
class ConsentSettingsUiNotifier extends Notifier<SettingsConsentViewState> {
  @override
  SettingsConsentViewState build() {
    unawaited(_load());
    return const SettingsConsentViewState.loading();
  }

  static const _stubDelay = Duration(milliseconds: 120);

  @visibleForTesting
  static bool debugSimulateLoadError = false;

  ConsentSettingsPort get _port => ref.read(consentSettingsPortProvider);

  Future<void> _load() async {
    state = const SettingsConsentViewState.loading();
    await Future<void>.delayed(_stubDelay);
    if (!ref.mounted) return;
    if (debugSimulateLoadError) {
      state = const SettingsConsentViewState.error(
        'Konsente konnten nicht geladen werden.',
      );
      return;
    }
    try {
      final data = await _port.load();
      if (!ref.mounted) return;
      state = SettingsConsentViewState.ready(data);
    } catch (e) {
      if (!ref.mounted) return;
      state = SettingsConsentViewState.error(e.toString());
    }
  }

  Future<void> retry() => _load();

  Future<void> setAnalytics(bool enabled) async {
    final current = state.userConsent;
    if (current == null) return;
    try {
      final next = await _port.setAnalytics(enabled: enabled);
      if (!ref.mounted) return;
      state = SettingsConsentViewState.ready(next);
    } catch (e) {
      if (!ref.mounted) return;
      state = SettingsConsentViewState.error(e.toString());
    }
  }

  Future<void> setMarketing(bool enabled) async {
    final current = state.userConsent;
    if (current == null) return;
    try {
      final next = await _port.setMarketing(enabled: enabled);
      if (!ref.mounted) return;
      state = SettingsConsentViewState.ready(next);
    } catch (e) {
      if (!ref.mounted) return;
      state = SettingsConsentViewState.error(e.toString());
    }
  }
}

final consentSettingsUiProvider =
    NotifierProvider<ConsentSettingsUiNotifier, SettingsConsentViewState>(
      ConsentSettingsUiNotifier.new,
    );
