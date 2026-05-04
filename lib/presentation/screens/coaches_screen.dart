import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/data/models/coach_filter.dart';
import 'package:sibaha_app/presentation/blocs/coach_bloc/coach_bloc.dart';
import 'package:sibaha_app/presentation/widgets/coaches/coach_filter_sheet.dart';
import 'package:sibaha_app/presentation/widgets/coaches/coaches_list_widget.dart';

class CoachesScreen extends StatefulWidget {
  const CoachesScreen({super.key});

  @override
  State<CoachesScreen> createState() => _CoachesScreenState();
}

class _CoachesScreenState extends State<CoachesScreen> {
  final _searchController = TextEditingController();
  CoachFilter _activeFilter = const CoachFilter();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    context.read<CoachBloc>().add(SearchCoaches(value.trim()));
    setState(() {});
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<CoachBloc>().add(SearchCoaches(''));
    setState(() {});
  }

  Future<void> _openFilter() async {
    final bloc = context.read<CoachBloc>();
    final all = bloc.allCoaches;

    final languages = all
        .expand((c) => c.languages)
        .toSet()
        .toList()
      ..sort();

    final specialities = all
        .expand((c) => c.speciality
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty))
        .toSet()
        .toList()
      ..sort();

    final result = await showModalBottomSheet<CoachFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CoachFilterSheet(
        availableLanguages: languages,
        availableSpecialities: specialities,
        currentLanguages: _activeFilter.languages,
        currentSpecialities: _activeFilter.specialities,
        currentHasExperience: _activeFilter.hasExperience,
      ),
    );

    if (result != null) {
      setState(() => _activeFilter = result);
      bloc.add(FilterCoaches(result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(
            searchController: _searchController,
            onSearchChanged: _onSearchChanged,
            onClearSearch: _clearSearch,
            onFilterTap: _openFilter,
            filterActive: _activeFilter.isActive,
          ),
          const Expanded(child: CoachesListWidget()),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final VoidCallback onFilterTap;
  final bool filterActive;

  const _Header({
    required this.searchController,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onFilterTap,
    required this.filterActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        top: MediaQuery.of(context).padding.top + AppSpacing.lg,
        bottom: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  style: AppTextStyles.fieldInput,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search by name…',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: AppColors.outline.withValues(alpha: 0.7),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.outline,
                      size: 20,
                    ),
                    suffixIcon: searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: onClearSearch,
                            child: const Icon(
                              Icons.close,
                              color: AppColors.outline,
                              size: 18,
                            ),
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                      horizontal: AppSpacing.lg,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.pill),
                      borderSide: const BorderSide(
                          color: AppColors.outlineVariant, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.pill),
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 1.5),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _FilterButton(active: filterActive, onTap: onFilterTap),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;

  const _FilterButton({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: active
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              border: Border.all(
                color: active ? AppColors.primary : AppColors.outlineVariant,
                width: 1,
              ),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: active ? AppColors.primary : AppColors.outline,
              size: 20,
            ),
          ),
          if (active)
            Positioned(
              top: -3,
              right: -3,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
