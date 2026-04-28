import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:emma_app/features/subscriptions/data/datasources/subscription_remote_datasource.dart';
import 'package:emma_app/features/subscriptions/data/repositories/subscription_repository_impl.dart';
import 'package:emma_app/features/subscriptions/domain/entities/subscription.dart';
import 'package:emma_app/features/subscriptions/domain/repositories/subscription_repository.dart';

final subscriptionRemoteDataSourceProvider =
    Provider<SubscriptionRemoteDataSource>(
      (ref) => SubscriptionRemoteDataSourceImpl(),
    );

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepositoryImpl(
    ref.watch(subscriptionRemoteDataSourceProvider),
  );
});

class SubscriptionNotifier extends Notifier<List<Subscription>> {
  @override
  List<Subscription> build() => const [];

  Future<void> loadUserSubscriptions(String userId) async {
    final repo = ref.read(subscriptionRepositoryProvider);
    final subscriptions = await repo.getUserSubscriptions(userId);
    state = subscriptions;
  }
}

final subscriptionNotifierProvider =
    NotifierProvider<SubscriptionNotifier, List<Subscription>>(
      SubscriptionNotifier.new,
    );
