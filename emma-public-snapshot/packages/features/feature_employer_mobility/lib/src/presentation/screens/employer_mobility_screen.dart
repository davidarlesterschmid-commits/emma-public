import 'package:domain_employer_mobility/domain_employer_mobility.dart';
import 'package:domain_wallet/domain_wallet.dart';
import 'package:flutter/material.dart';

import '../widgets/benefit_wallet.dart';
import '../widgets/budget_dashboard.dart';
import '../widgets/profile_mode_switch.dart';

/// Einstiegsscreen für die Arbeitgebermobilität.
///
/// Lade- und Aktionen-Callbacks kommen von der App-Shell (z. B. Riverpod).
class EmployerMobilityScreen extends StatelessWidget {
  const EmployerMobilityScreen({
    super.key,
    required this.budgetIsLoading,
    this.budgetError,
    this.budget,
    required this.benefitsIsLoading,
    this.benefitsError,
    this.budgetRelevantBenefits,
    required this.profileIsLoading,
    this.profileError,
    this.profileMode,
    required this.selectedMode,
    required this.onSelectPrivate,
    this.onSelectEmployer,
  });

  final bool budgetIsLoading;
  final Object? budgetError;
  final MobilityBudget? budget;

  final bool benefitsIsLoading;
  final Object? benefitsError;
  final List<Benefit>? budgetRelevantBenefits;

  final bool profileIsLoading;
  final Object? profileError;
  final ProfileMode? profileMode;
  final UserMode selectedMode;
  final VoidCallback onSelectPrivate;
  final VoidCallback? onSelectEmployer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arbeitgebermobilität'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ProfileModeSwitch(
                isLoading: profileIsLoading,
                error: profileError,
                profileMode: profileMode,
                selectedMode: selectedMode,
                onSelectPrivate: onSelectPrivate,
                onSelectEmployer: onSelectEmployer,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BudgetDashboard(
              isLoading: budgetIsLoading,
              error: budgetError,
              budget: budget,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Partner & Benefits',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            BenefitWallet(
              isLoading: benefitsIsLoading,
              error: benefitsError,
              benefits: budgetRelevantBenefits,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
