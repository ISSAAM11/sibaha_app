import 'package:dio/dio.dart';

abstract class AppException implements Exception {
  String get message;
}

class TokenExpiredException implements AppException {
  @override
  final String message;
  TokenExpiredException(this.message);

  @override
  String toString() => message;
}

class NetworkNotFoundException implements AppException {
  @override
  final String message;
  NetworkNotFoundException(this.message);

  @override
  String toString() => 'Network error: $message';
}

class ServerException implements AppException {
  final int? statusCode;
  @override
  final String message;

  ServerException(this.statusCode, this.message);

  @override
  String toString() => 'Server error: $statusCode - $message';
}

class ObjectNotFoundException implements AppException {
  @override
  final String message;
  ObjectNotFoundException(this.message);

  @override
  String toString() => 'object not found: $message';
}

Never handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      throw NetworkNotFoundException('Connection timeout occurred');

    case DioExceptionType.badResponse:
      if (e.response != null) {
        switch (e.response!.statusCode) {
          case 400:
            throw ServerException(400, 'Bad request');
          case 401:
            throw TokenExpiredException('Authentication token has expired');
          case 403:
            throw ServerException(403, 'Forbidden: Insufficient permissions');
          case 404:
            throw ServerException(404, 'Requested resource not found');
          case 500:
            throw ServerException(500, 'Internal server error');
          default:
            throw ServerException(e.response!.statusCode,
                e.response!.statusMessage ?? 'Unknown server error');
        }
      }
      throw NetworkNotFoundException('Bad response with no body');

    case DioExceptionType.cancel:
      throw NetworkNotFoundException('Request was cancelled');

    case DioExceptionType.badCertificate:
      throw NetworkNotFoundException('Bad certificate');

    case DioExceptionType.unknown:
      throw NetworkNotFoundException(
          'No internet connection: ${e.error?.toString() ?? e.toString()}');

    default:
      throw NetworkNotFoundException('Network error occurred: ${e.toString()}');
  }
}

Never handleAuthenticationException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      throw NetworkNotFoundException('Connection timeout occurred');

    case DioExceptionType.badResponse:
      if (e.response != null) {
        switch (e.response!.statusCode) {
          case 400:
            final msg400 = e.response!.data["message"];
            throw ServerException(
                400,
                (msg400 is List && msg400.isNotEmpty)
                    ? msg400.first.toString()
                    : msg400?.toString() ?? 'Bad request');
          case 401:
            final msg401 = e.response!.data["message"];
            throw ServerException(401, msg401?.toString() ?? 'Unauthorized');
          case 403:
            throw ServerException(403, 'Forbidden: Insufficient permissions');
          case 404:
            throw ServerException(404, 'Requested resource not found');
          case 500:
            throw ServerException(500, 'Internal server error');
          default:
            throw ServerException(e.response!.statusCode,
                e.response!.statusMessage ?? 'Unknown server error');
        }
      }
      throw NetworkNotFoundException('Bad response with no body');

    case DioExceptionType.cancel:
      throw NetworkNotFoundException('Request was cancelled');

    case DioExceptionType.badCertificate:
      throw NetworkNotFoundException('Bad certificate');

    case DioExceptionType.unknown:
      throw NetworkNotFoundException(
          'No internet connection: ${e.error?.toString() ?? e.toString()}');

    default:
      throw NetworkNotFoundException('Network error occurred: ${e.toString()}');
  }
}

Never resetPasswordVerificationException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      throw NetworkNotFoundException('Connection timeout occurred');

    case DioExceptionType.badResponse:
      if (e.response != null) {
        switch (e.response!.statusCode) {
          case 400:
            throw ServerException(400, 'le code de vérification est incorrect');
          case 401:
            final msg401 = e.response!.data["message"];
            throw ServerException(401, msg401?.toString() ?? 'Unauthorized');
          case 403:
            throw ServerException(403, 'Forbidden: Insufficient permissions');
          case 404:
            throw ServerException(404, 'Requested resource not found');
          case 500:
            throw ServerException(500, 'Internal server error');
          default:
            throw ServerException(e.response!.statusCode,
                e.response!.statusMessage ?? 'Unknown server error');
        }
      }
      throw NetworkNotFoundException('Bad response with no body');

    case DioExceptionType.cancel:
      throw NetworkNotFoundException('Request was cancelled');

    case DioExceptionType.badCertificate:
      throw NetworkNotFoundException('Bad certificate');

    case DioExceptionType.unknown:
      throw NetworkNotFoundException(
          'No internet connection: ${e.error?.toString() ?? e.toString()}');

    default:
      throw NetworkNotFoundException('Network error occurred: ${e.toString()}');
  }
}

void handleNoDataReceivedException(Response<dynamic> response) {
  if (response.data == null) {
    throw ServerException(
        response.statusCode, 'No data received from the server');
  }
}
