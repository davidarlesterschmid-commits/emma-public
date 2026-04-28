import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:emma_app/core/journey_providers.dart';

class CustomerServiceScreen extends ConsumerWidget {
  const CustomerServiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supportCases = ref.watch(supportCasesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Customer Service')),
      body: supportCases.isEmpty
          ? const Center(
              child: Text(
                'Keine offenen Supportfaelle im aktuellen Journey-Kontext.',
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: supportCases.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = supportCases[index];
                return Card(
                  child: ListTile(
                    title: Text(item.reasonCode),
                    subtitle: Text(
                      'Quelle: ${item.sourceModule}\n'
                      'Status: ${item.caseStatus}\n'
                      'Severity: ${item.severity}',
                    ),
                    isThreeLine: true,
                    trailing: Text(item.caseId),
                  ),
                );
              },
            ),
    );
  }
}
