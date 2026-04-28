import 'package:domain_rules/domain_rules.dart';
import 'package:emma_contracts/emma_contracts.dart';

import 'package:fake_tariff/fixtures/mdv_mvp_v1.dart';

/// Lokal deterministische Tarif-Implementierung (M11) aus YAML-String + Engine.
class FakeTariffAdapter implements TariffPort {
  FakeTariffAdapter({String? fixtureYaml})
    : _engine = TariffEngine(
        loadTariffRuleSetYaml(fixtureYaml ?? kMdvMvpV1FixtureYaml),
      ) {
    _catalog = loadTariffCatalogYaml(fixtureYaml ?? kMdvMvpV1FixtureYaml);
  }

  final TariffEngine _engine;
  late final List<TariffCatalogEntry> _catalog;

  @override
  Future<TariffQuote?> quote({
    required String originStationId,
    required String destinationStationId,
    required DateTime departureAt,
    String? passengerClass,
  }) async {
    final r = _engine.quote(
      originStationId: originStationId,
      destinationStationId: destinationStationId,
      departureAt: departureAt,
      passengerClass: passengerClass,
    );
    if (r == null) {
      return null;
    }
    return _mapResult(r);
  }

  @override
  Future<List<TariffProduct>> listProducts({required String zoneId}) async {
    final rows = _engine.listProductsForZone(zoneId);
    return rows
        .map(
          (e) => TariffProduct(
            productCode: e.productCode,
            zoneId: e.zoneId,
            priceEuroCents: e.priceEuroCents,
            label: e.label,
          ),
        )
        .toList();
  }

  @override
  Future<List<TariffRule>> getAvailableTariffs() async {
    return _catalog
        .map(
          (c) => TariffRule(
            id: c.id,
            name: c.name,
            price: c.price,
            entitlements: c.entitlements,
            isSubscription: c.isSubscription,
          ),
        )
        .toList();
  }

  TariffQuote _mapResult(TariffQuoteResult r) {
    return TariffQuote(
      priceEuroCents: r.priceEuroCents,
      currency: r.currency,
      productCode: r.productCode,
      zoneFrom: r.zoneFrom,
      zoneTo: r.zoneTo,
      validFrom: r.validFrom,
      validTo: r.validTo,
      ruleTrace: r.ruleTrace,
      isFallback: r.isFallback,
      priceSourceKind: PriceSourceKind.emmaRuleEngine,
      ruleSetVersion: r.ruleSetVersion,
      fixtureBundleId: r.fixtureBundleId,
      operatorId: r.operatorId,
      passengerClass: r.passengerClass,
    );
  }
}
