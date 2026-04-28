import 'package:domain_wallet/domain_wallet.dart';

abstract class BudgetPort {
  Future<MobilityBudget> getBudget();
}
