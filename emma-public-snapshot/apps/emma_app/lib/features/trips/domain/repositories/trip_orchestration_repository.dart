import 'package:emma_app/features/trips/domain/entities/trip_orchestration.dart';

abstract class TripOrchestrationRepository {
  Future<List<TripOrchestration>> getOrchestrations();
}
