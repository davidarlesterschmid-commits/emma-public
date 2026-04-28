// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tariff_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TariffRule _$TariffRuleFromJson(Map<String, dynamic> json) => _TariffRule(
  id: json['id'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  entitlements: (json['entitlements'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  isSubscription: json['isSubscription'] as bool,
);

Map<String, dynamic> _$TariffRuleToJson(_TariffRule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'entitlements': instance.entitlements,
      'isSubscription': instance.isSubscription,
    };
