import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/data/models/coach_summary.dart';
import 'package:sibaha_app/data/models/invitation.dart';
import 'package:sibaha_app/presentation/blocs/invitation_bloc/invitation_bloc.dart';
import 'package:sibaha_app/presentation/blocs/invitation_bloc/invitation_event.dart';
import 'package:sibaha_app/presentation/blocs/invitation_bloc/invitation_state.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';

class InviteCoachesScreen extends StatefulWidget {
  final int academyId;

  const InviteCoachesScreen({super.key, required this.academyId});

  @override
  State<InviteCoachesScreen> createState() => _InviteCoachesScreenState();
}

class _InviteCoachesScreenState extends State<InviteCoachesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tokenState = context.read<TokenBloc>().state;
    if (tokenState is TokenRetrieved) {
      context
          .read<InvitationBloc>()
          .add(FetchInvitations(tokenState.token, widget.academyId));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InvitationBloc, InvitationState>(
      listener: (context, state) {
        if (state is InvitationTokenExpired) {
          context.read<TokenBloc>().add(TokenRefresh());
        }
        if (state is InvitationSendFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
        if (state is InvitationSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invitation sent successfully'),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainerLow,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            'Invite Coaches',
            style: AppTextStyles.subtitle.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(49),
            child: Column(
              children: [
                Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors.outlineVariant.withOpacity(0.4),
                ),
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.onSurfaceVariant,
                  indicatorColor: AppColors.primary,
                  labelStyle: AppTextStyles.buttonLabel,
                  tabs: const [
                    Tab(text: 'Coaches'),
                    Tab(text: 'Invitations'),
                  ],
                ),
              ],
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
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.subtitle
                        .copyWith(color: AppColors.onSurfaceVariant),
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
            final List<CoachSummary> coaches = switch (state) {
              InvitationLoaded s => s.coaches,
              InvitationSending s => s.coaches,
              InvitationSent s => s.coaches,
              InvitationSendFailed s => s.coaches,
              _ => [],
            };
            final isSending = state is InvitationSending;

            return Stack(
              children: [
                TabBarView(
                  controller: _tabController,
                  children: [
                    _CoachesTab(
                      coaches: coaches,
                      invitations: invitations,
                      isSending: isSending,
                      academyId: widget.academyId,
                    ),
                    _InvitationsTab(invitations: invitations),
                  ],
                ),
                if (isSending)
                  const ColoredBox(
                    color: Colors.black12,
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CoachesTab extends StatefulWidget {
  final List<CoachSummary> coaches;
  final List<Invitation> invitations;
  final bool isSending;
  final int academyId;

  const _CoachesTab({
    required this.coaches,
    required this.invitations,
    required this.isSending,
    required this.academyId,
  });

  @override
  State<_CoachesTab> createState() => _CoachesTabState();
}

class _CoachesTabState extends State<_CoachesTab> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  InvitationStatus? _statusFor(int coachId) {
    try {
      return widget.invitations.firstWhere((i) => i.toCoach == coachId).status;
    } catch (_) {
      return null;
    }
  }

  List<CoachSummary> get _filtered {
    if (_query.isEmpty) return widget.coaches;
    return widget.coaches
        .where((c) => c.username.toLowerCase().contains(_query))
        .toList();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          child: TextField(
            controller: _searchController,
            style: AppTextStyles.fieldInput,
            onChanged: (v) => setState(() => _query = v.trim().toLowerCase()),
            decoration: InputDecoration(
              hintText: 'Search coaches…',
              hintStyle: TextStyle(
                fontSize: 16,
                color: AppColors.outline.withOpacity(0.7),
              ),
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.outline, size: 20),
              suffixIcon: _query.isNotEmpty
                  ? GestureDetector(
                      onTap: _clearSearch,
                      child: const Icon(Icons.close,
                          color: AppColors.outline, size: 18),
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: AppSpacing.sm,
                horizontal: AppSpacing.lg,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.pill),
                borderSide: const BorderSide(
                    color: AppColors.outlineVariant, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.pill),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ),
        if (filtered.isEmpty)
          Expanded(
            child: Center(
              child: Text(
                _query.isEmpty ? 'No coaches available' : 'No coaches found',
                style: AppTextStyles.subtitle
                    .copyWith(color: AppColors.onSurfaceVariant),
              ),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xxl,
              ),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final coach = filtered[index];
                final status = _statusFor(coach.id);
                return _CoachCard(
                  coach: coach,
                  invitationStatus: status,
                  isSending: widget.isSending,
                  onInvite: () {
                    final tokenState = context.read<TokenBloc>().state;
                    if (tokenState is TokenRetrieved) {
                      context.read<InvitationBloc>().add(
                            SendInvitation(
                                tokenState.token, widget.academyId, coach.id),
                          );
                    }
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

class _CoachCard extends StatelessWidget {
  final CoachSummary coach;
  final InvitationStatus? invitationStatus;
  final bool isSending;
  final VoidCallback onInvite;

  const _CoachCard({
    required this.coach,
    required this.invitationStatus,
    required this.isSending,
    required this.onInvite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppBorderRadius.lgRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          _CoachAvatar(picture: coach.picture, name: coach.username),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coach.username,
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                if (coach.speciality.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    coach.speciality,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
                if (coach.yearsOfExperience != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${coach.yearsOfExperience} yrs experience',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (invitationStatus == null)
            OutlinedButton(
              onPressed: isSending ? null : onInvite,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.smRadius,
                ),
              ),
              child: Text('Invite',
                  style: AppTextStyles.buttonLabel
                      .copyWith(color: AppColors.primary)),
            )
          else
            _StatusChip(status: invitationStatus!),
        ],
      ),
    );
  }
}

class _CoachAvatar extends StatelessWidget {
  final String? picture;
  final String name;

  const _CoachAvatar({this.picture, required this.name});

  @override
  Widget build(BuildContext context) {
    if (picture != null && picture!.isNotEmpty) {
      return CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(picture!),
        onBackgroundImageError: (_, __) {},
      );
    }
    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.primary.withOpacity(0.12),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: AppTextStyles.subtitle.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final InvitationStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      InvitationStatus.pending => (
          'Pending',
          const Color(0xFFFFF3CD),
          const Color(0xFF856404),
        ),
      InvitationStatus.accepted => (
          'Accepted',
          const Color(0xFFD1E7DD),
          const Color(0xFF0A3622),
        ),
      InvitationStatus.declined => (
          'Declined',
          const Color(0xFFF8D7DA),
          const Color(0xFF58151C),
        ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppBorderRadius.smRadius,
      ),
      child: Text(label,
          style: AppTextStyles.caption.copyWith(
            color: fg,
            fontWeight: FontWeight.w600,
          )),
    );
  }
}

class _InvitationsTab extends StatelessWidget {
  final List<Invitation> invitations;

  const _InvitationsTab({required this.invitations});

  @override
  Widget build(BuildContext context) {
    if (invitations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.mail_outline,
                  size: 56, color: AppColors.outlineVariant),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'No invitations sent yet',
                style: AppTextStyles.subtitle
                    .copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Go to the Coaches tab to invite a coach',
                style: AppTextStyles.caption.copyWith(color: AppColors.outline),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final pending =
        invitations.where((i) => i.status == InvitationStatus.pending).toList();
    final accepted =
        invitations.where((i) => i.status == InvitationStatus.accepted).toList();
    final declined =
        invitations.where((i) => i.status == InvitationStatus.declined).toList();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        if (pending.isNotEmpty) ...[
          _SectionHeader(label: 'Pending', count: pending.length),
          const SizedBox(height: AppSpacing.sm),
          ...pending.map((i) => _InvitationCard(invitation: i)),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (accepted.isNotEmpty) ...[
          _SectionHeader(label: 'Accepted', count: accepted.length),
          const SizedBox(height: AppSpacing.sm),
          ...accepted.map((i) => _InvitationCard(invitation: i)),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (declined.isNotEmpty) ...[
          _SectionHeader(label: 'Declined', count: declined.length),
          const SizedBox(height: AppSpacing.sm),
          ...declined.map((i) => _InvitationCard(invitation: i)),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;

  const _SectionHeader({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.fieldLabel.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(width: AppSpacing.xs),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs, vertical: 1),
          decoration: BoxDecoration(
            color: AppColors.outlineVariant.withOpacity(0.4),
            borderRadius: AppBorderRadius.xsRadius,
          ),
          child: Text(
            '$count',
            style: AppTextStyles.caption.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}

class _InvitationCard extends StatelessWidget {
  final Invitation invitation;

  const _InvitationCard({required this.invitation});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppBorderRadius.lgRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _CoachAvatar(
              picture: invitation.toCoachPicture,
              name: invitation.toCoachName),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invitation.toCoachName,
                  style: AppTextStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _formatDate(invitation.createdAt),
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          _StatusChip(status: invitation.status),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
