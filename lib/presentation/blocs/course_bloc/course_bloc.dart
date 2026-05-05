import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/data/models/course.dart';
import 'package:sibaha_app/data/repositories/course_repository.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository _courseRepository;
  List<Course> _courses = [];

  CourseBloc({required CourseRepository courseRepository})
      : _courseRepository = courseRepository,
        super(CourseInitial()) {
    on<FetchCoursesEvent>(_onFetch);
    on<CreateCourseEvent>(_onCreate);
    on<UpdateCourseEvent>(_onUpdate);
    on<DeleteCourseEvent>(_onDelete);
  }

  Future<void> _onFetch(
      FetchCoursesEvent event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    try {
      _courses = await _courseRepository.getCourses(event.token, event.academyId);
      emit(CourseLoaded(_courses));
    } on TokenExpiredException {
      emit(CourseTokenExpired());
    } catch (e) {
      emit(CourseFailed(e.toString()));
    }
  }

  Future<void> _onCreate(
      CreateCourseEvent event, Emitter<CourseState> emit) async {
    emit(CourseCreating());
    try {
      final course = await _courseRepository.createCourse(
        token: event.token,
        academyId: event.academyId,
        name: event.name,
        description: event.description,
        level: event.level,
        pricePerMonth: event.pricePerMonth,
        coachId: event.coachId,
        poolId: event.poolId,
        timings: event.timings,
      );
      _courses = [..._courses, course];
      emit(CourseCreated(course));
      emit(CourseLoaded(_courses));
    } on TokenExpiredException {
      emit(CourseTokenExpired());
    } catch (e) {
      emit(CourseCreateFailed(e.toString()));
    }
  }

  Future<void> _onUpdate(
      UpdateCourseEvent event, Emitter<CourseState> emit) async {
    emit(CourseUpdating());
    try {
      final course = await _courseRepository.updateCourse(
        token: event.token,
        academyId: event.academyId,
        courseId: event.courseId,
        name: event.name,
        description: event.description,
        level: event.level,
        pricePerMonth: event.pricePerMonth,
        coachId: event.coachId,
        poolId: event.poolId,
        timings: event.timings,
      );
      final index = _courses.indexWhere((c) => c.id == event.courseId);
      if (index != -1) {
        _courses = [..._courses]..[index] = course;
      }
      emit(CourseUpdated(course));
      emit(CourseLoaded(_courses));
    } on TokenExpiredException {
      emit(CourseTokenExpired());
    } catch (e) {
      emit(CourseUpdateFailed(e.toString()));
    }
  }

  Future<void> _onDelete(
      DeleteCourseEvent event, Emitter<CourseState> emit) async {
    emit(CourseDeleting(event.courseId));
    try {
      await _courseRepository.deleteCourse(
        token: event.token,
        academyId: event.academyId,
        courseId: event.courseId,
      );
      _courses = _courses.where((c) => c.id != event.courseId).toList();
      emit(CourseDeleted(event.courseId));
      emit(CourseLoaded(_courses));
    } on TokenExpiredException {
      emit(CourseTokenExpired());
    } catch (e) {
      emit(CourseDeleteFailed(e.toString()));
    }
  }
}
