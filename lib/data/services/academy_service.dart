import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/core/utils/server_config.dart';
import 'package:sibaha_app/data/models/academy.dart';

class AcademyService {
  final Dio _dio;

  AcademyService(this._dio);

  Future<List<Academy>> fetchAcademies(String? token) async {
    final url = Uri.parse("$httpServerPath/api/academy/");
    try {
      final response = await _dio.getUri(url,
          options: token != null
              ? Options(headers: {'Authorization': 'Bearer $token'})
              : null);
      handleNoDataReceivedException(response);

      try {
        return (response.data["data"] as List)
            .map((e) => Academy.fromJson(e))
            .whereType<Academy>()
            .toList();
      } catch (parseError) {
        throw ServerException(response.statusCode,
            'Failed to parse Academy: ${parseError.toString()}');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<List<Academy>> fetchMyAcademies(String token) async {
    final url = Uri.parse("$httpServerPath/api/my-academies/");
    try {
      final response = await _dio.getUri(
        url,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      handleNoDataReceivedException(response);
      try {
        return (response.data["data"] as List)
            .map((e) => Academy.fromJson(e))
            .whereType<Academy>()
            .toList();
      } catch (parseError) {
        throw ServerException(response.statusCode,
            'Failed to parse Academy: ${parseError.toString()}');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<Academy> createAcademy({
    required String token,
    required String name,
    required String city,
    required String address,
    required String description,
    required List<String> specialities,
    required Uint8List pictureBytes,
    required String pictureFilename,
    double? latitude,
    double? longitude,
  }) async {
    final url = Uri.parse("$httpServerPath/api/my-academies/");
    try {
      final fields = <String, dynamic>{
        'name': name,
        'city': city,
        'address': address,
        'description': description,
        'specialities': jsonEncode(specialities),
        'picture': MultipartFile.fromBytes(pictureBytes, filename: pictureFilename),
      };
      if (latitude != null) fields['latitude'] = latitude.toString();
      if (longitude != null) fields['longitude'] = longitude.toString();

      final response = await _dio.postUri(
        url,
        data: FormData.fromMap(fields),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      handleNoDataReceivedException(response);
      try {
        return Academy.fromJson(response.data["data"]);
      } catch (parseError) {
        throw ServerException(response.statusCode,
            'Failed to parse Academy: ${parseError.toString()}');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<Academy> fetchAcademyDetails(String? token, int academyId) async {
    final url = Uri.parse("$httpServerPath/api/academy/$academyId/");
    try {
      final response = await _dio.getUri(url,
          options: token != null
              ? Options(headers: {'Authorization': 'Bearer $token'})
              : null);
      handleNoDataReceivedException(response);

      try {
        return Academy.fromJson(response.data["data"]);
      } catch (parseError) {
        throw ServerException(response.statusCode,
            'Failed to parse Academy: ${parseError.toString()}');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }

  Future<Academy> updateAcademy({
    required String token,
    required int academyId,
    required String name,
    required String city,
    required String address,
    required String description,
    required List<String> specialities,
    Uint8List? pictureBytes,
    String? pictureFilename,
    double? latitude,
    double? longitude,
  }) async {
    final url = Uri.parse("$httpServerPath/api/my-academies/$academyId/");
    try {
      final fields = <String, dynamic>{
        'name': name,
        'city': city,
        'address': address,
        'description': description,
        'specialities': jsonEncode(specialities),
      };
      if (pictureBytes != null && pictureFilename != null) {
        fields['picture'] = MultipartFile.fromBytes(pictureBytes, filename: pictureFilename);
      }
      if (latitude != null) fields['latitude'] = latitude.toString();
      if (longitude != null) fields['longitude'] = longitude.toString();

      final response = await _dio.patchUri(
        url,
        data: FormData.fromMap(fields),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      handleNoDataReceivedException(response);
      try {
        return Academy.fromJson(response.data["data"]);
      } catch (parseError) {
        throw ServerException(response.statusCode,
            'Failed to parse Academy: ${parseError.toString()}');
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw ServerException(null, 'Unexpected error occurred: ${e.toString()}');
    }
  }
}
