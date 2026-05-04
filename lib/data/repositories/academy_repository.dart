import 'dart:typed_data';
import 'package:sibaha_app/data/models/academy.dart';
import 'package:sibaha_app/data/models/invitation.dart';
import 'package:sibaha_app/data/models/review.dart';
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

  Future<List<Invitation>> getInvitations(String token, int academyId) =>
      _service.fetchInvitations(token, academyId);

  Future<Invitation> sendInvitation(String token, int academyId, int coachId) =>
      _service.sendInvitation(token, academyId, coachId);

  Future<List<Review>> getReviews(String? token, int academyId) =>
      _service.fetchReviews(token, academyId);

  Future<Review> createReview(
          String token, int academyId, int rating, String comment) =>
      _service.createReview(token, academyId, rating, comment);

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
  }) =>
      _service.updateAcademy(
        token: token,
        academyId: academyId,
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
