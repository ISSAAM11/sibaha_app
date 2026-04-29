import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/data/models/coach_summary.dart';

class CoachCard extends StatelessWidget {
  final CoachSummary coach;

  const CoachCard({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasExperience = coach.yearsOfExperience != null;

    return GestureDetector(
      onTap: () => context.push('/coachList/${coach.id}', extra: coach),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Avatar(pictureUrl: coach.picture),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coach.username,
                    style: textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    coach.speciality.isNotEmpty
                        ? coach.speciality
                        : 'Swimming Coach',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryContainer,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (coach.languages.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    _LanguageChips(languages: coach.languages),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCell(
                          label: 'Experience',
                          value: hasExperience
                              ? '${coach.yearsOfExperience}+ yrs'
                              : '—',
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: _InfoCell(
                          label: 'Speciality',
                          value: coach.speciality.isNotEmpty
                              ? coach.speciality
                              : '—',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? pictureUrl;

  const _Avatar({this.pictureUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      child: SizedBox(
        width: 110,
        height: 110,
        child: pictureUrl != null
            ? Image.network(
                pictureUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _Placeholder(),
              )
            : _Placeholder(),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainerLow,
      child: const Icon(Icons.person, size: 44, color: AppColors.outline),
    );
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
          // color: AppColors.surfaceContainerLow,
          // borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          // border: Border.all(
          //   color: AppColors.outlineVariant.withValues(alpha: 0.4),
          //   width: 1,
          // ),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.outline,
              letterSpacing: 0.6,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _LanguageChips extends StatelessWidget {
  final List<String> languages;

  const _LanguageChips({required this.languages});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: languages.take(3).map((lang) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppBorderRadius.pill),
            border: Border.all(
              color: AppColors.primaryContainer.withValues(alpha: 0.35),
              width: 0.5,
            ),
          ),
          child: Text(
            lang,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.primaryContainer,
                  fontSize: 10,
                ),
          ),
        );
      }).toList(),
    );
  }
}
