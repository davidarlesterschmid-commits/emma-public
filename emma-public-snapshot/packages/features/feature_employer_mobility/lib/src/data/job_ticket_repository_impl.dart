import 'package:domain_employer_mobility/domain_employer_mobility.dart';

import 'job_ticket_remote_datasource.dart';

/// Default [JobTicketRepository] implementation.
class JobTicketRepositoryImpl implements JobTicketRepository {
  JobTicketRepositoryImpl(this._remote);

  final JobTicketRemoteDataSource _remote;

  @override
  Future<List<JobTicket>> getAvailableTickets() =>
      _remote.getAvailableTickets();

  @override
  Future<void> bookTicket(String ticketId) async {
    // TODO(emma-employer): echter Booking-Call über Tarifserver/Partner.
    await Future<void>.delayed(const Duration(seconds: 1));
  }
}
