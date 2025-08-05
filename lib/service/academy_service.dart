import 'package:dio/dio.dart';
import 'package:sibaha_app/Model/academy.dart';
import 'package:sibaha_app/utils/exceptions.dart';
import 'package:sibaha_app/utils/server_config.dart';

class AcademyService {
  final token = "";
  Future<List<Academy>> fetchAcademies() async {
    final url = Uri.parse("$httpServerPath/academy/");
    try {
      final Dio dio = Dio();
      final response = await dio.getUri(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      handleNoDataReceivedException(response);
      print(response.data["data"]);
      try {
        final departments = (response.data["data"] as List)
            .map((e) => Academy.fromJson(e))
            .whereType<Academy>()
            .toList();
        return departments;
      } catch (parseError) {
        throw ServerException(response.statusCode,
            'Failed to parse Academy: ${parseError.toString()}');
      }
    } on DioException catch (e) {
      handleDioException(e);
      throw NetworkNotFoundException('Network error occurred: ${e.toString()}');
    } catch (e) {
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<Academy> fetchAcademyDetails(int academyId) async {
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
      throw NetworkNotFoundException('Network error occurred: ${e.toString()}');
    } catch (e) {
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }
}
