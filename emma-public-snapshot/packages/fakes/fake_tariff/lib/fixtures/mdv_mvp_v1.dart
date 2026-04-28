/// YAML-Inhalt des MDV-MVP-Regelwerks (Build-Zeit; kein Laufzeit-File-I/O in Flutter-Web).
const String kMdvMvpV1FixtureYaml = r'''
rule_set_version: "mdv-mvp-2026-04-27"
fixture_bundle_id: "mdv_mvp_v1"
fallback:
  product_code: "MDV-FB"
  price_euro_cents: 300
  currency: "EUR"
# Station-IDs: Abstimmung mit domain_journey / Routing-Stub, siehe SPECS M11
station_zones:
  "leipzig_hbf": "110"
  "halle_hbf": "210"
  "chemnitz_hbf": "310"
  "dresden_hbf": "410"
# Paar-Regeln: guenstigster Treffer in Engine, Tiebreaker Regel-id
pair_rules:
  - id: "ef_110_210_adult"
    zone_from: "110"
    zone_to: "210"
    product_code: "MDV-1-EF"
    price_euro_cents: 1500
    currency: "EUR"
    passenger_classes: ["adult"]
  - id: "ef_110_210_reduced"
    zone_from: "110"
    zone_to: "210"
    product_code: "MDV-1-EF"
    price_euro_cents: 800
    currency: "EUR"
    passenger_classes: ["reduced"]
  - id: "ef_110_310_adult"
    zone_from: "110"
    zone_to: "310"
    product_code: "MDV-1-EF"
    price_euro_cents: 1200
    currency: "EUR"
    passenger_classes: ["adult"]
  - id: "tages_110"
    zone_from: "110"
    zone_to: "110"
    product_code: "MDV-TAGESKARTE"
    price_euro_cents: 900
    currency: "EUR"
catalog:
  - id: "1"
    name: "D-Ticket (Anzeige)"
    price: 4.6
    entitlements: ["OEPNV"]
    is_subscription: true
  - id: "2"
    name: "MDV Einzelfahrschein (Katalog)"
    price: 3.0
    entitlements: ["OEPNV"]
    is_subscription: false
''';
