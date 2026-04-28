import 'package:domain_learning/domain_learning.dart';

class FakeLearningRepository implements LearningRepository {
  FakeLearningRepository();

  final List<LearningSignal> _signals = <LearningSignal>[];

  @override
  Future<void> recordSignal(LearningSignal signal) async {
    _signals.add(signal);
  }

  @override
  Future<List<PreferenceUpdate>> suggestPreferenceUpdates() async {
    if (_signals.isEmpty) {
      return const <PreferenceUpdate>[];
    }
    return const <PreferenceUpdate>[
      PreferenceUpdate(
        id: 'pref-update-demo',
        preferenceKey: 'route_profile',
        value: 'reliable',
        isAutomated: false,
      ),
    ];
  }
}
