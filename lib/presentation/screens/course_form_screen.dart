import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_spacing.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/data/models/academy.dart';
import 'package:sibaha_app/data/models/course.dart';
import 'package:sibaha_app/data/models/invitation.dart';
import 'package:sibaha_app/presentation/blocs/course_bloc/course_bloc.dart';
import 'package:sibaha_app/presentation/blocs/invitation_bloc/invitation_bloc.dart';
import 'package:sibaha_app/presentation/blocs/invitation_bloc/invitation_state.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';

class CourseFormScreen extends StatefulWidget {
  final Academy academy;
  final Course? course;

  const CourseFormScreen({
    super.key,
    required this.academy,
    this.course,
  });

  @override
  State<CourseFormScreen> createState() => _CourseFormScreenState();
}

class _TimingEntry {
  String weekday;
  TimeOfDay startTime;
  TimeOfDay endTime;

  _TimingEntry({
    required this.weekday,
    required this.startTime,
    required this.endTime,
  });
}

const _weekdays = [
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday',
];

class _CourseFormScreenState extends State<CourseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;

  String _level = 'beginner';
  int? _selectedCoachId;
  int? _selectedPoolId;
  final List<_TimingEntry> _timings = [];

  bool get _isEdit => widget.course != null;

  @override
  void initState() {
    super.initState();
    final c = widget.course;
    _nameController = TextEditingController(text: c?.name ?? '');
    _descriptionController = TextEditingController(text: c?.description ?? '');
    _priceController = TextEditingController(
      text: c?.pricePerMonth != null
          ? c!.pricePerMonth!.toStringAsFixed(2)
          : '',
    );
    if (c != null) {
      _level = c.level;
      _selectedCoachId = c.coachId;
      _selectedPoolId = c.poolId;
      for (final t in c.timings) {
        final startParts = t.startTime.split(':');
        final endParts = t.endTime.split(':');
        _timings.add(_TimingEntry(
          weekday: t.weekday,
          startTime: TimeOfDay(
              hour: int.parse(startParts[0]),
              minute: int.parse(startParts[1])),
          endTime: TimeOfDay(
              hour: int.parse(endParts[0]), minute: int.parse(endParts[1])),
        ));
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  List<Map<String, String>> _buildTimingsPayload() => _timings
      .map((t) => {
            'weekday': t.weekday,
            'start_time': _formatTime(t.startTime),
            'end_time': _formatTime(t.endTime),
          })
      .toList();

  void _addTimingRow() {
    setState(() {
      _timings.add(_TimingEntry(
        weekday: 'monday',
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 10, minute: 0),
      ));
    });
  }

  void _removeTimingRow(int index) {
    setState(() => _timings.removeAt(index));
  }

  Future<void> _pickTime(int index, bool isStart) async {
    final initial =
        isStart ? _timings[index].startTime : _timings[index].endTime;
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      setState(() {
        if (isStart) {
          _timings[index].startTime = picked;
        } else {
          _timings[index].endTime = picked;
        }
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final tokenState = context.read<TokenBloc>().state;
    if (tokenState is! TokenRetrieved) return;

    final priceText = _priceController.text.trim();
    final price =
        priceText.isNotEmpty ? double.tryParse(priceText) : null;

    if (_isEdit) {
      context.read<CourseBloc>().add(UpdateCourseEvent(
            token: tokenState.token,
            academyId: widget.academy.id,
            courseId: widget.course!.id,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            level: _level,
            pricePerMonth: price,
            coachId: _selectedCoachId,
            poolId: _selectedPoolId,
            timings: _buildTimingsPayload(),
          ));
    } else {
      context.read<CourseBloc>().add(CreateCourseEvent(
            token: tokenState.token,
            academyId: widget.academy.id,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            level: _level,
            pricePerMonth: price,
            coachId: _selectedCoachId,
            poolId: _selectedPoolId,
            timings: _buildTimingsPayload(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CourseBloc, CourseState>(
      listener: (context, state) {
        if (state is CourseCreated || state is CourseUpdated) {
          Navigator.of(context).pop();
        } else if (state is CourseCreateFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.errorColor,
            behavior: SnackBarBehavior.floating,
          ));
        } else if (state is CourseUpdateFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.errorColor,
            behavior: SnackBarBehavior.floating,
          ));
        } else if (state is CourseTokenExpired) {
          context.read<TokenBloc>().add(TokenRefresh());
        }
      },
      child: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          final isSaving =
              state is CourseCreating || state is CourseUpdating;
          return Stack(
            children: [
              Scaffold(
                backgroundColor: AppColors.surfaceContainerLow,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  title: Text(
                    _isEdit ? 'Edit Course' : 'New Course',
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
                  actions: [
                    TextButton(
                      onPressed: isSaving ? null : _submit,
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: isSaving
                              ? AppColors.outlineVariant
                              : AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                body: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    children: [
                      _SectionLabel(label: 'Course details'),
                      const SizedBox(height: AppSpacing.sm),
                      _buildCard(children: [
                        _FieldLabel(text: 'Name'),
                        TextFormField(
                          controller: _nameController,
                          decoration: _inputDecoration('e.g. Morning Freestyle'),
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _FieldLabel(text: 'Description'),
                        TextFormField(
                          controller: _descriptionController,
                          decoration:
                              _inputDecoration('Describe the course (optional)'),
                          maxLines: 3,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _FieldLabel(text: 'Level'),
                        DropdownButtonFormField<String>(
                          value: _level,
                          decoration: _inputDecoration(null),
                          items: const [
                            DropdownMenuItem(
                                value: 'beginner', child: Text('Beginner')),
                            DropdownMenuItem(
                                value: 'intermediate',
                                child: Text('Intermediate')),
                            DropdownMenuItem(
                                value: 'advanced', child: Text('Advanced')),
                          ],
                          onChanged: (v) => setState(() => _level = v!),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _FieldLabel(text: 'Price per month (TND)'),
                        TextFormField(
                          controller: _priceController,
                          decoration:
                              _inputDecoration('e.g. 150.00 (leave empty if free)'),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return null;
                            if (double.tryParse(v.trim()) == null) {
                              return 'Enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ]),
                      const SizedBox(height: AppSpacing.xl),
                      _SectionLabel(label: 'Assignment (optional)'),
                      const SizedBox(height: AppSpacing.sm),
                      BlocBuilder<InvitationBloc, InvitationState>(
                        builder: (context, invState) {
                          final acceptedCoaches = invState is InvitationLoaded
                              ? invState.invitations
                                  .where((i) =>
                                      i.status == InvitationStatus.accepted)
                                  .toList()
                              : <Invitation>[];

                          final coachIdValid = acceptedCoaches
                              .any((i) => i.toCoach == _selectedCoachId);

                          return _buildCard(children: [
                            _FieldLabel(text: 'Coach'),
                            invState is InvitationLoading
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: AppSpacing.md),
                                    child: Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.primary),
                                      ),
                                    ),
                                  )
                                : DropdownButtonFormField<int?>(
                                    value:
                                        coachIdValid ? _selectedCoachId : null,
                                    decoration: _inputDecoration(
                                        acceptedCoaches.isEmpty
                                            ? 'No coaches assigned to this academy'
                                            : 'Select a coach (optional)'),
                                    items: [
                                      const DropdownMenuItem<int?>(
                                          value: null, child: Text('None')),
                                      ...acceptedCoaches.map(
                                        (i) => DropdownMenuItem<int?>(
                                            value: i.toCoach,
                                            child: Text(i.toCoachName)),
                                      ),
                                    ],
                                    onChanged: (v) =>
                                        setState(() => _selectedCoachId = v),
                                  ),
                            const SizedBox(height: AppSpacing.lg),
                            _FieldLabel(text: 'Pool'),
                            DropdownButtonFormField<int?>(
                              value: _selectedPoolId,
                              decoration: _inputDecoration('No pool assigned'),
                              items: [
                                const DropdownMenuItem<int?>(
                                    value: null, child: Text('None')),
                                ...widget.academy.poolList.map(
                                  (p) => DropdownMenuItem<int?>(
                                      value: p.id, child: Text(p.name)),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => _selectedPoolId = v),
                            ),
                          ]);
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      _SectionLabel(label: 'Weekly sessions'),
                      const SizedBox(height: AppSpacing.sm),
                      if (_timings.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Text(
                            'No sessions added yet.',
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.onSurfaceVariant),
                          ),
                        ),
                      ..._timings.asMap().entries.map((entry) {
                        final i = entry.key;
                        final t = entry.value;
                        return Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _buildCard(children: [
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    value: t.weekday,
                                    decoration:
                                        _inputDecoration(null),
                                    items: _weekdays
                                        .map((d) => DropdownMenuItem(
                                              value: d,
                                              child: Text(
                                                d[0].toUpperCase() +
                                                    d.substring(1),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (v) => setState(
                                        () => _timings[i].weekday = v!),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline,
                                      color: AppColors.errorColor, size: 22),
                                  onPressed: () => _removeTimingRow(i),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                Expanded(
                                  child: _TimeField(
                                    label: 'Start',
                                    time: t.startTime,
                                    onTap: () => _pickTime(i, true),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm),
                                  child: Text('–',
                                      style: TextStyle(
                                          color: AppColors.onSurfaceVariant)),
                                ),
                                Expanded(
                                  child: _TimeField(
                                    label: 'End',
                                    time: t.endTime,
                                    onTap: () => _pickTime(i, false),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        );
                      }),
                      TextButton.icon(
                        onPressed: _addTimingRow,
                        icon: const Icon(Icons.add, color: AppColors.primary),
                        label: const Text('Add session',
                            style: TextStyle(color: AppColors.primary)),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
              if (isSaving)
                const ModalBarrier(dismissible: false, color: Colors.black26),
              if (isSaving)
                const Center(
                    child: CircularProgressIndicator(color: AppColors.primary)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppBorderRadius.lgRadius,
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  InputDecoration _inputDecoration(String? hint) => InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.fieldInput
            .copyWith(color: AppColors.outlineVariant),
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        border: OutlineInputBorder(
          borderRadius: AppBorderRadius.smRadius,
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.smRadius,
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.smRadius,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.smRadius,
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
      );
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.fieldLabel.copyWith(color: AppColors.onSurfaceVariant),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(
        text,
        style: AppTextStyles.fieldLabel.copyWith(color: AppColors.onSurface),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;

  const _TimeField({
    required this.label,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formatted =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: AppBorderRadius.smRadius,
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          children: [
            Text(
              '$label: ',
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
            Text(
              formatted,
              style: AppTextStyles.fieldInput.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
