part of 'academy_bloc.dart';

@immutable
sealed class AcademyState extends Equatable {}

final class AcademyInitial extends AcademyState {
  @override
  List<Object?> get props => [];
}

class AcademyLoading extends AcademyState {
  @override
  List<Object?> get props => [];
}

class AcademyLoaded extends AcademyState {
  final List<Academy> academies;

  AcademyLoaded(this.academies);

  @override
  List<Object?> get props => [academies];
}

class AcademyFailed extends AcademyState {
  final String message;

  AcademyFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class AcademyTokenExpired extends AcademyState {
  @override
  List<Object?> get props => [];
}
