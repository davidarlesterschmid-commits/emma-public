import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:emma_app/features/trips/data/repositories/trip_orchestration_repository_impl.dart';
import 'package:emma_app/features/trips/data/repositories/trip_repository_impl.dart';
import 'package:emma_app/features/trips/domain/repositories/trip_orchestration_repository.dart';
import 'package:emma_app/features/trips/domain/repositories/trip_repository.dart';

final tripOrchestrationRepositoryProvider =
    Provider<TripOrchestrationRepository>((ref) {
      return TripOrchestrationRepositoryImpl();
    });

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  return TripRepositoryImpl(ref.watch(tripRemoteDataSourceProvider));
});

// Mock provider for remote data source - in real app this would be injected
final tripRemoteDataSourceProvider = Provider((ref) {
  // This would normally be injected with Dio and proper configuration
  throw UnimplementedError('Trip remote data source not properly configured');
});
