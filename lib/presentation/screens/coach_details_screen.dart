import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/data/models/coach_summary.dart';

class CoachDetailsScreen extends StatelessWidget {
  final CoachSummary coach;

  const CoachDetailsScreen({super.key, required this.coach});

  static const double _heroHeight = 380.0;
  static const double _overlap = 32.0;

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      body: SizedBox.expand(
        child: Stack(
          children: [
            // Hero image fixed at top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: _heroHeight,
              child: _HeroSection(coach: coach),
            ),
            // Scrollable content overlapping the hero
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: _heroHeight - _overlap),
                  _ContentSheet(coach: coach),
                ],
              ),
            ),
            // Back button
            Positioned(
              top: statusBarHeight + 12,
              left: 24,
              child: _GlassIconButton(
                icon: Icons.arrow_back,
                onTap: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: const _BookSessionFAB(),
    );
  }
}

// ── Hero ─────────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final CoachSummary coach;

  const _HeroSection({required this.coach});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image
        _HeroImage(pictureUrl: coach.picture),
        // Scrim gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Color(0xB3000000)],
              stops: [0.4, 1.0],
            ),
          ),
        ),
        // Name + speciality + badge
        Positioned(
          left: AppSpacing.xl,
          right: AppSpacing.xl,
          bottom: CoachDetailsScreen._overlap + AppSpacing.xl,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      coach.username,
                      style: AppTextStyles.screenTitle.copyWith(
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coach.speciality.isNotEmpty
                          ? coach.speciality
                          : 'Swimming Coach',
                      style: AppTextStyles.fieldLabel.copyWith(
                        color: const Color(0xFF00F1FE),
                        letterSpacing: 0.4,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (coach.yearsOfExperience != null) ...[
                const SizedBox(width: AppSpacing.md),
                _ExperienceBadge(years: coach.yearsOfExperience!),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroImage extends StatelessWidget {
  final String? pictureUrl;

  const _HeroImage({this.pictureUrl});

  @override
  Widget build(BuildContext context) {
    if (pictureUrl != null) {
      return Image.network(
        pictureUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _PlaceholderImage(),
      );
    }
    return _PlaceholderImage();
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceContainerLow,
      child: const Icon(Icons.person, size: 80, color: AppColors.outline),
    );
  }
}

class _ExperienceBadge extends StatelessWidget {
  final int years;

  const _ExperienceBadge({required this.years});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppBorderRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                '$years+ yrs',
                style: AppTextStyles.fieldLabel.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'EXPERIENCE',
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 9,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

// ── Glass button ──────────────────────────────────────────────────────────────

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppBorderRadius.pill),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

// ── Content sheet ─────────────────────────────────────────────────────────────

class _ContentSheet extends StatelessWidget {
  final CoachSummary coach;

  const _ContentSheet({required this.coach});

  @override
  Widget build(BuildContext context) {
    final specialties = coach.speciality.isNotEmpty
        ? coach.speciality
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList()
        : <String>[];

    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height -
            CoachDetailsScreen._heroHeight +
            CoachDetailsScreen._overlap,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.xl),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xxxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _KeyInfoGrid(coach: coach),
          if (specialties.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xl),
            _SpecialtiesSection(specialties: specialties),
          ],
          if (coach.aboutMe.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xl),
            _AboutMeSection(text: coach.aboutMe),
          ],
          if (coach.languages.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xl),
            _LanguagesSection(languages: coach.languages),
          ],
        ],
      ),
    );
  }
}

// ── Key info grid ─────────────────────────────────────────────────────────────

class _KeyInfoGrid extends StatelessWidget {
  final CoachSummary coach;

  const _KeyInfoGrid({required this.coach});

  @override
  Widget build(BuildContext context) {
    final langValue =
        coach.languages.isNotEmpty ? coach.languages.join(', ') : '—';
    final expValue = coach.yearsOfExperience != null
        ? '${coach.yearsOfExperience}+ Years'
        : '—';

    return Row(
      children: [
        Expanded(
          child: _InfoBlock(
            icon: Icons.translate_rounded,
            iconColor: AppColors.primary,
            label: 'Languages',
            value: langValue,
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: _InfoBlock(
            icon: Icons.verified_rounded,
            iconColor: const Color(0xFF00696F),
            label: 'Experience',
            value: expValue,
          ),
        ),
      ],
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoBlock({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label.toUpperCase(),
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.outline,
              letterSpacing: 0.8,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.fieldLabel.copyWith(
              color: AppColors.onSurface,
              letterSpacing: 0,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Specialties ───────────────────────────────────────────────────────────────

class _SpecialtiesSection extends StatelessWidget {
  final List<String> specialties;

  const _SpecialtiesSection({required this.specialties});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specialties',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: specialties.map((s) => _SpecialtyChip(label: s)).toList(),
        ),
      ],
    );
  }
}

class _SpecialtyChip extends StatelessWidget {
  final String label;

  const _SpecialtyChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppBorderRadius.pill),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── About Me ──────────────────────────────────────────────────────────────────

class _AboutMeSection extends StatelessWidget {
  final String text;

  const _AboutMeSection({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Me',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppBorderRadius.xl),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.onSurface.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.6,
                ),
          ),
        ),
      ],
    );
  }
}

// ── Languages ─────────────────────────────────────────────────────────────────

class _LanguagesSection extends StatelessWidget {
  final List<String> languages;

  const _LanguagesSection({required this.languages});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Languages',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: languages
              .map(
                (lang) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppBorderRadius.pill),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    lang,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

// ── FAB ───────────────────────────────────────────────────────────────────────

class _BookSessionFAB extends StatelessWidget {
  const _BookSessionFAB();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {},
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: 6,
      icon: const Icon(Icons.calendar_today_rounded, size: 18),
      label: Text('Book a Session', style: AppTextStyles.buttonLabel),
      shape: const StadiumBorder(),
    );
  }
}
