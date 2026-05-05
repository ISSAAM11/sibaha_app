part of 'academy_clients_bloc.dart';

@immutable
abstract class AcademyClientsEvent {}

class FetchAcademyClientsEvent extends AcademyClientsEvent {
  final String token;
  final int academyId;
  FetchAcademyClientsEvent(this.token, this.academyId);
}

class RemoveAcademyClientEvent extends AcademyClientsEvent {
  final String token;
  final int academyId;
  final int subscriptionId;
  RemoveAcademyClientEvent(this.token, this.academyId, this.subscriptionId);
}
