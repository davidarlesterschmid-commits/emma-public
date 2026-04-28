import 'package:dio/dio.dart';

import 'package:emma_app/features/trips/domain/entities/trip.dart';

abstract class TripRemoteDataSource {
  Future<List<Trip>> searchTrips({
    required String from,
    required String to,
    required DateTime departureTime,
    int? maxResults,
  });

  Future<List<Location>> searchLocations(String query);
}

class TripRemoteDataSourceImpl implements TripRemoteDataSource {
  final Dio dio;

  TripRemoteDataSourceImpl(this.dio);

  @override
  Future<List<Trip>> searchTrips({
    required String from,
    required String to,
    required DateTime departureTime,
    int? maxResults,
  }) async {
    // Mock TRIAS API call
    await Future.delayed(const Duration(seconds: 2));

    // Mock response with realistic trip data
    return [
      Trip(
        id: 'trip_1',
        from: from,
        to: to,
        departureTime: departureTime,
        legs: [
          TripLeg(
            id: 'leg_1',
            mode: 'walk',
            from: from,
            to: 'Hauptbahnhof',
            departureTime: departureTime,
            arrivalTime: departureTime.add(const Duration(minutes: 15)),
            duration: const Duration(minutes: 15),
            cost: 0.0,
          ),
          TripLeg(
            id: 'leg_2',
            mode: 'train',
            from: 'Hauptbahnhof',
            to: 'Zentralbahnhof',
            departureTime: departureTime.add(const Duration(minutes: 15)),
            arrivalTime: departureTime.add(const Duration(minutes: 45)),
            duration: const Duration(minutes: 30),
            cost: 12.50,
            provider: 'Deutsche Bahn',
            line: 'ICE 123',
          ),
          TripLeg(
            id: 'leg_3',
            mode: 'walk',
            from: 'Zentralbahnhof',
            to: to,
            departureTime: departureTime.add(const Duration(minutes: 45)),
            arrivalTime: departureTime.add(const Duration(minutes: 55)),
            duration: const Duration(minutes: 10),
            cost: 0.0,
          ),
        ],
        totalDuration: const Duration(minutes: 55),
        totalCost: 12.50,
        status: 'planned',
      ),
      // Alternative route
      Trip(
        id: 'trip_2',
        from: from,
        to: to,
        departureTime: departureTime.add(const Duration(minutes: 10)),
        legs: [
          TripLeg(
            id: 'leg_4',
            mode: 'bus',
            from: from,
            to: to,
            departureTime: departureTime.add(const Duration(minutes: 10)),
            arrivalTime: departureTime.add(const Duration(minutes: 50)),
            duration: const Duration(minutes: 40),
            cost: 8.90,
            provider: 'Stadtbus',
            line: 'Bus 42',
          ),
        ],
        totalDuration: const Duration(minutes: 40),
        totalCost: 8.90,
        status: 'planned',
      ),
    ];
  }

  @override
  Future<List<Location>> searchLocations(String query) async {
    // Mock location search
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock locations based on query
    return [
      Location(
        id: 'loc_1',
        name: '$query Hauptbahnhof',
        latitude: 51.3397,
        longitude: 12.3731,
        address: 'Bahnhofstraße 1, 04103 Leipzig',
        stopId: 'de:14712:1',
      ),
      Location(
        id: 'loc_2',
        name: '$query Zentrum',
        latitude: 51.3400,
        longitude: 12.3750,
        address: 'Markt 1, 04109 Leipzig',
        stopId: 'de:14712:2',
      ),
    ];
  }
}
