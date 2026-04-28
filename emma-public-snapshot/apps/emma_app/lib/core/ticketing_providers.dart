import 'package:domain_ticketing/domain_ticketing.dart';
import 'package:emma_app/core/config/app_config.dart';
import 'package:fake_ticketing/fake_ticketing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [TicketingRepository]: Fake im MVP-Default, spaeter HTTP-Adapter.
final ticketingRepositoryProvider = Provider<TicketingRepository>((ref) {
  if (AppConfig.useFakes) {
    return FakeTicketingRepository();
  }
  throw UnimplementedError(
    'Echter Ticketing-Adapter: nicht im MVP-Default-Build.',
  );
});
