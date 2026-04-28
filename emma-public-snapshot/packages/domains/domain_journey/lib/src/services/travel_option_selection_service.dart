import 'package:domain_journey/src/entities/travel_option.dart';

class TravelOptionSelectionService {
  const TravelOptionSelectionService();

  TravelOption? selectBest(List<TravelOption> options) {
    if (options.isEmpty) return null;

    final sorted = [...options]
      ..sort((a, b) {
        final guarantee = b.guaranteeScore.compareTo(a.guaranteeScore);
        if (guarantee != 0) return guarantee;

        final reliability = b.reliabilityScore.compareTo(a.reliabilityScore);
        if (reliability != 0) return reliability;

        final arrival = a.estimatedArrival.compareTo(b.estimatedArrival);
        if (arrival != 0) return arrival;

        return a.estimatedCostEuro.compareTo(b.estimatedCostEuro);
      });

    return sorted.first;
  }
}
