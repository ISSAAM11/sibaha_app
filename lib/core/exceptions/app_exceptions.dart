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

String _extractDrfError(dynamic data, {String fallback = 'Bad request'}) {
  if (data is Map) {
    // DRF flat detail: {"detail": "..."}
    if (data['detail'] is String) return data['detail'] as String;

    // DRF field errors: {"email": ["msg"], "username": ["msg"], ...}
    for (final value in data.values) {
      if (value is List && value.isNotEmpty) return value.first.toString();
      if (value is String && value.isNotEmpty) return value;
    }

    // DRF non-field errors list: {"non_field_errors": ["msg"]}
    final nonField = data['non_field_errors'];
    if (nonField is List && nonField.isNotEmpty) return nonField.first.toString();
  }
  return fallback;
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
            throw ServerException(400, _extractDrfError(e.response!.data));
          case 401:
            throw ServerException(401, _extractDrfError(e.response!.data, fallback: 'Unauthorized'));
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
            final msg404 = e.response!.data["detail"];
            throw ServerException(404, msg404?.toString() ?? 'No account found with this email address.');
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
