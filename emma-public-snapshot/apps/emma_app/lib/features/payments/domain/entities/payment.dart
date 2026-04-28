class Payment {
  final String id;
  final String userId;
  final double amount;
  final String currency;
  final String status; // 'pending', 'completed', 'failed'
  final DateTime timestamp;
  // TODO: Add more fields like payment method, transaction id

  Payment({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.timestamp,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      userId: json['userId'],
      amount: json['amount'],
      currency: json['currency'],
      status: json['status'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'currency': currency,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
