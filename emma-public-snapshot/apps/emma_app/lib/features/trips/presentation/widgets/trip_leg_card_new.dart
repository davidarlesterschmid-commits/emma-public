import 'package:flutter/material.dart';

import 'package:emma_app/features/trips/domain/entities/trip.dart';

class TripLegCard extends StatelessWidget {
  final TripLeg leg;

  const TripLegCard({super.key, required this.leg});

  IconData _getModeIcon(String mode) {
    switch (mode) {
      case 'walk':
        return Icons.directions_walk;
      case 'bus':
        return Icons.directions_bus;
      case 'train':
        return Icons.train;
      case 'car':
        return Icons.directions_car;
      case 'bike':
        return Icons.directions_bike;
      default:
        return Icons.directions_transit;
    }
  }

  Color _getModeColor(String mode) {
    switch (mode) {
      case 'walk':
        return Colors.green;
      case 'bus':
        return Colors.blue;
      case 'train':
        return Colors.red;
      case 'car':
        return Colors.orange;
      case 'bike':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getModeColor(leg.mode).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getModeColor(leg.mode).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getModeIcon(leg.mode),
            color: _getModeColor(leg.mode),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        leg.line ?? leg.mode.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (leg.provider != null)
                      Text(
                        leg.provider!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${leg.from} → ${leg.to}',
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${leg.departureTime.hour}:${leg.departureTime.minute.toString().padLeft(2, '0')} - ${leg.arrivalTime.hour}:${leg.arrivalTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${leg.duration.inMinutes} min',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (leg.cost != null && leg.cost! > 0)
            Text(
              '€${leg.cost!.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
        ],
      ),
    );
  }
}
