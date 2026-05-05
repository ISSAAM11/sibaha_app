import 'package:sibaha_app/data/models/coach_course.dart';
import 'package:sibaha_app/data/models/coach_summary.dart';
import 'package:sibaha_app/data/models/invitation.dart';
import 'package:sibaha_app/data/services/coach_service.dart';

class CoachRepository {
  final CoachService _service;

  CoachRepository(this._service);

  Future<List<CoachSummary>> getCoaches() => _service.fetchCoaches();

  Future<List<Invitation>> getMyInvitations(String token) =>
      _service.fetchMyInvitations(token);

  Future<Invitation> respondToInvitation(String token, int id, String status) =>
      _service.respondToInvitation(token, id, status);

  Future<List<CoachCourse>> getMyCourses(String token) =>
      _service.fetchMyCourses(token);
}
