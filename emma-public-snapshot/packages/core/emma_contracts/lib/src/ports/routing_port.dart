import 'package:domain_journey/domain_journey.dart';

abstract class RoutingPort {
  Future<List<TravelOption>> searchOptions({required UserIntent intent});
}
