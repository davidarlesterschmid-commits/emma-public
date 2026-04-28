import 'package:domain_mobility_guarantee/src/entities/guarantee_rule.dart';
import 'package:domain_mobility_guarantee/src/m07/guarantee_trigger_id.dart';

final List<GuaranteeRule> m07GuaranteeRuleCatalog = <GuaranteeRule>[
  GuaranteeRule(
    id: 'm07-t01',
    label: 'Zugausfall — Alternativ-Verbindung + 5 EUR',
    m07TriggerId: GuaranteeTriggerId.t01,
    maxCompensationCents: 500,
    trigger: const GuaranteeTriggerCancellation(),
    primaryAction: const GuaranteeActionTaxi(maxCompensationCents: 5000),
  ),
  GuaranteeRule(
    id: 'm07-t02',
    label: 'Verspaetung > 20 Min — 5 EUR Gutschein',
    m07TriggerId: GuaranteeTriggerId.t02,
    maxCompensationCents: 500,
    trigger: const GuaranteeTriggerDelay(minimumDelayMinutes: 21),
    primaryAction: const GuaranteeActionOnDemand(),
  ),
  GuaranteeRule(
    id: 'm07-t03',
    label: 'Verspaetung > 60 Min — 15 EUR Gutschein',
    m07TriggerId: GuaranteeTriggerId.t03,
    maxCompensationCents: 1500,
    trigger: const GuaranteeTriggerDelay(minimumDelayMinutes: 61),
    primaryAction: const GuaranteeActionOnDemand(),
  ),
  GuaranteeRule(
    id: 'm07-t04',
    label: 'Letzte Verbindung des Tages — Taxi-Platzhalter',
    m07TriggerId: GuaranteeTriggerId.t04,
    maxCompensationCents: null,
    trigger: const GuaranteeTriggerCancellation(),
    primaryAction: const GuaranteeActionTaxi(maxCompensationCents: 5000),
  ),
  GuaranteeRule(
    id: 'm07-t05',
    label: 'Linie > 2h ausser Betrieb — 10 EUR',
    m07TriggerId: GuaranteeTriggerId.t05,
    maxCompensationCents: 1000,
    trigger: const GuaranteeTriggerDelay(minimumDelayMinutes: 0),
    primaryAction: const GuaranteeActionOnDemand(),
  ),
  GuaranteeRule(
    id: 'm07-t06',
    label: 'Umstieg verpasst (Puffer ueberschritten)',
    m07TriggerId: GuaranteeTriggerId.t06,
    maxCompensationCents: 500,
    trigger: const GuaranteeTriggerDelay(minimumDelayMinutes: 1),
    primaryAction: const GuaranteeActionOnDemand(),
  ),
  GuaranteeRule(
    id: 'm07-t08',
    label: 'Selbstmeldung — manuelle Pruefung',
    m07TriggerId: GuaranteeTriggerId.t08,
    maxCompensationCents: 1000,
    trigger: const GuaranteeTriggerCancellation(),
    primaryAction: const GuaranteeActionOnDemand(),
  ),
];
