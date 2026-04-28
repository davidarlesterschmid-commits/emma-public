import 'package:emma_contracts/emma_contracts.dart';

class TriasService {
  Future<List<EmmaLocation>> searchLocations(
    String query, {
    String provider = 'delfi',
    int limit = 5,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
          EmmaLocation(
            name: 'Leipzig Hauptbahnhof',
            stopRef: 'DE001:12345',
            latitude: 51.3458,
            longitude: 12.3811,
          ),
          EmmaLocation(
            name: 'Berlin Hauptbahnhof',
            stopRef: 'DE002:67890',
            latitude: 52.5250,
            longitude: 13.3694,
          ),
        ]
        .where((loc) => loc.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<EmmaTrip>> searchTrips(
    String originRef,
    String destinationRef, {
    String provider = 'delfi',
    DateTime? departureTime,
    int maxResults = 5,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      EmmaTrip(
        id: 'trip1',
        departureTime: DateTime.now().add(const Duration(hours: 1)),
        arrivalTime: DateTime.now().add(const Duration(hours: 2, minutes: 30)),
        totalDurationSeconds: 5400,
        transferCount: 0,
        providerId: provider,
        legs: [
          EmmaLeg(
            legIndex: 0,
            mode: 'rail',
            origin: EmmaLocation(name: 'Leipzig Hbf', stopRef: originRef),
            destination: EmmaLocation(
              name: 'Berlin Hbf',
              stopRef: destinationRef,
            ),
            line: EmmaLine(
              shortName: 'ICE 123',
              directionText: 'Berlin',
              operatorName: 'DB',
              ptMode: 'rail',
            ),
            departure: EmmaRealtimeInfo(
              timetabledTime: DateTime.now().add(const Duration(hours: 1)),
              isRealtime: true,
            ),
            arrival: EmmaRealtimeInfo(
              timetabledTime: DateTime.now().add(
                const Duration(hours: 2, minutes: 30),
              ),
              isRealtime: true,
            ),
          ),
        ],
      ),
    ];
  }
}
