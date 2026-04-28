import 'package:domain_rules/domain_rules.dart';
import 'package:emma_contracts/emma_contracts.dart';

abstract class TariffRepository implements TariffPort {
  @override
  Future<List<TariffRule>> getAvailableTariffs();

  @override
  Future<TariffQuote?> quote({
    required String originStationId,
    required String destinationStationId,
    required DateTime departureAt,
    String? passengerClass,
  });

  @override
  Future<List<TariffProduct>> listProducts({required String zoneId});

  /// Einfache Linearkalkulation (Legacy-Hilfsfunktion, nicht M11-Primärpreis).
  Future<double> calculatePrice(String ruleId, int distanceKm);
}
