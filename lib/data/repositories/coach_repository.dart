import 'package:sibaha_app/data/models/coach_summary.dart';
import 'package:sibaha_app/data/services/coach_service.dart';

class CoachRepository {
  final CoachService _service;

  CoachRepository(this._service);

  Future<List<CoachSummary>> getCoaches() => _service.fetchCoaches();
}
