import 'package:domain_ticketing/src/entities/ticket_product.dart' show
    TicketProduct, TicketPurchaseResult;

/// Lesen und simulierter Kauf (ohne PSP im MVP-Default).
abstract interface class TicketingRepository {
  Future<List<TicketProduct>> listProducts();

  Future<TicketPurchaseResult> purchase(String productId);
}
