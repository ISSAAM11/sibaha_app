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
}

class CoachCourse {
  final int id;
  final String name;
  final String description;
  final String level;
  final int academyId;
  final String academyName;
  final int? poolId;
  final String? poolName;
  final List<CourseTiming> timings;
  final DateTime createdAt;

  const CoachCourse({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    required this.academyId,
    required this.academyName,
    this.poolId,
    this.poolName,
    required this.timings,
    required this.createdAt,
  });

  factory CoachCourse.fromJson(Map<String, dynamic> json) => CoachCourse(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        level: json['level'] as String? ?? 'beginner',
        academyId: json['academy_id'] as int,
        academyName: json['academy_name'] as String,
        poolId: json['pool_id'] as int?,
        poolName: json['pool_name'] as String?,
        timings: (json['timings'] as List? ?? [])
            .map((e) => CourseTiming.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}
