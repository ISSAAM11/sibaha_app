part of 'academy_details_bloc.dart';

@immutable
sealed class AcademyDetailsEvent {}

class FetchAcademyDetailsEvent extends AcademyDetailsEvent {
  final String token;
  final int id;
  FetchAcademyDetailsEvent(this.token, this.id);
}
