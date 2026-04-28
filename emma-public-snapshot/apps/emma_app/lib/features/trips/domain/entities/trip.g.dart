// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Trip _$TripFromJson(Map<String, dynamic> json) => _Trip(
  id: json['id'] as String,
  from: json['from'] as String,
  to: json['to'] as String,
  departureTime: DateTime.parse(json['departureTime'] as String),
  legs: (json['legs'] as List<dynamic>)
      .map((e) => TripLeg.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalDuration: Duration(microseconds: (json['totalDuration'] as num).toInt()),
  totalCost: (json['totalCost'] as num).toDouble(),
  status: json['status'] as String?,
);

Map<String, dynamic> _$TripToJson(_Trip instance) => <String, dynamic>{
  'id': instance.id,
  'from': instance.from,
  'to': instance.to,
  'departureTime': instance.departureTime.toIso8601String(),
  'legs': instance.legs,
  'totalDuration': instance.totalDuration.inMicroseconds,
  'totalCost': instance.totalCost,
  'status': instance.status,
};

_TripLeg _$TripLegFromJson(Map<String, dynamic> json) => _TripLeg(
  id: json['id'] as String,
  mode: json['mode'] as String,
  from: json['from'] as String,
  to: json['to'] as String,
  departureTime: DateTime.parse(json['departureTime'] as String),
  arrivalTime: DateTime.parse(json['arrivalTime'] as String),
  duration: Duration(microseconds: (json['duration'] as num).toInt()),
  cost: (json['cost'] as num?)?.toDouble(),
  provider: json['provider'] as String?,
  line: json['line'] as String?,
  additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$TripLegToJson(_TripLeg instance) => <String, dynamic>{
  'id': instance.id,
  'mode': instance.mode,
  'from': instance.from,
  'to': instance.to,
  'departureTime': instance.departureTime.toIso8601String(),
  'arrivalTime': instance.arrivalTime.toIso8601String(),
  'duration': instance.duration.inMicroseconds,
  'cost': instance.cost,
  'provider': instance.provider,
  'line': instance.line,
  'additionalInfo': instance.additionalInfo,
};

_Location _$LocationFromJson(Map<String, dynamic> json) => _Location(
  id: json['id'] as String,
  name: json['name'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  address: json['address'] as String?,
  stopId: json['stopId'] as String?,
);

Map<String, dynamic> _$LocationToJson(_Location instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'address': instance.address,
  'stopId': instance.stopId,
};
