import 'package:domain_journey/domain_journey.dart';
import 'package:flutter/material.dart';

/// Kompakte Darstellung einer einzelnen [TravelLeg].
///
/// Bewusst schlank gehalten: Icon pro Modus, Provider-Label,
/// Origin → Destination. Keine Zeit-/Preis-Details — die aggregierten
/// Werte liegen auf [TravelOption] und werden dort gerendert.
class TravelLegRow extends StatelessWidget {
  const TravelLegRow({super.key, required this.leg});

  final TravelLeg leg;

  IconData get _modeIcon {
    switch (leg.mode.toLowerCase()) {
      case 'walk':
      case 'foot':
        return Icons.directions_walk;
      case 'bus':
        return Icons.directions_bus;
      case 'train':
      case 'rail':
        return Icons.train;
      case 'tram':
        return Icons.tram;
      case 'bike':
      case 'bicycle':
        return Icons.directions_bike;
      case 'car':
        return Icons.directions_car;
      default:
        return Icons.swap_horiz;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_modeIcon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leg.provider,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${leg.originLabel} → ${leg.destinationLabel}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
