import 'package:domain_ticketing/domain_ticketing.dart';

/// In-memory Katalog + deterministischer Demo-Kauf (kein PSP).
class FakeTicketingRepository implements TicketingRepository {
  FakeTicketingRepository();

  static const List<TicketProduct> _catalog = <TicketProduct>[
    TicketProduct(
      id: 'prod-dt-001',
      name: 'Deutschlandticket (Demo)',
      description: 'Monatskarte, gueltig im oeffentlichen Nahverkehr (Fake).',
      priceCents: 5800,
    ),
    TicketProduct(
      id: 'prod-reg-002',
      name: 'Verbundticket Region (Demo)',
      description: 'Tarifgebiet Mitteldeutschland, 1 Monat (Fake).',
      priceCents: 8900,
    ),
    TicketProduct(
      id: 'prod-bike-003',
      name: 'Bike-Sharing Tagespass (Demo)',
      description: 'Partner A, unbegrenzte Fahrten 24h (Fake).',
      priceCents: 1299,
    ),
    TicketProduct(
      id: 'prod-park-004',
      name: 'Parken City (Demo)',
      description: 'Tagesparkschein Zone Innenstadt (Fake).',
      priceCents: 850,
    ),
    TicketProduct(
      id: 'prod-onde-005',
      name: 'On-Demand Guthaben (Demo)',
      description: 'Guthaben fuer spontane Fahrten (Fake).',
      priceCents: 2500,
    ),
  ];

  int _seq = 0;
  static final DateTime _basePurchasedAt = DateTime.utc(2026, 4, 24, 8);

  @override
  Future<List<TicketProduct>> listProducts() async => _catalog;

  @override
  Future<TicketPurchaseResult> purchase(String productId) async {
    for (final p in _catalog) {
      if (p.id == productId) {
        _seq += 1;
        return TicketPurchaseResult(
          receiptId: 'rcpt-demo-$_seq',
          productId: productId,
          purchasedAt: _basePurchasedAt.add(Duration(minutes: _seq)),
        );
      }
    }
    throw StateError('Unknown product: $productId');
  }
}
