part of 'pool_details_bloc.dart';

@immutable
sealed class PoolDetailsEvent {}

class FetchPoolDetailsEvent extends PoolDetailsEvent {
  final String token;
  final int id;

  FetchPoolDetailsEvent(this.token, this.id);
}
