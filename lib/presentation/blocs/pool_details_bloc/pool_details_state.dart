part of 'pool_details_bloc.dart';

@immutable
sealed class PoolDetailsState {}

final class PoolDetailsInitial extends PoolDetailsState {}

class PoolDetailsLoading extends PoolDetailsState {}

class PoolDetailsLoaded extends PoolDetailsState {
  final Pool poolDetails;

  PoolDetailsLoaded(this.poolDetails);
}

class PoolDetailsFailed extends PoolDetailsState {
  final String message;

  PoolDetailsFailed(this.message);
}

class PoolDetailsTokenExpired extends PoolDetailsState {}
