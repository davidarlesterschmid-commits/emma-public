// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mobility_budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MobilityBudget _$MobilityBudgetFromJson(Map<String, dynamic> json) =>
    _MobilityBudget(
      totalBudget: (json['totalBudget'] as num).toDouble(),
      usedAmount: (json['usedAmount'] as num).toDouble(),
      remainingAmount: (json['remainingAmount'] as num).toDouble(),
      billingPeriodStart: DateTime.parse(json['billingPeriodStart'] as String),
      billingPeriodEnd: DateTime.parse(json['billingPeriodEnd'] as String),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$MobilityBudgetToJson(_MobilityBudget instance) =>
    <String, dynamic>{
      'totalBudget': instance.totalBudget,
      'usedAmount': instance.usedAmount,
      'remainingAmount': instance.remainingAmount,
      'billingPeriodStart': instance.billingPeriodStart.toIso8601String(),
      'billingPeriodEnd': instance.billingPeriodEnd.toIso8601String(),
      'currency': instance.currency,
    };
