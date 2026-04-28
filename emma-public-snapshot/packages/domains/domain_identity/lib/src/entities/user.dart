import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Customer-facing identity record.
///
/// Kept deliberately small and transport-stable. Partner-specific
/// attributes (employer contract IDs, loyalty data, tariff roles) belong
/// on [UserAccount] or on dedicated contract objects — not here.
@freezed
sealed class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    String? company,
    String? phone,
    String? address,
    DateTime? birthDate,
    // ISO 639-1: 'de', 'en'.
    String? language,
    bool? notificationsEnabled,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
