import 'package:emma_app/features/prep_e2e/presentation/models/routing_option_dummy.dart';
import 'package:flutter/material.dart';

/// E2E: Auswahl-UI mit festen Beispielwerten, keine Tarif- oder Routing-Berechnung.
class PrepE2eRoutingOptionsScreen extends StatelessWidget {
  const PrepE2eRoutingOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verbindungswahl (Demo)'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: kRoutingOptionDummies.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final o = kRoutingOptionDummies[index];
          return _RoutingOptionTile(
            option: o,
            onSelect: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Nur UI — gewählt: ${o.label}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _RoutingOptionTile extends StatelessWidget {
  const _RoutingOptionTile({required this.option, required this.onSelect});

  final RoutingOptionDummy option;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                option.label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule, size: 18, color: scheme.primary),
                  const SizedBox(width: 6),
                  Text(option.durationLabel),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.payments_outlined, size: 18, color: scheme.primary),
                  const SizedBox(width: 6),
                  Text(option.priceLabel),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                option.comfortLabel,
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
