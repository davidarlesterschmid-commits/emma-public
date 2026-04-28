import 'package:emma_app/features/tariff_rules/domain/entities/tariff_rule.dart';
import 'package:emma_app/features/tariff_rules/domain/repositories/tariff_repository.dart';
import 'package:emma_contracts/emma_contracts.dart';
import 'package:fake_tariff/fake_tariff.dart';

class TariffRepositoryImpl implements TariffRepository {
  TariffRepositoryImpl({TariffPort? engine}) : _inner = engine ?? FakeTariffAdapter();

  final TariffPort _inner;

  @override
  Future<List<TariffRule>> getAvailableTariffs() => _inner.getAvailableTariffs();

  @override
  Future<TariffQuote?> quote({
    required String originStationId,
    required String destinationStationId,
    required DateTime departureAt,
    String? passengerClass,
  }) {
    return _inner.quote(
      originStationId: originStationId,
      destinationStationId: destinationStationId,
      departureAt: departureAt,
      passengerClass: passengerClass,
    );
  }

  @override
  Future<List<TariffProduct>> listProducts({required String zoneId}) {
    return _inner.listProducts(zoneId: zoneId);
  }

  @override
  Future<double> calculatePrice(String ruleId, int distanceKm) async {
    if (ruleId == 'MDV-1-EF' || ruleId == '1') {
      return distanceKm * 0.1;
    }
    return distanceKm * 0.1;
  }
}
