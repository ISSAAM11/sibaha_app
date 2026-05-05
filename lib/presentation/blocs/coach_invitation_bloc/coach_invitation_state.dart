import 'package:sibaha_app/data/models/invitation.dart';

abstract class CoachInvitationState {}

class CoachInvitationInitial extends CoachInvitationState {}

class CoachInvitationLoading extends CoachInvitationState {}

class CoachInvitationLoaded extends CoachInvitationState {
  final List<Invitation> invitations;
  CoachInvitationLoaded(this.invitations);
}

class CoachInvitationResponding extends CoachInvitationState {
  final List<Invitation> invitations;
  final int respondingId;
  CoachInvitationResponding(this.invitations, this.respondingId);
}

class CoachInvitationFailed extends CoachInvitationState {
  final String message;
  CoachInvitationFailed(this.message);
}

class CoachInvitationTokenExpired extends CoachInvitationState {}
