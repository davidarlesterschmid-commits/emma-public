import 'package:domain_wallet/domain_wallet.dart';
import 'package:flutter/material.dart';

/// Kundensicht auf das aktuelle Mobilitätsbudget.
///
/// [isLoading] / [error] / [budget] spiegeln z. B. `AsyncValue` aus
/// Riverpod wider — die App-Shell mappt [Ref.watch] darauf, ohne
/// `flutter_riverpod` in diesem Paket zu benötigen.
class BudgetDashboard extends StatelessWidget {
  const BudgetDashboard({
    super.key,
    required this.isLoading,
    this.budget,
    this.error,
  });

  final bool isLoading;
  final Object? error;
  final MobilityBudget? budget;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (error != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(child: Text('Fehler beim Laden: $error')),
      );
    }
    final b = budget;
    if (b == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text('Kein Budget geladen.')),
      );
    }

    final percentage = b.totalBudget == 0 ? 0.0 : b.usedAmount / b.totalBudget;
    final remaining = b.remainingAmount;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mobilitätsbudget',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verbleibendes Budget',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${remaining.toStringAsFixed(2)} €',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Genutzt / Gesamt',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${b.usedAmount.toStringAsFixed(2)} € / ${b.totalBudget.toStringAsFixed(2)} €',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: percentage.clamp(0.0, 1.0),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Abrechnungszeitraum: ${b.billingPeriodStart.toString().split(' ')[0]} bis ${b.billingPeriodEnd.toString().split(' ')[0]}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
