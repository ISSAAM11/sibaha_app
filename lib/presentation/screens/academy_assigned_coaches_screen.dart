import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/data/models/coach_summary.dart';
import 'package:sibaha_app/data/models/invitation.dart';
import 'package:sibaha_app/presentation/blocs/invitation_bloc/invitation_bloc.dart';
import 'package:sibaha_app/presentation/blocs/invitation_bloc/invitation_event.dart';
import 'package:sibaha_app/presentation/blocs/invitation_bloc/invitation_state.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/widgets/coaches/coach_card.dart';

class AcademyAssignedCoachesScreen extends StatefulWidget {
  final int academyId;
  final String academyName;

  const AcademyAssignedCoachesScreen({
    super.key,
    required this.academyId,
    required this.academyName,
  });

  @override
  State<AcademyAssignedCoachesScreen> createState() =>
      _AcademyAssignedCoachesScreenState();
}

class _AcademyAssignedCoachesScreenState
    extends State<AcademyAssignedCoachesScreen> {
  bool _fetchTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetchTriggered) {
      final tokenState = context.read<TokenBloc>().state;
      if (tokenState is TokenRetrieved) {
        context.read<InvitationBloc>().add(
              FetchInvitations(tokenState.token, widget.academyId),
            );
        _fetchTriggered = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Coaches',
          style: AppTextStyles.subtitle.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.outlineVariant.withOpacity(0.4),
          ),
        ),
      ),
      body: BlocBuilder<InvitationBloc, InvitationState>(
        builder: (context, state) {
          if (state is InvitationInitial || state is InvitationLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is InvitationFailed) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline,
                        color: AppColors.errorColor, size: 48),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            );
          }

          final List<Invitation> invitations = switch (state) {
            InvitationLoaded s => s.invitations,
            InvitationSending s => s.invitations,
            InvitationSent s => s.invitations,
            InvitationSendFailed s => s.invitations,
            _ => [],
          };
          final List<CoachSummary> allCoaches = switch (state) {
            InvitationLoaded s => s.coaches,
            InvitationSending s => s.coaches,
            InvitationSent s => s.coaches,
            InvitationSendFailed s => s.coaches,
            _ => [],
          };

          final acceptedIds = invitations
              .where((i) => i.status == InvitationStatus.accepted)
              .map((i) => i.toCoach)
              .toSet();

          final assigned = allCoaches
              .where((c) => acceptedIds.contains(c.id))
              .toList();

          if (assigned.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_off_outlined,
                        size: 56, color: AppColors.outlineVariant),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'No coaches assigned yet',
                      style: AppTextStyles.subtitle
                          .copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Coaches who accept your invitation will appear here',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.outline),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            itemCount: assigned.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.lg),
            itemBuilder: (context, index) =>
                CoachCard(coach: assigned[index]),
          );
        },
      ),
    );
  }
}
