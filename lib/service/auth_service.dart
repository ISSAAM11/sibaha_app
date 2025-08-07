import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sibaha_app/utils/exceptions.dart';
import 'package:sibaha_app/utils/server_config.dart';

class AuthService {
  Future<Object?> tryAutoLogin() async {
    const storage = FlutterSecureStorage();
    String? userDataString = await storage.read(key: 'userData');

    if (userDataString == null) {
      return null;
    }

    final userData = json.decode(userDataString) as Map;
    return userData;
  }

  Future<(String?, String?)> retrieveToken() async {
    const storage = FlutterSecureStorage();
    String? userDataString = await storage.read(key: 'userData');
    if (userDataString == null) {
      return (null, null);
    }

    final userData = json.decode(userDataString) as Map;
    return (userData['access_token'] as String, userData['username'] as String);
  }

  Future<void> login(String email, String password) async {
    try {
      final url = Uri.parse("$httpServerPath/api/login/");
      final Dio dio = Dio();
      final response = await dio.postUri(
        url,
        data: json.encode({"username": email, "password": password}),
        options: Options(contentType: Headers.jsonContentType),
      );
      const storage = FlutterSecureStorage();
      final idUser = response.data["user"]['id'];
      final username = response.data["user"]['username'];
      final thisEmail = response.data["user"]["email"];
      final userType = response.data["user"]["user_type"];
      final accessToken = response.data["access"];
      final refreshToken = response.data["refresh"];

      final userData = json.encode(
        {
          'id': idUser,
          'username': username,
          'email': thisEmail,
          'user_type': userType,
          'access_token': accessToken,
          'refresh_token': refreshToken,
        },
      );
      await storage.write(key: 'userData', value: userData);
    } on DioException catch (e) {
      handleAuthenticationException(e);
      throw NetworkNotFoundException('Network error occurred: ${e.toString()}');
    } catch (e) {
      print(e);
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> logoutUser() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'userData');
  }
}
