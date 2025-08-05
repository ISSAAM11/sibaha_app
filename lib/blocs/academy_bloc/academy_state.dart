part of 'academy_bloc.dart';

@immutable
sealed class AcademyState {}

final class AcademyInitial extends AcademyState {}

class AcademyLoading extends AcademyState {}

class AcademyLoaded extends AcademyState {
  final List<dynamic> academies;

  AcademyLoaded(this.academies);
}

class FetchAcademy extends AcademyEvent {
  final int id;

  FetchAcademy(this.id);
}

class AcademyFailed extends AcademyState {
  final String message;

  AcademyFailed(this.message);
}
