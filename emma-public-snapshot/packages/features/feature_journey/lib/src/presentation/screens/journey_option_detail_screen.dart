import 'package:domain_journey/domain_journey.dart';
import 'package:flutter/material.dart';

import 'package:feature_journey/src/presentation/widgets/travel_leg_row.dart';

/// Detail-Ansicht einer in [JourneySearchScreen] gewaehlten
/// [TravelOption].
///
/// Bewusst Riverpod-frei und read-only — zeigt aggregierte Metriken
/// (Dauer, Ankunft, Kosten, Verlaesslichkeit, Garantie-Eignung),
/// Anbieter-Liste und Legs. Keine Buchungslogik; ein Bestaetigen-
/// Button ist als Slot vorgesehen (per [onConfirm]), aktuell rein
/// optisch. Die Buchungs-Phase (Phase 2/3 der Journey) wandert in ein
/// eigenes Inkrement.
class JourneyOptionDetailScreen extends StatelessWidget {
  const JourneyOptionDetailScreen({
    super.key,
    required this.option,
    this.onConfirm,
  });

  final TravelOption option;
  final VoidCallback? onConfirm;

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Verbindung')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Ankunft ${_formatTime(option.estimatedArrival)}',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            '${option.estimatedDurationMinutes} Minuten — '
            '€${option.estimatedCostEuro.toStringAsFixed(2)}',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          _MetricsRow(option: option),
          const SizedBox(height: 24),
          Text('Abschnitte', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ...option.legs.map((leg) => TravelLegRow(leg: leg)),
          const SizedBox(height: 24),
          Text('Anbieter', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: option.providerCandidates
                .map((p) => Chip(label: Text(p)))
                .toList(),
          ),
          const SizedBox(height: 24),
          if (option.requiresPartnerBooking)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Diese Verbindung erfordert eine Partner-Buchung.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              key: const Key('journey-option-detail-confirm'),
              onPressed: onConfirm,
              child: const Text('Verbindung auswaehlen'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsRow extends StatelessWidget {
  const _MetricsRow({required this.option});

  final TravelOption option;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Metric(
          label: 'Verlaesslichkeit',
          value: '${(option.reliabilityScore * 100).round()} %',
        ),
        _Metric(
          label: 'Garantie-Eignung',
          value: '${(option.guaranteeScore * 100).round()} %',
        ),
        _Metric(
          label: 'Budget-passend',
          value: option.budgetCompatible ? 'ja' : 'nein',
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
