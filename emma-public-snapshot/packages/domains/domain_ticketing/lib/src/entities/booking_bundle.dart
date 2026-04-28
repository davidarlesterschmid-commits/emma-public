import 'package:domain_ticketing/src/ticketing_process.dart';

/// Represents a bundle of ticketing items for a complete journey.
class BookingBundle {
  const BookingBundle({
    required this.bundleId,
    required this.journeyId,
    required this.items,
    required this.totalPriceEuroCents,
    required this.currency,
  });

  final String bundleId;
  final String journeyId;
  final List<TicketingLineItem> items;
  final int totalPriceEuroCents;
  final String currency;

  double get totalPriceEuro => totalPriceEuroCents / 100.0;
}
