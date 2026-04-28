import 'package:emma_app/features/trips/domain/entities/trip_orchestration.dart';
import 'package:emma_app/features/trips/domain/repositories/trip_orchestration_repository.dart';

class TripOrchestrationRepositoryImpl implements TripOrchestrationRepository {
  @override
  Future<List<TripOrchestration>> getOrchestrations() async {
    // Mock data
    return [
      const TripOrchestration(
        id: '1',
        type: 'mediated',
        providers: ['DB', 'nextbike'],
        cost: 10.0,
      ),
    ];
  }
}
