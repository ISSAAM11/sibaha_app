class CourseTiming {
  final int id;
  final String weekday;
  final String startTime;
  final String endTime;

  const CourseTiming({
    required this.id,
    required this.weekday,
    required this.startTime,
    required this.endTime,
  });

  factory CourseTiming.fromJson(Map<String, dynamic> json) => CourseTiming(
        id: json['id'] as int,
        weekday: json['weekday'] as String,
        startTime: json['start_time'] as String,
        endTime: json['end_time'] as String,
      );

  Map<String, dynamic> toJson() => {
        'weekday': weekday,
        'start_time': startTime,
        'end_time': endTime,
      };
}

class Course {
  final int id;
  final int academyId;
  final String name;
  final String description;
  final String level;
  final double? pricePerMonth;
  final int? coachId;
  final String? coachName;
  final String? coachPicture;
  final int? poolId;
  final List<CourseTiming> timings;
  final DateTime createdAt;

  const Course({
    required this.id,
    required this.academyId,
    required this.name,
    required this.description,
    required this.level,
    this.pricePerMonth,
    this.coachId,
    this.coachName,
    this.coachPicture,
    this.poolId,
    required this.timings,
    required this.createdAt,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json['id'] as int,
        academyId: json['academy'] as int,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        level: json['level'] as String? ?? 'beginner',
        pricePerMonth: json['price_per_month'] != null
            ? double.tryParse(json['price_per_month'].toString())
            : null,
        coachId: json['coach_id'] as int?,
        coachName: json['coach_name'] as String?,
        coachPicture: json['coach_picture'] as String?,
        poolId: json['pool_id'] as int?,
        timings: (json['timings'] as List? ?? [])
            .map((e) => CourseTiming.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}
