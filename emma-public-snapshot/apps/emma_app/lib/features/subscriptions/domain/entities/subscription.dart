class Subscription {
  final String id;
  final String userId;
  final String type; // e.g., 'Deutschlandticket', 'Jobticket'
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final String status; // 'active', 'expired', 'cancelled'
  // TODO: Add more fields as per requirements

  Subscription({
    required this.id,
    required this.userId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.status,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      userId: json['userId'],
      type: json['type'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      price: json['price'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'type': type,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'price': price,
      'status': status,
    };
  }
}
