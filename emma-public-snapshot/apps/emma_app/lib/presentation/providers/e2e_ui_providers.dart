import 'package:flutter_riverpod/flutter_riverpod.dart';

/// E2E-/Demo-only: simuliert eine aktive Reise für Statusleisten, ohne Backend.
class E2eJourneyActiveNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void activate() => state = true;

  void deactivate() => state = false;
}

final e2eJourneyActiveProvider =
    NotifierProvider<E2eJourneyActiveNotifier, bool>(
  E2eJourneyActiveNotifier.new,
);
