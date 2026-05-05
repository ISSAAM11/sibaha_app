import 'package:sibaha_app/data/models/course.dart';
import 'package:sibaha_app/data/services/course_service.dart';

class CourseRepository {
  final CourseService _service;
  CourseRepository(this._service);

  Future<List<Course>> getCourses(String token, int academyId) =>
      _service.fetchCourses(token, academyId);

  Future<Course> createCourse({
    required String token,
    required int academyId,
    required String name,
    required String description,
    required String level,
    double? pricePerMonth,
    int? coachId,
    int? poolId,
    required List<Map<String, String>> timings,
  }) =>
      _service.createCourse(
        token: token,
        academyId: academyId,
        name: name,
        description: description,
        level: level,
        pricePerMonth: pricePerMonth,
        coachId: coachId,
        poolId: poolId,
        timings: timings,
      );

  Future<Course> updateCourse({
    required String token,
    required int academyId,
    required int courseId,
    required String name,
    required String description,
    required String level,
    double? pricePerMonth,
    int? coachId,
    int? poolId,
    required List<Map<String, String>> timings,
  }) =>
      _service.updateCourse(
        token: token,
        academyId: academyId,
        courseId: courseId,
        name: name,
        description: description,
        level: level,
        pricePerMonth: pricePerMonth,
        coachId: coachId,
        poolId: poolId,
        timings: timings,
      );

  Future<void> deleteCourse({
    required String token,
    required int academyId,
    required int courseId,
  }) =>
      _service.deleteCourse(
          token: token, academyId: academyId, courseId: courseId);
}
