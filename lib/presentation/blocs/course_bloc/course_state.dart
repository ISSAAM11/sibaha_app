part of 'course_bloc.dart';

@immutable
sealed class CourseState extends Equatable {}

final class CourseInitial extends CourseState {
  @override
  List<Object?> get props => [];
}

class CourseLoading extends CourseState {
  @override
  List<Object?> get props => [];
}

class CourseLoaded extends CourseState {
  final List<Course> courses;
  CourseLoaded(this.courses);
  @override
  List<Object?> get props => [courses];
}

class CourseFailed extends CourseState {
  final String message;
  CourseFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class CourseTokenExpired extends CourseState {
  @override
  List<Object?> get props => [];
}

class CourseCreating extends CourseState {
  @override
  List<Object?> get props => [];
}

class CourseCreated extends CourseState {
  final Course course;
  CourseCreated(this.course);
  @override
  List<Object?> get props => [course];
}

class CourseCreateFailed extends CourseState {
  final String message;
  CourseCreateFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class CourseUpdating extends CourseState {
  @override
  List<Object?> get props => [];
}

class CourseUpdated extends CourseState {
  final Course course;
  CourseUpdated(this.course);
  @override
  List<Object?> get props => [course];
}

class CourseUpdateFailed extends CourseState {
  final String message;
  CourseUpdateFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class CourseDeleting extends CourseState {
  final int courseId;
  CourseDeleting(this.courseId);
  @override
  List<Object?> get props => [courseId];
}

class CourseDeleted extends CourseState {
  final int courseId;
  CourseDeleted(this.courseId);
  @override
  List<Object?> get props => [courseId];
}

class CourseDeleteFailed extends CourseState {
  final String message;
  CourseDeleteFailed(this.message);
  @override
  List<Object?> get props => [message];
}
