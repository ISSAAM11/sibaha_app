import 'package:sibaha_app/data/models/course.dart';

class Subscription {
  final int id;
  final int academyId;
  final String academyName;
  final String? academyCity;
  final String? academyAddress;
  final int? courseId;
  final String? courseName;
  final String? courseLevel;
  final String? coachName;
  final List<CourseTiming> timings;
  final double? priceAtSubscription;
  final String status;
  final DateTime subscribedAt;

  Subscription({
    required this.id,
    required this.academyId,
    required this.academyName,
    this.academyCity,
    this.academyAddress,
    this.courseId,
    this.courseName,
    this.courseLevel,
    this.coachName,
    this.timings = const [],
    this.priceAtSubscription,
    required this.status,
    required this.subscribedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as int,
      academyId: json['academy_id'] as int,
      academyName: json['academy_name'] as String,
      academyCity: json['academy_city'] as String?,
      academyAddress: json['academy_address'] as String?,
      courseId: json['course_id'] as int?,
      courseName: json['course_name'] as String?,
      courseLevel: json['course_level'] as String?,
      coachName: json['coach_name'] as String?,
      timings: (json['timings'] as List? ?? [])
          .map((e) => CourseTiming.fromJson(e as Map<String, dynamic>))
          .toList(),
      priceAtSubscription: json['price_at_subscription'] != null
          ? double.tryParse(json['price_at_subscription'].toString())
          : null,
      status: json['status'] as String,
      subscribedAt: DateTime.parse(json['subscribed_at'] as String),
    );
  }
}
