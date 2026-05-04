part of 'coach_bloc.dart';

@immutable
sealed class CoachEvent {}

class FetchCoaches extends CoachEvent {}

class SearchCoaches extends CoachEvent {
  final String query;
  SearchCoaches(this.query);
}

class FilterCoaches extends CoachEvent {
  final CoachFilter filter;
  FilterCoaches(this.filter);
}
