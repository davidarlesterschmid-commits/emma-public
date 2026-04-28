import 'package:freezed_annotation/freezed_annotation.dart';

part 'tariff_rule.freezed.dart';
part 'tariff_rule.g.dart';

@freezed
sealed class TariffRule with _$TariffRule {
  const factory TariffRule({
    required String id,
    required String name,
    required double price,
    required List<String> entitlements,
    required bool isSubscription,
  }) = _TariffRule;

  factory TariffRule.fromJson(Map<String, dynamic> json) =>
      _$TariffRuleFromJson(json);
}
