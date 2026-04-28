import 'package:emma_app/features/employer_mobility/presentation/providers/employer_mobility_providers.dart';
import 'package:feature_employer_mobility/feature_employer_mobility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod-Wiring für [EmployerMobilityScreen] (App-Shell).
class EmployerMobilityScreenShell extends ConsumerWidget {
  const EmployerMobilityScreenShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetAsync = ref.watch(budgetProvider);
    final benefitsAsync = ref.watch(budgetBenefitsProvider);
    final profileModeAsync = ref.watch(profileModeProvider);
    final selectedMode = ref.watch(selectedModeProvider);

    return EmployerMobilityScreen(
      budgetIsLoading: budgetAsync.isLoading,
      budgetError: budgetAsync.hasError ? budgetAsync.error : null,
      budget: budgetAsync.value,
      benefitsIsLoading: benefitsAsync.isLoading,
      benefitsError: benefitsAsync.hasError ? benefitsAsync.error : null,
      budgetRelevantBenefits: benefitsAsync.value,
      profileIsLoading: profileModeAsync.isLoading,
      profileError: profileModeAsync.hasError ? profileModeAsync.error : null,
      profileMode: profileModeAsync.value,
      selectedMode: selectedMode,
      onSelectPrivate: () {
        ref.read(selectedModeProvider.notifier).setMode(UserMode.private);
      },
      onSelectEmployer: () {
        ref.read(selectedModeProvider.notifier).setMode(UserMode.employer);
      },
    );
  }
}
