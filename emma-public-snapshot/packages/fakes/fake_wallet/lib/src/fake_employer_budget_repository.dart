import 'package:domain_employer_mobility/domain_employer_mobility.dart';
import 'package:domain_wallet/domain_wallet.dart';

class FakeEmployerBudgetRepository implements BudgetRepository {
  const FakeEmployerBudgetRepository({MobilityBudget? budget})
    : _budget = budget;

  final MobilityBudget? _budget;

  @override
  Future<MobilityBudget> getBudget() async => _budget ?? _defaultBudget();

  @override
  Future<void> refreshBudget() async {}

  static MobilityBudget _defaultBudget() {
    return MobilityBudget(
      totalBudget: 58,
      usedAmount: 12,
      remainingAmount: 46,
      billingPeriodStart: DateTime.utc(2026, 4),
      billingPeriodEnd: DateTime.utc(2026, 4, 30),
      currency: 'EUR',
    );
  }
}
