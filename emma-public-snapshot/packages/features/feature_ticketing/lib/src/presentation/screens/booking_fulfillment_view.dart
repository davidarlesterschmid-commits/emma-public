import 'package:domain_ticketing/domain_ticketing.dart';
import 'package:feature_ticketing/src/presentation/widgets/booking_summary_card.dart';
import 'package:flutter/material.dart';

class BookingFulfillmentView extends StatelessWidget {
  const BookingFulfillmentView({
    super.key,
    required this.bundle,
    required this.status,
    this.onConfirm,
  });

  final BookingBundle bundle;
  final String status;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BookingSummaryCard(bundle: bundle),
        const SizedBox(height: 20),
        if (status != 'booked') ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Rechtlicher Hinweis',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Mit dem Klick auf "Jetzt zahlungspflichtig buchen" gehen Sie einen verbindlichen Kaufvertrag ein.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onConfirm,
            icon: const Icon(Icons.shopping_cart_checkout),
            label: const Text('Jetzt zahlungspflichtig buchen'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ] else ...[
          Card(
            color: Colors.green.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 12),
                  Text(
                    'Buchung erfolgreich abgeschlossen',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
