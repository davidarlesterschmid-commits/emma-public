import 'package:emma_contracts/emma_contracts.dart';
import 'package:domain_journey/domain_journey.dart';
import 'package:adapter_trias/src/trias_service.dart';

class TriasRoutingPort implements RoutingPort {
  TriasRoutingPort(this._triasService);

  final TriasService _triasService;

  @override
  Future<List<TravelOption>> searchOptions({required UserIntent intent}) async {
    final origins = await _triasService.searchLocations(intent.origin);
    final destinations = await _triasService.searchLocations(
      intent.destination,
    );

    if (origins.isEmpty || destinations.isEmpty) {
      return const [];
    }

    final trips = await _triasService.searchTrips(
      origins.first.stopRef,
      destinations.first.stopRef,
      departureTime: intent.targetArrivalTime.subtract(
        const Duration(hours: 2),
      ),
    );

    return trips.map((trip) {
      final legs = trip.legs
          .map(
            (leg) => TravelLeg(
              mode: leg.mode,
              provider: leg.line?.operatorName ?? trip.providerId,
              originLabel: leg.origin.name,
              destinationLabel: leg.destination?.name ?? intent.destination,
            ),
          )
          .toList();

      final reliabilityScore =
          trip.legs.any((leg) => leg.departure?.isRealtime == true)
          ? 0.9
          : 0.75;
      final guaranteeScore = trip.transferCount == 0 ? 0.92 : 0.82;

      return TravelOption(
        optionId: trip.id,
        legs: legs,
        providerCandidates: [trip.providerId],
        estimatedArrival: trip.arrivalTime,
        estimatedDurationMinutes: (trip.totalDurationSeconds / 60).round(),
        estimatedCostEuro: (trip.fare as num?)?.toDouble() ?? 4.60,
        reliabilityScore: reliabilityScore,
        guaranteeScore: guaranteeScore,
        budgetCompatible: true,
        requiresPartnerBooking: false,
      );
    }).toList();
  }
}
