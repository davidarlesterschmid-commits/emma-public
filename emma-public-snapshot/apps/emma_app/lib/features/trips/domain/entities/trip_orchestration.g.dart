// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_orchestration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TripOrchestration _$TripOrchestrationFromJson(Map<String, dynamic> json) =>
    _TripOrchestration(
      id: json['id'] as String,
      type: json['type'] as String,
      providers: (json['providers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      cost: (json['cost'] as num).toDouble(),
    );

Map<String, dynamic> _$TripOrchestrationToJson(_TripOrchestration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'providers': instance.providers,
      'cost': instance.cost,
    };
