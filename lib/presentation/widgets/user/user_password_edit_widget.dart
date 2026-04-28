import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/blocs/user_details_bloc/user_details_bloc.dart';

class UserPasswordEditWidget extends StatefulWidget {
  const UserPasswordEditWidget({super.key});

  @override
  State<UserPasswordEditWidget> createState() => _UserPasswordEditWidgetState();
}

class _UserPasswordEditWidgetState extends State<UserPasswordEditWidget> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  String? _newPasswordError;
  String? _confirmError;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    bool hasError = false;

    if (newPassword.length < 8) {
      setState(
          () => _newPasswordError = 'Password must be at least 8 characters.');
      hasError = true;
    } else {
      setState(() => _newPasswordError = null);
    }

    if (newPassword != confirmPassword) {
      setState(() => _confirmError = 'Passwords do not match.');
      hasError = true;
    } else {
      setState(() => _confirmError = null);
    }

    if (hasError) return;

    final token = (context.read<TokenBloc>().state as TokenRetrieved).token;
    context.read<UserDetailsBloc>().add(
          ChangePasswordEvent(
            token,
            _currentPasswordController.text.trim(),
            newPassword,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocListener<UserDetailsBloc, UserDetailsState>(
        listenWhen: (_, s) =>
            s is ChangePasswordSuccess || s is ChangePasswordError,
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password updated successfully.'),
                backgroundColor: Color(0xFF00696F),
              ),
            );
            context.go('/UserDetails/informations');
          } else if (state is ChangePasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFBA1A1A),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Password',
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1B1B),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFF0EDEC)),
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  children: [
                    _buildPasswordField(
                      label: 'Current Password',
                      controller: _currentPasswordController,
                      obscure: _obscureCurrent,
                      onToggle: () =>
                          setState(() => _obscureCurrent = !_obscureCurrent),
                    ),
                    const Divider(height: 1, color: Color(0xFFF0EDEC)),
                    _buildPasswordField(
                      label: 'New Password',
                      controller: _newPasswordController,
                      obscure: _obscureNew,
                      onToggle: () =>
                          setState(() => _obscureNew = !_obscureNew),
                      errorText: _newPasswordError,
                    ),
                    const Divider(height: 1, color: Color(0xFFF0EDEC)),
                    _buildPasswordField(
                      label: 'Confirm New Password',
                      controller: _confirmPasswordController,
                      obscure: _obscureConfirm,
                      onToggle: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      errorText: _confirmError,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<UserDetailsBloc, UserDetailsState>(
                buildWhen: (_, s) =>
                    s is ChangePasswordLoading ||
                    s is ChangePasswordSuccess ||
                    s is ChangePasswordError ||
                    s is UserDetailsLoaded,
                builder: (context, state) {
                  final isLoading = state is ChangePasswordLoading;
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0058BC),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Save Password',
                              style: TextStyle(
                                fontFamily: 'Lexend',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Lexend',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF414755),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            obscureText: obscure,
            style: const TextStyle(
              fontFamily: 'Lexend',
              fontSize: 16,
              color: Color(0xFF1C1B1B),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '••••••••',
              hintStyle: TextStyle(color: Colors.grey[300]),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFF414755),
                  size: 20,
                ),
                onPressed: onToggle,
              ),
              errorText: errorText,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
