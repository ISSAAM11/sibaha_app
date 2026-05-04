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
