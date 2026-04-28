import 'package:emma_app/features/subscriptions/domain/entities/subscription.dart';

abstract class SubscriptionRemoteDataSource {
  Future<List<Subscription>> fetchUserSubscriptions(String userId);
  Future<Subscription> fetchSubscriptionById(String id);
  Future<void> createSubscription(Subscription subscription);
  Future<void> updateSubscription(Subscription subscription);
  Future<void> cancelSubscription(String id);
  // TODO: Implement data source logic
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  // TODO: Implement with Dio or other HTTP client
  @override
  Future<List<Subscription>> fetchUserSubscriptions(String userId) async {
    // Placeholder
    return [];
  }

  @override
  Future<Subscription> fetchSubscriptionById(String id) async {
    // Placeholder
    throw UnimplementedError();
  }

  @override
  Future<void> createSubscription(Subscription subscription) async {
    // Placeholder
  }

  @override
  Future<void> updateSubscription(Subscription subscription) async {
    // Placeholder
  }

  @override
  Future<void> cancelSubscription(String id) async {
    // Placeholder
  }
}
