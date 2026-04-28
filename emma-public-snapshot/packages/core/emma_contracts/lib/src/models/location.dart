class EmmaLocation {
  final String name;
  final String stopRef;
  final String? platformCode;
  final double? latitude;
  final double? longitude;

  EmmaLocation({
    required this.name,
    required this.stopRef,
    this.platformCode,
    this.latitude,
    this.longitude,
  });

  factory EmmaLocation.fromJson(Map<String, dynamic> json) {
    return EmmaLocation(
      name: json['name'],
      stopRef: json['stopRef'],
      platformCode: json['platformCode'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'stopRef': stopRef,
      'platformCode': platformCode,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
