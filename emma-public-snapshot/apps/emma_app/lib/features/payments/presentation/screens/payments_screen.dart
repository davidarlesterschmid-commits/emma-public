import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:emma_app/core/journey_providers.dart';

class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journeyCase = ref.watch(journeyCaseProvider);
    final paymentIntent = journeyCase?.paymentIntent;

    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: paymentIntent == null
          ? const Center(child: Text('Kein Payment Intent verfuegbar.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: ListTile(
                    title: Text(
                      'Payment Intent ${paymentIntent.paymentIntentId}',
                    ),
                    subtitle: Text(
                      'Status: ${paymentIntent.paymentStatus}\n'
                      'Gesamt: ${paymentIntent.amountTotalEuro.toStringAsFixed(2)} EUR\n'
                      'Handoff: ${paymentIntent.handoffRequired ? 'wartet auf externen Zahlungsadapter' : 'intern abschliessbar'}',
                    ),
                    isThreeLine: true,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    title: const Text('Kostensplit'),
                    subtitle: Text(
                      'Privat: ${paymentIntent.amountPrivateEuro.toStringAsFixed(2)} EUR\n'
                      'Arbeitgeber: ${paymentIntent.amountEmployerEuro.toStringAsFixed(2)} EUR\n'
                      'Methode: ${paymentIntent.paymentMethodRef}',
                    ),
                    isThreeLine: true,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          paymentIntent.receiptDraft.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...paymentIntent.receiptDraft.lineItems.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(item),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
