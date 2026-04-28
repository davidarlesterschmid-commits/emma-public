/// Public surface of the employer-mobility feature.
///
/// The host app (`apps/emma_app`) wires Riverpod in
/// `features/employer_mobility/presentation/providers/employer_mobility_providers.dart`
/// and overrides [employerDioProvider] / [employerSecureStorageProvider] at
/// bootstrap.
///
/// * [employerDioProvider] / [employerSecureStorageProvider] — port providers
///   in [src/wiring/feature_employer_mobility_ports.dart].
/// * [EmployerMobilityScreen] / [TicketConfiguratorScreen] — parameters from shell.
/// * [BudgetDashboard] / [BenefitWallet] / [ProfileModeSwitch] — explicit params.
/// * [SelectedModeNotifier] / data-source exports — for app-shell providers.
library;

export 'package:domain_employer_mobility/domain_employer_mobility.dart'
    show
        Benefit,
        BenefitRepository,
        BudgetRepository,
        JobTicket,
        JobTicketRepository,
        ProfileMode,
        ProfileModeRepository,
        TicketType,
        UserMode;
export 'package:domain_wallet/domain_wallet.dart' show MobilityBudget;

export 'employer_data_exports.dart';
export 'src/presentation/notifiers/selected_mode_notifier.dart'
    show SelectedModeNotifier;
export 'src/presentation/screens/employer_mobility_screen.dart'
    show EmployerMobilityScreen;
export 'src/presentation/screens/ticket_configurator_screen.dart'
    show TicketConfiguratorScreen;
export 'src/presentation/widgets/benefit_wallet.dart' show BenefitWallet;
export 'src/presentation/widgets/budget_dashboard.dart' show BudgetDashboard;
export 'src/presentation/widgets/profile_mode_switch.dart'
    show ProfileModeSwitch;
export 'src/wiring/feature_employer_mobility_ports.dart'
    show employerDioProvider, employerSecureStorageProvider;
