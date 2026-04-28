import 'package:flutter/foundation.dart';

/// Nur Darstellung — keine Fahrplan-, Preis- oder Komfortlogik.
@immutable
class RoutingOptionDummy {
  const RoutingOptionDummy({
    required this.id,
    required this.label,
    required this.durationLabel,
    required this.priceLabel,
    required this.comfortLabel,
  });

  final String id;
  final String label;
  final String durationLabel;
  final String priceLabel;
  final String comfortLabel;
}

const kRoutingOptionDummies = <RoutingOptionDummy>[
  RoutingOptionDummy(
    id: 'A',
    label: 'Schnellverbindung (IC/RE, Demo)',
    durationLabel: '1 h 10 min',
    priceLabel: 'ab 19,90 €',
    comfortLabel: 'Komfort: hoch (Dummy)',
  ),
  RoutingOptionDummy(
    id: 'B',
    label: 'Günstige Verbindung (RB/Bus, Demo)',
    durationLabel: '1 h 40 min',
    priceLabel: 'ab 8,20 €',
    comfortLabel: 'Komfort: mittel (Dummy)',
  ),
  RoutingOptionDummy(
    id: 'C',
    label: 'Entspannt: weniger Umstiege (Demo)',
    durationLabel: '1 h 25 min',
    priceLabel: 'ab 12,00 €',
    comfortLabel: 'Komfort: hoch (Dummy)',
  ),
];
