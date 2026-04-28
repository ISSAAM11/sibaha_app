import 'package:dio/dio.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/core/utils/server_config.dart';
import 'package:sibaha_app/data/models/academy.dart';

class AcademyService {
  final Dio _dio;

  AcademyService(this._dio);

  Future<List<Academy>> fetchAcademies(String? token) async {
    final url = Uri.parse("$httpServerPath/api/academy/");
    try {
      final response = await _dio.getUri(url,
          options: token != null
              ? Options(headers: {'Authorization': 'Bearer $token'})
              : null);
      handleNoDataReceivedException(response);

      try {
        return (response.data["data"] as List)
            .map((e) => Academy.fromJson(e))
            .whereType<Academy>()
            .toList();
      } catch (parseError) {
        throw ServerException(response.statusCode,
            'Failed to parse Academy: ${parseError.toString()}');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<Academy> fetchAcademyDetails(String? token, int academyId) async {
    final url = Uri.parse("$httpServerPath/api/academy/$academyId/");
    try {
      final response = await _dio.getUri(url,
          options: token != null
              ? Options(headers: {'Authorization': 'Bearer $token'})
              : null);
      handleNoDataReceivedException(response);

      try {
        return Academy.fromJson(response.data["data"]);
      } catch (parseError) {
        throw ServerException(response.statusCode,
            'Failed to parse Academy: ${parseError.toString()}');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }
}
