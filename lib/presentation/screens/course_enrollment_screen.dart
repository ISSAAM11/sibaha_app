import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/data/models/course.dart';
import 'package:sibaha_app/presentation/blocs/subscription_bloc/subscription_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';

class CourseEnrollmentScreen extends StatefulWidget {
  final Course course;

  const CourseEnrollmentScreen({super.key, required this.course});

  @override
  State<CourseEnrollmentScreen> createState() => _CourseEnrollmentScreenState();
}

class _CourseEnrollmentScreenState extends State<CourseEnrollmentScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final subState = context.read<SubscriptionBloc>().state;
    if (subState is! MyEnrollmentsLoaded && subState is! MyEnrollmentsLoading) {
      final tokenState = context.read<TokenBloc>().state;
      if (tokenState is TokenRetrieved) {
        context
            .read<SubscriptionBloc>()
            .add(FetchMyEnrollmentsEvent(tokenState.token));
      }
    }
  }

  bool _isAlreadyEnrolled(SubscriptionState state) {
    if (state is MyEnrollmentsLoaded) {
      return state.enrollments.any((e) => e.courseId == widget.course.id);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscriptionBloc, SubscriptionState>(
      listenWhen: (_, s) =>
          s is CourseEnrollmentSuccess ||
          s is CourseEnrollmentFailed ||
          s is CourseEnrollmentTokenExpired,
      listener: (context, state) {
        if (state is CourseEnrollmentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Enrolled successfully!'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.mdRadius),
            ),
          );
          context.pop();
        } else if (state is CourseEnrollmentFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.mdRadius),
            ),
          );
        } else if (state is CourseEnrollmentTokenExpired) {
          context.read<TokenBloc>().add(TokenRefresh());
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
            onPressed: () => context.pop(),
          ),
          title: const Text('Enroll in Course',
              style: AppTextStyles.fieldLabel),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.outlineVariant.withOpacity(0.4),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: AppBorderRadius.lgRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.course.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ),
                        _LevelChip(level: widget.course.level),
                      ],
                    ),
                    if (widget.course.description.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        widget.course.description,
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: AppBorderRadius.mdRadius,
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      label: 'Monthly price',
                      value: widget.course.pricePerMonth != null
                          ? '${widget.course.pricePerMonth!.toStringAsFixed(2)} TND'
                          : 'Contact for pricing',
                      valueColor: AppColors.primary,
                    ),
                    if (widget.course.coachName != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      _InfoRow(
                          label: 'Coach', value: widget.course.coachName!),
                    ],
                    if (widget.course.timings.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      _TimingsRow(timings: widget.course.timings),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    _InfoRow(
                        label: 'Payment', value: 'On-site (no charge now)'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              BlocBuilder<SubscriptionBloc, SubscriptionState>(
                builder: (context, state) {
                  final isEnrolling = state is CourseEnrollmentLoading;
                  final isCheckingEnrollments = state is MyEnrollmentsLoading;
                  final alreadyEnrolled = _isAlreadyEnrolled(state);

                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: (isEnrolling ||
                                  isCheckingEnrollments ||
                                  alreadyEnrolled)
                              ? null
                              : () => _onConfirm(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: alreadyEnrolled
                                ? AppColors.outlineVariant
                                : AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            disabledBackgroundColor: AppColors.outlineVariant,
                            shape: const RoundedRectangleBorder(
                                borderRadius: AppBorderRadius.pillRadius),
                            elevation: 0,
                          ),
                          child: isEnrolling || isCheckingEnrollments
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white))
                              : Text(
                                  alreadyEnrolled
                                      ? 'Already enrolled'
                                      : 'Confirm & Enroll',
                                  style: AppTextStyles.buttonLabel,
                                ),
                        ),
                      ),
                      if (!alreadyEnrolled) ...[
                        const SizedBox(height: AppSpacing.lg),
                        Center(
                          child: Text(
                            'No payment is charged now. You will pay at the academy.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.caption,
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onConfirm(BuildContext context) {
    final tokenState = context.read<TokenBloc>().state;
    if (tokenState is! TokenRetrieved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to enroll.')),
      );
      return;
    }
    context
        .read<SubscriptionBloc>()
        .add(EnrollInCourseEvent(tokenState.token, widget.course.id));
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _TimingsRow extends StatelessWidget {
  final List<CourseTiming> timings;
  const _TimingsRow({required this.timings});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sessions', style: AppTextStyles.fieldLabel),
        const Spacer(),
        Flexible(
          child: Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            alignment: WrapAlignment.end,
            children: timings.map((t) {
              final day =
                  t.weekday[0].toUpperCase() + t.weekday.substring(1, 3);
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: AppBorderRadius.smRadius,
                ),
                child: Text(
                  '$day ${t.startTime}–${t.endTime}',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _LevelChip extends StatelessWidget {
  final String level;
  const _LevelChip({required this.level});

  @override
  Widget build(BuildContext context) {
    final color = switch (level) {
      'advanced' => const Color(0xFFBA1A1A),
      'intermediate' => const Color(0xFF0070EB),
      _ => const Color(0xFF007A5E),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppBorderRadius.smRadius,
      ),
      child: Text(
        level[0].toUpperCase() + level.substring(1),
        style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
