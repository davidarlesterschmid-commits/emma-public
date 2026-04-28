import 'package:emma_app/core/journey_providers.dart';
import 'package:feature_journey/feature_journey.dart' show JourneyStepScreen;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Thin app-shell wrapper around [JourneyStepScreen].
///
/// Responsible solely for wiring the Riverpod providers from
/// `core/journey_providers.dart`
/// ([journeyStateProvider], [journeyCaseProvider]) into the parametrized
/// presentation. The UI lives in [JourneyStepScreen] so it stays
/// preview- and testable without Riverpod.
class JourneyScreen extends ConsumerWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeyState = ref.watch(journeyStateProvider);
    return JourneyStepScreen(
      state: journeyState,
      onAdvance: () => ref.read(journeyCaseProvider.notifier).advanceStep(),
      onConfirmBooking: () =>
          ref.read(journeyCaseProvider.notifier).confirmMockBooking(),
      onSimulateDisruption: () =>
          ref.read(journeyCaseProvider.notifier).simulateDisruption(),
      onAcceptFallback: () =>
          ref.read(journeyCaseProvider.notifier).acceptFallback(),
      onCompleteJourney: () =>
          ref.read(journeyCaseProvider.notifier).completeJourney(),
    );
  }
}
