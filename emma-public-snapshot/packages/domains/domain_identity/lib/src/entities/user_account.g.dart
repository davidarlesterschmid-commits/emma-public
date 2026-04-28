// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserAccount _$UserAccountFromJson(Map<String, dynamic> json) => _UserAccount(
  id: json['id'] as String,
  email: json['email'] as String,
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
  contracts: (json['contracts'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  ticketHistory: (json['ticketHistory'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  preferences: json['preferences'] as Map<String, dynamic>,
);

Map<String, dynamic> _$UserAccountToJson(_UserAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'roles': instance.roles,
      'contracts': instance.contracts,
      'ticketHistory': instance.ticketHistory,
      'preferences': instance.preferences,
    };
