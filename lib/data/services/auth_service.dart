import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/core/utils/server_config.dart';

class AuthService {
  Future<Object?> tryAutoLogin() async {
    const storage = FlutterSecureStorage();
    String? userDataString = await storage.read(key: 'userData');

    if (userDataString == null) {
      return null;
    }

    try {
      final userData = json.decode(userDataString) as Map;
      return userData;
    } catch (_) {
      await storage.delete(key: 'userData');
      return null;
    }
  }

  Future<(String?, String?, String?)> retrieveToken() async {
    const storage = FlutterSecureStorage();
    String? userDataString = await storage.read(key: 'userData');
    if (userDataString == null) {
      return (null, null, null);
    }

    try {
      final userData = json.decode(userDataString) as Map;
      return (
        userData['access_token'] as String?,
        userData['username'] as String?,
        userData['user_type'] as String?
      );
    } catch (_) {
      await storage.delete(key: 'userData');
      return (null, null, null);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final url = Uri.parse("$httpServerPath/api/login/");
      final Dio dio = Dio();
      final response = await dio.postUri(
        url,
        data: json.encode({"email": email, "password": password}),
        options: Options(contentType: Headers.jsonContentType),
      );
      final user = response.data["user"] as Map?;
      if (user == null || response.data["access"] == null) {
        throw ServerException(null, 'Invalid response from server');
      }
      const storage = FlutterSecureStorage();
      final userData = json.encode({
        'id': user['id'],
        'username': user['username'],
        'email': user['email'],
        'user_type': user['user_type'],
        'access_token': response.data["access"],
        'refresh_token': response.data["refresh"],
      });
      await storage.write(key: 'userData', value: userData);
    } on DioException catch (e) {
      handleAuthenticationException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> logoutUser() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'userData');
  }

  Future<(String?, String?, String?)> refreshToken() async {
    const storage = FlutterSecureStorage();
    String? userDataString = await storage.read(key: 'userData');
    if (userDataString == null) {
      throw ServerException(
          null, 'Unexpected error occurred: User data not found');
    }

    final Map storedData;
    try {
      storedData = json.decode(userDataString) as Map;
    } catch (_) {
      await storage.delete(key: 'userData');
      throw TokenExpiredException('Session data is corrupted, please log in again');
    }

    final storedRefreshToken = storedData['refresh_token'] as String?;
    if (storedRefreshToken == null) {
      throw TokenExpiredException('No refresh token found, please log in again');
    }

    try {
      final url = Uri.parse("$httpServerPath/api/token/refresh/");
      final Dio dio = Dio();
      final response = await dio.postUri(
        url,
        data: json.encode({"refresh": storedRefreshToken}),
        options: Options(contentType: Headers.jsonContentType),
      );

      final user = response.data["user"] as Map?;
      if (user == null || response.data["access"] == null) {
        throw TokenExpiredException('Invalid token refresh response');
      }

      final accessToken = response.data["access"] as String;
      const refreshStorage = FlutterSecureStorage();
      final newUserData = json.encode({
        'id': user['id'],
        'username': user['username'],
        'email': user['email'],
        'user_type': user['user_type'],
        'access_token': accessToken,
        'refresh_token': response.data["refresh"],
      });
      await refreshStorage.write(key: 'userData', value: newUserData);

      return (accessToken, user['username'] as String?, user['user_type'] as String?);
    } catch (e) {
      if (e is AppException) rethrow;
      throw TokenExpiredException('Failed to refresh token: ${e.toString()}');
    }
  }
}
