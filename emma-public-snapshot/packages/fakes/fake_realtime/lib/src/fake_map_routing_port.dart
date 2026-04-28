import 'package:domain_journey/domain_journey.dart';
import 'package:emma_core/emma_core.dart';

class FakeMapRoutingPort implements MapRoutingPort {
  const FakeMapRoutingPort();

  @override
  Future<Result<List<Journey>>> calculateRoute(
    String originId,
    String destinationId,
  ) async {
    return Result.success(<Journey>[
      Journey(
        id: 'fake-journey-1',
        originId: originId,
        destinationId: destinationId,
        label: 'Fake journey',
      ),
    ]);
  }
}
