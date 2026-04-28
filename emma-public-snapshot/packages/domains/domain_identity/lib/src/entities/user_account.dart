import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_account.freezed.dart';
part 'user_account.g.dart';

/// Aggregated customer account view.
///
/// Carries roles, contract references and opaque preferences. The shape
/// is intentionally string/list/map based so it can be swapped to a
/// real backend schema without churn in feature code.
@freezed
sealed class UserAccount with _$UserAccount {
  const factory UserAccount({
    required String id,
    required String email,
    // e.g. 'private', 'employer'.
    required List<String> roles,
    required List<String> contracts,
    required List<String> ticketHistory,
    required Map<String, dynamic> preferences,
  }) = _UserAccount;

  factory UserAccount.fromJson(Map<String, dynamic> json) =>
      _$UserAccountFromJson(json);
}
