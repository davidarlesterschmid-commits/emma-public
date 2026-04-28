import 'package:flutter/material.dart';
import 'package:emma_app/features/subscriptions/domain/entities/subscription.dart';

class SubscriptionCard extends StatelessWidget {
  final Subscription subscription;

  const SubscriptionCard({super.key, required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(subscription.type),
        subtitle: Text('Status: ${subscription.status}'),
        // TODO: Add more details and actions
      ),
    );
  }
}
