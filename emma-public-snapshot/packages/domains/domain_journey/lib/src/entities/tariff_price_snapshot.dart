/// Abstraktion des M11-Tarifergebnisses innerhalb [domain_journey] (kein emma_contracts-Import).
class TariffPriceSnapshot {
  const TariffPriceSnapshot({
    required this.priceEuroCents,
    required this.productCode,
    required this.ruleTrace,
    required this.isFallback,
    required this.ruleSetVersion,
    this.fixtureBundleId,
  });

  final int priceEuroCents;
  final String productCode;
  final List<String> ruleTrace;
  final bool isFallback;
  final String ruleSetVersion;
  final String? fixtureBundleId;
}
