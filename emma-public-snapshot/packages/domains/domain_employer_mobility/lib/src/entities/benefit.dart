import 'package:freezed_annotation/freezed_annotation.dart';

part 'benefit.freezed.dart';
part 'benefit.g.dart';

/// Partner-vermittelter Benefit im Arbeitgeber-Mobilitätsbudget.
///
/// [isInBudget] trennt budgetrelevante Leistungen (z. B. verrechnete
/// Sharing-Monatspakete) von rein beworbenen Angeboten. [deepLink] ist
/// für vermittelte Redirects, [voucherCode] für "eingekaufte" Codes.
@freezed
sealed class Benefit with _$Benefit {
  const factory Benefit({
    required String id,
    required String name,
    required String description,
    required String partnerName,
    required bool isInBudget,
    required String? deepLink,
    required String? voucherCode,
    required String? logoUrl,
  }) = _Benefit;

  factory Benefit.fromJson(Map<String, dynamic> json) =>
      _$BenefitFromJson(json);
}
