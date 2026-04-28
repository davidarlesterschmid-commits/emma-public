/// Engine-Ausgabe (reines `domain_rules`-Modell; Adapter mappen auf `emma_contracts`).
class TariffQuoteResult {
  const TariffQuoteResult({
    required this.priceEuroCents,
    required this.currency,
    required this.productCode,
    required this.zoneFrom,
    required this.zoneTo,
    required this.validFrom,
    required this.validTo,
    required this.ruleTrace,
    required this.isFallback,
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
  final String ruleSetVersion;
  final String fixtureBundleId;
  final String? operatorId;
  final String? passengerClass;
}

/// Produktzeile aus dem Regelkatalog.
class TariffProductRow {
  const TariffProductRow({
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
