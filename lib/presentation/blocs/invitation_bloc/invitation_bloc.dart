import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/core/exceptions/app_exceptions.dart';
import 'package:sibaha_app/data/models/coach_summary.dart';
import 'package:sibaha_app/data/models/invitation.dart';
import 'package:sibaha_app/data/repositories/academy_repository.dart';
import 'package:sibaha_app/data/repositories/coach_repository.dart';
import 'invitation_event.dart';
import 'invitation_state.dart';

class InvitationBloc extends Bloc<InvitationEvent, InvitationState> {
  final AcademyRepository _academyRepository;
  final CoachRepository _coachRepository;

  InvitationBloc({
    required AcademyRepository academyRepository,
    required CoachRepository coachRepository,
  })  : _academyRepository = academyRepository,
        _coachRepository = coachRepository,
        super(InvitationInitial()) {
    on<FetchInvitations>(_onFetch);
    on<SendInvitation>(_onSend);
  }

  Future<void> _onFetch(
      FetchInvitations event, Emitter<InvitationState> emit) async {
    emit(InvitationLoading());
    try {
      final results = await Future.wait([
        _academyRepository.getInvitations(event.token, event.academyId),
        _coachRepository.getCoaches(),
      ]);
      emit(InvitationLoaded(
        results[0] as List<Invitation>,
        results[1] as List<CoachSummary>,
      ));
    } on TokenExpiredException {
      emit(InvitationTokenExpired());
    } catch (e) {
      emit(InvitationFailed(e.toString()));
    }
  }

  Future<void> _onSend(
      SendInvitation event, Emitter<InvitationState> emit) async {
    final current = state;
    final List<Invitation> invitations = current is InvitationLoaded
        ? current.invitations
        : current is InvitationSent
            ? current.invitations
            : current is InvitationSendFailed
                ? current.invitations
                : [];
    final List<CoachSummary> coaches = current is InvitationLoaded
        ? current.coaches
        : current is InvitationSent
            ? current.coaches
            : current is InvitationSendFailed
                ? current.coaches
                : [];

    emit(InvitationSending(invitations, coaches));
    try {
      final invitation = await _academyRepository.sendInvitation(
          event.token, event.academyId, event.coachId);
      final updated = [...invitations, invitation];
      emit(InvitationSent(updated, coaches));
    } on TokenExpiredException {
      emit(InvitationTokenExpired());
    } catch (e) {
      emit(InvitationSendFailed(e.toString(), invitations, coaches));
    }
  }
}
