import 'package:domain_rules/src/tariff/tariff_quote_result.dart';
import 'package:domain_rules/src/tariff/tariff_rule_set.dart';

/// Deterministische Tarif-Engine: guenstigste passende Regel, Tiebreaker: Regel-ID.
class TariffEngine {
  TariffEngine(this._ruleSet);

  final TariffRuleSet _ruleSet;

  static const _milestoneValidFrom = '2020-01-01T00:00:00.000Z';
  static const _milestoneValidTo = '2035-12-31T23:59:59.000Z';

  /// Station-IDs (HAFAS/TRIAS-Stub) -> Zonen-Code aus Fixture-Map.
  TariffQuoteResult? quote({
    required String originStationId,
    required String destinationStationId,
    required DateTime departureAt,
    String? passengerClass,
  }) {
    // Zeitreise-/Fahrplanlogik: spaeter; Fixture-Preise gelten fuer sinnvolle Eingabezeiten.
    assert(
      !departureAt.millisecondsSinceEpoch.isNegative,
      'departure time must be representable',
    );
    final zFrom = _ruleSet.stationZones[originStationId];
    final zTo = _ruleSet.stationZones[destinationStationId];
    if (zFrom == null || zTo == null) {
      return _fallbackQuote(
        zoneFrom: zFrom ?? 'UNKNOWN',
        zoneTo: zTo ?? 'UNKNOWN',
        passengerClass: passengerClass,
        trace: const ['no_zone_mapping'],
      );
    }
    final normClass = passengerClass?.toLowerCase();
    final candidates = _ruleSet.pairs
        .where(
          (r) =>
              r.zoneFrom == zFrom &&
              r.zoneTo == zTo &&
              _classMatches(r.passengerClasses, normClass),
        )
        .toList();
    if (candidates.isEmpty) {
      return _fallbackQuote(
        zoneFrom: zFrom,
        zoneTo: zTo,
        passengerClass: passengerClass,
        trace: const ['no_pair_rule'],
      );
    }
    candidates.sort((a, b) => a.id.compareTo(b.id));
    var best = candidates.first;
    var bestCents = best.priceEuroCents;
    for (final c in candidates.skip(1)) {
      if (c.priceEuroCents < bestCents) {
        best = c;
        bestCents = c.priceEuroCents;
      } else if (c.priceEuroCents == bestCents && c.id.compareTo(best.id) < 0) {
        best = c;
      }
    }
    return TariffQuoteResult(
      priceEuroCents: best.priceEuroCents,
      currency: best.currency,
      productCode: best.productCode,
      zoneFrom: zFrom,
      zoneTo: zTo,
      validFrom: DateTime.parse(_milestoneValidFrom),
      validTo: DateTime.parse(_milestoneValidTo),
      ruleTrace: [best.id],
      isFallback: false,
      ruleSetVersion: _ruleSet.ruleSetVersion,
      fixtureBundleId: _ruleSet.fixtureBundleId,
      operatorId: 'MDV',
      passengerClass: passengerClass,
    );
  }

  List<TariffProductRow> listProductsForZone(String zoneId) {
    final seen = <String, TariffProductRow>{};
    for (final p in _ruleSet.pairs) {
      if (p.zoneFrom != zoneId && p.zoneTo != zoneId) {
        continue;
      }
      final key = p.productCode;
      final existing = seen[key];
      if (existing == null || p.priceEuroCents < existing.priceEuroCents) {
        seen[key] = TariffProductRow(
          productCode: p.productCode,
          zoneId: zoneId,
          priceEuroCents: p.priceEuroCents,
          label: _labelFor(p.productCode),
        );
      }
    }
    return seen.values.toList()..sort((a, b) => a.productCode.compareTo(b.productCode));
  }

  bool _classMatches(Set<String>? ruleClasses, String? requestClass) {
    if (ruleClasses == null || ruleClasses.isEmpty) {
      return true;
    }
    if (requestClass == null || requestClass.isEmpty) {
      return ruleClasses.contains('adult');
    }
    return ruleClasses.contains(requestClass);
  }

  TariffQuoteResult _fallbackQuote({
    required String zoneFrom,
    required String zoneTo,
    String? passengerClass,
    required List<String> trace,
  }) {
    final fb = _ruleSet.fallback;
    return TariffQuoteResult(
      priceEuroCents: fb.priceEuroCents,
      currency: fb.currency,
      productCode: fb.productCode,
      zoneFrom: zoneFrom,
      zoneTo: zoneTo,
      validFrom: DateTime.parse(_milestoneValidFrom),
      validTo: DateTime.parse(_milestoneValidTo),
      ruleTrace: trace,
      isFallback: true,
      ruleSetVersion: _ruleSet.ruleSetVersion,
      fixtureBundleId: _ruleSet.fixtureBundleId,
      operatorId: 'MDV',
      passengerClass: passengerClass,
    );
  }

  String _labelFor(String productCode) {
    switch (productCode) {
      case 'MDV-1-EF':
        return 'Einzelfahrschein';
      case 'MDV-TAGESKARTE':
        return 'Tageskarte (Bestpreis-Hinweis)';
      case 'MDV-FB':
        return 'Pauschalpreis (Fallback)';
      default:
        return productCode;
    }
  }
}
