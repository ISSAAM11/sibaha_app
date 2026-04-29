import 'package:flutter/material.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/data/models/coach_filter.dart';

class CoachFilterSheet extends StatefulWidget {
  final List<String> availableLanguages;
  final List<String> availableSpecialities;
  final List<String> currentLanguages;
  final List<String> currentSpecialities;
  final bool currentHasExperience;

  const CoachFilterSheet({
    super.key,
    required this.availableLanguages,
    required this.availableSpecialities,
    this.currentLanguages = const [],
    this.currentSpecialities = const [],
    this.currentHasExperience = false,
  });

  @override
  State<CoachFilterSheet> createState() => _CoachFilterSheetState();
}

class _CoachFilterSheetState extends State<CoachFilterSheet> {
  late List<String> _selectedLanguages;
  late List<String> _selectedSpecialities;
  late bool _hasExperience;

  @override
  void initState() {
    super.initState();
    _selectedLanguages = List.from(widget.currentLanguages);
    _selectedSpecialities = List.from(widget.currentSpecialities);
    _hasExperience = widget.currentHasExperience;
  }

  void _toggleLanguage(String lang) {
    setState(() {
      _selectedLanguages.contains(lang)
          ? _selectedLanguages.remove(lang)
          : _selectedLanguages.add(lang);
    });
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
        CoachFilter(
          languages: List.from(_selectedLanguages),
          specialities: List.from(_selectedSpecialities),
          hasExperience: _hasExperience,
        ),
      );

  void _reset() {
    setState(() {
      _selectedLanguages = [];
      _selectedSpecialities = [];
      _hasExperience = false;
    });
    Navigator.pop(context, const CoachFilter());
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
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
                if (widget.availableLanguages.isNotEmpty) ...[
                  _SectionHeader(title: 'Languages'),
                  const SizedBox(height: AppSpacing.md),
                  _FilterChips(
                    options: widget.availableLanguages,
                    selected: _selectedLanguages,
                    onToggle: _toggleLanguage,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
                if (widget.availableSpecialities.isNotEmpty) ...[
                  _SectionHeader(title: 'Specialities'),
                  const SizedBox(height: AppSpacing.md),
                  _FilterChips(
                    options: widget.availableSpecialities,
                    selected: _selectedSpecialities,
                    onToggle: _toggleSpeciality,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
                _SectionHeader(title: 'Experience'),
                const SizedBox(height: AppSpacing.md),
                _ExperienceToggle(
                  value: _hasExperience,
                  onChanged: (v) => setState(() => _hasExperience = v),
                ),
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

class _FilterChips extends StatelessWidget {
  final List<String> options;
  final List<String> selected;
  final ValueChanged<String> onToggle;

  const _FilterChips({
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: options.map((opt) {
        final isSelected = selected.contains(opt);
        return FilterChip(
          label: Text(opt),
          selected: isSelected,
          onSelected: (_) => onToggle(opt),
          selectedColor: AppColors.primary.withValues(alpha: 0.12),
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

class _ExperienceToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ExperienceToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: const Text('Has experience data'),
      selected: value,
      onSelected: onChanged,
      selectedColor: AppColors.primary.withValues(alpha: 0.12),
      checkmarkColor: AppColors.primary,
      labelStyle: AppTextStyles.caption.copyWith(
        color: value ? AppColors.primary : AppColors.onSurfaceVariant,
        fontWeight: value ? FontWeight.w600 : FontWeight.w500,
      ),
      side: BorderSide(
        color: value ? AppColors.primary : AppColors.outlineVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      backgroundColor: Colors.white,
      showCheckmark: false,
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
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
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
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
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
