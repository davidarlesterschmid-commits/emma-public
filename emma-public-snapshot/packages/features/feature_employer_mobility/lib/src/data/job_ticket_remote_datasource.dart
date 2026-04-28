import 'package:dio/dio.dart';
import 'package:domain_employer_mobility/domain_employer_mobility.dart';

/// Remote side of the job-ticket repository.
abstract interface class JobTicketRemoteDataSource {
  Future<List<JobTicket>> getAvailableTickets();
}

class JobTicketRemoteDataSourceImpl implements JobTicketRemoteDataSource {
  JobTicketRemoteDataSourceImpl(this._dio);

  // ignore: unused_field
  final Dio _dio;

  @override
  Future<List<JobTicket>> getAvailableTickets() async {
    // TODO(emma-employer): replace with tariff-server offer endpoint.
    await Future<void>.delayed(const Duration(seconds: 1));
    final now = DateTime.now();
    return [
      JobTicket(
        id: 'ticket-1',
        type: TicketType.dticket,
        name: 'D-Ticket Abo',
        totalPrice: 49.0,
        employeeShare: 0.0,
        employerSubsidy: 49.0,
        validFrom: now,
        validTo: DateTime(now.year, now.month + 1, 0),
        isActive: true,
      ),
      JobTicket(
        id: 'ticket-2',
        type: TicketType.regionalJobticket,
        name: 'MDV Jobticket Leipzig',
        totalPrice: 35.0,
        employeeShare: 10.0,
        employerSubsidy: 25.0,
        validFrom: now,
        validTo: DateTime(now.year, now.month + 1, 0),
        isActive: true,
      ),
    ];
  }
}
