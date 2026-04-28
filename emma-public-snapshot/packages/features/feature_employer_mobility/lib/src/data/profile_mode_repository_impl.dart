import 'package:domain_employer_mobility/domain_employer_mobility.dart';

import 'profile_mode_local_datasource.dart';

/// Default [ProfileModeRepository] implementation.
///
/// [isEmployerModeAvailable] ist aktuell hart auf `true` gesetzt. In
/// einer späteren Iteration wird dieser Wert aus dem Kundenkonto
/// (BMM-Vertragsstatus) abgeleitet.
class ProfileModeRepositoryImpl implements ProfileModeRepository {
  ProfileModeRepositoryImpl(this._local);

  final ProfileModeLocalDataSource _local;

  @override
  Future<ProfileMode> getProfileMode() async {
    final mode = await _local.getProfileMode();
    return ProfileMode(
      currentMode: mode ?? UserMode.private,
      isEmployerModeAvailable: true,
    );
  }

  @override
  Future<void> setProfileMode(UserMode mode) => _local.setProfileMode(mode);
}
