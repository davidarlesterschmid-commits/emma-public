// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobTicket _$JobTicketFromJson(Map<String, dynamic> json) => _JobTicket(
  id: json['id'] as String,
  type: $enumDecode(_$TicketTypeEnumMap, json['type']),
  name: json['name'] as String,
  totalPrice: (json['totalPrice'] as num).toDouble(),
  employeeShare: (json['employeeShare'] as num).toDouble(),
  employerSubsidy: (json['employerSubsidy'] as num).toDouble(),
  validFrom: DateTime.parse(json['validFrom'] as String),
  validTo: DateTime.parse(json['validTo'] as String),
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$JobTicketToJson(_JobTicket instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$TicketTypeEnumMap[instance.type]!,
      'name': instance.name,
      'totalPrice': instance.totalPrice,
      'employeeShare': instance.employeeShare,
      'employerSubsidy': instance.employerSubsidy,
      'validFrom': instance.validFrom.toIso8601String(),
      'validTo': instance.validTo.toIso8601String(),
      'isActive': instance.isActive,
    };

const _$TicketTypeEnumMap = {
  TicketType.dticket: 'dticket',
  TicketType.regionalJobticket: 'regionalJobticket',
};
