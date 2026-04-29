part of 'coach_bloc.dart';

@immutable
sealed class CoachState extends Equatable {}

final class CoachInitial extends CoachState {
  @override
  List<Object?> get props => [];
}

class CoachLoading extends CoachState {
  @override
  List<Object?> get props => [];
}

class CoachLoaded extends CoachState {
  final List<CoachSummary> coaches;
  CoachLoaded(this.coaches);

  @override
  List<Object?> get props => [coaches];
}

class CoachFailed extends CoachState {
  final String message;
  CoachFailed(this.message);

  @override
  List<Object?> get props => [message];
}
