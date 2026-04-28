import 'package:domain_mobility_guarantee/src/m07/guarantee_trigger_id.dart';
import 'package:meta/meta.dart';

/// Wiederaufnahme der Recovery-Struktur (Trigger + Aktion) plus M07-Felder.
@immutable
class GuaranteeRule {
  const GuaranteeRule({
    required this.id,
    required this.label,
    required this.trigger,
    required this.primaryAction,
    this.m07TriggerId,
    this.maxCompensationCents,
  });

  final String id;
  final String label;
  final GuaranteeTrigger trigger;
  final GuaranteeAction primaryAction;
  final GuaranteeTriggerId? m07TriggerId;
  final int? maxCompensationCents;
}

@immutable
sealed class GuaranteeTrigger {
  const GuaranteeTrigger();
}

@immutable
final class GuaranteeTriggerDelay extends GuaranteeTrigger {
  const GuaranteeTriggerDelay({required this.minimumDelayMinutes});
  final int minimumDelayMinutes;
}

@immutable
final class GuaranteeTriggerCancellation extends GuaranteeTrigger {
  const GuaranteeTriggerCancellation();
}

@immutable
sealed class GuaranteeAction {
  const GuaranteeAction();
}

@immutable
final class GuaranteeActionTaxi extends GuaranteeAction {
  const GuaranteeActionTaxi({this.maxCompensationCents});
  final int? maxCompensationCents;
}

@immutable
final class GuaranteeActionOnDemand extends GuaranteeAction {
  const GuaranteeActionOnDemand();
}
