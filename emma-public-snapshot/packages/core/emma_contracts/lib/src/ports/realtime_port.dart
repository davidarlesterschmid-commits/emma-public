import 'package:emma_contracts/src/models/realtime_event.dart';

abstract interface class RealtimePort {
  Stream<RealtimeEvent> eventsFor({required List<String> tripIds});
}
