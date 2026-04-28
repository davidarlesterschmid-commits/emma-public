class JourneyOptionDto {
  JourneyOptionDto({
    required this.id,
    required this.label,
    required this.originId,
    required this.destinationId,
  });

  final String id;
  final String label;
  final String originId;
  final String destinationId;

  factory JourneyOptionDto.fromJson(Map<String, dynamic> json) {
    return JourneyOptionDto(
      id: json['id'] as String,
      label: json['label'] as String,
      originId: json['originId'] as String,
      destinationId: json['destinationId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'originId': originId,
      'destinationId': destinationId,
    };
  }
}
