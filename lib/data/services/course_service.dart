import 'package:dio/dio.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/core/utils/server_config.dart';
import 'package:sibaha_app/data/models/course.dart';

class CourseService {
  final Dio _dio;
  CourseService(this._dio);

  Future<List<Course>> fetchCourses(String token, int academyId) async {
    final url = Uri.parse('$httpServerPath/api/my-academies/$academyId/courses/');
    try {
      final response = await _dio.getUri(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      handleNoDataReceivedException(response);
      try {
        return (response.data['data'] as List)
            .map((e) => Course.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (parseError) {
        throw ServerException(
            response.statusCode, 'Failed to parse Course: $parseError');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error: $e');
    }
  }

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
  }) async {
    final url = Uri.parse('$httpServerPath/api/my-academies/$academyId/courses/');
    try {
      final body = <String, dynamic>{
        'name': name,
        'description': description,
        'level': level,
        'timings': timings,
        if (pricePerMonth != null) 'price_per_month': pricePerMonth,
        if (coachId != null) 'coach': coachId,
        if (poolId != null) 'pool': poolId,
      };
      final response = await _dio.postUri(
        url,
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      handleNoDataReceivedException(response);
      try {
        return Course.fromJson(response.data['data'] as Map<String, dynamic>);
      } catch (parseError) {
        throw ServerException(
            response.statusCode, 'Failed to parse Course: $parseError');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error: $e');
    }
  }

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
  }) async {
    final url = Uri.parse(
        '$httpServerPath/api/my-academies/$academyId/courses/$courseId/');
    try {
      final body = <String, dynamic>{
        'name': name,
        'description': description,
        'level': level,
        'coach': coachId,
        'pool': poolId,
        'timings': timings,
        if (pricePerMonth != null) 'price_per_month': pricePerMonth,
      };
      final response = await _dio.patchUri(
        url,
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      handleNoDataReceivedException(response);
      try {
        return Course.fromJson(response.data['data'] as Map<String, dynamic>);
      } catch (parseError) {
        throw ServerException(
            response.statusCode, 'Failed to parse Course: $parseError');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error: $e');
    }
  }

  Future<void> deleteCourse({
    required String token,
    required int academyId,
    required int courseId,
  }) async {
    final url = Uri.parse(
        '$httpServerPath/api/my-academies/$academyId/courses/$courseId/');
    try {
      await _dio.deleteUri(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error: $e');
    }
  }
}
