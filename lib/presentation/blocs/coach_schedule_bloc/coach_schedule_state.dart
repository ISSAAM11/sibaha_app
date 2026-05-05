import 'package:sibaha_app/data/models/coach_course.dart';

abstract class CoachScheduleState {}

class CoachScheduleInitial extends CoachScheduleState {}

class CoachScheduleLoading extends CoachScheduleState {}

class CoachScheduleLoaded extends CoachScheduleState {
  final List<CoachCourse> courses;
  CoachScheduleLoaded(this.courses);
}

class CoachScheduleFailed extends CoachScheduleState {
  final String message;
  CoachScheduleFailed(this.message);
}

class CoachScheduleTokenExpired extends CoachScheduleState {}
