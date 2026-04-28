part of 'academy_bloc.dart';

@immutable
sealed class AcademyEvent {}

class FetchAcademies extends AcademyEvent {
  final String? token;

  FetchAcademies(this.token);
}

class FetchAcademy extends AcademyEvent {
  final int id;

  FetchAcademy(this.id);
}

class SearchAcademies extends AcademyEvent {
  final String query;

  SearchAcademies(this.query);
}

class FilterAcademies extends AcademyEvent {
  final String? city;
  final List<String> specialities;

  FilterAcademies({this.city, this.specialities = const []});
}
