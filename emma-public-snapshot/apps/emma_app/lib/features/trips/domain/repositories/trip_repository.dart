import 'package:emma_app/features/trips/domain/entities/trip.dart';

abstract class TripRepository {
  Future<List<Trip>> searchTrips({
    required String from,
    required String to,
    required DateTime departureTime,
    int? maxResults,
  });

  Future<Trip> getTripDetails(String tripId);

  Future<List<Location>> searchLocations(String query);
}
