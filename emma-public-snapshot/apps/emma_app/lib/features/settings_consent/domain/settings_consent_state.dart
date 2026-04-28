import 'package:emma_contracts/emma_contracts.dart' show UserConsentState;

/// UI-Status Einstellungen & Einwilligungen.
class SettingsConsentViewState {
  const SettingsConsentViewState({
    required this.phase,
    this.errorMessage,
    this.userConsent,
  });

  const SettingsConsentViewState.loading()
    : this(phase: SettingsConsentPhase.loading);

  const SettingsConsentViewState.error(this.errorMessage)
    : phase = SettingsConsentPhase.error,
      userConsent = null;

  const SettingsConsentViewState.ready(this.userConsent)
    : phase = SettingsConsentPhase.ready,
      errorMessage = null,
      assert(userConsent != null);

  final SettingsConsentPhase phase;
  final String? errorMessage;
  final UserConsentState? userConsent;

  bool get isReady =>
      phase == SettingsConsentPhase.ready && userConsent != null;
}

enum SettingsConsentPhase { loading, error, ready }
