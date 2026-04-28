import 'package:flutter/material.dart';

import 'package:emma_contracts/emma_contracts.dart';

class TripLegCard extends StatelessWidget {
  final EmmaLeg leg;

  const TripLegCard({super.key, required this.leg});

  @override
  Widget build(BuildContext context) {
    final title = leg.line?.shortName ?? leg.mode;
    final subtitle =
        '${leg.origin.name} → ${leg.destination?.name ?? 'Unbekannt'}';

    return ListTile(
      leading: Icon(
        leg.mode == 'walk' ? Icons.directions_walk : Icons.directions_transit,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
