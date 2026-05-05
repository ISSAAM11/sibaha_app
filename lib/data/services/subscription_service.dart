import 'package:dio/dio.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/core/utils/server_config.dart';
import 'package:sibaha_app/data/models/academy_client.dart';
import 'package:sibaha_app/data/models/subscription.dart';

class SubscriptionService {
  final Dio _dio;

  SubscriptionService(this._dio);

  Future<Subscription> subscribe(String token, int academyId) async {
    final url = Uri.parse('$httpServerPath/api/academy/$academyId/subscribe/');
    try {
      final response = await _dio.postUri(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      handleNoDataReceivedException(response);
      try {
        return Subscription.fromJson(response.data['data'] as Map<String, dynamic>);
      } catch (parseError) {
        throw ServerException(response.statusCode, 'Failed to parse Subscription: $parseError');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error: ${e.toString()}');
    }
  }

  Future<List<Subscription>> fetchMySubscriptions(String token) async {
    final url = Uri.parse('$httpServerPath/api/my-subscriptions/');
    try {
      final response = await _dio.getUri(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      handleNoDataReceivedException(response);
      try {
        return (response.data['data'] as List)
            .map((e) => Subscription.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (parseError) {
        throw ServerException(response.statusCode, 'Failed to parse Subscriptions: $parseError');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error: ${e.toString()}');
    }
  }

  Future<List<AcademyClient>> fetchAcademyClients(String token, int academyId) async {
    final url = Uri.parse('$httpServerPath/api/my-academies/$academyId/clients/');
    try {
      final response = await _dio.getUri(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      handleNoDataReceivedException(response);
      try {
        return (response.data['data'] as List)
            .map((e) => AcademyClient.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (parseError) {
        throw ServerException(response.statusCode, 'Failed to parse clients: $parseError');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error: ${e.toString()}');
    }
  }

  Future<void> removeClient(String token, int academyId, int subscriptionId) async {
    final url = Uri.parse('$httpServerPath/api/my-academies/$academyId/clients/$subscriptionId/');
    try {
      await _dio.deleteUri(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error: ${e.toString()}');
    }
  }
}
