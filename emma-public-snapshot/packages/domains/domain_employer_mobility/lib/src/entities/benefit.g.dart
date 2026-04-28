// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'benefit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Benefit _$BenefitFromJson(Map<String, dynamic> json) => _Benefit(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  partnerName: json['partnerName'] as String,
  isInBudget: json['isInBudget'] as bool,
  deepLink: json['deepLink'] as String?,
  voucherCode: json['voucherCode'] as String?,
  logoUrl: json['logoUrl'] as String?,
);

Map<String, dynamic> _$BenefitToJson(_Benefit instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'partnerName': instance.partnerName,
  'isInBudget': instance.isInBudget,
  'deepLink': instance.deepLink,
  'voucherCode': instance.voucherCode,
  'logoUrl': instance.logoUrl,
};
