import 'package:domain_employer_mobility/domain_employer_mobility.dart';

import 'benefit_remote_datasource.dart';

/// Default [BenefitRepository] implementation.
class BenefitRepositoryImpl implements BenefitRepository {
  BenefitRepositoryImpl(this._remote);

  final BenefitRemoteDataSource _remote;

  @override
  Future<List<Benefit>> getBenefits({bool inBudgetOnly = false}) async {
    final benefits = await _remote.getBenefits();
    if (inBudgetOnly) {
      return benefits.where((b) => b.isInBudget).toList(growable: false);
    }
    return benefits;
  }
}
