/// Die drei im MVP sichtbaren Ticket-/Kauf-Pfade (siehe MVP_PRODUCT_DECISIONS Abschnitt C).
enum TicketingProcessKind {
  /// UC-TICK-01: emma-Preis/Netz (M11 / TarifPort / fake Tarif).
  emmaNetworkPrice,

  /// UC-TICK-02: Dienstleister-Publikation (Preis aus VVU/Fixtures, nicht M11-Engine).
  operatorPublication,

  /// UC-TICK-03: Abo / D-Ticket o. a. (MVP: Anzeige-Stub, kein faktischer Kauffluss).
  subscriptionOrPassDisplay,
}

/// Stabile Anker-IDs fuer Router/Screens/DoD-Referenzen.
abstract final class TicketingUsecaseIds {
  static const uCTick01EmmaNet = 'UC-TICK-01';
  static const uCTick02Operator = 'UC-TICK-02';
  static const uCTick03Subscription = 'UC-TICK-03';
}

enum TicketingPriceSource {
  emmaRuleEngine,
  operatorPublished,
  employerBudgetOnly,
}

/// Zeile auf einem Ticket-/Warenkorb-Read-Model (Cent-basiert).
class TicketingLineItem {
  const TicketingLineItem({
    required this.label,
    required this.priceEuroCents,
    required this.source,
    this.process,
    this.useCaseId,
    this.operatorId,
    this.ruleSetVersion,
    this.publicationId,
  });

  final String label;
  final int priceEuroCents;
  final TicketingPriceSource source;
  final TicketingProcessKind? process;
  final String? useCaseId;
  final String? operatorId;
  final String? ruleSetVersion;
  final String? publicationId;
}
