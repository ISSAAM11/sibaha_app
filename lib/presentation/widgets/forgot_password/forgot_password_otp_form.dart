import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/presentation/blocs/auth_bloc/auth_bloc.dart';

class ForgotPasswordOtpForm extends StatefulWidget {
  final String email;

  const ForgotPasswordOtpForm({super.key, required this.email});

  @override
  State<ForgotPasswordOtpForm> createState() => _ForgotPasswordOtpFormState();
}

class _ForgotPasswordOtpFormState extends State<ForgotPasswordOtpForm> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  String get _code => _controllers.map((c) => c.text).join();

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onDigitEntered(int index) {
    if (index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else {
      _focusNodes[index].unfocus();
    }
  }

  void _onBackspaceOnEmpty(int index) {
    if (index > 0) _focusNodes[index - 1].requestFocus();
  }

  void _verify(BuildContext context) {
    final code = _code;
    if (code.length < 6) return;
    context
        .read<AuthBloc>()
        .add(VerifyPasswordResetCodeEvent(widget.email, code));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PasswordResetCodeVerified) {
          GoRouter.of(context).go(
            '/forgot-password/new-password',
            extra: {'email': widget.email, 'code': _code},
          );
        }
      },
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildGlassCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryContainer.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.water_drop_outlined,
              color: Colors.white, size: 36),
        ),
        const SizedBox(height: 16),
        const Text('Verify Identity', style: AppTextStyles.screenTitle),
        const SizedBox(height: 8),
        const SizedBox(
          width: 280,
          child: Text(
            "We've sent a 6-digit verification code to your registered email address.",
            textAlign: TextAlign.center,
            style: AppTextStyles.subtitle,
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: List.generate(6, (i) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < 5 ? 8 : 0),
                      child: _OtpBox(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        onFilled: () => _onDigitEntered(i),
                        onBackspaceEmpty: () => _onBackspaceOnEmpty(i),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              // Error banner
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthFailed) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.errorColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: AppColors.errorColor, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(state.error,
                                style: AppTextStyles.errorText),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              // Verify button
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final isLoading = state is AuthLoading;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () => _verify(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            AppColors.primary.withOpacity(0.5),
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        shape: const StadiumBorder(),
                        elevation: 4,
                        shadowColor: AppColors.primary.withOpacity(0.25),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.5, color: Colors.white),
                            )
                          : const Text('Verify',
                              style: AppTextStyles.buttonLabel),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Divider(
                  color: AppColors.outlineVariant.withOpacity(0.3),
                  thickness: 1),
              const SizedBox(height: 16),
              const Text("Didn't receive the code?",
                  style: AppTextStyles.caption),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context
                    .read<AuthBloc>()
                    .add(RequestPasswordResetEvent(widget.email)),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Resend Code',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      letterSpacing: 0.7,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onFilled;
  final VoidCallback onBackspaceEmpty;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onFilled,
    required this.onBackspaceEmpty,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() => _isFocused = widget.focusNode.hasFocus);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              widget.controller.text.isEmpty) {
            widget.onBackspaceEmpty();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          maxLength: 1,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) widget.onFilled();
          },
          decoration: InputDecoration(
            counterText: '',
            hintText: '•',
            hintStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w300,
              color: AppColors.outlineVariant,
            ),
            filled: true,
            fillColor:
                _isFocused ? Colors.white : AppColors.surfaceContainerLow,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  color: AppColors.outlineVariant, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  color: AppColors.primaryContainer, width: 2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
