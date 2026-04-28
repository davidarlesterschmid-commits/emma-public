import 'package:flutter/material.dart';

import 'package:emma_app/features/tariff_rules/domain/entities/tariff_rule.dart';

class TariffCard extends StatelessWidget {
  final TariffRule rule;

  const TariffCard({super.key, required this.rule});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(rule.name),
        subtitle: Text('${rule.price}€'),
        trailing: ElevatedButton(
          onPressed: () {
            // Buy tariff
          },
          child: const Text('Kaufen'),
        ),
      ),
    );
  }
}
