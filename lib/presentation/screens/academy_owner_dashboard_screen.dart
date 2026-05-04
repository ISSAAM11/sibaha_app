import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/data/models/academy.dart';

class AcademyOwnerDashboardScreen extends StatelessWidget {
  final Academy academy;

  const AcademyOwnerDashboardScreen({
    super.key,
    required this.academy,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          academy.name,
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
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _DashboardSection(
            icon: Icons.edit_outlined,
            title: 'Edit Academy',
            subtitle: 'Update your academy information and settings',
            onTap: () => context.push(
              '/MyAcademies/edit/${academy.id}',
              extra: academy,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _DashboardSection(
            icon: Icons.people_outline,
            title: 'Clients',
            subtitle: 'View and manage your registered clients',
          ),
          const SizedBox(height: AppSpacing.md),
          _DashboardSection(
            icon: Icons.sports_outlined,
            title: 'Coaches',
            subtitle: 'See the coaches assigned to your academy',
            onTap: () => context.push('/AcademyCoachs'),
          ),
          const SizedBox(height: AppSpacing.md),
          _DashboardSection(
            icon: Icons.person_add_outlined,
            title: 'Invite a Coach',
            subtitle: 'Send an invitation to a coach to join your academy',
          ),
          const SizedBox(height: AppSpacing.md),
          _DashboardSection(
            icon: Icons.rate_review_outlined,
            title: 'Reviews',
            subtitle: 'Read what clients are saying about your academy',
            onTap: () => context.push(
              '/ReviewList',
              extra: {
                'academyId': academy.id,
                'academyName': academy.name,
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _DashboardSection({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: AppBorderRadius.lgRadius,
      child: InkWell(
        onTap: onTap,
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
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: AppBorderRadius.mdRadius,
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.subtitle.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                onTap != null ? Icons.chevron_right : Icons.lock_outline,
                color: AppColors.outlineVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
