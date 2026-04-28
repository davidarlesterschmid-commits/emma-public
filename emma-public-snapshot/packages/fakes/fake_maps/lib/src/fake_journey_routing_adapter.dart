import 'package:domain_journey/domain_journey.dart';
import 'package:emma_contracts/emma_contracts.dart';

/// Deterministic RoutingPort for the mock end-to-end journey MVP.
///
/// No network access, no TRIAS, no paid API. The adapter translates free-form
/// origin/destination labels into two stable options so widget and repository
/// tests can exercise selection, booking and fallback behavior.
class FakeJourneyRoutingAdapter implements RoutingPort {
  const FakeJourneyRoutingAdapter();

  @override
  Future<List<TravelOption>> searchOptions({required UserIntent intent}) async {
    final arrival = intent.targetArrivalTime;
    final origin = intent.origin.isEmpty ? 'Leipzig Hbf' : intent.origin;
    final destination = intent.destination.isEmpty
        ? 'Halle Hbf'
        : intent.destination;

    return <TravelOption>[
      TravelOption(
        optionId: 'mock-route-guaranteed',
        legs: <TravelLeg>[
          TravelLeg(
            mode: 'rail',
            provider: 'MDV',
            originLabel: origin,
            destinationLabel: 'Leipzig Bayerischer Bahnhof',
          ),
          TravelLeg(
            mode: 'tram',
            provider: 'HAVAG',
            originLabel: 'Leipzig Bayerischer Bahnhof',
            destinationLabel: destination,
          ),
        ],
        providerCandidates: const <String>['MDV_VDV_KA', 'HAVAG'],
        estimatedArrival: arrival,
        estimatedDurationMinutes: 42,
        estimatedCostEuro: 3.5,
        reliabilityScore: 0.93,
        guaranteeScore: 0.97,
        budgetCompatible: true,
        requiresPartnerBooking: false,
      ),
      TravelOption(
        optionId: 'mock-route-low-change',
        legs: <TravelLeg>[
          TravelLeg(
            mode: 'rail',
            provider: 'DB Regio',
            originLabel: origin,
            destinationLabel: destination,
          ),
        ],
        providerCandidates: const <String>['DB_REGIO'],
        estimatedArrival: arrival.add(const Duration(minutes: 9)),
        estimatedDurationMinutes: 51,
        estimatedCostEuro: 4.8,
        reliabilityScore: 0.84,
        guaranteeScore: 0.82,
        budgetCompatible: true,
        requiresPartnerBooking: false,
      ),
    ];
  }
}
