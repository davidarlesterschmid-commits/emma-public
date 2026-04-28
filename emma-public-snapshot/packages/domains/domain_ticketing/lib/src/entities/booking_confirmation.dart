/// Ticketing status for MVP simulation only.
enum TicketingSimulationStatus { simulated, gateRequired }

class BookingConfirmation {
  const BookingConfirmation({
    required this.confirmationId,
    required this.productId,
    required this.status,
    required this.confirmedAt,
    required this.gateNote,
  });

  final String confirmationId;
  final String productId;
  final TicketingSimulationStatus status;
  final DateTime confirmedAt;
  final String gateNote;
}
