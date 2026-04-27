import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';
import 'package:sibaha_app/core/theme/app_text_styles.dart';
import 'package:sibaha_app/presentation/blocs/auth_bloc/auth_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 40,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPasswordField(context, authBloc),
              const SizedBox(height: 16),
              _buildErrorMessage(),
              _buildSubmitButton(authBloc),
              const SizedBox(height: 32),
              // _buildDivider(),
              // const SizedBox(height: 16),
              // _buildSocialButtons(),
              // const SizedBox(height: 32),
              _buildFooter(context, authBloc),
              const SizedBox(height: 16),
              _policyFooter(),
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
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/app-icon/sibahaIcon.jpg',
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Sibaha',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            letterSpacing: -0.32,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Dive back into your rhythm',
          style: TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text('Email Address', style: AppTextStyles.fieldLabel),
        ),
        _StyledTextField(
          controller: _emailController,
          hintText: 'swimmer@sibaha.com',
          prefixIcon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildPasswordField(BuildContext context, AuthBloc authBloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Password', style: AppTextStyles.fieldLabel),
              GestureDetector(
                onTap: () {
                  authBloc.add(ResetAuthEvent());
                  GoRouter.of(context).go('/forgot-password');
                },
                child: const Text('Forgot?', style: AppTextStyles.linkPrimary),
              ),
            ],
          ),
        ),
        _StyledTextField(
          controller: _passwordController,
          hintText: '••••••••',
          prefixIcon: Icons.lock_outline,
          obscureText: _obscurePassword,
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
            child: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.outline,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthFailed) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.errorContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppColors.errorColor.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.error_outline,
                    color: AppColors.errorColor, size: 18),
                SizedBox(width: 8),
                Text('Invalid email or password.',
                    style: AppTextStyles.errorText),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSubmitButton(AuthBloc authBloc) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () => authBloc.add(LoginEvent(
                      _emailController.text,
                      _passwordController.text,
                    )),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  AppColors.primary.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: const StadiumBorder(),
              elevation: 4,
              shadowColor: AppColors.primary.withOpacity(0.3),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue Journey',
                          style: AppTextStyles.buttonLabel),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(
            child: Divider(color: AppColors.outlineVariant, thickness: 1)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR ACCESS VIA',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.outline,
              letterSpacing: 2,
            ),
          ),
        ),
        const Expanded(
            child: Divider(color: AppColors.outlineVariant, thickness: 1)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: _SocialButton(
            label: 'Google',
            icon: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCJ80FxJ-jmIHDdWGK0s8HicwHvX_OMirDDvao6o_ldaNDm9TcoZWal52JiLVrRtDpXR-GI1VgC8QP-P-prV0SEBqn5aQWmX5fI6geIUFfERj8spq72JWtJqIGbh2cTdljc1h9-MNH-QK2L7fnpivRitqe8cbxMF6NXHm9BDo-1t7QDtVBz7df_Tve5VNYHOQrRZ3CD8-0kq8irfJy6osKdfz0nTdJhMimCY5cWYKn4mxIaJByGg_e4e4uBQVDv8NOwrGWcJ0375uOc',
              width: 20,
              height: 20,
              errorBuilder: (_, __, ___) => const Text(
                'G',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: _SocialButton(
            label: 'Apple',
            icon: Icon(Icons.apple, size: 20, color: AppColors.onSurface),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, AuthBloc authBloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('New to the water? ',
            style: TextStyle(
                fontSize: 16, color: AppColors.onSurfaceVariant)),
        GestureDetector(
          onTap: () {
            authBloc.add(ResetAuthEvent());
            GoRouter.of(context).go('/signup');
          },
          child: const Text('Create Account', style: AppTextStyles.bodyLink),
        ),
      ],
    );
  }

  Widget _policyFooter() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontFamily: 'Lexend',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurface.withOpacity(0.6),
        ),
        children: const [
          TextSpan(text: "By continuing, you agree to Sibaha's "),
          TextSpan(
            text: 'Terms of Flow',
            style: TextStyle(decoration: TextDecoration.underline),
          ),
          TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(decoration: TextDecoration.underline),
          ),
          TextSpan(text: '.'),
        ],
      ),
    );
  }
}

class _StyledTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const _StyledTextField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  State<_StyledTextField> createState() => _StyledTextFieldState();
}

class _StyledTextFieldState extends State<_StyledTextField> {
  final _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      style: AppTextStyles.fieldInput,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        hintText: widget.hintText,
        hintStyle: TextStyle(
            fontSize: 16, color: AppColors.outline.withOpacity(0.6)),
        prefixIcon: Icon(
          widget.prefixIcon,
          color: _isFocused ? AppColors.primary : AppColors.outline,
          size: 22,
        ),
        suffixIcon: widget.suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 8),
                child: widget.suffixIcon,
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final Widget icon;

  const _SocialButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.outlineVariant),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              )),
        ],
      ),
    );
  }
}
