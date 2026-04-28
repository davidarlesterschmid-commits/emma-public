/// Single price line within a [FareDecision].
class FareDecisionLineItem {
  const FareDecisionLineItem({
    required this.label,
    required this.amountEuro,
    required this.source,
  });

  final String label;
  final double amountEuro;
  final String source;

  Map<String, dynamic> toJson() {
    return {'label': label, 'amount_euro': amountEuro, 'source': source};
  }
}

/// Outcome of evaluating tariffs, employer benefits and entitlements
/// for a single selected travel option.
class FareDecision {
  const FareDecision({
    required this.decisionId,
    required this.journeyId,
    required this.applicableProducts,
    required this.entitlementsUsed,
    required this.priceBreakdown,
    required this.budgetImpactEuro,
    required this.ruleVersion,
    required this.decisionStatus,
    this.tariffProductCode,
    this.tariffPriceEuroCents,
    this.tariffRuleTrace,
    this.tariffIsFallback,
  });

  final String decisionId;
  final String journeyId;
  final List<String> applicableProducts;
  final List<String> entitlementsUsed;
  final List<FareDecisionLineItem> priceBreakdown;
  final double budgetImpactEuro;
  final String ruleVersion;
  final String decisionStatus;
  /// M11: Produktcode aus Tarif-Engine, falls ermittelt.
  final String? tariffProductCode;
  /// M11: Preis in Cent (kein double-Geldbetrag).
  final int? tariffPriceEuroCents;
  final List<String>? tariffRuleTrace;
  final bool? tariffIsFallback;

  double get totalPriceEuro =>
      priceBreakdown.fold(0, (sum, item) => sum + item.amountEuro);

  Map<String, dynamic> toJson() {
    return {
      'decision_id': decisionId,
      'journey_id': journeyId,
      'applicable_products': applicableProducts,
      'entitlements_used': entitlementsUsed,
      'price_breakdown': priceBreakdown.map((item) => item.toJson()).toList(),
      'budget_impact_euro': budgetImpactEuro,
      'rule_version': ruleVersion,
      'decision_status': decisionStatus,
      'total_price_euro': totalPriceEuro,
      'tariff_product_code': tariffProductCode,
      'tariff_price_euro_cents': tariffPriceEuroCents,
      'tariff_rule_trace': tariffRuleTrace,
      'tariff_is_fallback': tariffIsFallback,
    };
  }
}
