/// Snapshots der zustimmungsrelevanten Schalter (MVP, App-Shell, kein DSGVO-Backend).
class UserConsentState {
  const UserConsentState({
    required this.analyticsEnabled,
    required this.marketingEnabled,
  });

  final bool analyticsEnabled;
  final bool marketingEnabled;

  UserConsentState copyWith({bool? analyticsEnabled, bool? marketingEnabled}) {
    return UserConsentState(
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      marketingEnabled: marketingEnabled ?? this.marketingEnabled,
    );
  }
}
