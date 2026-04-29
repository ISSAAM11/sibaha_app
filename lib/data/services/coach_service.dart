import 'package:dio/dio.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/core/utils/server_config.dart';
import 'package:sibaha_app/data/models/coach_summary.dart';

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
}
