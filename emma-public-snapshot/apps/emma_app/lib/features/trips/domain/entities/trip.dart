import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

@freezed
sealed class Trip with _$Trip {
  const factory Trip({
    required String id,
    required String from,
    required String to,
    required DateTime departureTime,
    required List<TripLeg> legs,
    required Duration totalDuration,
    required double totalCost,
    String? status, // 'planned', 'active', 'completed', 'cancelled'
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
}

@freezed
sealed class TripLeg with _$TripLeg {
  const factory TripLeg({
    required String id,
    required String mode, // 'walk', 'bus', 'train', 'car', 'bike'
    required String from,
    required String to,
    required DateTime departureTime,
    required DateTime arrivalTime,
    required Duration duration,
    double? cost,
    String? provider,
    String? line,
    Map<String, dynamic>? additionalInfo,
  }) = _TripLeg;

  factory TripLeg.fromJson(Map<String, dynamic> json) =>
      _$TripLegFromJson(json);
}

@freezed
sealed class Location with _$Location {
  const factory Location({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    String? address,
    String? stopId, // TRIAS stop point ID
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}
