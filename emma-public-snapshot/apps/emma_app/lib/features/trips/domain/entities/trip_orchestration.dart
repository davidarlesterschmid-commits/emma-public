import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_orchestration.freezed.dart';
part 'trip_orchestration.g.dart';

@freezed
sealed class TripOrchestration with _$TripOrchestration {
  const factory TripOrchestration({
    required String id,
    required String type, // 'mediated', 'purchased', 'selfProvided'
    required List<String> providers,
    required double cost,
  }) = _TripOrchestration;

  factory TripOrchestration.fromJson(Map<String, dynamic> json) =>
      _$TripOrchestrationFromJson(json);
}
