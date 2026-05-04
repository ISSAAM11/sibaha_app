import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/core/utils/static_data.dart';
import 'package:sibaha_app/data/models/academy.dart';

class AcademyCard extends StatelessWidget {
  final int index;
  final Academy academy;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry margin;

  const AcademyCard({
    super.key,
    required this.index,
    required this.academy,
    this.onTap,
    this.margin = const EdgeInsets.only(bottom: AppSpacing.lg),
  });

  @override
  Widget build(BuildContext context) {
    final staticAcademy = academies[index % academies.length];

    return GestureDetector(
      onTap: onTap ?? () => context.push('/AcademyDetails/${academy.id}'),
      child: Container(
        margin: margin,
        height: 220,
        decoration: BoxDecoration(
          borderRadius: AppBorderRadius.lgRadius,
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: AppBorderRadius.lgRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildBackground(),
              _buildGradient(),
              // Rating badge — top right
              Positioned(
                top: AppSpacing.md,
                right: AppSpacing.md,
                child: _RatingBadge(
                  rating: '${staticAcademy['rating']}',
                  reviewCount: '${staticAcademy['reviewCount']}',
                ),
              ),
              // Academy info — bottom overlay
              Positioned(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                bottom: AppSpacing.lg,
                child: _InfoOverlay(academy: academy),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    if (academy.image != null && academy.image!.isNotEmpty) {
      return Image.network(
        academy.image!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.primaryContainer.withOpacity(0.15),
      child: const Center(
        child: Icon(Icons.pool, size: 56, color: AppColors.outlineVariant),
      ),
    );
  }

  Widget _buildGradient() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.onSurface.withOpacity(0.75),
          ],
          stops: const [0.3, 1.0],
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final String rating;
  final String reviewCount;

  const _RatingBadge({required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.onSurface.withOpacity(0.55),
        borderRadius: AppBorderRadius.smRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded,
              color: AppColors.secondaryFixedDim, size: 14),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$rating ($reviewCount)',
            style: const TextStyle(
              fontFamily: 'Lexend',
              color: AppColors.onPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoOverlay extends StatelessWidget {
  final Academy academy;

  const _InfoOverlay({required this.academy});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Speciality chips
        if (academy.specialities.isNotEmpty) ...[
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: academy.specialities
                .take(3)
                .map((s) => _SpecialityChip(label: s))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        // Name
        Text(
          academy.name,
          style: const TextStyle(
            fontFamily: 'Lexend',
            color: AppColors.onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        // Location + pool count
        Row(
          children: [
            const Icon(Icons.location_on_outlined,
                size: 14, color: AppColors.onPrimary),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                academy.city.isNotEmpty ? academy.city : academy.address,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onPrimary.withOpacity(0.85),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (academy.poolList.isNotEmpty) ...[
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.pool, size: 14, color: AppColors.onPrimary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '${academy.poolList.length} pool${academy.poolList.length > 1 ? 's' : ''}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onPrimary.withOpacity(0.85),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _SpecialityChip extends StatelessWidget {
  final String label;

  const _SpecialityChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withOpacity(0.15),
        borderRadius: AppBorderRadius.xsRadius,
        border:
            Border.all(color: AppColors.onPrimary.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: AppColors.onPrimary),
      ),
    );
  }
}
