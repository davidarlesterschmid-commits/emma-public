// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  company: json['company'] as String?,
  phone: json['phone'] as String?,
  address: json['address'] as String?,
  birthDate: json['birthDate'] == null
      ? null
      : DateTime.parse(json['birthDate'] as String),
  language: json['language'] as String?,
  notificationsEnabled: json['notificationsEnabled'] as bool?,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'company': instance.company,
  'phone': instance.phone,
  'address': instance.address,
  'birthDate': instance.birthDate?.toIso8601String(),
  'language': instance.language,
  'notificationsEnabled': instance.notificationsEnabled,
};
