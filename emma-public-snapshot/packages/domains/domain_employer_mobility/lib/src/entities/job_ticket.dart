import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_ticket.freezed.dart';
part 'job_ticket.g.dart';

/// Art eines Jobtickets.
///
/// [dticket] — bundesweites Deutschland-Ticket.
/// [regionalJobticket] — regionaler Tarif (z. B. MDV-Jobticket).
enum TicketType { dticket, regionalJobticket }

/// Ein konkretes Jobticket-Angebot inkl. Arbeitgeber-/Arbeitnehmer-Aufteilung.
///
/// [totalPrice] = [employeeShare] + [employerSubsidy]. Die Domäne erzwingt
/// diese Invariante nicht explizit — Validierung liegt in der
/// Tarif-/Regelwerks-Domäne.
@freezed
sealed class JobTicket with _$JobTicket {
  const factory JobTicket({
    required String id,
    required TicketType type,
    required String name,
    required double totalPrice,
    required double employeeShare,
    required double employerSubsidy,
    required DateTime validFrom,
    required DateTime validTo,
    required bool isActive,
  }) = _JobTicket;

  factory JobTicket.fromJson(Map<String, dynamic> json) =>
      _$JobTicketFromJson(json);
}
