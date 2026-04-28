import 'package:domain_partnerhub/domain_partnerhub.dart';

class FakePartnerCatalogPort implements PartnerCatalogPort {
  const FakePartnerCatalogPort();

  @override
  Future<PartnerCatalogSnapshot> loadCatalog() async {
    return PartnerCatalogSnapshot(
      partners: <PartnerProfile>[
        PartnerProfile(partnerId: 'partner-demo-bike', name: 'Demo Bike'),
      ],
      status: PartnerStatus.simulationOnly,
      gateNote: 'Echte Partner-APIs Gate erforderlich / nicht implementiert',
    );
  }
}
