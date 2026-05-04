import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/data/models/academy.dart';
import 'package:sibaha_app/data/models/pool_summary_dto.dart';
import 'package:sibaha_app/presentation/blocs/my_academy_bloc/my_academy_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';

const _kSpecialities = [
  'Freestyle',
  'Backstroke',
  'Butterfly',
  'Breaststroke',
  'Open Water',
  'Water Polo',
  'Kids',
];

class CreateAcademyScreen extends StatefulWidget {
  final Academy? academy;
  
  const CreateAcademyScreen({super.key, this.academy});

  @override
  State<CreateAcademyScreen> createState() => _CreateAcademyScreenState();
}

class _CreateAcademyScreenState extends State<CreateAcademyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latController = TextEditingController();
  final _lonController = TextEditingController();
  Set<String> _selectedSpecialities = {};
  XFile? _pickedImage;
  Uint8List? _imageBytes;
  List<PoolSummaryDTO> _pools = [];

  @override
  void initState() {
    super.initState();
    _populateFields();
  }

  void _populateFields() {
    if (widget.academy != null) {
      final academy = widget.academy!;
      _nameController.text = academy.name;
      _cityController.text = academy.city;
      _addressController.text = academy.address;
      _descriptionController.text = academy.description;
      _selectedSpecialities = Set.from(academy.specialities);
      if (academy.latitude != null) _latController.text = academy.latitude.toString();
      if (academy.longitude != null) _lonController.text = academy.longitude.toString();
      _pools = List.from(academy.poolList);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _latController.dispose();
    _lonController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _pickedImage = image;
        _imageBytes = bytes;
      });
    }
  }

  bool get _isEditMode => widget.academy != null;

  void _openAddPoolSheet([PoolSummaryDTO? pool]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<MyAcademyBloc>(),
        child: _AddPoolSheet(academyId: widget.academy!.id, pool: pool),
      ),
    );
  }

  void _confirmDeletePool(PoolSummaryDTO pool) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Pool'),
        content: Text('Are you sure you want to delete "${pool.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              final tokenState = context.read<TokenBloc>().state;
              if (tokenState is! TokenRetrieved) return;
              context.read<MyAcademyBloc>().add(DeletePool(
                    token: tokenState.token,
                    academyId: widget.academy!.id,
                    poolId: pool.id,
                  ));
            },
            child: Text('Delete',
                style: TextStyle(color: AppColors.errorColor)),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_pickedImage == null && !_isEditMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a cover image')),
      );
      return;
    }
    final tokenState = context.read<TokenBloc>().state;
    if (tokenState is! TokenRetrieved) return;

    if (_isEditMode) {
      context.read<MyAcademyBloc>().add(UpdateAcademy(
            token: tokenState.token,
            academyId: widget.academy!.id,
            name: _nameController.text.trim(),
            city: _cityController.text.trim(),
            address: _addressController.text.trim(),
            description: _descriptionController.text.trim(),
            specialities: _selectedSpecialities.toList(),
            pictureBytes: _imageBytes,
            pictureFilename: _pickedImage?.name,
            latitude: double.tryParse(_latController.text),
            longitude: double.tryParse(_lonController.text),
          ));
    } else {
      context.read<MyAcademyBloc>().add(CreateAcademy(
            token: tokenState.token,
            name: _nameController.text.trim(),
            city: _cityController.text.trim(),
            address: _addressController.text.trim(),
            description: _descriptionController.text.trim(),
            specialities: _selectedSpecialities.toList(),
            pictureBytes: _imageBytes!,
            pictureFilename: _pickedImage!.name,
            latitude: double.tryParse(_latController.text),
            longitude: double.tryParse(_lonController.text),
          ));
    }
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
          onTap: () => context.pop(),
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
        title: Text(
          _isEditMode ? 'Edit Academy' : 'New Academy',
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
      body: BlocListener<MyAcademyBloc, MyAcademyState>(
        listenWhen: (_, s) =>
            s is AcademyCreated || s is AcademyCreateFailed ||
            s is AcademyUpdated || s is AcademyUpdateFailed ||
            s is PoolCreated || s is PoolUpdated ||
            s is PoolDeleted || s is PoolDeleteFailed,
        listener: (context, state) {
          if (state is AcademyCreated || state is AcademyUpdated) {
            context.pop();
          } else if (state is PoolCreated) {
            setState(() {
              _pools.add(PoolSummaryDTO(
                id: state.pool.id,
                name: state.pool.name,
                image: state.pool.image,
                speciality: state.pool.speciality,
                dimension: state.pool.dimension,
                heated: state.pool.heated,
                showers: state.pool.showers,
              ));
            });
          } else if (state is PoolUpdated) {
            setState(() {
              final i = _pools.indexWhere((p) => p.id == state.pool.id);
              if (i != -1) {
                _pools[i] = PoolSummaryDTO(
                  id: state.pool.id,
                  name: state.pool.name,
                  image: state.pool.image,
                  speciality: state.pool.speciality,
                  dimension: state.pool.dimension,
                  heated: state.pool.heated,
                  showers: state.pool.showers,
                );
              }
            });
          } else if (state is PoolDeleted) {
            setState(() {
              _pools.removeWhere((p) => p.id == state.poolId);
            });
          } else if (state is AcademyCreateFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorColor,
              ),
            );
          } else if (state is AcademyUpdateFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorColor,
              ),
            );
          } else if (state is PoolDeleteFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.errorColor,
              ),
            );
          }
        },
        child: BlocBuilder<MyAcademyBloc, MyAcademyState>(
          buildWhen: (_, s) =>
              s is AcademyCreating ||
              s is AcademyCreated ||
              s is AcademyCreateFailed ||
              s is AcademyUpdating ||
              s is AcademyUpdated ||
              s is AcademyUpdateFailed,
          builder: (context, state) {
            final isLoading = state is AcademyCreating || state is AcademyUpdating;
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  _ImagePickerCard(
                    imageBytes: _imageBytes, 
                    existingImageUrl: _isEditMode ? widget.academy?.image : null,
                    onTap: isLoading ? null : _pickImage
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FieldLabel('Academy Name'),
                  const SizedBox(height: AppSpacing.sm),
                  _InputField(
                    controller: _nameController,
                    hint: 'e.g. Aqua Sport Academy',
                    enabled: !isLoading,
                    validator: _required,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FieldLabel('City'),
                  const SizedBox(height: AppSpacing.sm),
                  _InputField(
                    controller: _cityController,
                    hint: 'e.g. Tunis',
                    enabled: !isLoading,
                    validator: _required,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FieldLabel('Address'),
                  const SizedBox(height: AppSpacing.sm),
                  _InputField(
                    controller: _addressController,
                    hint: 'Full street address',
                    enabled: !isLoading,
                    validator: _required,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FieldLabel('Description'),
                  const SizedBox(height: AppSpacing.sm),
                  _InputField(
                    controller: _descriptionController,
                    hint: 'Describe your academy…',
                    maxLines: 4,
                    enabled: !isLoading,
                    validator: _required,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FieldLabel('Specialities'),
                  const SizedBox(height: AppSpacing.sm),
                  _SpecialitiesSelector(
                    selected: _selectedSpecialities,
                    enabled: !isLoading,
                    onToggle: (s) => setState(() {
                      _selectedSpecialities.contains(s)
                          ? _selectedSpecialities.remove(s)
                          : _selectedSpecialities.add(s);
                    }),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _FieldLabel('Location (optional)'),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: _InputField(
                          controller: _latController,
                          hint: 'Latitude',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          enabled: !isLoading,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _InputField(
                          controller: _lonController,
                          hint: 'Longitude',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          enabled: !isLoading,
                        ),
                      ),
                    ],
                  ),
                  if (_isEditMode) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _PoolsSection(
                      pools: _pools,
                      onAddPressed: isLoading ? null : () => _openAddPoolSheet(),
                      onEditPool: isLoading ? null : _openAddPoolSheet,
                      onDeletePool: isLoading ? null : _confirmDeletePool,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xxl),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor:
                            AppColors.primary.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                            borderRadius: AppBorderRadius.pillRadius),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : Text(_isEditMode ? 'Update Academy' : 'Create Academy',
                              style: AppTextStyles.buttonLabel
                                  .copyWith(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'This field is required' : null;
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(text, style: AppTextStyles.fieldLabel);
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool enabled;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.enabled = true,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      enabled: enabled,
      style: AppTextStyles.fieldInput,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            fontSize: 16, color: AppColors.outline.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide:
              const BorderSide(color: AppColors.outlineVariant, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide:
              const BorderSide(color: AppColors.errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide:
              const BorderSide(color: AppColors.errorColor, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          borderSide:
              const BorderSide(color: AppColors.outlineVariant, width: 1),
        ),
      ),
    );
  }
}

class _SpecialitiesSelector extends StatelessWidget {
  final Set<String> selected;
  final void Function(String) onToggle;
  final bool enabled;

  const _SpecialitiesSelector({
    required this.selected,
    required this.onToggle,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: _kSpecialities.map((s) {
        final isSelected = selected.contains(s);
        return GestureDetector(
          onTap: enabled ? () => onToggle(s) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.white,
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.outlineVariant,
                width: isSelected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(AppBorderRadius.pill),
            ),
            child: Text(
              s,
              style: AppTextStyles.buttonLabel.copyWith(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ImagePickerCard extends StatelessWidget {
  final Uint8List? imageBytes;
  final String? existingImageUrl;
  final VoidCallback? onTap;

  const _ImagePickerCard({
    required this.imageBytes, 
    this.existingImageUrl, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          border: Border.all(
              color: AppColors.outlineVariant,
              width: 1,
              style: BorderStyle.solid),
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildImageContent(),
      ),
    );
  }

  Widget _buildImageContent() {
    if (imageBytes != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(imageBytes!, fit: BoxFit.cover),
          Positioned(
            bottom: AppSpacing.sm,
            right: AppSpacing.sm,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius:
                    BorderRadius.circular(AppBorderRadius.pill),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit, color: Colors.white, size: 14),
                  SizedBox(width: AppSpacing.xs),
                  Text('Change',
                      style: TextStyle(
                          color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      );
    }
    
    if (existingImageUrl != null && existingImageUrl!.isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.network(existingImageUrl!, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _placeholder()),
          Positioned(
            bottom: AppSpacing.sm,
            right: AppSpacing.sm,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius:
                    BorderRadius.circular(AppBorderRadius.pill),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit, color: Colors.white, size: 14),
                  SizedBox(width: AppSpacing.xs),
                  Text('Change',
                      style: TextStyle(
                          color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      );
    }
    
    return _placeholder();
  }

  Widget _placeholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.add_photo_alternate_outlined,
            size: 40, color: AppColors.outlineVariant),
        const SizedBox(height: AppSpacing.sm),
        Text(existingImageUrl != null
            ? 'Tap to change the cover photo'
            : 'Tap to add a cover photo',
            style: AppTextStyles.caption
                .copyWith(color: AppColors.outline)),
      ],
    );
  }
}

class _PoolsSection extends StatelessWidget {
  final List<PoolSummaryDTO> pools;
  final VoidCallback? onAddPressed;
  final void Function(PoolSummaryDTO)? onEditPool;
  final void Function(PoolSummaryDTO)? onDeletePool;

  const _PoolsSection({
    required this.pools,
    this.onAddPressed,
    this.onEditPool,
    this.onDeletePool,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('Pools'),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Column(
            children: [
              if (pools.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg, horizontal: AppSpacing.lg),
                  child: Center(
                    child: Text('No pools yet',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.outline)),
                  ),
                )
              else
                ...pools.map((pool) => _PoolTile(
                      pool: pool,
                      onEdit: onEditPool != null ? () => onEditPool!(pool) : null,
                      onDelete:
                          onDeletePool != null ? () => onDeletePool!(pool) : null,
                    )),
              const Divider(height: 1, thickness: 1, color: AppColors.outlineVariant),
              InkWell(
                onTap: onAddPressed,
                borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(AppBorderRadius.md)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md, horizontal: AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add,
                          color: onAddPressed != null
                              ? AppColors.primary
                              : AppColors.outlineVariant,
                          size: 18),
                      const SizedBox(width: AppSpacing.xs),
                      Text('Add Pool',
                          style: AppTextStyles.buttonLabel.copyWith(
                              color: onAddPressed != null
                                  ? AppColors.primary
                                  : AppColors.outlineVariant)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PoolTile extends StatelessWidget {
  final PoolSummaryDTO pool;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _PoolTile({required this.pool, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            child: pool.image != null && pool.image!.isNotEmpty
                ? Image.network(
                    pool.image!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _poolImagePlaceholder(),
                  )
                : _poolImagePlaceholder(),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(pool.name,
                style: AppTextStyles.fieldInput,
                overflow: TextOverflow.ellipsis),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 18),
            color: AppColors.primary,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
            onPressed: onEdit,
            tooltip: 'Edit pool',
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            color: AppColors.errorColor,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
            onPressed: onDelete,
            tooltip: 'Delete pool',
          ),
        ],
      ),
    );
  }

  Widget _poolImagePlaceholder() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: const Icon(Icons.pool, color: AppColors.outlineVariant, size: 20),
    );
  }
}

class _AddPoolSheet extends StatefulWidget {
  final int academyId;
  final PoolSummaryDTO? pool;

  const _AddPoolSheet({required this.academyId, this.pool});

  @override
  State<_AddPoolSheet> createState() => _AddPoolSheetState();
}

class _AddPoolSheetState extends State<_AddPoolSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dimensionController = TextEditingController();
  late final Set<String> _selectedSpecialities;
  late bool _heated;
  late int _showers;
  XFile? _pickedImage;
  Uint8List? _imageBytes;

  bool get _isEditMode => widget.pool != null;

  @override
  void initState() {
    super.initState();
    final pool = widget.pool;
    if (pool != null) {
      _nameController.text = pool.name;
      _dimensionController.text =
          pool.dimension.isNotEmpty ? pool.dimension.first : '';
      _selectedSpecialities = Set.from(pool.speciality);
      _heated = pool.heated;
      _showers = pool.showers;
    } else {
      _selectedSpecialities = {};
      _heated = false;
      _showers = 0;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dimensionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _pickedImage = image;
        _imageBytes = bytes;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final tokenState = context.read<TokenBloc>().state;
    if (tokenState is! TokenRetrieved) return;
    final dimension = _dimensionController.text.trim().isEmpty
        ? <String>[]
        : [_dimensionController.text.trim()];
    if (_isEditMode) {
      context.read<MyAcademyBloc>().add(UpdatePool(
            token: tokenState.token,
            academyId: widget.academyId,
            poolId: widget.pool!.id,
            name: _nameController.text.trim(),
            speciality: _selectedSpecialities.toList(),
            dimension: dimension,
            heated: _heated,
            showers: _showers,
            pictureBytes: _imageBytes,
            pictureFilename: _pickedImage?.name,
          ));
    } else {
      context.read<MyAcademyBloc>().add(CreatePool(
            token: tokenState.token,
            academyId: widget.academyId,
            name: _nameController.text.trim(),
            speciality: _selectedSpecialities.toList(),
            dimension: dimension,
            heated: _heated,
            showers: _showers,
            pictureBytes: _imageBytes,
            pictureFilename: _pickedImage?.name,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyAcademyBloc, MyAcademyState>(
      listenWhen: (_, s) =>
          s is PoolCreated || s is PoolCreateFailed ||
          s is PoolUpdated || s is PoolUpdateFailed,
      listener: (context, state) {
        if (state is PoolCreated || state is PoolUpdated) {
          Navigator.of(context).pop();
        } else if (state is PoolCreateFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorColor,
            ),
          );
        } else if (state is PoolUpdateFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
      },
      child: BlocBuilder<MyAcademyBloc, MyAcademyState>(
        buildWhen: (_, s) =>
            s is PoolCreating || s is PoolCreated || s is PoolCreateFailed ||
            s is PoolUpdating || s is PoolUpdated || s is PoolUpdateFailed,
        builder: (context, state) {
          final isLoading = state is PoolCreating || state is PoolUpdating;
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppBorderRadius.lg)),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.outlineVariant,
                            borderRadius:
                                BorderRadius.circular(AppBorderRadius.pill),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        _isEditMode ? 'Edit Pool' : 'Add Pool',
                        style: AppTextStyles.subtitle
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _ImagePickerCard(
                        imageBytes: _imageBytes,
                        existingImageUrl:
                            _isEditMode ? widget.pool?.image : null,
                        onTap: isLoading ? null : _pickImage,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const _FieldLabel('Pool Name'),
                      const SizedBox(height: AppSpacing.sm),
                      _InputField(
                        controller: _nameController,
                        hint: 'e.g. Main Pool',
                        enabled: !isLoading,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'This field is required'
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const _FieldLabel('Specialities'),
                      const SizedBox(height: AppSpacing.sm),
                      _SpecialitiesSelector(
                        selected: _selectedSpecialities,
                        enabled: !isLoading,
                        onToggle: (s) => setState(() {
                          _selectedSpecialities.contains(s)
                              ? _selectedSpecialities.remove(s)
                              : _selectedSpecialities.add(s);
                        }),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const _FieldLabel('Dimensions (optional)'),
                      const SizedBox(height: AppSpacing.sm),
                      _InputField(
                        controller: _dimensionController,
                        hint: 'e.g. 25m × 10m',
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Heated',
                                style: AppTextStyles.fieldLabel),
                          ),
                          Switch(
                            value: _heated,
                            onChanged: isLoading
                                ? null
                                : (v) => setState(() => _heated = v),
                            activeThumbColor: AppColors.primary,
                            activeTrackColor: AppColors.primary.withValues(alpha: 0.4),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: Text('Showers',
                                style: AppTextStyles.fieldLabel),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            color: AppColors.primary,
                            onPressed: isLoading || _showers == 0
                                ? null
                                : () => setState(() => _showers--),
                          ),
                          SizedBox(
                            width: 32,
                            child: Text(
                              '$_showers',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.fieldInput,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            color: AppColors.primary,
                            onPressed: isLoading
                                ? null
                                : () => setState(() => _showers++),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            disabledBackgroundColor:
                                AppColors.primary.withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                                borderRadius: AppBorderRadius.pillRadius),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : Text(
                                  _isEditMode ? 'Update Pool' : 'Save Pool',
                                  style: AppTextStyles.buttonLabel
                                      .copyWith(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
