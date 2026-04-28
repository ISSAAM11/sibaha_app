import 'package:sibaha_app/data/models/academy.dart';
import 'package:sibaha_app/data/services/academy_service.dart';

class AcademyRepository {
  final AcademyService _service;

  AcademyRepository(this._service);

  Future<List<Academy>> getAcademies(String? token) =>
      _service.fetchAcademies(token);

  Future<Academy> getAcademyDetails(String? token, int id) =>
      _service.fetchAcademyDetails(token, id);
}
