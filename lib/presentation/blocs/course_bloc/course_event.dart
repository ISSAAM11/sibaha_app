part of 'course_bloc.dart';

@immutable
sealed class CourseEvent {}

class FetchCoursesEvent extends CourseEvent {
  final String token;
  final int academyId;
  FetchCoursesEvent(this.token, this.academyId);
}

class CreateCourseEvent extends CourseEvent {
  final String token;
  final int academyId;
  final String name;
  final String description;
  final String level;
  final double? pricePerMonth;
  final int? coachId;
  final int? poolId;
  final List<Map<String, String>> timings;

  CreateCourseEvent({
    required this.token,
    required this.academyId,
    required this.name,
    required this.description,
    required this.level,
    this.pricePerMonth,
    this.coachId,
    this.poolId,
    required this.timings,
  });
}

class UpdateCourseEvent extends CourseEvent {
  final String token;
  final int academyId;
  final int courseId;
  final String name;
  final String description;
  final String level;
  final double? pricePerMonth;
  final int? coachId;
  final int? poolId;
  final List<Map<String, String>> timings;

  UpdateCourseEvent({
    required this.token,
    required this.academyId,
    required this.courseId,
    required this.name,
    required this.description,
    required this.level,
    this.pricePerMonth,
    this.coachId,
    this.poolId,
    required this.timings,
  });
}

class DeleteCourseEvent extends CourseEvent {
  final String token;
  final int academyId;
  final int courseId;

  DeleteCourseEvent({
    required this.token,
    required this.academyId,
    required this.courseId,
  });
}
