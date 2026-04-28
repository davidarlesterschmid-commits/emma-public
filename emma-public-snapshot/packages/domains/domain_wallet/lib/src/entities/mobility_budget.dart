import 'package:freezed_annotation/freezed_annotation.dart';

part 'mobility_budget.freezed.dart';
part 'mobility_budget.g.dart';

@freezed
sealed class MobilityBudget with _$MobilityBudget {
  const factory MobilityBudget({
    required double totalBudget,
    required double usedAmount,
    required double remainingAmount,
    required DateTime billingPeriodStart,
    required DateTime billingPeriodEnd,
    required String currency,
  }) = _MobilityBudget;

  factory MobilityBudget.fromJson(Map<String, dynamic> json) =>
      _$MobilityBudgetFromJson(json);
}
