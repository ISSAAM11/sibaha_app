part of 'academy_bloc.dart';

@immutable
sealed class AcademyEvent {}

class FetchAcademies extends AcademyEvent {
  final String token;

  FetchAcademies(this.token);
}
