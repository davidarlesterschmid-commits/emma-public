import 'package:domain_learning/src/learning_models.dart';

abstract interface class LearningRepository {
  Future<void> recordSignal(LearningSignal signal);

  Future<List<PreferenceUpdate>> suggestPreferenceUpdates();
}
