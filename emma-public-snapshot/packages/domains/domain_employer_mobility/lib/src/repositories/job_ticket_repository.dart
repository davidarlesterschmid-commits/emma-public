import '../entities/job_ticket.dart';

/// Quelle der Wahrheit für Jobticket-Angebote und Buchungen.
abstract interface class JobTicketRepository {
  Future<List<JobTicket>> getAvailableTickets();
  Future<void> bookTicket(String ticketId);
}
