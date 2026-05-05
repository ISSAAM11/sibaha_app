import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/data/models/academy.dart';
import 'package:sibaha_app/data/models/course.dart';
import 'package:sibaha_app/presentation/blocs/course_bloc/course_bloc.dart';
import 'package:sibaha_app/presentation/blocs/invitation_bloc/invitation_bloc.dart';
import 'package:sibaha_app/presentation/blocs/invitation_bloc/invitation_event.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';

class AcademyCoursesScreen extends StatefulWidget {
  final Academy academy;

  const AcademyCoursesScreen({super.key, required this.academy});

  @override
  State<AcademyCoursesScreen> createState() => _AcademyCoursesScreenState();
}

class _AcademyCoursesScreenState extends State<AcademyCoursesScreen> {
  bool _fetchTriggered = false;
  List<Course> _courses = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetchTriggered) {
      final tokenState = context.read<TokenBloc>().state;
      if (tokenState is TokenRetrieved) {
        context
            .read<CourseBloc>()
            .add(FetchCoursesEvent(tokenState.token, widget.academy.id));
        context
            .read<InvitationBloc>()
            .add(FetchInvitations(tokenState.token, widget.academy.id));
        _fetchTriggered = true;
      }
    }
  }

  void _openCreateForm() {
    context.push(
      '/MyAcademies/${widget.academy.id}/courses/new',
      extra: widget.academy,
    );
  }

  void _openEditForm(Course course) {
    context.push(
      '/MyAcademies/${widget.academy.id}/courses/edit',
      extra: {'academy': widget.academy, 'course': course},
    );
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
          'Courses',
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
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateForm,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: BlocConsumer<CourseBloc, CourseState>(
        listener: (context, state) {
          if (state is CourseLoaded) {
            setState(() => _courses = state.courses);
          } else if (state is CourseTokenExpired) {
            context.read<TokenBloc>().add(TokenRefresh());
          } else if (state is CourseDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Course deleted'),
                backgroundColor: AppColors.primary,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.mdRadius),
              ),
            );
          } else if (state is CourseDeleteFailed) {
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
        builder: (context, state) {
          if (state is CourseInitial || state is CourseLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is CourseFailed) {
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
                  ],
                ),
              ),
            );
          }

          final deletingId =
              state is CourseDeleting ? state.courseId : null;

          if (_courses.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.school_outlined,
                        size: 56, color: AppColors.outlineVariant),
                    const SizedBox(height: AppSpacing.lg),
                    Text('No courses yet',
                        style: AppTextStyles.subtitle
                            .copyWith(color: AppColors.onSurfaceVariant)),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Create your first course using the + button',
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
            itemCount: _courses.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final course = _courses[index];
              return _CourseCard(
                course: course,
                isDeleting: deletingId == course.id,
                onEdit: () => _openEditForm(course),
                onDelete: () => _confirmDelete(context, course),
              );
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, Course course) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: AppBorderRadius.lgRadius),
        title: const Text('Delete course?'),
        content: Text(
            'This will permanently delete "${course.name}" and all its sessions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              final tokenState = context.read<TokenBloc>().state;
              if (tokenState is TokenRetrieved) {
                context.read<CourseBloc>().add(DeleteCourseEvent(
                      token: tokenState.token,
                      academyId: widget.academy.id,
                      courseId: course.id,
                    ));
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}


class _CourseCard extends StatelessWidget {
  final Course course;
  final bool isDeleting;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CourseCard({
    required this.course,
    required this.isDeleting,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
                _LevelChip(level: course.level),
              ],
            ),
            if (course.description.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                course.description,
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.onSurfaceVariant),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(Icons.payments_outlined,
                    size: 14, color: AppColors.onSurfaceVariant),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  course.pricePerMonth != null
                      ? '${course.pricePerMonth!.toStringAsFixed(2)} TND/mo'
                      : '--',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.onSurfaceVariant),
                ),
                if (course.coachName != null) ...[
                  const SizedBox(width: AppSpacing.md),
                  _CoachAvatar(
                      name: course.coachName!, pictureUrl: course.coachPicture),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      course.coachName!,
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.onSurfaceVariant),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
            if (course.timings.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children:
                    course.timings.map((t) => _TimingChip(timing: t)).toList(),
              ),
            ],
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined,
                      color: AppColors.primary, size: 20),
                  tooltip: 'Edit course',
                  onPressed: isDeleting ? null : onEdit,
                ),
                isDeleting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.errorColor),
                      )
                    : IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: AppColors.errorColor, size: 20),
                        tooltip: 'Delete course',
                        onPressed: onDelete,
                      ),
              ],
            ),
          ],
        ),
      ),
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
        style:
            TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}

class _CoachAvatar extends StatelessWidget {
  final String name;
  final String? pictureUrl;

  const _CoachAvatar({required this.name, this.pictureUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 10,
      backgroundColor: AppColors.primaryContainer.withOpacity(0.2),
      backgroundImage: pictureUrl != null && pictureUrl!.isNotEmpty
          ? NetworkImage(pictureUrl!)
          : null,
      child: pictureUrl == null || pictureUrl!.isEmpty
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary),
            )
          : null,
    );
  }
}

class _TimingChip extends StatelessWidget {
  final CourseTiming timing;
  const _TimingChip({required this.timing});

  @override
  Widget build(BuildContext context) {
    final day =
        timing.weekday[0].toUpperCase() + timing.weekday.substring(1, 3);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: AppBorderRadius.smRadius,
      ),
      child: Text(
        '$day ${timing.startTime}–${timing.endTime}',
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.primary),
      ),
    );
  }
}
