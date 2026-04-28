import 'package:emma_core/emma_core.dart';
import 'package:domain_journey/src/entities/journey.dart';

abstract class MapRoutingPort {
  Future<Result<List<Journey>>> calculateRoute(
    String originId,
    String destinationId,
  );
}
