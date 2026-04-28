import 'package:dio/dio.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/core/utils/server_config.dart';
import 'package:sibaha_app/data/models/pool.dart';

class PoolService {
  final Dio _dio;
  PoolService(this._dio);

  Future<Pool> fetchPoolDetails(String? token, int poolId) async {
    final url = Uri.parse("$httpServerPath/api/pool/$poolId/");
    try {
      final response = await _dio.getUri(url,
          options: token != null
              ? Options(headers: {'Authorization': 'Bearer $token'})
              : null);
      handleNoDataReceivedException(response);

      try {
        final pool = Pool.fromJson(response.data["data"]);
        return pool;
      } catch (parseError) {
        throw ServerException(response.statusCode,
            'Failed to parse Pool: ${parseError.toString()}');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<List<Pool>> fetchPools(String? token) async {
    final url = Uri.parse("$httpServerPath/api/pool/");
    try {
      final response = await _dio.getUri(url,
          options: token != null
              ? Options(headers: {'Authorization': 'Bearer $token'})
              : null);
      handleNoDataReceivedException(response);

      try {
        final pools = (response.data["data"] as List)
            .map((e) => Pool.fromJson(e))
            .whereType<Pool>()
            .toList();
        return pools;
      } catch (parseError) {
        throw ServerException(response.statusCode,
            'Failed to parse Pool: ${parseError.toString()}');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }
}
