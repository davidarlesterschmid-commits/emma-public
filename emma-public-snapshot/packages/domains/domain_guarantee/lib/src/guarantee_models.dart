class GuaranteeEligibility {
  const GuaranteeEligibility({
    required this.journeyId,
    required this.isEligible,
    required this.reason,
  });

  final String journeyId;
  final bool isEligible;
  final String reason;
}

class FallbackOffer {
  const FallbackOffer({
    required this.id,
    required this.label,
    required this.requiresOperationalGate,
  });

  final String id;
  final String label;
  final bool requiresOperationalGate;
}

class GuaranteeDecision {
  const GuaranteeDecision({
    required this.eligibility,
    required this.offers,
    required this.gateNote,
  });

  final GuaranteeEligibility eligibility;
  final List<FallbackOffer> offers;
  final String gateNote;
}
