import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/data/models/invitation.dart';
import 'package:sibaha_app/data/repositories/coach_repository.dart';
import 'coach_invitation_event.dart';
import 'coach_invitation_state.dart';

class CoachInvitationBloc extends Bloc<CoachInvitationEvent, CoachInvitationState> {
  final CoachRepository _coachRepository;

  CoachInvitationBloc({required CoachRepository coachRepository})
      : _coachRepository = coachRepository,
        super(CoachInvitationInitial()) {
    on<FetchCoachInvitations>(_onFetch);
    on<RespondToInvitation>(_onRespond);
  }

  Future<void> _onFetch(
      FetchCoachInvitations event, Emitter<CoachInvitationState> emit) async {
    emit(CoachInvitationLoading());
    try {
      final invitations = await _coachRepository.getMyInvitations(event.token);
      emit(CoachInvitationLoaded(invitations));
    } on TokenExpiredException {
      emit(CoachInvitationTokenExpired());
    } catch (e) {
      emit(CoachInvitationFailed(e.toString()));
    }
  }

  Future<void> _onRespond(
      RespondToInvitation event, Emitter<CoachInvitationState> emit) async {
    final current = state;
    final List<Invitation> invitations =
        current is CoachInvitationLoaded ? current.invitations : [];

    emit(CoachInvitationResponding(invitations, event.invitationId));
    try {
      final updated = await _coachRepository.respondToInvitation(
          event.token, event.invitationId, event.status);
      final newList = invitations
          .map((inv) => inv.id == updated.id ? updated : inv)
          .toList();
      emit(CoachInvitationLoaded(newList));
    } on TokenExpiredException {
      emit(CoachInvitationTokenExpired());
    } catch (e) {
      emit(CoachInvitationLoaded(invitations));
    }
  }
}
