import 'package:dio/dio.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/core/utils/server_config.dart';
import 'package:sibaha_app/data/models/coach_course.dart';
import 'package:sibaha_app/data/models/coach_summary.dart';
import 'package:sibaha_app/data/models/invitation.dart';

class CoachService {
  final Dio _dio;

  CoachService(this._dio);

  Future<List<CoachSummary>> fetchCoaches() async {
    final url = Uri.parse("$httpServerPath/api/coaches/");
    try {
      final response = await _dio.getUri(url);
      handleNoDataReceivedException(response);

      try {
        return (response.data as List)
            .map((e) => CoachSummary.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (parseError) {
        throw ServerException(response.statusCode,
            'Failed to parse coaches: ${parseError.toString()}');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error: ${e.toString()}');
    }
  }

  Future<List<Invitation>> fetchMyInvitations(String token) async {
    final url = Uri.parse('$httpServerPath/api/my-invitations/');
    try {
      final response = await _dio.getUri(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      handleNoDataReceivedException(response);
      try {
        return (response.data['data'] as List)
            .map((e) => Invitation.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (parseError) {
        throw ServerException(response.statusCode, 'Failed to parse invitations: $parseError');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error: ${e.toString()}');
    }
  }

  Future<Invitation> respondToInvitation(String token, int id, String status) async {
    final url = Uri.parse('$httpServerPath/api/my-invitations/$id/');
    try {
      final response = await _dio.patchUri(
        url,
        data: {'status': status},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      handleNoDataReceivedException(response);
      try {
        return Invitation.fromJson(response.data['data'] as Map<String, dynamic>);
      } catch (parseError) {
        throw ServerException(response.statusCode, 'Failed to parse invitation: $parseError');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error: ${e.toString()}');
    }
  }

  Future<List<CoachCourse>> fetchMyCourses(String token) async {
    final url = Uri.parse('$httpServerPath/api/my-courses/');
    try {
      final response = await _dio.getUri(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      handleNoDataReceivedException(response);
      try {
        return (response.data['data'] as List)
            .map((e) => CoachCourse.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (parseError) {
        throw ServerException(response.statusCode, 'Failed to parse courses: $parseError');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error: ${e.toString()}');
    }
  }
}
