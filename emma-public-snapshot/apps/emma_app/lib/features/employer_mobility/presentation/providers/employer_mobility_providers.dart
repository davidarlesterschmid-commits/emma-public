import 'package:dio/dio.dart';
import 'package:feature_employer_mobility/feature_employer_mobility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// -----------------------------------------------------------------------------
// Infra — throw-defaults, overridden in [bootstrap] (same as former package).
// -----------------------------------------------------------------------------

/// HTTP client for employer-mobility remote data sources. MUST be overridden.
final employerDioProvider = Provider<Dio>((ref) {
  throw StateError(
    'employerDioProvider was read without an override. '
    'Bind it to your app-level Dio provider in ProviderScope.overrides.',
  );
});

/// Secure storage for profile-mode local data source. MUST be overridden.
final employerSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  throw StateError(
    'employerSecureStorageProvider was read without an override. '
    'Bind it to your app-level FlutterSecureStorage provider in '
    'ProviderScope.overrides.',
  );
});

// -----------------------------------------------------------------------------
// Repositories and async state
// -----------------------------------------------------------------------------

final _benefitRemoteDataSourceProvider = Provider<BenefitRemoteDataSource>((
  ref,
) {
  return BenefitRemoteDataSourceImpl(ref.watch(employerDioProvider));
});

final benefitRepositoryProvider = Provider<BenefitRepository>((ref) {
  return BenefitRepositoryImpl(ref.watch(_benefitRemoteDataSourceProvider));
});

final benefitsProvider = FutureProvider<List<Benefit>>((ref) async {
  return ref.watch(benefitRepositoryProvider).getBenefits();
});

final budgetBenefitsProvider = FutureProvider<List<Benefit>>((ref) async {
  return ref.watch(benefitRepositoryProvider).getBenefits(inBudgetOnly: true);
});

final _budgetRemoteDataSourceProvider = Provider<BudgetRemoteDataSource>((ref) {
  return BudgetRemoteDataSourceImpl(ref.watch(employerDioProvider));
});

/// Concrete [BudgetRepository]. Journey uses it as [BudgetPort] from
/// `emma_contracts`.
final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepositoryImpl(ref.watch(_budgetRemoteDataSourceProvider));
});

final budgetProvider = FutureProvider<MobilityBudget>((ref) async {
  return ref.watch(budgetRepositoryProvider).getBudget();
});

final _jobTicketRemoteDataSourceProvider = Provider<JobTicketRemoteDataSource>((
  ref,
) {
  return JobTicketRemoteDataSourceImpl(ref.watch(employerDioProvider));
});

final jobTicketRepositoryProvider = Provider<JobTicketRepository>((ref) {
  return JobTicketRepositoryImpl(ref.watch(_jobTicketRemoteDataSourceProvider));
});

final jobTicketsProvider = FutureProvider<List<JobTicket>>((ref) async {
  return ref.watch(jobTicketRepositoryProvider).getAvailableTickets();
});

final bookTicketProvider = FutureProvider.family<void, String>((
  ref,
  ticketId,
) async {
  await ref.watch(jobTicketRepositoryProvider).bookTicket(ticketId);
});

final _profileModeLocalDataSourceProvider =
    Provider<ProfileModeLocalDataSource>((ref) {
      return ProfileModeLocalDataSourceImpl(
        ref.watch(employerSecureStorageProvider),
      );
    });

final profileModeRepositoryProvider = Provider<ProfileModeRepository>((ref) {
  return ProfileModeRepositoryImpl(
    ref.watch(_profileModeLocalDataSourceProvider),
  );
});

final profileModeProvider = FutureProvider<ProfileMode>((ref) async {
  return ref.watch(profileModeRepositoryProvider).getProfileMode();
});

/// Local UI selection — persistent choice lives in [profileModeProvider].
class SelectedModeNotifier extends Notifier<UserMode> {
  @override
  UserMode build() => UserMode.private;

  void setMode(UserMode mode) => state = mode;
}

final selectedModeProvider = NotifierProvider<SelectedModeNotifier, UserMode>(
  SelectedModeNotifier.new,
);
