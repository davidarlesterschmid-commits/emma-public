import 'package:domain_employer_mobility/domain_employer_mobility.dart';
import 'package:domain_wallet/domain_wallet.dart';

import 'budget_remote_datasource.dart';

/// Default [BudgetRepository] implementation.
///
/// Orchestriert den [BudgetRemoteDataSource]. Das Refresh-Verhalten
/// bleibt konservativ — es feuert erneut den Abruf; ein Caching-Layer
/// kommt später.
class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(this._remote);

  final BudgetRemoteDataSource _remote;

  @override
  Future<MobilityBudget> getBudget() => _remote.getBudget();

  @override
  Future<void> refreshBudget() async {
    await _remote.getBudget();
  }
}
