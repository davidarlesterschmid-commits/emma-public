import 'package:domain_journey/domain_journey.dart';
import 'package:emma_core/emma_core.dart';

class MdvRoutingAdapter implements MapRoutingPort {
  @override
  Future<Result<List<Journey>>> calculateRoute(
    String originId,
    String destinationId,
  ) async {
    return Result.success(<Journey>[
      Journey(
        id: 'journey-1',
        originId: originId,
        destinationId: destinationId,
        label: 'Stub route from $originId to $destinationId',
      ),
    ]);
  }
}
