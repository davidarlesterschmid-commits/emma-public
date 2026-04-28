import 'package:domain_journey/domain_journey.dart';
import 'package:flutter/material.dart';

import 'package:feature_journey/src/presentation/widgets/travel_leg_row.dart';

/// Zeigt eine einzelne [TravelOption] als tippbare Karte in der Such-
/// ergebnisliste.
///
/// Pflichtfeld-nahe Darstellung: Ankunftszeit, Gesamtdauer, Preis,
/// Verlässlichkeit, Mobilitätsgarantie-Eignung. Legs werden kompakt
/// als [TravelLegRow]-Stack untereinander gerendert.
class TravelOptionCard extends StatelessWidget {
  const TravelOptionCard({super.key, required this.option, this.onTap});

  final TravelOption option;
  final VoidCallback? onTap;

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ankunft ${_formatTime(option.estimatedArrival)}',
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    '${option.estimatedDurationMinutes} min',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...option.legs.map((leg) => TravelLegRow(leg: leg)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _MetricChip(
                    label: 'Verlässlichkeit',
                    value: '${(option.reliabilityScore * 100).round()} %',
                  ),
                  _MetricChip(
                    label: 'Garantie-Eignung',
                    value: '${(option.guaranteeScore * 100).round()} %',
                  ),
                  Text(
                    '€${option.estimatedCostEuro.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

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
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
