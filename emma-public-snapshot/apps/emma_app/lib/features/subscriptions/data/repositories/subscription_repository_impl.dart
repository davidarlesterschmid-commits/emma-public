import 'package:emma_app/features/subscriptions/domain/entities/subscription.dart';
import 'package:emma_app/features/subscriptions/domain/repositories/subscription_repository.dart';
import 'package:emma_app/features/subscriptions/data/datasources/subscription_remote_datasource.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remoteDataSource;

  SubscriptionRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Subscription>> getUserSubscriptions(String userId) async {
    return await remoteDataSource.fetchUserSubscriptions(userId);
  }

  @override
  Future<Subscription?> getSubscriptionById(String id) async {
    return await remoteDataSource.fetchSubscriptionById(id);
  }

  @override
  Future<void> createSubscription(Subscription subscription) async {
    await remoteDataSource.createSubscription(subscription);
  }

  @override
  Future<void> updateSubscription(Subscription subscription) async {
    await remoteDataSource.updateSubscription(subscription);
  }

  @override
  Future<void> cancelSubscription(String id) async {
    await remoteDataSource.cancelSubscription(id);
  }
}
