abstract class CoachScheduleEvent {}

class FetchCoachCourses extends CoachScheduleEvent {
  final String token;
  FetchCoachCourses(this.token);
}
