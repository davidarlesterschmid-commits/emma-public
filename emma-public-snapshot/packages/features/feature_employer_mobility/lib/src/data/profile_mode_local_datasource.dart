import 'package:domain_employer_mobility/domain_employer_mobility.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persistenz für den Profilmodus-Wahl des Kunden.
///
/// Nutzt [FlutterSecureStorage], damit die Wahl Prozess-übergreifend
/// erhalten bleibt, ohne in Klartext-Preferences zu landen.
abstract interface class ProfileModeLocalDataSource {
  Future<UserMode?> getProfileMode();
  Future<void> setProfileMode(UserMode mode);
}

class ProfileModeLocalDataSourceImpl implements ProfileModeLocalDataSource {
  ProfileModeLocalDataSourceImpl(this._storage);

  static const _key = 'profile_mode';

  final FlutterSecureStorage _storage;

  @override
  Future<UserMode?> getProfileMode() async {
    final mode = await _storage.read(key: _key);
    if (mode == null) return null;
    return mode == 'employer' ? UserMode.employer : UserMode.private;
  }

  @override
  Future<void> setProfileMode(UserMode mode) async {
    await _storage.write(
      key: _key,
      value: mode == UserMode.employer ? 'employer' : 'private',
    );
  }
}
