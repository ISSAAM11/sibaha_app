import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/data/models/course.dart';
import 'package:sibaha_app/data/models/subscription.dart';
import 'package:sibaha_app/presentation/blocs/subscription_bloc/subscription_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  bool _fetchTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetchTriggered) {
      final tokenState = context.read<TokenBloc>().state;
      if (tokenState is TokenRetrieved) {
        context
            .read<SubscriptionBloc>()
            .add(FetchMyEnrollmentsEvent(tokenState.token));
        _fetchTriggered = true;
      }
    }
  }

  void _refresh() {
    final tokenState = context.read<TokenBloc>().state;
    if (tokenState is TokenRetrieved) {
      context
          .read<SubscriptionBloc>()
          .add(FetchMyEnrollmentsEvent(tokenState.token));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscriptionBloc, SubscriptionState>(
      listenWhen: (_, s) =>
          s is MyEnrollmentsTokenExpired ||
          s is DeleteEnrollmentSuccess ||
          s is DeleteEnrollmentFailed ||
          s is DeleteEnrollmentTokenExpired,
      listener: (context, state) {
        if (state is MyEnrollmentsTokenExpired ||
            state is DeleteEnrollmentTokenExpired) {
          context.read<TokenBloc>().add(TokenRefresh());
        } else if (state is DeleteEnrollmentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Enrollment cancelled.'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.mdRadius),
            ),
          );
          _refresh();
        } else if (state is DeleteEnrollmentFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.mdRadius),
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
            'My Courses',
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
        body: BlocBuilder<SubscriptionBloc, SubscriptionState>(
          buildWhen: (_, s) =>
              s is MyEnrollmentsLoading ||
              s is MyEnrollmentsLoaded ||
              s is MyEnrollmentsFailed,
          builder: (context, state) {
            if (state is MyEnrollmentsLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary));
            }
            if (state is MyEnrollmentsFailed) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppColors.errorColor, size: 48),
                      const SizedBox(height: AppSpacing.lg),
                      Text(state.message,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.subtitle
                              .copyWith(color: AppColors.onSurfaceVariant)),
                      const SizedBox(height: AppSpacing.lg),
                      TextButton(
                        onPressed: _refresh,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is MyEnrollmentsLoaded) {
              if (state.enrollments.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.school_outlined,
                            size: 56, color: AppColors.outlineVariant),
                        const SizedBox(height: AppSpacing.lg),
                        Text('No enrollments yet',
                            style: AppTextStyles.subtitle
                                .copyWith(color: AppColors.onSurfaceVariant)),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Browse academies and enroll in a course',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.outline),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async => _refresh(),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.lg,
                  ),
                  itemCount: state.enrollments.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) => _EnrollmentCard(
                    enrollment: state.enrollments[index],
                    onDelete: () =>
                        _confirmDelete(context, state.enrollments[index]),
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Subscription enrollment) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel enrollment?'),
        content: Text(
          'Remove your enrollment in "${enrollment.courseName ?? 'this course'}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              final tokenState = context.read<TokenBloc>().state;
              if (tokenState is TokenRetrieved) {
                context.read<SubscriptionBloc>().add(
                      DeleteEnrollmentEvent(tokenState.token, enrollment.id),
                    );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.errorColor),
            child: const Text('Cancel enrollment'),
          ),
        ],
      ),
    );
  }
}

class _EnrollmentCard extends StatelessWidget {
  final Subscription enrollment;
  final VoidCallback onDelete;

