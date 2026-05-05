part of 'academy_clients_bloc.dart';

@immutable
abstract class AcademyClientsState {}

class AcademyClientsInitial extends AcademyClientsState {}

class AcademyClientsLoading extends AcademyClientsState {}

class AcademyClientsLoaded extends AcademyClientsState {
  final List<AcademyClient> clients;
  AcademyClientsLoaded(this.clients);
}

class AcademyClientsRemoving extends AcademyClientsState {
  final List<AcademyClient> clients;
  final int removingSubscriptionId;
  AcademyClientsRemoving(this.clients, this.removingSubscriptionId);
}

class AcademyClientsFailed extends AcademyClientsState {
  final String message;
  AcademyClientsFailed(this.message);
}

class AcademyClientsTokenExpired extends AcademyClientsState {}
