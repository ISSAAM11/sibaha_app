import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/presentation/blocs/pool_bloc/pool_bloc.dart';
import 'package:sibaha_app/presentation/widgets/pools/pools_list_widget.dart';

class PoolsScreen extends StatefulWidget {
  const PoolsScreen({super.key});

  @override
  State<PoolsScreen> createState() => _PoolsScreenState();
}

class _PoolsScreenState extends State<PoolsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    context.read<PoolBloc>().add(SearchPools(value.trim()));
    setState(() {});
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<PoolBloc>().add(SearchPools(''));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: GestureDetector(
          onTap: () => context.go('/home'),
          child: Container(
            margin: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: AppBorderRadius.smRadius,
            ),
            child: const Icon(Icons.arrow_back,
                color: AppColors.onSurface, size: 20),
          ),
        ),
        title: TextField(
          controller: _searchController,
          style: AppTextStyles.fieldInput,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search pools…',
            hintStyle: TextStyle(
              fontSize: 16,
              color: AppColors.outline.withOpacity(0.7),
            ),
            prefixIcon:
                const Icon(Icons.search, color: AppColors.outline, size: 20),
            suffixIcon: _searchController.text.isNotEmpty
                ? GestureDetector(
                    onTap: _clearSearch,
                    child: const Icon(Icons.close,
                        color: AppColors.outline, size: 18),
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
              borderSide:
                  const BorderSide(color: AppColors.outlineVariant, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.pill),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
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
      body: const PoolsListWidget(),
    );
  }
}
