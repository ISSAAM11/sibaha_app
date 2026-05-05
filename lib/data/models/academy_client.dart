class AcademyClient {
  final int subscriptionId;
  final int userId;
  final String username;
  final String email;
  final String? userPicture;
  final double? priceAtSubscription;
  final String status;
  final DateTime subscribedAt;

  AcademyClient({
    required this.subscriptionId,
    required this.userId,
    required this.username,
    required this.email,
    this.userPicture,
    this.priceAtSubscription,
    required this.status,
    required this.subscribedAt,
  });

  factory AcademyClient.fromJson(Map<String, dynamic> json) {
    return AcademyClient(
      subscriptionId: json['id'] as int,
      userId: json['user_id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      userPicture: json['user_picture'] as String?,
      priceAtSubscription: json['price_at_subscription'] != null
          ? double.tryParse(json['price_at_subscription'].toString())
          : null,
      status: json['status'] as String,
      subscribedAt: DateTime.parse(json['subscribed_at'] as String),
    );
  }
}
