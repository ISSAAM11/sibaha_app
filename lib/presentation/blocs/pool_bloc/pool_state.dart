part of 'pool_bloc.dart';

@immutable
sealed class PoolState {}

final class PoolInitial extends PoolState {}

class PoolLoading extends PoolState {}

class PoolLoaded extends PoolState {
  final List<Pool> pools;

  PoolLoaded(this.pools);
}

class PoolFailed extends PoolState {
  final String message;

  PoolFailed(this.message);
}

class PoolTokenExpired extends PoolState {}
