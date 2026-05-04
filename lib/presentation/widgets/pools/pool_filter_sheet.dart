import 'package:flutter/material.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';

class PoolFilter {
  final bool? heated;
  final List<String> specialities;

  const PoolFilter({this.heated, this.specialities = const []});

  bool get isActive => heated != null || specialities.isNotEmpty;
}

class PoolFilterSheet extends StatefulWidget {
  final List<String> availableSpecialities;
  final bool? currentHeated;
  final List<String> currentSpecialities;

  const PoolFilterSheet({
    super.key,
    required this.availableSpecialities,
    this.currentHeated,
    this.currentSpecialities = const [],
  });

  @override
  State<PoolFilterSheet> createState() => _PoolFilterSheetState();
}

class _PoolFilterSheetState extends State<PoolFilterSheet> {
  bool? _selectedHeated;
  late List<String> _selectedSpecialities;

  @override
  void initState() {
    super.initState();
    _selectedHeated = widget.currentHeated;
    _selectedSpecialities = List.from(widget.currentSpecialities);
  }

  void _toggleSpeciality(String s) {
    setState(() {
      _selectedSpecialities.contains(s)
          ? _selectedSpecialities.remove(s)
          : _selectedSpecialities.add(s);
    });
  }

  void _apply() => Navigator.pop(
        context,
        PoolFilter(
          heated: _selectedHeated,
          specialities: List.from(_selectedSpecialities),
        ),
      );

  void _reset() {
    setState(() {
      _selectedHeated = null;
      _selectedSpecialities = [];
    });
    Navigator.pop(context, const PoolFilter());
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, scrollController) => Column(
        children: [
          _SheetHandle(),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.sm,
                AppSpacing.xl,
                AppSpacing.xxl,
              ),
              children: [
                _SectionHeader(title: 'Temperature'),
                const SizedBox(height: AppSpacing.md),
                _HeatedSelector(
                  selected: _selectedHeated,
                  onSelect: (value) =>
                      setState(() => _selectedHeated = value),
                ),
                const SizedBox(height: AppSpacing.xl),
                if (widget.availableSpecialities.isNotEmpty) ...[
                  _SectionHeader(title: 'Specialities'),
                  const SizedBox(height: AppSpacing.md),
                  _SpecialityChips(
                    available: widget.availableSpecialities,
                    selected: _selectedSpecialities,
                    onToggle: _toggleSpeciality,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ],
            ),
          ),
          _ActionRow(onReset: _reset, onApply: _apply),
        ],
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppBorderRadius.lg),
          topRight: Radius.circular(AppBorderRadius.lg),
        ),
      ),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.outlineVariant,
            borderRadius: AppBorderRadius.pillRadius,
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(color: AppColors.onSurface),
    );
  }
}

class _HeatedSelector extends StatelessWidget {
  final bool? selected;
  final ValueChanged<bool?> onSelect;

  const _HeatedSelector({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HeatedChip(
          label: 'All',
          icon: Icons.water,
          value: null,
          selected: selected == null,
          onTap: () => onSelect(null),
        ),
        const SizedBox(width: AppSpacing.sm),
        _HeatedChip(
          label: 'Heated',
          icon: Icons.whatshot,
          value: true,
          selected: selected == true,
          onTap: () => onSelect(true),
        ),
        const SizedBox(width: AppSpacing.sm),
        _HeatedChip(
          label: 'Unheated',
          icon: Icons.ac_unit,
          value: false,
          selected: selected == false,
          onTap: () => onSelect(false),
        ),
      ],
    );
  }
}

class _HeatedChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool? value;
  final bool selected;
  final VoidCallback onTap;

  const _HeatedChip({
    required this.label,
    required this.icon,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color: selected ? AppColors.primary : AppColors.onSurfaceVariant),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecialityChips extends StatelessWidget {
  final List<String> available;
  final List<String> selected;
  final ValueChanged<String> onToggle;

  const _SpecialityChips({
    required this.available,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: available.map((s) {
        final isSelected = selected.contains(s);
        return FilterChip(
          label: Text(s),
          selected: isSelected,
          onSelected: (_) => onToggle(s),
          selectedColor: AppColors.primary.withOpacity(0.12),
          checkmarkColor: AppColors.primary,
          labelStyle: AppTextStyles.caption.copyWith(
            color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
          backgroundColor: Colors.white,
          showCheckmark: false,
        );
      }).toList(),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onApply;

  const _ActionRow({required this.onReset, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.xl + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: onReset,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.onSurface,
                side: const BorderSide(color: AppColors.outlineVariant),
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.pill),
                ),
              ),
              child: Text('Reset', style: AppTextStyles.buttonLabel),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onApply,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.pill),
                ),
                elevation: 0,
              ),
              child: Text('Apply', style: AppTextStyles.buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}
