import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/data/models/subscription.dart';
import 'package:sibaha_app/data/repositories/subscription_repository.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository _subscriptionRepository;

  SubscriptionBloc({required SubscriptionRepository subscriptionRepository})
      : _subscriptionRepository = subscriptionRepository,
        super(SubscriptionInitial()) {
    on<SubscribeToAcademyEvent>(_onSubscribe);
    on<EnrollInCourseEvent>(_onEnrollInCourse);
    on<FetchMyEnrollmentsEvent>(_onFetchMyEnrollments);
    on<DeleteEnrollmentEvent>(_onDeleteEnrollment);
  }

  Future<void> _onSubscribe(
      SubscribeToAcademyEvent event, Emitter<SubscriptionState> emit) async {
    emit(SubscriptionLoading());
    try {
      await _subscriptionRepository.subscribe(event.token, event.academyId);
      emit(SubscriptionSuccess());
    } on TokenExpiredException {
      emit(SubscriptionTokenExpired());
    } catch (e) {
      emit(SubscriptionFailed(e.toString()));
    }
  }

  Future<void> _onEnrollInCourse(
      EnrollInCourseEvent event, Emitter<SubscriptionState> emit) async {
    emit(CourseEnrollmentLoading());
    try {
      await _subscriptionRepository.enrollInCourse(event.token, event.courseId);
      emit(CourseEnrollmentSuccess());
    } on TokenExpiredException {
      emit(CourseEnrollmentTokenExpired());
    } catch (e) {
      emit(CourseEnrollmentFailed(e.toString()));
    }
  }

  Future<void> _onFetchMyEnrollments(
      FetchMyEnrollmentsEvent event, Emitter<SubscriptionState> emit) async {
    emit(MyEnrollmentsLoading());
    try {
      final enrollments = await _subscriptionRepository.getMyEnrollments(event.token);
      emit(MyEnrollmentsLoaded(enrollments));
    } on TokenExpiredException {
      emit(MyEnrollmentsTokenExpired());
    } catch (e) {
      emit(MyEnrollmentsFailed(e.toString()));
    }
  }

  Future<void> _onDeleteEnrollment(
      DeleteEnrollmentEvent event, Emitter<SubscriptionState> emit) async {
    emit(DeleteEnrollmentLoading());
    try {
      await _subscriptionRepository.deleteEnrollment(event.token, event.enrollmentId);
      emit(DeleteEnrollmentSuccess());
    } on TokenExpiredException {
      emit(DeleteEnrollmentTokenExpired());
    } catch (e) {
      emit(DeleteEnrollmentFailed(e.toString()));
    }
  }
}
