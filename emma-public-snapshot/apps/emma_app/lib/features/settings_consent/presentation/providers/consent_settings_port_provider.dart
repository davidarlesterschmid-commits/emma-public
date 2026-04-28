import 'package:emma_contracts/emma_contracts.dart';
import 'package:fake_settings/fake_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// MVP-Default: [FakeConsentSettingsAdapter] (siehe ADR-03). Spaeter Adapter-Tausch hier.
final consentSettingsPortProvider = Provider<ConsentSettingsPort>(
  (ref) => FakeConsentSettingsAdapter(),
);
