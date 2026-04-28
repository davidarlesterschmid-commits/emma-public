import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:emma_app/features/tariff_rules/presentation/providers/tariff_provider.dart';
import 'package:emma_app/features/tariff_rules/presentation/widgets/tariff_card.dart';

class TariffScreen extends ConsumerWidget {
  const TariffScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tariffsAsync = ref.watch(availableTariffsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tarife')),
      body: tariffsAsync.when(
        data: (tariffs) => ListView(
          children: tariffs.map((rule) => TariffCard(rule: rule)).toList(),
        ),
        loading: () => const CircularProgressIndicator(),
        error: (err, _) => Text('Error: $err'),
      ),
    );
  }
}
