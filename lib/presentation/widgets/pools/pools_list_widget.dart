import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/presentation/blocs/pool_bloc/pool_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/widgets/pools/pool_card.dart';
import 'package:sibaha_app/presentation/widgets/pools/pool_filter_sheet.dart';

class PoolsListWidget extends StatefulWidget {
  const PoolsListWidget({super.key});

  @override
  State<PoolsListWidget> createState() => _PoolsListWidgetState();
}

class _PoolsListWidgetState extends State<PoolsListWidget> {
  bool _fetchTriggered = false;
  PoolFilter _activeFilter = const PoolFilter();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetchTriggered) {
      final tokenState = context.read<TokenBloc>().state;
      final token = tokenState is TokenRetrieved ? tokenState.token : null;
      context.read<PoolBloc>().add(FetchPools(token));
      _fetchTriggered = true;
    }
  }

  List<String> _availableSpecialities() {
    return context
        .read<PoolBloc>()
        .poolData
        .expand((p) => p.speciality)
        .toSet()
        .toList()
      ..sort();
  }

  Future<void> _openFilterSheet() async {
    final filter = await showModalBottomSheet<PoolFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppBorderRadius.lg),
          topRight: Radius.circular(AppBorderRadius.lg),
        ),
      ),
      builder: (_) => PoolFilterSheet(
        availableSpecialities: _availableSpecialities(),
        currentHeated: _activeFilter.heated,
        currentSpecialities: _activeFilter.specialities,
      ),
    );

    if (filter != null) {
      setState(() => _activeFilter = filter);
      if (mounted) {
        context.read<PoolBloc>().add(
              FilterPools(
                heated: filter.heated,
                specialities: filter.specialities,
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PoolBloc, PoolState>(
      listenWhen: (_, s) => s is PoolTokenExpired,
      listener: (context, _) => context.read<TokenBloc>().add(TokenRefresh()),
      child: Column(
        children: [
          _FilterBar(
            isFilterActive: _activeFilter.isActive,
            onFilterTap: _openFilterSheet,
          ),
          Expanded(child: _PoolList()),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final bool isFilterActive;
  final VoidCallback onFilterTap;

  const _FilterBar({
    required this.isFilterActive,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          _FilterButton(
            icon: Icons.tune_rounded,
            label: 'Filter',
            onTap: onFilterTap,
            isActive: isFilterActive,
          ),
          const SizedBox(width: AppSpacing.md),
          _FilterButton(
            icon: Icons.map_outlined,
            label: 'Map',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const _FilterButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
          decoration: BoxDecoration(
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.outlineVariant,
            ),
            borderRadius: AppBorderRadius.smRadius,
            color: isActive
                ? AppColors.primary.withOpacity(0.06)
                : Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16,
                  color: isActive
                      ? AppColors.primary
                      : AppColors.onSurfaceVariant),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: AppTextStyles.buttonLabel.copyWith(
                  color: isActive ? AppColors.primary : AppColors.onSurface,
                ),
              ),
              if (isActive) ...[
                const SizedBox(width: AppSpacing.xs),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PoolList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PoolBloc, PoolState>(
      builder: (context, state) {
        if (state is PoolInitial ||
            state is PoolLoading ||
            state is PoolTokenExpired) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (state is PoolFailed) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppColors.outline),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is PoolLoaded) {
          if (state.pools.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.search_off,
                      size: 48, color: AppColors.outline),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No pools found',
                    style: AppTextStyles.subtitle
                        .copyWith(color: AppColors.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            itemCount: state.pools.length,
            itemBuilder: (context, index) =>
                PoolCard(pool: state.pools[index]),
          );
        }
        return const SizedBox();
      },
    );
  }
}
