import 'package:emma_app/features/subscriptions/domain/entities/subscription.dart';

abstract class SubscriptionRepository {
  Future<List<Subscription>> getUserSubscriptions(String userId);
  Future<Subscription?> getSubscriptionById(String id);
  Future<void> createSubscription(Subscription subscription);
  Future<void> updateSubscription(Subscription subscription);
  Future<void> cancelSubscription(String id);
  // TODO: Implement all required methods
}
