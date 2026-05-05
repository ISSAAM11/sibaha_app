class Subscription {
  final int id;
  final int academyId;
  final String academyName;
  final double? priceAtSubscription;
  final String status;
  final DateTime subscribedAt;

  Subscription({
    required this.id,
    required this.academyId,
    required this.academyName,
    this.priceAtSubscription,
    required this.status,
    required this.subscribedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as int,
      academyId: json['academy_id'] as int,
      academyName: json['academy_name'] as String,
      priceAtSubscription: json['price_at_subscription'] != null
          ? double.tryParse(json['price_at_subscription'].toString())
          : null,
      status: json['status'] as String,
      subscribedAt: DateTime.parse(json['subscribed_at'] as String),
    );
  }
}
