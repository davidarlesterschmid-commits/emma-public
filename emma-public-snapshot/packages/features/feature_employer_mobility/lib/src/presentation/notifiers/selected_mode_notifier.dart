import 'package:domain_employer_mobility/domain_employer_mobility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// UI-lokale Selektion — persistierte Wahl lebt im [ProfileModeRepository].
class SelectedModeNotifier extends Notifier<UserMode> {
  @override
  UserMode build() => UserMode.private;

  void setMode(UserMode mode) => state = mode;
}
