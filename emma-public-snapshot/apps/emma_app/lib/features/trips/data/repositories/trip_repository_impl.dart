import 'package:emma_app/features/trips/domain/entities/trip.dart';
import 'package:emma_app/features/trips/domain/repositories/trip_repository.dart';
import 'package:emma_app/features/trips/data/datasources/trip_remote_datasource.dart';

class TripRepositoryImpl implements TripRepository {
  final TripRemoteDataSource remoteDataSource;

  TripRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Trip>> searchTrips({
    required String from,
    required String to,
    required DateTime departureTime,
    int? maxResults,
  }) async {
    return await remoteDataSource.searchTrips(
      from: from,
      to: to,
      departureTime: departureTime,
      maxResults: maxResults ?? 5,
    );
  }

  @override
  Future<Trip> getTripDetails(String tripId) async {
    // Mock implementation - in real app would fetch from cache or API
    throw UnimplementedError('Trip details not implemented yet');
  }

  @override
  Future<List<Location>> searchLocations(String query) async {
    return await remoteDataSource.searchLocations(query);
  }
}
