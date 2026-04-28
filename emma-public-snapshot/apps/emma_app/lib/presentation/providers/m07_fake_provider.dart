import 'package:emma_app/core/config/app_config.dart';
import 'package:fake_guarantee/fake_guarantee.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// M07-Demo-Stack — nur sinnvoll mit `--dart-define=USE_FAKES=true`.
final m07FakeInMemoryProvider = Provider<FakeM07InMemory?>((ref) {
  if (!AppConfig.useFakes) {
    return null;
  }
  return FakeM07InMemory();
});
