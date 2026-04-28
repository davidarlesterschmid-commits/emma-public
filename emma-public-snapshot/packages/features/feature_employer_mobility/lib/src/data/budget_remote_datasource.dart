import 'package:dio/dio.dart';
import 'package:domain_wallet/domain_wallet.dart';

/// Remote side of the budget repository.
///
/// The current implementation is a mock that mirrors the previous
/// app-internal behaviour (1:1-Übernahmepflicht). A real tariff-server
/// adapter replaces [BudgetRemoteDataSourceImpl] without touching the
/// contract.
abstract interface class BudgetRemoteDataSource {
  Future<MobilityBudget> getBudget();
}

class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  BudgetRemoteDataSourceImpl(this._dio);

  // ignore: unused_field
  final Dio _dio;

  @override
  Future<MobilityBudget> getBudget() async {
    // TODO(emma-employer): replace with real budget endpoint.
    await Future<void>.delayed(const Duration(seconds: 1));
    final now = DateTime.now();
    return MobilityBudget(
      totalBudget: 2500.0,
      usedAmount: 847.50,
      remainingAmount: 1652.50,
      billingPeriodStart: DateTime(now.year, now.month, 1),
      billingPeriodEnd: DateTime(now.year, now.month + 1, 0),
      currency: 'EUR',
    );
  }
}
