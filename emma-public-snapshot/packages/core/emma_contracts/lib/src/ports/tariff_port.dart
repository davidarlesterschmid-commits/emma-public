import 'package:domain_rules/domain_rules.dart';

import 'package:emma_contracts/src/ports/tariff_types.dart';

/// Lese-Pfad Tarif (M11). Implementierungen: `fake_tariff`, spaeter ggf. Echt-Adapter.
abstract class TariffPort {
  /// Einzelfahrt- o. a. Preis fuer Stationen-Paar und Abfahrt; `passengerClass` z. B. adult|reduced.
  Future<TariffQuote?> quote({
    required String originStationId,
    required String destinationStationId,
    required DateTime departureAt,
    String? passengerClass,
  });

  /// Produkte mit Bezug zu einer MDV-Zone (Anzeige / Auswahl).
  Future<List<TariffProduct>> listProducts({required String zoneId});

  /// Katalog-Liste fuer Legacy/Anzeige (Journey, Tarif-Screen).
  Future<List<TariffRule>> getAvailableTariffs();
}
