import 'package:emma_app/features/employer_mobility/presentation/providers/employer_mobility_providers.dart';
import 'package:feature_employer_mobility/feature_employer_mobility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod-Wiring für [TicketConfiguratorScreen] (App-Shell).
class TicketConfiguratorScreenShell extends ConsumerWidget {
  const TicketConfiguratorScreenShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketsAsync = ref.watch(jobTicketsProvider);

    return TicketConfiguratorScreen(
      isLoading: ticketsAsync.isLoading,
      error: ticketsAsync.hasError ? ticketsAsync.error : null,
      tickets: ticketsAsync.value,
      onBook: (id) => ref.read(jobTicketRepositoryProvider).bookTicket(id),
    );
  }
}
