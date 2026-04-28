import 'package:domain_ticketing/domain_ticketing.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketProductTile extends StatelessWidget {
  const TicketProductTile({
    super.key,
    required this.product,
    this.isPurchasing = false,
    this.onPurchase,
  });

  final TicketProduct product;
  final bool isPurchasing;
  final VoidCallback? onPurchase;

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat.currency(locale: 'de_DE', symbol: '€');

    return Semantics(
      label: 'Produkt ${product.name}, ${money.format(product.priceCents / 100)}',
      button: true,
      child: ListTile(
        title: Text(product.name),
        subtitle: Text(product.description),
        trailing: isPurchasing
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : FilledButton(
                onPressed: onPurchase,
                child: Text(
                  money.format(product.priceCents / 100),
                ),
              ),
      ),
    );
  }
}
