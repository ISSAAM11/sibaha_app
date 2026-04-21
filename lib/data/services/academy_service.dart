import 'package:dio/dio.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/core/utils/server_config.dart';
import 'package:sibaha_app/data/models/academy.dart';

class AcademyService {
  Future<List<Academy>> fetchAcademies(String token) async {
    final url = Uri.parse("$httpServerPath/academy/");
    try {
      final Dio dio = Dio();
      final response = await dio.getUri(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      handleNoDataReceivedException(response);
      try {
        final academy = (response.data["data"] as List)
            .map((e) => Academy.fromJson(e))
            .whereType<Academy>()
            .toList();
        return academy;
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

  Future<Academy> fetchAcademyDetails(String token, int academyId) async {
    final url = Uri.parse("$httpServerPath/academy/$academyId");
    try {
      final Dio dio = Dio();
      final response = await dio.getUri(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      handleNoDataReceivedException(response);

      try {
        final academyData = response.data["data"];
        final academy = Academy.fromJson(academyData);
        return academy;
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
