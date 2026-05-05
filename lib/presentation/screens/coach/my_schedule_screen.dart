import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/data/models/coach_course.dart';
import 'package:sibaha_app/data/models/invitation.dart';
import 'package:sibaha_app/presentation/blocs/coach_invitation_bloc/coach_invitation_bloc.dart';
import 'package:sibaha_app/presentation/blocs/coach_invitation_bloc/coach_invitation_event.dart';
import 'package:sibaha_app/presentation/blocs/coach_invitation_bloc/coach_invitation_state.dart';
import 'package:sibaha_app/presentation/blocs/coach_schedule_bloc/coach_schedule_bloc.dart';
import 'package:sibaha_app/presentation/blocs/coach_schedule_bloc/coach_schedule_event.dart';
import 'package:sibaha_app/presentation/blocs/coach_schedule_bloc/coach_schedule_state.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';

class MyScheduleScreen extends StatefulWidget {
  const MyScheduleScreen({super.key});

  @override
  State<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends State<MyScheduleScreen>
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
      final scheduleState = context.read<CoachScheduleBloc>().state;
      if (scheduleState is CoachScheduleInitial) {
        context.read<CoachScheduleBloc>().add(FetchCoachCourses(tokenState.token));
      }
      final invState = context.read<CoachInvitationBloc>().state;
      if (invState is CoachInvitationInitial) {
        context.read<CoachInvitationBloc>().add(FetchCoachInvitations(tokenState.token));
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CoachScheduleBloc, CoachScheduleState>(
          listenWhen: (_, s) => s is CoachScheduleTokenExpired,
          listener: (context, _) => context.read<TokenBloc>().add(TokenRefresh()),
        ),
        BlocListener<CoachInvitationBloc, CoachInvitationState>(
          listenWhen: (_, s) => s is CoachInvitationTokenExpired,
          listener: (context, _) => context.read<TokenBloc>().add(TokenRefresh()),
        ),
        BlocListener<TokenBloc, TokenState>(
          listenWhen: (_, s) => s is TokenRetrieved,
          listener: (context, state) {
            if (state is TokenRetrieved) {
              final scheduleState = context.read<CoachScheduleBloc>().state;
              if (scheduleState is! CoachScheduleLoaded &&
                  scheduleState is! CoachScheduleLoading) {
                context.read<CoachScheduleBloc>().add(FetchCoachCourses(state.token));
              }
              final invState = context.read<CoachInvitationBloc>().state;
              if (invState is! CoachInvitationLoaded &&
                  invState is! CoachInvitationLoading) {
                context.read<CoachInvitationBloc>().add(FetchCoachInvitations(state.token));
              }
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.surfaceContainerLow,
        body: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'My Schedule',
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.onSurfaceVariant,
                indicatorColor: AppColors.primary,
                indicatorWeight: 2,
                labelStyle: const TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: 'Schedule'),
                  Tab(text: 'Invitations'),
                ],
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: const [
              _ScheduleTab(),
              _InvitationsTab(),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Schedule Tab ────────────────────────────────────────────────────────────

class _ScheduleTab extends StatelessWidget {
  const _ScheduleTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoachScheduleBloc, CoachScheduleState>(
      builder: (context, state) {
        if (state is CoachScheduleInitial ||
            state is CoachScheduleLoading ||
            state is CoachScheduleTokenExpired) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (state is CoachScheduleFailed) {
          return _ErrorView(message: state.message);
        }
        if (state is CoachScheduleLoaded) {
          if (state.courses.isEmpty) {
            return const _EmptyView(
              icon: Icons.event_note_outlined,
              title: 'No courses assigned yet',
              subtitle: 'Your academy owner will assign you to a course',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            itemCount: state.courses.length,
            itemBuilder: (context, index) =>
                _CourseCard(course: state.courses[index]),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _CourseCard extends StatelessWidget {
  final CoachCourse course;
  const _CourseCard({required this.course});

  static const _levelColors = {
    'beginner': Color(0xFF007A5E),
    'intermediate': Color(0xFF0070EB),
    'advanced': Color(0xFFBA1A1A),
  };

  @override
  Widget build(BuildContext context) {
    final levelColor = _levelColors[course.level] ?? AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
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
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    course.name,
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _LevelChip(label: course.level, color: levelColor),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(Icons.business_outlined,
                    size: 14, color: AppColors.onSurfaceVariant),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  course.academyName,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
                if (course.poolName != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  const Icon(Icons.pool_outlined,
                      size: 14, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    course.poolName!,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ],
            ),
            if (course.description.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                course.description,
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.onSurfaceVariant),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (course.timings.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1, color: AppColors.outlineVariant),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children:
                    course.timings.map((t) => _TimingChip(timing: t)).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  final String label;
  final Color color;
  const _LevelChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: AppBorderRadius.smRadius,
      ),
      child: Text(
        label[0].toUpperCase() + label.substring(1),
        style: TextStyle(
          fontFamily: 'Lexend',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _TimingChip extends StatelessWidget {
  final CourseTiming timing;
  const _TimingChip({required this.timing});

  @override
  Widget build(BuildContext context) {
    final day = timing.weekday[0].toUpperCase() + timing.weekday.substring(1, 3);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: AppBorderRadius.smRadius,
        border: Border.all(
            color: AppColors.primary.withOpacity(0.2), width: 0.5),
      ),
      child: Text(
        '$day  ${timing.startTime}–${timing.endTime}',
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Invitations Tab ─────────────────────────────────────────────────────────

class _InvitationsTab extends StatelessWidget {
  const _InvitationsTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoachInvitationBloc, CoachInvitationState>(
      builder: (context, state) {
        if (state is CoachInvitationInitial ||
            state is CoachInvitationLoading ||
            state is CoachInvitationTokenExpired) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (state is CoachInvitationFailed) {
          return _ErrorView(message: state.message);
        }

        final List<Invitation> invitations;
        final int? respondingId;
        if (state is CoachInvitationLoaded) {
          invitations = state.invitations;
          respondingId = null;
        } else if (state is CoachInvitationResponding) {
          invitations = state.invitations;
          respondingId = state.respondingId;
        } else {
          return const SizedBox();
        }

        if (invitations.isEmpty) {
          return const _EmptyView(
            icon: Icons.mail_outline_rounded,
            title: 'No invitations yet',
            subtitle: 'Academy owners will send you invitations here',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          itemCount: invitations.length,
          itemBuilder: (context, index) => _InvitationCard(
            invitation: invitations[index],
            isResponding: respondingId == invitations[index].id,
          ),
        );
      },
    );
  }
}

class _InvitationCard extends StatelessWidget {
  final Invitation invitation;
  final bool isResponding;
  const _InvitationCard(
      {required this.invitation, required this.isResponding});

  void _respond(BuildContext context, String status) {
    final tokenState = context.read<TokenBloc>().state;
    if (tokenState is! TokenRetrieved) return;
    context.read<CoachInvitationBloc>().add(
          RespondToInvitation(tokenState.token, invitation.id, status),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isPending = invitation.status == InvitationStatus.pending;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
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
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.business_outlined,
                      color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invitation.academyName ?? 'Unknown Academy',
                        style: AppTextStyles.subtitle.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Text(
                        'From ${invitation.fromOwnerName}',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: invitation.status),
              ],
            ),
            if (invitation.courseName != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  const Icon(Icons.school_outlined,
                      size: 14, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    invitation.courseName!,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.xs),
            Text(
              _formatDate(invitation.createdAt),
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.outlineVariant),
            ),
            if (isPending) ...[
              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1, color: AppColors.outlineVariant),
              const SizedBox(height: AppSpacing.md),
              if (isResponding)
                const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.primary),
                  ),
                )
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _respond(context, 'declined'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.errorColor,
                          side: const BorderSide(color: AppColors.errorColor),
                          shape: RoundedRectangleBorder(
                              borderRadius: AppBorderRadius.mdRadius),
                        ),
                        child: const Text('Decline'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _respond(context, 'accepted'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: AppBorderRadius.mdRadius),
                        ),
                        child: const Text('Accept'),
                      ),
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}

class _StatusBadge extends StatelessWidget {
  final InvitationStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      InvitationStatus.accepted => ('Accepted', const Color(0xFF007A5E)),
      InvitationStatus.declined => ('Declined', AppColors.errorColor),
      InvitationStatus.pending => ('Pending', const Color(0xFFF59E0B)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: AppBorderRadius.smRadius,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Lexend',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ─── Shared Helpers ──────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _EmptyView(
      {required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.outlineVariant),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTextStyles.subtitle
                  .copyWith(color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle,
              style: AppTextStyles.caption.copyWith(color: AppColors.outline),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                size: 48, color: AppColors.outline),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
