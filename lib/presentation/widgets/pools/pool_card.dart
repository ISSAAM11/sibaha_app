import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/data/models/pool.dart';

class PoolCard extends StatelessWidget {
  final Pool pool;

  const PoolCard({super.key, required this.pool});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/poolList/${pool.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.lg),
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
              Positioned(
                top: AppSpacing.md,
                right: AppSpacing.md,
                child: _HeatedBadge(heated: pool.heated),
              ),
              Positioned(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                bottom: AppSpacing.lg,
                child: _InfoOverlay(pool: pool),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    if (pool.image != null && pool.image!.isNotEmpty) {
      return Image.network(
        pool.image!,
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

class _HeatedBadge extends StatelessWidget {
  final bool heated;

  const _HeatedBadge({required this.heated});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: heated
            ? Colors.deepOrange.withOpacity(0.85)
            : AppColors.onSurface.withOpacity(0.55),
        borderRadius: AppBorderRadius.smRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            heated ? Icons.whatshot : Icons.ac_unit,
            color: AppColors.onPrimary,
            size: 14,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            heated ? 'Heated' : 'Unheated',
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
  final Pool pool;

  const _InfoOverlay({required this.pool});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (pool.speciality.isNotEmpty) ...[
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: pool.speciality
                .take(3)
                .map((s) => _SpecialityChip(label: s))
                .toList(),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Text(
          pool.name,
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
        Row(
          children: [
            const Icon(Icons.school_outlined,
                size: 14, color: AppColors.onPrimary),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                pool.academyName,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onPrimary.withOpacity(0.85),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
        border: Border.all(
            color: AppColors.onPrimary.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: AppColors.onPrimary),
      ),
    );
  }
}
