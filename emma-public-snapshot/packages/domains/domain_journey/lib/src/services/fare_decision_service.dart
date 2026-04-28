import 'package:domain_journey/src/entities/fare_decision.dart';
import 'package:domain_journey/src/entities/tariff_price_snapshot.dart';
import 'package:domain_journey/src/entities/travel_option.dart';
import 'package:domain_journey/src/entities/user_intent.dart';
import 'package:domain_rules/domain_rules.dart';
import 'package:domain_wallet/domain_wallet.dart';

/// Baut die [FareDecision] fuer eine ausgewaehlte Route.
///
/// Bewertet verfuegbare Bestandstarife (ueber [TariffRule]-Entitlements),
/// rechnet das Arbeitgeberbudget ([MobilityBudget]) ein und bestimmt den
/// Decision-Status. Pure Domain-Logik ohne Port- oder UI-Abhaengigkeiten.
class FareDecisionService {
  const FareDecisionService();

  FareDecision buildDecision({
    required String journeyId,
    required TravelOption selectedOption,
    required UserIntent userIntent,
    required List<TariffRule> availableTariffs,
    required MobilityBudget mobilityBudget,
    TariffPriceSnapshot? tariffPrice,
  }) {
    final applicableTariffs = availableTariffs
        .where(
          (rule) => rule.entitlements.any(
            (item) {
              final u = item.toUpperCase();
              return u.contains('OEPNV') || u.contains('PNV') || item.contains('ÖPNV');
            },
          ),
        )
        .toList();
    final hasBudget = mobilityBudget.remainingAmount > 0;
    final employerContribution = hasBudget ? 0.50 : 0.0;
    final quoteEuro = (tariffPrice != null) ? (tariffPrice.priceEuroCents / 100.0) : null;
    final grossTicketPrice = quoteEuro ?? selectedOption.estimatedCostEuro;
    final netBudgetImpact = (grossTicketPrice - employerContribution).clamp(
      0.0,
      grossTicketPrice,
    );

    return FareDecision(
      decisionId: 'fare-$journeyId',
      journeyId: journeyId,
      applicableProducts: [
        ...applicableTariffs.map((rule) => rule.name),
        if (tariffPrice != null) tariffPrice.productCode,
        'Anschlussticket',
      ],
      entitlementsUsed: [
        if (applicableTariffs.isNotEmpty) applicableTariffs.first.name,
        if (hasBudget) 'Arbeitgeberbudget',
        userIntent.tripPurpose,
      ],
      priceBreakdown: [
        FareDecisionLineItem(
          label: 'Ticketpreis',
          amountEuro: grossTicketPrice,
          source: tariffPrice != null ? 'tariff_m11' : 'selected_option',
        ),
        if (employerContribution > 0)
          FareDecisionLineItem(
            label: 'Arbeitgeberzuschuss',
            amountEuro: -employerContribution,
            source: 'mobility_budget',
          ),
      ],
      budgetImpactEuro: netBudgetImpact,
      ruleVersion: tariffPrice?.ruleSetVersion ?? 'tariff.v2.local',
      decisionStatus: hasBudget ? 'APPROVED' : 'REVIEW_REQUIRED',
      tariffProductCode: tariffPrice?.productCode,
      tariffPriceEuroCents: tariffPrice?.priceEuroCents,
      tariffRuleTrace: tariffPrice?.ruleTrace,
      tariffIsFallback: tariffPrice?.isFallback,
    );
  }
}
