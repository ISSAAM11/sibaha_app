import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
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
  const CreateAcademyScreen({super.key});

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
  final Set<String> _selectedSpecialities = {};
  XFile? _pickedImage;
  Uint8List? _imageBytes;

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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a cover image')),
      );
      return;
    }
    final tokenState = context.read<TokenBloc>().state;
    if (tokenState is! TokenRetrieved) return;

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
          'New Academy',
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
        listenWhen: (_, s) => s is AcademyCreated || s is AcademyCreateFailed,
        listener: (context, state) {
          if (state is AcademyCreated) {
            context.pop();
          } else if (state is AcademyCreateFailed) {
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
              s is AcademyCreateFailed,
          builder: (context, state) {
            final isLoading = state is AcademyCreating;
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  _ImagePickerCard(
                      imageBytes: _imageBytes, onTap: isLoading ? null : _pickImage),
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
                          : Text('Create Academy',
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
  final VoidCallback? onTap;

  const _ImagePickerCard({required this.imageBytes, required this.onTap});

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
        child: imageBytes != null
            ? Stack(
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
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_photo_alternate_outlined,
                      size: 40, color: AppColors.outlineVariant),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Tap to add a cover photo',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.outline)),
                ],
              ),
      ),
    );
  }
}
