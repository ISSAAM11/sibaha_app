import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/data/repositories/coach_repository.dart';
import 'coach_schedule_event.dart';
import 'coach_schedule_state.dart';

class CoachScheduleBloc extends Bloc<CoachScheduleEvent, CoachScheduleState> {
  final CoachRepository _coachRepository;

  CoachScheduleBloc({required CoachRepository coachRepository})
      : _coachRepository = coachRepository,
        super(CoachScheduleInitial()) {
    on<FetchCoachCourses>(_onFetch);
  }

  Future<void> _onFetch(
      FetchCoachCourses event, Emitter<CoachScheduleState> emit) async {
    emit(CoachScheduleLoading());
    try {
      final courses = await _coachRepository.getMyCourses(event.token);
      emit(CoachScheduleLoaded(courses));
    } on TokenExpiredException {
      emit(CoachScheduleTokenExpired());
    } catch (e) {
      emit(CoachScheduleFailed(e.toString()));
    }
  }
}
