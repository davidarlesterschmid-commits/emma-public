import 'package:domain_rules/src/tariff/tariff_rule_set.dart';
import 'package:yaml/yaml.dart';

/// Laedt [TariffRuleSet] aus einem YAML-String (Fixtures, Tests).
TariffRuleSet loadTariffRuleSetYaml(String source) {
  final dynamic root = loadYaml(source);
  if (root is! Map) {
    throw FormatException('Tariff YAML root must be a map');
  }
  final map = root.map((k, v) => MapEntry(k.toString(), v));
  final ruleSetVersion = map['rule_set_version']?.toString() ?? '0';
  final fixtureBundleId = map['fixture_bundle_id']?.toString() ?? 'unknown';
  final fb = map['fallback'];
  if (fb is! Map) {
    throw FormatException('Tariff YAML: fallback required');
  }
  final fallback = TariffPairFallback(
    productCode: fb['product_code']?.toString() ?? 'MDV-FB',
    priceEuroCents: _asInt(fb['price_euro_cents']) ?? 300,
    currency: fb['currency']?.toString() ?? 'EUR',
  );
  final stationZones = <String, String>{};
  final sz = map['station_zones'];
  if (sz is Map) {
    for (final e in sz.entries) {
      stationZones[e.key.toString()] = e.value.toString();
    }
  }
  final pairs = <TariffPairRule>[];
  final p = map['pair_rules'];
  if (p is List) {
    for (final item in p) {
      if (item is! Map) continue;
      final m = item.map((k, v) => MapEntry(k.toString(), v));
      Set<String>? classes;
      final pc = m['passenger_classes'];
      if (pc is List) {
        classes = pc.map((e) => e.toString().toLowerCase()).toSet();
      }
      pairs.add(
        TariffPairRule(
          id: m['id']?.toString() ?? 'rule',
          zoneFrom: m['zone_from']?.toString() ?? '',
          zoneTo: m['zone_to']?.toString() ?? '',
          productCode: m['product_code']?.toString() ?? 'EF',
          priceEuroCents: _asInt(m['price_euro_cents']) ?? 0,
          currency: m['currency']?.toString() ?? 'EUR',
          passengerClasses: classes,
        ),
      );
    }
  }
  return TariffRuleSet(
    ruleSetVersion: ruleSetVersion,
    fixtureBundleId: fixtureBundleId,
    fallback: fallback,
    stationZones: stationZones,
    pairs: pairs,
  );
}

List<TariffCatalogEntry> loadTariffCatalogYaml(String source) {
  final dynamic root = loadYaml(source);
  if (root is! Map) {
    return const [];
  }
  final map = root.map((k, v) => MapEntry(k.toString(), v));
  final c = map['catalog'];
  if (c is! List) {
    return const [];
  }
  final out = <TariffCatalogEntry>[];
  for (final item in c) {
    if (item is! Map) continue;
    final m = item.map((k, v) => MapEntry(k.toString(), v));
    final ent = m['entitlements'];
    out.add(
      TariffCatalogEntry(
        id: m['id']?.toString() ?? '',
        name: m['name']?.toString() ?? '',
        price: (m['price'] as num?)?.toDouble() ?? 0.0,
        entitlements: ent is List
            ? ent.map((e) => e.toString()).toList()
            : const <String>[],
        isSubscription: m['is_subscription'] == true,
      ),
    );
  }
  return out;
}

int? _asInt(dynamic v) {
  if (v == null) {
    return null;
  }
  if (v is int) {
    return v;
  }
  if (v is num) {
    return v.toInt();
  }
  return int.tryParse(v.toString());
}
