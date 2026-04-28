import 'package:emma_contracts/src/models/user_consent_state.dart';

/// Port: Einwilligungen & Nutzereinstellungen (Analyse, Marketing).
///
/// Fakes/Adapter in `fakes` bzw. `adapters` — kein kostenpflichtiger Dritt-Dienst
/// im MVP-Default (ADR-03/04).
abstract interface class ConsentSettingsPort {
  /// Stellt die aktuell gueltigen Schalter (In-Memory oder Persistenz) bereit.
  Future<UserConsentState> load();

  Future<UserConsentState> setAnalytics({required bool enabled});

  Future<UserConsentState> setMarketing({required bool enabled});
}
