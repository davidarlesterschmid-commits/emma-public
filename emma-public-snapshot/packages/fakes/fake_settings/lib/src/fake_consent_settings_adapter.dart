import 'package:emma_contracts/emma_contracts.dart';

/// In-memory, synchronous-looking consent flags (MVP, Fake-First).
class FakeConsentSettingsAdapter implements ConsentSettingsPort {
  FakeConsentSettingsAdapter({this.initialSimulateError = false});

  /// Wenn [true], werfen [load] und Toggles (nach kurzer Wartezeit) [Exception].
  final bool initialSimulateError;

  UserConsentState _state = const UserConsentState(
    analyticsEnabled: false,
    marketingEnabled: false,
  );

  bool _simulateError = false;

  /// Nur fuer Tests, um Fehlerzweige zu triggern.
  void setSimulateError(bool value) {
    _simulateError = value;
  }

  static const _delay = Duration(milliseconds: 50);

  Future<void> _maybeFail() async {
    await Future<void>.delayed(_delay);
    if (initialSimulateError || _simulateError) {
      throw StateError('Fake: consent load/update failed');
    }
  }

  @override
  Future<UserConsentState> load() async {
    await _maybeFail();
    return _state;
  }

  @override
  Future<UserConsentState> setAnalytics({required bool enabled}) async {
    await _maybeFail();
    _state = _state.copyWith(analyticsEnabled: enabled);
    return _state;
  }

  @override
  Future<UserConsentState> setMarketing({required bool enabled}) async {
    await _maybeFail();
    _state = _state.copyWith(marketingEnabled: enabled);
    return _state;
  }
}
