import 'package:domain_rules/domain_rules.dart';

class FakeProductCatalogPort implements ProductCatalogPort {
  const FakeProductCatalogPort();

  @override
  Future<List<ProductCatalogProduct>> listProducts() async {
    return const <ProductCatalogProduct>[
      ProductCatalogProduct(
        id: 'single-trip-demo',
        label: 'Einzelfahrt Demo',
        status: ProductCatalogStatus.simulationOnly,
        gateNote: 'Produktkatalog ist Fake-First und ohne Tarifserver',
      ),
      ProductCatalogProduct(
        id: 'subscription-demo',
        label: 'Abo/D-Ticket Demo',
        status: ProductCatalogStatus.gateRequired,
        gateNote:
            'Abo-/CiCo-Vertragslogik Gate erforderlich / nicht implementiert',
      ),
    ];
  }
}
