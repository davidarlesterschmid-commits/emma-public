import 'package:meta/meta.dart';

/// Ticket-/Produktkatalogzeile (MVP, Anzeige + Demo-Kauf).
@immutable
class TicketProduct {
  const TicketProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.priceCents,
    this.currency = 'EUR',
  });

  final String id;
  final String name;
  final String description;
  final int priceCents;
  final String currency;
}

@immutable
class TicketPurchaseResult {
  const TicketPurchaseResult({
    required this.receiptId,
    required this.productId,
    required this.purchasedAt,
  });

  final String receiptId;
  final String productId;
  final DateTime purchasedAt;
}
