import 'package:domain_employer_mobility/domain_employer_mobility.dart';
import 'package:flutter/material.dart';

/// Liste der Arbeitgeber-Benefits.
///
/// Lade- und Fehlerzustand werden explizit übergeben (App-Shell mappt
/// z. B. [AsyncValue]).
class BenefitWallet extends StatelessWidget {
  const BenefitWallet({
    super.key,
    required this.isLoading,
    this.benefits,
    this.error,
  });

  final bool isLoading;
  final List<Benefit>? benefits;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(child: Text('Fehler: $error'));
    }
    final list = benefits;
    if (list == null || list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('Keine Benefits verfügbar.')),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) => _BenefitCard(benefit: list[index]),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({required this.benefit});

  final Benefit benefit;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        benefit.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        benefit.partnerName,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                if (benefit.isInBudget)
                  const Chip(
                    label: Text(
                      'Im Budget',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    backgroundColor: Colors.green,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              benefit.description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (benefit.deepLink != null)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text('Öffnen'),
                    onPressed: () {
                      // TODO(emma-partnerhub): echten Deeplink-Launcher anschließen.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Öffne: ${benefit.deepLink}')),
                      );
                    },
                  ),
                if (benefit.voucherCode != null) ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Code: ${benefit.voucherCode}'),
                          action: SnackBarAction(
                            label: 'Kopieren',
                            onPressed: () {},
                          ),
                        ),
                      );
                    },
                    child: const Text('Code anzeigen'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
