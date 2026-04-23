part of 'academy_bloc.dart';

@immutable
sealed class AcademyState {}

final class AcademyInitial extends AcademyState {}

class AcademyLoading extends AcademyState {}

class AcademyLoaded extends AcademyState {
  final List<Academy> academies;

  AcademyLoaded(this.academies);
}

class AcademyFailed extends AcademyState {
  final String message;

  AcademyFailed(this.message);
}

class AcademyTokenExpired extends AcademyState {}
