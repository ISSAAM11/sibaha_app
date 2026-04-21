import 'package:dio/dio.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/core/utils/server_config.dart';
import 'package:sibaha_app/data/models/user.dart';

class UserService {
  Future<User> fetchUserDetails(String token) async {
    final url = Uri.parse("$httpServerPath/api/profile/");
    try {
      final Dio dio = Dio();
      final response = await dio.getUri(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      handleNoDataReceivedException(response);
      try {
        final user = User.fromJson(response.data);
        return user;
      } catch (parseError) {
        throw ServerException(response.statusCode,
            'Failed to parse User: ${parseError.toString()}');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }
}
