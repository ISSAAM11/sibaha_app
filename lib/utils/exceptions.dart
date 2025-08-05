import 'package:dio/dio.dart';

class TokenExpiredException implements Exception {
  final String message;

  TokenExpiredException(this.message);

  @override
  String toString() {
    return message;
  }
}

class NetworkNotFoundException implements Exception {
  final String message;
  NetworkNotFoundException(this.message);

  @override
  String toString() => 'Network error: $message';
}

class ServerException implements Exception {
  final int? statusCode;
  final String message;

  ServerException(this.statusCode, this.message);

  @override
  String toString() => 'Server error: $statusCode - $message';
}

class ObjectNotFoundException implements Exception {
  final String message;

  ObjectNotFoundException(this.message);
  @override
  String toString() => 'object not found: $message';
}

void handleDioException(DioException e) {
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
      break;

    case DioExceptionType.cancel:
      throw NetworkNotFoundException('Request was cancelled');

    case DioExceptionType.badCertificate:
      throw NetworkNotFoundException('Bad certificate');

    case DioExceptionType.unknown:
      if (e.error != null) {
        throw NetworkNotFoundException(
            'No internet connection: ${e.error.toString()}');
      }
      break;
    default:
      throw NetworkNotFoundException('Network error occurred: ${e.toString()}');
  }
}

void handleAuthenticationException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      throw NetworkNotFoundException('Connection timeout occurred');

    case DioExceptionType.badResponse:
      if (e.response != null) {
        switch (e.response!.statusCode) {
          case 400:
            throw ServerException(
                400,
                e.response != null
                    ? e.response!.data["message"][0]
                    : 'Bad Request');
          case 401:
            throw ServerException(401, e.response!.data["message"]);
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
      break;

    case DioExceptionType.cancel:
      throw NetworkNotFoundException('Request was cancelled');

    case DioExceptionType.badCertificate:
      throw NetworkNotFoundException('Bad certificate');

    case DioExceptionType.unknown:
      if (e.error != null) {
        throw NetworkNotFoundException(
            'No internet connection: ${e.error.toString()}');
      }
      break;
    default:
      throw NetworkNotFoundException('Network error occurred: ${e.toString()}');
  }
}

void resetPasswordVerificationException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      throw NetworkNotFoundException('Connection timeout occurred');

    case DioExceptionType.badResponse:
      if (e.response != null) {
        switch (e.response!.statusCode) {
          case 400:
            throw Exception('le code de vérification est incorrect');
          case 401:
            throw ServerException(401, e.response!.data["message"]);
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
      break;

    case DioExceptionType.cancel:
      throw NetworkNotFoundException('Request was cancelled');

    case DioExceptionType.badCertificate:
      throw NetworkNotFoundException('Bad certificate');

    case DioExceptionType.unknown:
      if (e.error != null) {
        throw NetworkNotFoundException(
            'No internet connection: ${e.error.toString()}');
      }
      break;
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
