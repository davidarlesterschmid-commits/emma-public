import 'package:emma_contracts/src/models/location.dart';

class EmmaRealtimeInfo {
  final DateTime timetabledTime;
  final DateTime? estimatedTime;
  final int? delayMinutes;
  final bool isRealtime;

  EmmaRealtimeInfo({
    required this.timetabledTime,
    this.estimatedTime,
    this.delayMinutes,
    required this.isRealtime,
  });

  factory EmmaRealtimeInfo.fromJson(Map<String, dynamic> json) {
    return EmmaRealtimeInfo(
      timetabledTime: DateTime.parse(json['timetabledTime']),
      estimatedTime: json['estimatedTime'] != null
          ? DateTime.parse(json['estimatedTime'])
          : null,
      delayMinutes: json['delayMinutes'],
      isRealtime: json['isRealtime'],
    );
  }
}

class EmmaLine {
  final String shortName;
  final String directionText;
  final String operatorName;
  final String ptMode;

  EmmaLine({
    required this.shortName,
    required this.directionText,
    required this.operatorName,
    required this.ptMode,
  });

  factory EmmaLine.fromJson(Map<String, dynamic> json) {
    return EmmaLine(
      shortName: json['shortName'],
      directionText: json['directionText'],
      operatorName: json['operatorName'],
      ptMode: json['ptMode'],
    );
  }
}

class EmmaLeg {
  final int legIndex;
  final String mode;
  final EmmaLocation origin;
  final EmmaLocation? destination;
  final EmmaLine? line;
  final EmmaRealtimeInfo? departure;
  final EmmaRealtimeInfo? arrival;

  EmmaLeg({
    required this.legIndex,
    required this.mode,
    required this.origin,
    this.destination,
    this.line,
    this.departure,
    this.arrival,
  });

  factory EmmaLeg.fromJson(Map<String, dynamic> json) {
    return EmmaLeg(
      legIndex: json['legIndex'],
      mode: json['mode'],
      origin: EmmaLocation.fromJson(json['origin']),
      destination: json['destination'] != null
          ? EmmaLocation.fromJson(json['destination'])
          : null,
      line: json['line'] != null ? EmmaLine.fromJson(json['line']) : null,
      departure: json['departure'] != null
          ? EmmaRealtimeInfo.fromJson(json['departure'])
          : null,
      arrival: json['arrival'] != null
          ? EmmaRealtimeInfo.fromJson(json['arrival'])
          : null,
    );
  }
}

class EmmaTrip {
  final String id;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int totalDurationSeconds;
  final int transferCount;
  final String providerId;
  final List<EmmaLeg> legs;
  final dynamic fare;
  final dynamic co2Grams;

  EmmaTrip({
    required this.id,
    required this.departureTime,
    required this.arrivalTime,
    required this.totalDurationSeconds,
    required this.transferCount,
    required this.providerId,
    required this.legs,
    this.fare,
    this.co2Grams,
  });

  factory EmmaTrip.fromJson(Map<String, dynamic> json) {
    return EmmaTrip(
      id: json['id'],
      departureTime: DateTime.parse(json['departureTime']),
      arrivalTime: DateTime.parse(json['arrivalTime']),
      totalDurationSeconds: json['totalDurationSeconds'],
      transferCount: json['transferCount'],
      providerId: json['providerId'],
      legs: (json['legs'] as List).map((leg) => EmmaLeg.fromJson(leg)).toList(),
      fare: json['fare'],
      co2Grams: json['co2Grams'],
    );
  }
}
