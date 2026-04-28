import 'package:meta/meta.dart';

/// Geparstes YAML-Regelwerk (M11 Fixture).
@immutable
class TariffRuleSet {
  const TariffRuleSet({
    required this.ruleSetVersion,
    required this.fixtureBundleId,
    required this.fallback,
    required this.stationZones,
    required this.pairs,
  });

  final String ruleSetVersion;
  final String fixtureBundleId;
  final TariffPairFallback fallback;
  final Map<String, String> stationZones;
  final List<TariffPairRule> pairs;
}

@immutable
class TariffPairFallback {
  const TariffPairFallback({
    required this.productCode,
    required this.priceEuroCents,
    required this.currency,
  });

  final String productCode;
  final int priceEuroCents;
  final String currency;
}

@immutable
class TariffPairRule {
  const TariffPairRule({
    required this.id,
    required this.zoneFrom,
    required this.zoneTo,
    required this.productCode,
    required this.priceEuroCents,
    required this.currency,
    this.passengerClasses,
  });

  final String id;
  final String zoneFrom;
  final String zoneTo;
  final String productCode;
  final int priceEuroCents;
  final String currency;
  /// Wenn leer: gilt fuer alle Klassen.
  final Set<String>? passengerClasses;
}

@immutable
class TariffCatalogEntry {
  const TariffCatalogEntry({
    required this.id,
    required this.name,
    required this.price,
    required this.entitlements,
    required this.isSubscription,
  });

  final String id;
  final String name;
  final double price;
  final List<String> entitlements;
  final bool isSubscription;
}
