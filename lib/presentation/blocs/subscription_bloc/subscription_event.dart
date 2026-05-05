part of 'subscription_bloc.dart';

@immutable
abstract class SubscriptionEvent {}

class SubscribeToAcademyEvent extends SubscriptionEvent {
  final String token;
  final int academyId;

  SubscribeToAcademyEvent(this.token, this.academyId);
}

class EnrollInCourseEvent extends SubscriptionEvent {
  final String token;
  final int courseId;

  EnrollInCourseEvent(this.token, this.courseId);
}

class FetchMyEnrollmentsEvent extends SubscriptionEvent {
  final String token;

  FetchMyEnrollmentsEvent(this.token);
}

class DeleteEnrollmentEvent extends SubscriptionEvent {
  final String token;
  final int enrollmentId;

  DeleteEnrollmentEvent(this.token, this.enrollmentId);
}
