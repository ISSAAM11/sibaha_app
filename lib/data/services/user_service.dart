import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/core/utils/server_config.dart';
import 'package:sibaha_app/data/models/user.dart';

class UserService {
  final Dio _dio;
  UserService(this._dio);

  Future<User> fetchUserDetails(String token) async {
    final url = Uri.parse("$httpServerPath/api/profile/");
    try {
      final response = await _dio.getUri(url,
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

  Future<User> uploadProfilePicture(String token, XFile imageFile) async {
    final url = Uri.parse("$httpServerPath/api/profile/");
    try {
      final bytes = await imageFile.readAsBytes();
      final formData = FormData.fromMap({
        'picture': MultipartFile.fromBytes(bytes, filename: imageFile.name),
      });
      final response = await _dio.patchUri(
        url,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      handleNoDataReceivedException(response);
      return User.fromJson(response.data);
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<User> updateProfile(
      String token, {String? username, String? phone}) async {
    final url = Uri.parse("$httpServerPath/api/profile/");
    try {
      final response = await _dio.patchUri(
        url,
        data: {
          if (username != null) 'username': username,
          if (phone != null) 'phone': phone,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      handleNoDataReceivedException(response);
      return User.fromJson(response.data);
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> changePassword(
      String token, String currentPassword, String newPassword) async {
    final url = Uri.parse("$httpServerPath/api/profile/change-password/");
    try {
      await _dio.postUri(
        url,
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }
}