  const _EnrollmentCard({required this.enrollment, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isActive = enrollment.status == 'active';
    final hasLocation = (enrollment.academyCity?.isNotEmpty ?? false) ||
        (enrollment.academyAddress?.isNotEmpty ?? false);
    final hasDetails =
        hasLocation || enrollment.coachName != null || enrollment.timings.isNotEmpty;

    return Material(
      color: Colors.white,
      borderRadius: AppBorderRadius.lgRadius,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: AppBorderRadius.lgRadius,
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: course name + status chip + delete
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    enrollment.courseName ?? 'Course',
                    style: AppTextStyles.subtitle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _StatusChip(isActive: isActive),
                const SizedBox(width: AppSpacing.xs),
                BlocBuilder<SubscriptionBloc, SubscriptionState>(
                  buildWhen: (_, s) =>
                      s is DeleteEnrollmentLoading ||
                      s is DeleteEnrollmentSuccess ||
                      s is DeleteEnrollmentFailed,
                  builder: (context, state) {
                    if (state is DeleteEnrollmentLoading) {
                      return const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.errorColor),
                      );
                    }
                    return GestureDetector(
                      onTap: onDelete,
                      child: const Icon(Icons.delete_outline,
                          size: 20, color: AppColors.errorColor),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            // Academy name + level badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    enrollment.academyName,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ),
                if (enrollment.courseLevel != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  _LevelBadge(level: enrollment.courseLevel!),
                ],
              ],
            ),
            if (hasDetails) ...[
              const SizedBox(height: AppSpacing.sm),
              const Divider(height: 1, thickness: 1, color: Color(0xFFF2F2F2)),
              const SizedBox(height: AppSpacing.sm),
              if (hasLocation)
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  text: _buildLocation(),
                ),
              if (enrollment.coachName != null)
                _InfoRow(
                  icon: Icons.person_outline,
                  text: enrollment.coachName!,
                ),
              for (final timing in enrollment.timings)
                _InfoRow(
                  icon: Icons.schedule_outlined,
                  text:
                      '${_capitalize(timing.weekday)}  ${timing.startTime} – ${timing.endTime}',
                ),
              if (isActive && enrollment.timings.isNotEmpty)
                _NextSessionRow(timings: enrollment.timings),
            ],
            const SizedBox(height: AppSpacing.sm),
            // Footer: price + enrollment date
            Row(
              children: [
                const Icon(Icons.payments_outlined,
                    size: 14, color: AppColors.onSurfaceVariant),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  enrollment.priceAtSubscription != null
                      ? '${enrollment.priceAtSubscription!.toStringAsFixed(2)} TND/mo'
                      : '--',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
                const Spacer(),
                Text(
                  _formatDate(enrollment.subscribedAt),
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _buildLocation() {
    return [enrollment.academyCity, enrollment.academyAddress]
        .where((s) => s != null && s.isNotEmpty)
        .join(', ');
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

class _NextSessionRow extends StatelessWidget {
  final List<CourseTiming> timings;
  const _NextSessionRow({required this.timings});

  @override
  Widget build(BuildContext context) {
    final label = _nextSessionLabel(timings);
    if (label == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, size: 14, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'Next session $label',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static String? _nextSessionLabel(List<CourseTiming> timings) {
    if (timings.isEmpty) return null;
    final now = DateTime.now();
    const weekdays = [
      'monday', 'tuesday', 'wednesday', 'thursday',
      'friday', 'saturday', 'sunday',
    ];

    Duration? shortest;

    for (final timing in timings) {
      final targetIdx = weekdays.indexOf(timing.weekday.toLowerCase());
      if (targetIdx == -1) continue;

      final parts = timing.startTime.split(':');
      if (parts.length < 2) continue;
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts[1]) ?? 0;

      // DateTime.weekday is 1-based (1=Monday), targetIdx is 0-based
      var daysUntil = targetIdx - (now.weekday - 1);
      if (daysUntil < 0) daysUntil += 7;

      final candidate =
          DateTime(now.year, now.month, now.day, h, m).add(Duration(days: daysUntil));
      var diff = candidate.difference(now);
      if (diff.isNegative) diff += const Duration(days: 7);

      if (shortest == null || diff < shortest) shortest = diff;
    }

    if (shortest == null) return null;

    if (shortest.inMinutes < 60) return 'in ${shortest.inMinutes}min';
    if (shortest.inHours < 24) {
      final h = shortest.inHours;
      final m = shortest.inMinutes % 60;
      return m > 0 ? 'in ${h}h ${m}min' : 'in ${h}h';
    }
    if (shortest.inDays == 1) return 'tomorrow';
    return 'in ${shortest.inDays} days';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: AppColors.onSurfaceVariant),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  final String level;
  const _LevelBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (level) {
      'beginner' => (const Color(0xFF007A5E), 'Beginner'),
      'intermediate' => (const Color(0xFFB45000), 'Intermediate'),
      'advanced' => (AppColors.primary, 'Advanced'),
      _ => (AppColors.outline, level),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppBorderRadius.smRadius,
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool isActive;
  const _StatusChip({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF007A5E) : Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppBorderRadius.smRadius,
      ),
      child: Text(
        isActive ? 'Active' : 'Cancelled',
        style:
            TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
