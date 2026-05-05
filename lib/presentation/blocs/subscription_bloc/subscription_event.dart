part of 'subscription_bloc.dart';

@immutable
abstract class SubscriptionEvent {}

class SubscribeToAcademyEvent extends SubscriptionEvent {
  final String token;
  final int academyId;

  SubscribeToAcademyEvent(this.token, this.academyId);
}
