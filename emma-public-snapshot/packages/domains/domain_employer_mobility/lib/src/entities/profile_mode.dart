import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_mode.freezed.dart';

/// Rollenmodus des Kunden in emma.
///
/// [private] — privater Kundenzugang.
/// [employer] — Arbeitgeber-Mobilität aktiv; DSGVO-Hinweis muss beim
/// Wechsel durch die UI angezeigt werden.
enum UserMode { private, employer }

/// Aktueller Profilmodus-Zustand.
///
/// [isEmployerModeAvailable] bildet die Berechtigungslage ab: ein Kunde
/// ohne aktivem BMM-Vertrag darf den Arbeitgeber-Mode nicht aktivieren.
@freezed
sealed class ProfileMode with _$ProfileMode {
  const factory ProfileMode({
    required UserMode currentMode,
    required bool isEmployerModeAvailable,
  }) = _ProfileMode;
}
