part of 'pool_bloc.dart';

@immutable
sealed class PoolEvent {}

class FetchPools extends PoolEvent {
  final String? token;

  FetchPools(this.token);
}

class SearchPools extends PoolEvent {
  final String query;

  SearchPools(this.query);
}

class FilterPools extends PoolEvent {
  final bool? heated;
  final List<String> specialities;

  FilterPools({this.heated, this.specialities = const []});
}
