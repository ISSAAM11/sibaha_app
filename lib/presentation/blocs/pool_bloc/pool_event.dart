part of 'pool_bloc.dart';

@immutable
sealed class PoolEvent {}

class FetchPools extends PoolEvent {
  final String token;

  FetchPools(this.token);
}
