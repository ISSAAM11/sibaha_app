abstract class InvitationEvent {}

class FetchInvitations extends InvitationEvent {
  final String token;
  final int academyId;
  FetchInvitations(this.token, this.academyId);
}

class SendInvitation extends InvitationEvent {
  final String token;
  final int academyId;
  final int coachId;
  SendInvitation(this.token, this.academyId, this.coachId);
}
