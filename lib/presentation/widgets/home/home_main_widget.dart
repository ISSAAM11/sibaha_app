import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/widgets/home/search_button.dart';

class HomeMainWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeMainWidget({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TokenBloc, TokenState>(
      builder: (context, tokenState) {
        final username =
            tokenState is TokenRetrieved ? tokenState.username : null;
        return _buildContent(context, username);
      },
    );
  }

  Widget _buildContent(BuildContext context, String? username) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Hero(username: username),
          const SizedBox(height: AppSpacing.xl),
          _CitySearchSection(scaffoldKey: scaffoldKey),
          const SizedBox(height: AppSpacing.xl),
          const _PopularAcademiesSection(),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final String? username;

  const _Hero({required this.username});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryContainer,
            AppColors.secondaryFixedDim,
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username != null ? 'Welcome, $username' : 'Welcome',
                style: AppTextStyles.screenTitle.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Start your swimming journey',
                style: AppTextStyles.subtitle.copyWith(
                  color: AppColors.onPrimary.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'SEARCH BY',
                style: AppTextStyles.fieldLabel.copyWith(
                  color: AppColors.onPrimary.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: SearchButton(
                      icon: Icons.pool,
                      label: 'Pool',
                      onTap: () => context.go('/poolList'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: SearchButton(
                      icon: Icons.school,
                      label: 'Academy',
                      onTap: () => context.go('/AcademysList'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: SearchButton(
                      icon: Icons.person,
                      label: 'Coach',
                      onTap: () => context.go('/coachList'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CitySearchSection extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const _CitySearchSection({required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Your city',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.onSurface,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            readOnly: true,
            onTap: () => scaffoldKey.currentState?.openDrawer(),
            style: AppTextStyles.fieldInput,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceContainerLow,
              hintText: 'Search a city',
              hintStyle: TextStyle(
                fontSize: 16,
                color: AppColors.outline.withOpacity(0.6),
              ),
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.outline, size: 22),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: AppSpacing.lg,
                horizontal: AppSpacing.xs,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton.icon(
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(
              Icons.location_on_outlined,
              size: 18,
              color: AppColors.onPrimary,
            ),
            label: const Text(
              'Near to me',
              style: AppTextStyles.buttonLabel,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              shape: const StadiumBorder(),
              elevation: 4,
              shadowColor: AppColors.primary.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularAcademiesSection extends StatelessWidget {
  const _PopularAcademiesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Text(
            'Popular Academies',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.onSurface,
                ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final isEven = index % 2 == 0;
              return _AcademyCard(
                imageUrl: isEven
                    ? 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop'
                    : 'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?w=400&h=300&fit=crop',
                title: isEven ? 'Academy Sports' : 'Pool Academy',
                subtitle: 'Swimming • Fitness',
                rating: '4.5',
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AcademyCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String rating;

  const _AcademyCard({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        borderRadius: AppBorderRadius.lgRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppBorderRadius.lgRadius,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.surfaceContainerLow,
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.onSurface.withOpacity(0.75),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: AppSpacing.md,
              right: AppSpacing.md,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.onSurface.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star,
                        color: AppColors.secondaryFixedDim, size: 14),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      rating,
                      style: const TextStyle(
                        fontFamily: 'Lexend',
                        color: AppColors.onPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Lexend',
                      color: AppColors.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Lexend',
                      color: AppColors.onPrimary.withOpacity(0.85),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
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
