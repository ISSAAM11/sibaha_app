import 'dart:typed_data';
import 'package:sibaha_app/data/models/academy.dart';
import 'package:sibaha_app/data/services/academy_service.dart';

class AcademyRepository {
  final AcademyService _service;

  AcademyRepository(this._service);

  Future<List<Academy>> getAcademies(String? token) =>
      _service.fetchAcademies(token);

  Future<Academy> getAcademyDetails(String? token, int id) =>
      _service.fetchAcademyDetails(token, id);

  Future<List<Academy>> getMyAcademies(String token) =>
      _service.fetchMyAcademies(token);

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
  }) =>
      _service.createAcademy(
        token: token,
        name: name,
        city: city,
        address: address,
        description: description,
        specialities: specialities,
        pictureBytes: pictureBytes,
        pictureFilename: pictureFilename,
        latitude: latitude,
        longitude: longitude,
      );
}
