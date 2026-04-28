import 'package:domain_partnerhub/src/entities/partner_profile.dart';

enum PartnerStatus { simulationOnly, gateRequired }

class PartnerCatalogSnapshot {
  const PartnerCatalogSnapshot({
    required this.partners,
    required this.status,
    required this.gateNote,
  });

  final List<PartnerProfile> partners;
  final PartnerStatus status;
  final String gateNote;
}

abstract interface class PartnerCatalogPort {
  Future<PartnerCatalogSnapshot> loadCatalog();
}
