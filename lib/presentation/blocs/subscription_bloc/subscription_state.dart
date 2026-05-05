part of 'subscription_bloc.dart';

@immutable
abstract class SubscriptionState {}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionSuccess extends SubscriptionState {}

class SubscriptionFailed extends SubscriptionState {
  final String message;
  SubscriptionFailed(this.message);
}

class SubscriptionTokenExpired extends SubscriptionState {}
