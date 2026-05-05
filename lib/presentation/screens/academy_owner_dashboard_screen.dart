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
      body: CustomScrollView(
        slivers: [
          _HeroHeader(academy: academy),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
              child: _StatsRow(academy: academy),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xxl),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
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
                  onTap: () => context.push(
                    '/MyAcademies/${academy.id}/clients',
                    extra: {
                      'academyId': academy.id,
                      'academyName': academy.name,
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _DashboardSection(
                  icon: Icons.sports_outlined,
                  title: 'Coaches',
                  subtitle: 'See the coaches assigned to your academy',
                  onTap: () => context.push(
                    '/MyAcademies/${academy.id}/assigned-coaches',
                    extra: {
                      'academyId': academy.id,
                      'academyName': academy.name,
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _DashboardSection(
                  icon: Icons.person_add_outlined,
                  title: 'Invite a Coach',
                  subtitle:
                      'Send an invitation to a coach to join your academy',
                  onTap: () =>
                      context.push('/MyAcademies/${academy.id}/invite-coaches'),
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
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final Academy academy;
  const _HeroHeader({required this.academy});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          margin: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 6,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back,
              color: AppColors.onSurface, size: 20),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'academy-image-${academy.id}',
              child: academy.image != null && academy.image!.isNotEmpty
                  ? Image.network(
                      academy.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                          color: Colors.blueGrey[200],
                          child: const Center(
                              child: Icon(Icons.pool,
                                  size: 56, color: Colors.white54))),
                    )
                  : Container(
                      color: Colors.blueGrey[200],
                      child: const Center(
                          child:
                              Icon(Icons.pool, size: 56, color: Colors.white54)),
                    ),
            ),
            // Gradient overlay for text legibility
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.65),
                  ],
                  stops: const [0.45, 1.0],
                ),
              ),
            ),
            // Academy name + location at bottom of image
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    academy.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black38, blurRadius: 4)],
                    ),
                  ),
                  if (academy.city.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: Colors.white70, size: 14),
                        const SizedBox(width: 3),
                        Text(
                          academy.city,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        // Title shown when collapsed

        titlePadding: const EdgeInsetsDirectional.only(
            start: AppSpacing.xxxl + AppSpacing.sm, bottom: AppSpacing.mdLg),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final Academy academy;
  const _StatsRow({required this.academy});

  @override
  Widget build(BuildContext context) {
    final rating = academy.averageRating;
    final ratingLabel = rating != null ? rating.toStringAsFixed(1) : '--';

    return Row(
      children: [
        _StatCard(
          icon: Icons.pool_outlined,
          value: '${academy.poolList.length}',
          label: 'Pools',
          color: const Color(0xFF0070EB),
        ),
        const SizedBox(width: AppSpacing.sm),
        _StatCard(
          icon: Icons.sports_outlined,
          value: '${academy.coachesCount}',
          label: 'Coaches',
          color: const Color(0xFF007A5E),
        ),
        const SizedBox(width: AppSpacing.sm),
        _StatCard(
          icon: Icons.people_outline,
          value: '${academy.clientsCount}',
          label: 'Clients',
          color: const Color(0xFF6B48FF),
        ),
        const SizedBox(width: AppSpacing.sm),
        _StatCard(
          icon: Icons.star_outline_rounded,
          value: ratingLabel,
          label: '${academy.reviewCount} reviews',
          color: const Color(0xFFF59E0B),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md, horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppBorderRadius.mdRadius,
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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
                Icons.chevron_right,
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
