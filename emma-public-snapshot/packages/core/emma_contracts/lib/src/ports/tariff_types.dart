// Tariff- und Preistypen fuer M11 (Lese-Pfad). Kein double fuer Geldbetraege.

/// Herkunft der Preisermittlung (MVP-Entscheid, siehe MVP_PRODUCT_DECISIONS).
enum PriceSourceKind {
  /// emma-Regelwerk / `domain_rules` + Fixture
  emmaRuleEngine,

  /// VVU- oder Dienstleister-Publikationspreis (Fixture, nicht live API)
  operatorPublished,
}

/// Einzelpreis-Auskunft gemaess SPECS_MVP M11 §3.
class TariffQuote {
  const TariffQuote({
    required this.priceEuroCents,
    required this.currency,
    required this.productCode,
    required this.zoneFrom,
    required this.zoneTo,
    required this.validFrom,
    required this.validTo,
    required this.ruleTrace,
    required this.isFallback,
    required this.priceSourceKind,
    required this.ruleSetVersion,
    required this.fixtureBundleId,
    this.operatorId,
    this.passengerClass,
  });

  final int priceEuroCents;
  final String currency;
  final String productCode;
  final String zoneFrom;
  final String zoneTo;
  final DateTime validFrom;
  final DateTime validTo;
  final List<String> ruleTrace;
  final bool isFallback;
  final PriceSourceKind priceSourceKind;
  /// MVP: feste Regelwerks-Version (z. B. YAML-`rule_set_version`).
  final String ruleSetVersion;
  final String fixtureBundleId;
  final String? operatorId;
  final String? passengerClass;
}

/// Produkt im Sinne „Tarifprodukt pro Zone“ (Liste/Anzeige).
class TariffProduct {
  const TariffProduct({
    required this.productCode,
    required this.zoneId,
    required this.priceEuroCents,
    required this.label,
  });

  final String productCode;
  final String zoneId;
  final int priceEuroCents;
  final String label;
}

/// Keine passende Regel / Fixture-Fehler (optional, Engine kann null stattdessen).
class TariffException implements Exception {
  TariffException(this.message);

  final String message;

  @override
  String toString() => 'TariffException: $message';
}
