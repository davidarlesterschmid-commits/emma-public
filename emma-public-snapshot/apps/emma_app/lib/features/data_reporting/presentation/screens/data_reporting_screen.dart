import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:emma_app/core/journey_providers.dart';

class DataReportingScreen extends ConsumerWidget {
  const DataReportingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportingEvents = ref.watch(reportingEventsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Data & Reporting')),
      body: reportingEvents.isEmpty
          ? const Center(
              child: Text('Noch keine Betriebsereignisse verfuegbar.'),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: reportingEvents.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = reportingEvents[index];
                return Card(
                  child: ListTile(
                    title: Text(item.eventType),
                    subtitle: Text(
                      'Modul: ${item.module}\n'
                      'Severity: ${item.severity}\n'
                      'Zeit: ${item.occurredAt.toLocal()}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
