part of 'subscription_bloc.dart';

@immutable
abstract class SubscriptionState {}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionSuccess extends SubscriptionState {}

class SubscriptionFailed extends SubscriptionState {
  final String message;
  SubscriptionFailed(this.message);
}

class SubscriptionTokenExpired extends SubscriptionState {}

class CourseEnrollmentLoading extends SubscriptionState {}

class CourseEnrollmentSuccess extends SubscriptionState {}

class CourseEnrollmentFailed extends SubscriptionState {
  final String message;
  CourseEnrollmentFailed(this.message);
}

class CourseEnrollmentTokenExpired extends SubscriptionState {}

class MyEnrollmentsLoading extends SubscriptionState {}

class MyEnrollmentsLoaded extends SubscriptionState {
  final List<Subscription> enrollments;
  MyEnrollmentsLoaded(this.enrollments);
}

class MyEnrollmentsFailed extends SubscriptionState {
  final String message;
  MyEnrollmentsFailed(this.message);
}

class MyEnrollmentsTokenExpired extends SubscriptionState {}

class DeleteEnrollmentLoading extends SubscriptionState {}

class DeleteEnrollmentSuccess extends SubscriptionState {}

class DeleteEnrollmentFailed extends SubscriptionState {
  final String message;
  DeleteEnrollmentFailed(this.message);
}

class DeleteEnrollmentTokenExpired extends SubscriptionState {}
