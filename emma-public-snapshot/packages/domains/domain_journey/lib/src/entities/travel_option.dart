class TravelLeg {
  const TravelLeg({
    required this.mode,
    required this.provider,
    required this.originLabel,
    required this.destinationLabel,
  });

  final String mode;
  final String provider;
  final String originLabel;
  final String destinationLabel;

  Map<String, dynamic> toJson() {
    return {
      'mode': mode,
      'provider': provider,
      'origin_label': originLabel,
      'destination_label': destinationLabel,
    };
  }
}

class TravelOption {
  const TravelOption({
    required this.optionId,
    required this.legs,
    required this.providerCandidates,
    required this.estimatedArrival,
    required this.estimatedDurationMinutes,
    required this.estimatedCostEuro,
    required this.reliabilityScore,
    required this.guaranteeScore,
    required this.budgetCompatible,
    required this.requiresPartnerBooking,
  });

  final String optionId;
  final List<TravelLeg> legs;
  final List<String> providerCandidates;
  final DateTime estimatedArrival;
  final int estimatedDurationMinutes;
  final double estimatedCostEuro;
  final double reliabilityScore;
  final double guaranteeScore;
  final bool budgetCompatible;
  final bool requiresPartnerBooking;

  Map<String, dynamic> toJson() {
    return {
      'option_id': optionId,
      'legs': legs.map((leg) => leg.toJson()).toList(),
      'provider_candidates': providerCandidates,
      'estimated_arrival': estimatedArrival.toIso8601String(),
      'estimated_duration_minutes': estimatedDurationMinutes,
      'estimated_cost_euro': estimatedCostEuro,
      'reliability_score': reliabilityScore,
      'guarantee_score': guaranteeScore,
      'budget_compatible': budgetCompatible,
      'requires_partner_booking': requiresPartnerBooking,
    };
  }
}
