import 'package:emma_app/core/ticketing_providers.dart';
import 'package:feature_ticketing/feature_ticketing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TicketingCatalogHost extends ConsumerWidget {
  const TicketingCatalogHost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(ticketingRepositoryProvider);
    return TicketingCatalogScreen(repository: repo);
  }
}
