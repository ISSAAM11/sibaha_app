import 'package:sibaha_app/data/models/coach_summary.dart';
import 'package:sibaha_app/data/models/invitation.dart';

abstract class InvitationState {}

class InvitationInitial extends InvitationState {}

class InvitationLoading extends InvitationState {}

class InvitationLoaded extends InvitationState {
  final List<Invitation> invitations;
  final List<CoachSummary> coaches;
  InvitationLoaded(this.invitations, this.coaches);
}

class InvitationFailed extends InvitationState {
  final String message;
  InvitationFailed(this.message);
}

class InvitationTokenExpired extends InvitationState {}

class InvitationSending extends InvitationState {
  final List<Invitation> invitations;
  final List<CoachSummary> coaches;
  InvitationSending(this.invitations, this.coaches);
}

class InvitationSent extends InvitationState {
  final List<Invitation> invitations;
  final List<CoachSummary> coaches;
  InvitationSent(this.invitations, this.coaches);
}

class InvitationSendFailed extends InvitationState {
  final String message;
  final List<Invitation> invitations;
  final List<CoachSummary> coaches;
  InvitationSendFailed(this.message, this.invitations, this.coaches);
}
