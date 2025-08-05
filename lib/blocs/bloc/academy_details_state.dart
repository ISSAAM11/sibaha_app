part of 'academy_details_bloc.dart';

@immutable
sealed class AcademyDetailsState {}

final class AcademyDetailsInitial extends AcademyDetailsState {}

class AcademyDetailsLoading extends AcademyDetailsState {}

class AcademyDetailsLoaded extends AcademyDetailsState {
  final Academy academiyDetails;

  AcademyDetailsLoaded(this.academiyDetails);
}

class FetchAcademyDetails extends AcademyDetailsState {
  final int id;

  FetchAcademyDetails(this.id);
}

class AcademyDetailsFailed extends AcademyDetailsState {
  final String message;

  AcademyDetailsFailed(this.message);
}
