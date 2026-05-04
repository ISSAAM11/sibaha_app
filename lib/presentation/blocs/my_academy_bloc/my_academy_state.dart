part of 'my_academy_bloc.dart';

@immutable
sealed class MyAcademyState extends Equatable {}

final class MyAcademyInitial extends MyAcademyState {
  @override
  List<Object?> get props => [];
}

class MyAcademyLoading extends MyAcademyState {
  @override
  List<Object?> get props => [];
}

class MyAcademyLoaded extends MyAcademyState {
  final List<Academy> academies;
  MyAcademyLoaded(this.academies);
  @override
  List<Object?> get props => [academies];
}

class MyAcademyFailed extends MyAcademyState {
  final String message;
  MyAcademyFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class MyAcademyTokenExpired extends MyAcademyState {
  @override
  List<Object?> get props => [];
}

class AcademyCreating extends MyAcademyState {
  @override
  List<Object?> get props => [];
}

class AcademyCreated extends MyAcademyState {
  final Academy academy;
  AcademyCreated(this.academy);
  @override
  List<Object?> get props => [academy];
}

class AcademyCreateFailed extends MyAcademyState {
  final String message;
  AcademyCreateFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class PoolUpdating extends MyAcademyState {
  @override
  List<Object?> get props => [];
}

class PoolUpdated extends MyAcademyState {
  final Pool pool;
  PoolUpdated(this.pool);
  @override
  List<Object?> get props => [pool];
}

class PoolUpdateFailed extends MyAcademyState {
  final String message;
  PoolUpdateFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class PoolDeleting extends MyAcademyState {
  @override
  List<Object?> get props => [];
}

class PoolDeleted extends MyAcademyState {
  final int poolId;
  PoolDeleted(this.poolId);
  @override
  List<Object?> get props => [poolId];
}

class PoolDeleteFailed extends MyAcademyState {
  final String message;
  PoolDeleteFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class PoolCreating extends MyAcademyState {
  @override
  List<Object?> get props => [];
}

class PoolCreated extends MyAcademyState {
  final Pool pool;
  PoolCreated(this.pool);
  @override
  List<Object?> get props => [pool];
}

class PoolCreateFailed extends MyAcademyState {
  final String message;
  PoolCreateFailed(this.message);
  @override
  List<Object?> get props => [message];
}

class AcademyUpdating extends MyAcademyState {
  @override
  List<Object?> get props => [];
}

class AcademyUpdated extends MyAcademyState {
  final Academy academy;
  AcademyUpdated(this.academy);
  @override
  List<Object?> get props => [academy];
}

class AcademyUpdateFailed extends MyAcademyState {
  final String message;
  AcademyUpdateFailed(this.message);
  @override
  List<Object?> get props => [message];
}
