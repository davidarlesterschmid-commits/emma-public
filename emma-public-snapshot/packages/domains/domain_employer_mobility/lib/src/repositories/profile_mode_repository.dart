import '../entities/profile_mode.dart';

/// Persistiert und lädt den aktuellen [ProfileMode] des Kunden.
abstract interface class ProfileModeRepository {
  Future<ProfileMode> getProfileMode();
  Future<void> setProfileMode(UserMode mode);
}
