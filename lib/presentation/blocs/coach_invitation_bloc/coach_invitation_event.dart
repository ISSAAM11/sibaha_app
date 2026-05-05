abstract class CoachInvitationEvent {}

class FetchCoachInvitations extends CoachInvitationEvent {
  final String token;
  FetchCoachInvitations(this.token);
}

class RespondToInvitation extends CoachInvitationEvent {
  final String token;
  final int invitationId;
  final String status;
  RespondToInvitation(this.token, this.invitationId, this.status);
}
