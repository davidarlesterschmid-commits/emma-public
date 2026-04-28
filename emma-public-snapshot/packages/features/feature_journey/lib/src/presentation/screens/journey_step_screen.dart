import 'package:domain_journey/domain_journey.dart';
import 'package:flutter/material.dart';

import 'package:feature_journey/src/presentation/widgets/journey_step_widget.dart';

/// Shell for the journey orchestrator view.
///
/// Parameterised on the current [JourneyState] and an optional advance
/// callback, so the enclosing app can wire it up to any state source
/// (Riverpod, BLoC, preview harness) without feature_journey taking a
/// dependency on a specific state-management library.
class JourneyStepScreen extends StatelessWidget {
  const JourneyStepScreen({
    super.key,
    required this.state,
    this.onAdvance,
    this.onConfirmBooking,
    this.onSimulateDisruption,
    this.onAcceptFallback,
    this.onCompleteJourney,
  });

  /// Current orchestrator state. `null` renders a loading indicator.
  final JourneyState? state;

  /// Invoked when the user taps the "next phase" action.
  /// When `null`, the action is disabled (e.g. final phase reached
  /// or the enclosing shell cannot yet advance).
  final VoidCallback? onAdvance;
  final VoidCallback? onConfirmBooking;
  final VoidCallback? onSimulateDisruption;
  final VoidCallback? onAcceptFallback;
  final VoidCallback? onCompleteJourney;

  bool get _canAdvance {
    final current = state;
    if (current == null) {
      return false;
    }
    if (current.currentPhase == JourneyPhase.optimization) {
      return false;
    }
    return onAdvance != null;
  }

  @override
  Widget build(BuildContext context) {
    final current = state;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F4),
      appBar: AppBar(
        title: const Text('emma Orchestrator'),
        actions: [
          TextButton.icon(
            onPressed: _canAdvance ? onAdvance : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Naechste Phase'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: current == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _MvpActionBar(
                  state: current,
                  onConfirmBooking: onConfirmBooking,
                  onSimulateDisruption: onSimulateDisruption,
                  onAcceptFallback: onAcceptFallback,
                  onCompleteJourney: onCompleteJourney,
                ),
                Expanded(
                  child: JourneyStepWidget(
                    state: current,
                    onConfirmBooking: onConfirmBooking,
                  ),
                ),
              ],
            ),
    );
  }
}

class _MvpActionBar extends StatelessWidget {
  const _MvpActionBar({
    required this.state,
    required this.onConfirmBooking,
    required this.onSimulateDisruption,
    required this.onAcceptFallback,
    required this.onCompleteJourney,
  });

  final JourneyState state;
  final VoidCallback? onConfirmBooking;
  final VoidCallback? onSimulateDisruption;
  final VoidCallback? onAcceptFallback;
  final VoidCallback? onCompleteJourney;

  @override
  Widget build(BuildContext context) {
    final status = state.context['journey_status']?.toString();
    final phase = state.currentPhase;

    final actions = <Widget>[
      if (phase == JourneyPhase.transaction && status != 'booked')
        FilledButton.icon(
          key: const Key('journey-mvp-confirm-booking'),
          onPressed: onConfirmBooking,
          icon: const Icon(Icons.confirmation_number_outlined),
          label: const Text('Mock buchen'),
        ),
      if (phase == JourneyPhase.activeMonitoring)
        FilledButton.icon(
          key: const Key('journey-mvp-simulate-disruption'),
          onPressed: onSimulateDisruption,
          icon: const Icon(Icons.warning_amber_rounded),
          label: const Text('Stoerfall simulieren'),
        ),
      if (phase == JourneyPhase.crisisManagement)
        FilledButton.icon(
          key: const Key('journey-mvp-accept-fallback'),
          onPressed: onAcceptFallback,
          icon: const Icon(Icons.route_outlined),
          label: const Text('Fallback annehmen'),
        ),
      if ((phase == JourneyPhase.activeMonitoring ||
              phase == JourneyPhase.optimization) &&
          status != 'completed')
        FilledButton.icon(
          key: const Key('journey-mvp-complete'),
          onPressed: onCompleteJourney,
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Abschliessen'),
        ),
    ];

    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Wrap(spacing: 8, runSpacing: 8, children: actions),
        ),
      ),
    );
  }
}
